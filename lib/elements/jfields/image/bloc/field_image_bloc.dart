import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:omdk_inspecta/common/common.dart';
import 'package:omdk_local_data/omdk_local_data.dart';
import 'package:omdk_opera_api/omdk_opera_api.dart';
import 'package:omdk_opera_repo/omdk_opera_repo.dart';
import 'package:omdk_repo/omdk_repo.dart';

part 'field_image_event.dart';
part 'field_image_state.dart';

class FieldImageBloc extends Bloc<FieldImageEvent, FieldImageState> {
  FieldImageBloc({
    required String entityGuid,
    required JEntityType entityType,
    required OMDKLocalData omdkLocalData,
    required OperaUtils operaUtils,
    required OperaAttachmentRepo attachmentRepo,
    required EntityRepo<Asset> assetRepo,
    required EntityRepo<Node> nodeRepo,
    required EntityRepo<ScheduledActivity> scheduledRepo,
  })  : _entityGuid = entityGuid,
        _entityType = entityType,
        _omdkLocalData = omdkLocalData,
        _operaUtils = operaUtils,
        _attachmentRepo = attachmentRepo,
        _assetRepo = assetRepo,
        _nodeRepo = nodeRepo,
        _scheduledRepo = scheduledRepo,
        super(const FieldImageState()) {
    on<LoadImages>(_onLoadImages);
    on<AddImage>(_onAddImage);
    on<TakeCameraPhoto>(_onTakeCameraPhoto);
    on<PickImage>(_onPickImage);
  }

  final String _entityGuid;
  final JEntityType _entityType;
  final OMDKLocalData _omdkLocalData;

  final OperaAttachmentRepo _attachmentRepo;
  final EntityRepo<Asset> _assetRepo;
  final EntityRepo<Node> _nodeRepo;
  final EntityRepo<ScheduledActivity> _scheduledRepo;
  final OperaUtils _operaUtils;

  Future<void> _onLoadImages(
    LoadImages event,
    Emitter<FieldImageState> emit,
  ) async {
    if (event.imageGuidList == null || event.imageGuidList!.isEmpty) {
      return emit(
        state.copyWith(
          fileList: [],
          attachmentList: [],
          loadingStatus: LoadingStatus.done,
        ),
      );
    }

    final fileList = <File?>[];
    final attachmentList = <Attachment?>[];
    final downloadPath =
        await _omdkLocalData.fileManager.getDownloadDirectoryPath;

    for (final guid in event.imageGuidList!) {
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
        } else {
          return emit(state.copyWith(loadingStatus: LoadingStatus.failure));
        }
      }

      File? file;
      try {
        file = await _omdkLocalData.fileManager
            .getFile('$downloadPath/${attachmentEntity.attachment.guid}/'
                '${attachmentEntity.attachment.fileName}');
      } on FileException {
        // Try to download file
        final downloadRequest = await _attachmentRepo.download(
          guidAttachment: guid,
        );
        final fileData = downloadRequest.fold(
          (fileData) => fileData,
          (failure) => throw failure,
        );

        // Create attachment folder
        final filePath = await _omdkLocalData.fileManager.createFolder(guid);
        file = await _omdkLocalData.fileManager.saveFile(
          fileData,
          '$filePath/${attachmentEntity.attachment.fileName}',
        );
        // Update attachmentEntity
        await _attachmentRepo.updateLocalItem(
          attachmentEntity.copyWith(mediaStatus: MediaStatus.synced),
          attachmentEntity.entity.guid!,
        );
      } on Exception catch (_) {
        file = null;
      }

      fileList.add(file);
      attachmentList.add(attachmentEntity);
    }
    return emit(
      state.copyWith(
        fileList: fileList,
        attachmentList: attachmentList,
        loadingStatus: LoadingStatus.done,
      ),
    );
  }

  Future<void> _onAddImage(
    AddImage event,
    Emitter<FieldImageState> emit,
  ) async {
    emit(state.copyWith(loadingStatus: LoadingStatus.inProgress));
    final db = _omdkLocalData.isarManager.dbInstance;
    final fileEntity = await _operaUtils.buildAttachmentEntity(event.file);
    // Save file to app directory
    final filePath = await _omdkLocalData.fileManager.createFolder(
      fileEntity.entity.guid!,
    );
    await _omdkLocalData.fileManager.saveFile(
      event.file.readAsBytesSync(),
      '$filePath/${fileEntity.attachment.fileName}',
    );

    // Save file with entity reference
    switch (_entityType) {
      case JEntityType.Asset:
        // Get entity reference from DB
        final entityReferenceRequest = await _assetRepo.readLocalItem(
          itemID: _entityGuid,
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
            fileList: state.fileList..add(event.file),
            attachmentList: state.attachmentList..add(fileEntity),
            notify: true,
          ),
        );
      case JEntityType.Node:
        // Get entity reference from DB
        final entityReferenceRequest = await _nodeRepo.readLocalItem(
          itemID: _entityGuid,
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
            fileList: state.fileList..add(event.file),
            attachmentList: state.attachmentList..add(fileEntity),
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

  Future<void> _onTakeCameraPhoto(
      TakeCameraPhoto event,
      Emitter<FieldImageState> emit,
      ) async {
    emit(state.copyWith(loadingStatus: LoadingStatus.inProgress));
    final imageFile = await _omdkLocalData.mediaManager.takePicture(
      CameraDevice.rear,
    );
    if (imageFile != null) {
      add(AddImage(File(imageFile.path)));
    }
  }

  Future<void> _onPickImage(
      PickImage event,
      Emitter<FieldImageState> emit,
      ) async {
    emit(state.copyWith(loadingStatus: LoadingStatus.inProgress));
    final imageFile = await _omdkLocalData.mediaManager.selectPicture();
    if (imageFile != null) {
      add(AddImage(File(imageFile.path)));
    }
  }
}
