import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:omdk_inspecta/common/common.dart';
import 'package:omdk_local_data/omdk_local_data.dart';
import 'package:omdk_opera_api/omdk_opera_api.dart';
import 'package:omdk_opera_repo/omdk_opera_repo.dart';
import 'package:omdk_repo/omdk_repo.dart';

part 'field_file_event.dart';
part 'field_file_state.dart';

class FieldFileBloc extends Bloc<FieldFileEvent, FieldFileState> {
  FieldFileBloc({
    required this.entityGuid,
    required this.entityType,
    required bool isEnabled,
    required OMDKLocalData omdkLocalData,
    required OperaAttachmentRepo attachmentRepo,
    required EntityRepo<Asset> assetRepo,
    required EntityRepo<Node> nodeRepo,
    required EntityRepo<ScheduledActivity> scheduledRepo,
    required OperaUtils operaUtils,
  })  : _omdkLocalData = omdkLocalData,
        _attachmentRepo = attachmentRepo,
        _assetRepo = assetRepo,
        _nodeRepo = nodeRepo,
        _scheduledRepo = scheduledRepo,
        _operaUtils = operaUtils,
        super(FieldFileState(isEnabled: isEnabled)) {
    on<LoadData>(_onLoadData);
    on<Enable>(_onEnable);
    on<Disable>(_onDisable);
    on<ChangeSelected>(_onChangeSelected);
    on<AddFile>(_onAddFile);
  }

  final String entityGuid;
  final JEntityType entityType;
  final OMDKLocalData _omdkLocalData;
  final OperaAttachmentRepo _attachmentRepo;
  final OperaUtils _operaUtils;
  final EntityRepo<Asset> _assetRepo;
  final EntityRepo<Node> _nodeRepo;
  final EntityRepo<ScheduledActivity> _scheduledRepo;

  Future<void> _onLoadData(
    LoadData event,
    Emitter<FieldFileState> emit,
  ) async {
    // Empty field
    if (event.guids == null || event.guids!.isEmpty) {
      return emit(state.copyWith(loadingStatus: LoadingStatus.done));
    }

    emit(state.copyWith(loadingStatus: LoadingStatus.inProgress));

    final fileList = <File?>[];
    final attachmentEntityList = <Attachment?>[];

    for (final guid in event.guids!) {
      // Retrieve file entity from db
      final attachmentRequest =
          await _attachmentRepo.readLocalItem(itemID: guid);
      var attachmentEntity = attachmentRequest.fold(
        (data) => data,
        (failure) => null,
      );

      // If attachment wasn't found in db try to download it
      if (attachmentEntity == null) {
        final attachmentRequest = await _attachmentRepo.getAPIItem(guid: guid);
        attachmentEntity = attachmentRequest.fold(
          (data) => data,
          (failure) => null,
        );

        // Save download entity in db
        if (attachmentEntity != null) {
          await _attachmentRepo.saveLocalItem(attachmentEntity);
        }
      }

      // Fail to retrieve attachment entity, emit failure status
      if (attachmentEntity == null) {
        return emit(
          state.copyWith(
            loadingStatus: LoadingStatus.failure,
            errorText: 'Fail to retrieve attachment entity',
          ),
        );
      }

      // Add attachment entity to resul list
      attachmentEntityList.add(attachmentEntity);

      try {
        // Retrieve file from local storage
        final downloadPath =
            await _omdkLocalData.fileManager.getDownloadDirectoryPath;
        final attachmentFile = await _omdkLocalData.fileManager
            .getFile('$downloadPath/${attachmentEntity.attachment.guid}/'
                '${attachmentEntity.attachment.fileName}');
        fileList.add(attachmentFile);
      } on Exception catch (_) {
        fileList.add(null);
      }
    }

    return emit(
      state.copyWith(
        fileList: fileList,
        attachmentEntityList: attachmentEntityList,
        selectedAttachment: attachmentEntityList
            .singleWhereOrNull((a) => a?.entity.guid == event.selected),
        loadingStatus: LoadingStatus.done,
      ),
    );
  }

  Future<void> _onEnable(
    Enable event,
    Emitter<FieldFileState> emit,
  ) async {
    return emit(state.copyWith(isEnabled: true));
  }

  Future<void> _onDisable(
    Disable event,
    Emitter<FieldFileState> emit,
  ) async {
    return emit(state.copyWith(isEnabled: false));
  }

  Future<void> _onChangeSelected(
    ChangeSelected event,
    Emitter<FieldFileState> emit,
  ) async {
    return emit(state.copyWith(selectedAttachment: event.attachment));
  }

  Future<void> _onAddFile(
    AddFile event,
    Emitter<FieldFileState> emit,
  ) async {
    emit(state.copyWith(loadingStatus: LoadingStatus.inProgress));

    final imageFile = await _omdkLocalData.mediaManager.selectPicture();

    if (imageFile == null) {
      return emit(state.copyWith(loadingStatus: LoadingStatus.done));
    }

    final file = File(imageFile.path);

    final db = _omdkLocalData.isarManager.dbInstance;
    final fileEntity = await _operaUtils.buildAttachmentEntity(file);
    // Save file to app directory
    final filePath = await _omdkLocalData.fileManager.createFolder(
      fileEntity.entity.guid!,
    );
    await _omdkLocalData.fileManager.saveFile(
      file.readAsBytesSync(),
      '$filePath/${fileEntity.attachment.fileName}',
    );

    // Save file with entity reference
    switch (entityType) {
      case JEntityType.Asset:
        // Get entity reference from DB
        final entityReferenceRequest = await _assetRepo.readLocalItem(
          itemID: entityGuid,
        );
        final entityReference = entityReferenceRequest.fold(
          (entity) => entity,
          (failure) => null,
        );
        // Link entity to attachment
        fileEntity.assetLink.value = entityReference;
        // Save attachment entity to DB;
        await _attachmentRepo.saveLocalItem(fileEntity);

        // Update attachment link in entity
        entityReference?.attachments.add(fileEntity);
        await db.writeTxn(() async {
          await entityReference?.attachments.save();
        });
        final updatedAttachmentList =
            List<JAttachment>.from(entityReference!.attachmentsList)
              ..add(fileEntity.attachment);
        await _assetRepo.saveLocalItem(
          entityReference.copyWith(
            dates: entityReference.dates.copyWith(
              modified: await _operaUtils.getParticipationDate(),
            ),
            attachmentsList: updatedAttachmentList,
            syncStatus: SyncStatus.toUpload,
          ),
        );
        return emit(
          state.copyWith(
            loadingStatus: LoadingStatus.done,
            fileList: state.fileList..add(file),
            attachmentEntityList: state.attachmentEntityList..add(fileEntity),
            selectedAttachment: fileEntity,
            notify: true,
          ),
        );
      case JEntityType.Node:
        // Get entity reference from DB
        final entityReferenceRequest = await _nodeRepo.readLocalItem(
          itemID: entityGuid,
        );
        final entityReference = entityReferenceRequest.fold(
          (entity) => entity,
          (failure) => null,
        );
        // Link entity to attachment
        fileEntity.nodeLink.value = entityReference;
        // Save attachment entity to DB;
        await _attachmentRepo.saveLocalItem(fileEntity);

        // Update attachment link in entity
        entityReference?.attachments.add(fileEntity);
        await db.writeTxn(() async {
          await entityReference?.attachments.save();
        });
        final updatedAttachmentList =
            List<JAttachment>.from(entityReference!.attachmentsList)
              ..add(fileEntity.attachment);
        await _nodeRepo.saveLocalItem(
          entityReference.copyWith(
            dates: entityReference.dates.copyWith(
              modified: await _operaUtils.getParticipationDate(),
            ),
            attachmentsList: updatedAttachmentList,
            syncStatus: SyncStatus.toUpload,
          ),
        );
        return emit(
          state.copyWith(
            loadingStatus: LoadingStatus.done,
            fileList: List.from(state.fileList)..add(file),
            selectedAttachment: fileEntity,
            attachmentEntityList: List.from(state.attachmentEntityList)
              ..add(fileEntity),
            notify: true,
          ),
        );
      case JEntityType.unknown:
      case JEntityType.TemplateActivity:
      case JEntityType.ScheduledActivity:
      case JEntityType.User:
      case JEntityType.Group:
      case JEntityType.Tool:
      case JEntityType.SparePartGroup:
      case JEntityType.Warehouse:
      case JEntityType.IotDevice:
      case JEntityType.Partecipation:
      case JEntityType.Attachment:
      case JEntityType.Ticket:
      case JEntityType.Schema:
      case JEntityType.MappingScript:
      case JEntityType.Excel:
        return;
    }
  }
}
