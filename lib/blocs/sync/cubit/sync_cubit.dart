import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';
import 'package:omdk_inspecta/blocs/sync/enum/enum.dart';
import 'package:omdk_inspecta/common/common.dart';
import 'package:omdk_local_data/omdk_local_data.dart';
import 'package:omdk_opera_api/omdk_opera_api.dart';
import 'package:omdk_opera_repo/omdk_opera_repo.dart';
import 'package:omdk_repo/omdk_repo.dart';

part 'sync_cubit_state.dart';

class SyncCubit extends Cubit<SyncCubitState> {
  SyncCubit({
    required OMDKLocalData omdkLocalData,
    required EntityRepo<Asset> assetRepo,
    required EntityRepo<Node> nodeRepo,
    required EntityRepo<ScheduledActivity> scheduledRepo,
    required EntityRepo<MappingVersion> mappingVersionRepo,
    required OperaSynchronizationRepo synchronizationRepo,
    required OperaNodeOrganizationRepo nodeOrganizationRepo,
  })  : _omdkLocalData = omdkLocalData,
        _assetRepo = assetRepo,
        _nodeRepo = nodeRepo,
        _scheduledRepo = scheduledRepo,
        _mappingVersionRepo = mappingVersionRepo,
        _synchronizationRepo = synchronizationRepo,
        _nodeOrganizationRepo = nodeOrganizationRepo,
        super(const SyncCubitState());

  final OMDKLocalData _omdkLocalData;
  final EntityRepo<Asset> _assetRepo;
  final EntityRepo<Node> _nodeRepo;
  final EntityRepo<ScheduledActivity> _scheduledRepo;
  final EntityRepo<MappingVersion> _mappingVersionRepo;
  final OperaSynchronizationRepo _synchronizationRepo;
  final OperaNodeOrganizationRepo _nodeOrganizationRepo;

  void _resetState() => emit(const SyncCubitState());

  Future<void> syncData(JEntityType entityType) async {
    final entityRepo = switch (entityType) {
      JEntityType.unknown => throw UnimplementedError(),
      JEntityType.TemplateActivity => throw UnimplementedError(),
      JEntityType.ScheduledActivity => _scheduledRepo,
      JEntityType.Asset => _assetRepo,
      JEntityType.Node => _nodeRepo,
      JEntityType.User => throw UnimplementedError(),
      JEntityType.Group => throw UnimplementedError(),
      JEntityType.Tool => throw UnimplementedError(),
      JEntityType.SparePartGroup => throw UnimplementedError(),
      JEntityType.Warehouse => throw UnimplementedError(),
      JEntityType.IotDevice => throw UnimplementedError(),
      JEntityType.Partecipation => throw UnimplementedError(),
      JEntityType.Attachment => throw UnimplementedError(),
      JEntityType.Ticket => throw UnimplementedError(),
      JEntityType.Schema => throw UnimplementedError(),
      JEntityType.MappingScript => throw UnimplementedError(),
      JEntityType.Excel => throw UnimplementedError(),
    };
    final toUploadEntities = await _getToUploadEntities(entityType);

    final unUploadedEntities = <String>[];
    if (toUploadEntities.isNotEmpty) {
      emit(
        state.copyWith(
          loadingStatus: LoadingStatus.inProgress,
          itemToSync: toUploadEntities.length,
          itemSynced: 0,
          syncChanges: SyncChanges.added,
        ),
      );
      for (final i in toUploadEntities) {
        try {
          await _uploadEntity(entityRepo, i, i.entity.guid! as String);
          // Align attachments
          //await _checkAttachments(i, event.entityType, event.entityRepo);
          emit(state.copyWith(itemSynced: state.itemSynced + 1));
        } on DioException catch (e) {
          if (e.type == DioExceptionType.connectionError) {
            return _resetState();
          }
        } on Exception catch (e) {
          unUploadedEntities.add(i.entity.guid! as String);
          _omdkLocalData.logManager.log(LogType.error, e.toString());
        }
      }
    }

    final newToUploadEntities = await _getNewToUploadEntities(entityType);
    if (newToUploadEntities.isNotEmpty) {
      emit(
        state.copyWith(
          itemToSync: newToUploadEntities.length,
          itemSynced: 0,
          syncChanges: SyncChanges.added,
        ),
      );
      for (final i in newToUploadEntities) {
        try {
          await _uploadNewEntity(entityRepo, i, i.entity.guid! as String);
          // Align attachments
          //await _checkAttachments(i, event.entityType, _entityRepo);
          emit(state.copyWith(itemSynced: state.itemSynced + 1));
        } on DioException catch (e) {
          if (e.type == DioExceptionType.connectionError) {
            return _resetState();
          }
        } on Exception catch (e) {
          unUploadedEntities.add(i.entity.guid! as String);
          _omdkLocalData.logManager.log(LogType.error, e.toString());
        }
      }
    }

    final allEntities = await (entityRepo as EntityRepo).readAllLocalItems();
    final list = allEntities.fold(
      (data) => data
          .where((e) => e.syncStatus != SyncStatus.unknown)
          .map((e) => '${e.guid}:${e.rowVersion}')
          .toList(),
      (failure) => <String>[],
    );

    // Ask api for changes
    late SynchronizationStatus syncStatus;
    try {
      syncStatus = await _findChanges(entityType, list);
      emit(
        state.copyWith(
          itemToSync: syncStatus.newCount,
          itemSynced: 0,
          syncChanges: SyncChanges.added,
        ),
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        return _resetState();
      }
    } on Exception catch (e) {
      _omdkLocalData.logManager.log(LogType.error, e.toString());
    }

    // Add new entities to DB
    for (final guidRowVersion in syncStatus.added) {
      try {
        final entityRequest =
            await entityRepo.getAPIItem(guid: guidRowVersion.split(':').first);
        entityRequest.fold(
          (entity) async {
            if (entity is ScheduledActivity) {
              final mappingRequest = await _mappingVersionRepo.readLocalItem(
                itemID: entity.mapping!.guid!,
              );
              mappingRequest.fold(
                (data) => entity = (entity as ScheduledActivity).copyWith(
                  finalStateList: data.data.finalStateList,
                ),
                (f) async {
                  // Mapping not found in db, download it
                  _omdkLocalData.logManager.log(LogType.info, f.toString());
                  final mappingRequest = await _mappingVersionRepo.getAPIItem(
                    guid: (entity as ScheduledActivity).mapping!.guid!,
                  );
                  mappingRequest.fold(
                    (data) async {
                      await _mappingVersionRepo.saveLocalItem(data);
                      entity = (entity as ScheduledActivity).copyWith(
                        finalStateList: data.data.finalStateList,
                      );
                    },
                    (failure) => _omdkLocalData.logManager.log(
                      LogType.error,
                      failure.toString(),
                    ),
                  );
                },
              );
            }
            await entityRepo.saveLocalItem(entity);
            emit(state.copyWith(itemSynced: state.itemSynced + 1));
          },
          (failure) => _omdkLocalData.logManager.log(
            LogType.error,
            failure.toString(),
          ),
        );
      } catch (e, s) {
        _omdkLocalData.logManager
            .log(LogType.error, e.toString(), error: e, stackTrace: s);
        continue;
      }
    }

    // Remove from updated list items with local changes un-uploaded
    syncStatus.updated
        .removeWhere((e) => unUploadedEntities.contains(e.split(':').first));

    emit(
      state.copyWith(
        itemToSync: syncStatus.updated.length,
        itemSynced: 0,
        syncChanges: SyncChanges.updated,
      ),
    );

    // Update old entities in DB
    for (final guidRowVersion in syncStatus.updated) {
      try {
        final entityRequest =
            await entityRepo.getAPIItem(guid: guidRowVersion.split(':').first);
        entityRequest.fold(
          (entity) async {
            if (entity is ScheduledActivity) {
              final mappingRequest = await _mappingVersionRepo.readLocalItem(
                itemID: entity.mapping!.guid!,
              );
              mappingRequest.fold(
                (data) => entity.copyWith(
                  finalStateList: data.data.finalStateList,
                ),
                (failure) => _omdkLocalData.logManager.log(
                  LogType.error,
                  failure.toString(),
                ),
              );
            }
            await entityRepo.saveLocalItem(entity);
            emit(state.copyWith(itemSynced: state.itemSynced + 1));
          },
          (failure) => _omdkLocalData.logManager.log(
            LogType.error,
            failure.toString(),
          ),
        );
      } catch (e, s) {
        _omdkLocalData.logManager
            .log(LogType.error, e.toString(), error: e, stackTrace: s);
        continue;
      }
    }

    // Remove from deleted list items with local changes un-uploaded
    syncStatus.deleted
        .removeWhere((e) => unUploadedEntities.contains(e.split(':').first));

    emit(
      state.copyWith(
        itemToSync: syncStatus.deleted.length,
        itemSynced: 0,
        syncChanges: SyncChanges.deleted,
      ),
    );

    // Remove old entities in DB
    final deleteList =
        syncStatus.deleted.map((e) => e.split(':').first).toList();

    await entityRepo.deleteAllLocalItems(deleteList);
    if (entityType == JEntityType.Asset || entityType == JEntityType.Node) {
      await _nodeOrganizationRepo.deleteAllLocalItems(deleteList);
    }
    return _resetState();
  }

  Future<SynchronizationStatus> _findChanges(
    JEntityType entityType,
    List<String> guidRowVersionList, {
    String? filterBy,
  }) async {
    final syncEntityRequest = await _synchronizationRepo.findChanges(
      entityType: entityType,
      values: guidRowVersionList,
      filterBy: filterBy ??
          (entityType == JEntityType.TemplateActivity
              ? templateSyncFilter
              : null),
    );
    return syncEntityRequest.fold(
      (data) => data,
      (failure) => throw failure,
    );
  }

  Future<void> _uploadEntity(
    EntityRepo<dynamic> entityRepo,
    dynamic entity,
    String entityID,
  ) async {
    final entityRequest = await entityRepo.putAPIItem(entity);
    await entityRequest.fold(
      (successData) async => entityRepo.updateLocalItem(successData, entityID),
      (failure) => throw failure,
    );
  }

  Future<void> _uploadNewEntity(
    EntityRepo<dynamic> entityRepo,
    dynamic entity,
    String entityID,
  ) async {
    final entityRequest = await entityRepo.postAPIItem(entity);
    await entityRequest.fold(
      (successData) async => entityRepo.updateLocalItem(successData, entityID),
      (failure) => throw failure,
    );
  }

  Future<List<dynamic>> _getToUploadEntities(JEntityType entityType) async {
    switch (entityType) {
      case JEntityType.Asset:
        final collection = await _assetRepo.entityCollection;
        return collection
            .filter()
            .syncStatusEqualTo(SyncStatus.toUpload)
            .findAll();
      case JEntityType.Node:
        final collection = await _nodeRepo.entityCollection;
        return collection
            .filter()
            .syncStatusEqualTo(SyncStatus.toUpload)
            .findAll();
      case JEntityType.ScheduledActivity:
        final collection = await _scheduledRepo.entityCollection;
        return collection
            .filter()
            .syncStatusEqualTo(SyncStatus.toUpload)
            .findAll();
      default:
        throw Exception('Entity not found');
    }
  }

  Future<List<dynamic>> _getNewToUploadEntities(JEntityType entityType) async {
    switch (entityType) {
      case JEntityType.Asset:
        final collection = await _assetRepo.entityCollection;
        return collection
            .filter()
            .syncStatusEqualTo(SyncStatus.newToUpload)
            .findAll();
      case JEntityType.Node:
        final collection = await _nodeRepo.entityCollection;
        return collection
            .filter()
            .syncStatusEqualTo(SyncStatus.newToUpload)
            .findAll();
      case JEntityType.ScheduledActivity:
        final collection = await _scheduledRepo.entityCollection;
        return collection
            .filter()
            .syncStatusEqualTo(SyncStatus.newToUpload)
            .findAll();
      default:
        throw Exception('Entity not found');
    }
  }

  Future<void> syncNodeOrganization() async {
    emit(
      state.copyWith(
        loadingStatus: LoadingStatus.inProgress,
        itemSynced: 0,
        syncChanges: SyncChanges.deleted,
      ),
    );
    final nodeOrganizationRequest = await _nodeOrganizationRepo.getTree(
      includeChildren: true,
    );
    try {
      final nodeOrgCOl = await _nodeOrganizationRepo.entityCollection;
      final isarInstance = _omdkLocalData.isarManager.dbInstance;
      await isarInstance.writeTxn(() async {
        await nodeOrgCOl
            .filter()
            .assetEntity((q) => q.syncStatusEqualTo(SyncStatus.ok))
            .and()
            .nodeEntity((q) => q.syncStatusEqualTo(SyncStatus.ok))
            .deleteAll();
      });
      await nodeOrganizationRequest.fold(
        (nodeOrganization) async => _processNodeOrganization(nodeOrganization),
        (failure) => throw failure,
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        return _resetState();
      }
    } on Exception catch (e) {
      _omdkLocalData.logManager.log(LogType.error, e.toString());
    }

    return _resetState();
  }

  Future<void> _processNodeOrganization(
    List<OrganizationNode> orgNodes,
  ) async {
    for (final n in orgNodes) {
      switch (n.type) {
        case NodeType.Asset:
          final entityRequest =
              await _assetRepo.readLocalItem(itemID: n.asset!);
          entityRequest.fold(
            (entityData) async {
              final newN = n.copyWith(isRoot: true);
              newN.assetEntity.value = entityData;
              _nodeOrganizationRepo.saveLocalItemSync(newN);
            },
            (failure) => _omdkLocalData.logManager.log(
              LogType.error,
              failure.toString(),
            ),
          );
        case NodeType.Node:
          final entityRequest = await _nodeRepo.readLocalItem(itemID: n.node!);
          entityRequest.fold(
            (entityData) async {
              final newN = n.copyWith(isRoot: true);
              newN.nodeEntity.value = entityData;
              _nodeOrganizationRepo.saveLocalItemSync(newN);
              if (newN.nodes?.isNotEmpty ?? false) {
                final isarInstance = _omdkLocalData.isarManager.dbInstance;
                await _processNodeOrganizationItem(
                  db: isarInstance,
                  parent: newN,
                  children: newN.nodes!,
                );
              }
            },
            (failure) => _omdkLocalData.logManager.log(
              LogType.error,
              failure.toString(),
            ),
          );
        case NodeType.Unknown:
          break;
      }
    }
  }

  Future<void> _processNodeOrganizationItem({
    required Isar db,
    required OrganizationNode parent,
    required List<OrganizationNode> children,
  }) async {
    for (final child in children) {
      switch (child.type) {
        case NodeType.Asset:
          final entityRequest = await _assetRepo.readLocalItem(
            itemID: child.asset!,
          );
          entityRequest.fold(
            (entityData) async {
              child.assetEntity.value = entityData;
              child.nodeParent.value = parent;
              await _nodeOrganizationRepo.saveLocalItem(child);
              parent.children.add(child);
              // await db.writeTxn(() async {
              //   await parent.children.save();
              // });
            },
            (failure) => _omdkLocalData.logManager.log(
              LogType.error,
              failure.toString(),
            ),
          );
        case NodeType.Node:
          final entityRequest = await _nodeRepo.readLocalItem(
            itemID: child.node!,
          );
          entityRequest.fold(
            (entityData) async {
              child.nodeEntity.value = entityData;
              child.nodeParent.value = parent;
              await _nodeOrganizationRepo.saveLocalItem(child);
              parent.children.add(child);
              // await db.writeTxn(() async {
              //   await parent.children.save();
              // });
            },
            (failure) => _omdkLocalData.logManager.log(
              LogType.error,
              failure.toString(),
            ),
          );
        case NodeType.Unknown:
          break;
      }
      if (child.nodes?.isNotEmpty ?? false) {
        await _processNodeOrganizationItem(
          db: db,
          parent: child,
          children: child.nodes!,
        );
      }
    }
  }
}
