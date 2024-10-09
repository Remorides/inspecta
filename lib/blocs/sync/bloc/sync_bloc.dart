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

part 'sync_event.dart';
part 'sync_state.dart';

class SyncBloc extends Bloc<SyncEvent, SyncState> {
  /// Create [SyncBloc] instance
  SyncBloc({
    required this.assetRepo,
    required this.nodeRepo,
    required this.attachmentRepo,
    required this.scheduledRepo,
    required this.schemaRepo,
    required this.templateRepo,
    required this.groupRepo,
    required this.mappingVersionRepo,
    required this.userRepo,
    required this.mappingMapRepo,
    required this.nodeOrganizationRepo,
    required this.synchronizationRepo,
    required this.omdkLocalData,
  }) : super(const SyncState()) {
    on<SkipSync>(_onSkipSync);
    on<SyncNextEntity>(_onSyncNextEntity);
    on<SyncMappingMap>(_onSyncMappingMap);
    on<SyncMappingEntity>(_onSyncMappingEntity);
    on<SyncEntity>(_onSyncEntity);
    on<SyncNodeOrganization>(_onSyncNodeOrganization);
  }

  final EntityRepo<Asset> assetRepo;
  final EntityRepo<Node> nodeRepo;
  final OperaAttachmentRepo attachmentRepo;
  final EntityRepo<ScheduledActivity> scheduledRepo;
  final EntityRepo<OSchema> schemaRepo;
  final EntityRepo<TemplateActivity> templateRepo;
  final EntityRepo<Group> groupRepo;
  final EntityRepo<MappingVersion> mappingVersionRepo;
  final OperaNodeOrganizationRepo nodeOrganizationRepo;
  final OperaUserRepo userRepo;
  final OperaMappingMapRepo mappingMapRepo;
  final OperaSynchronizationRepo synchronizationRepo;

  /// [OMDKLocalData] instance
  final OMDKLocalData omdkLocalData;

  Future<void> _onSkipSync(
    SkipSync event,
    Emitter<SyncState> emit,
  ) async {
    return emit(state.copyWith(loadingStatus: LoadingStatus.done));
  }

  Future<void> _onSyncNextEntity(
    SyncNextEntity event,
    Emitter<SyncState> emit,
  ) async {
    emit(state.copyWith(loadingStatus: LoadingStatus.inProgress));

    final indexNextEntity = JEntityType.values.indexOf(state.entityType) + 1;
    if (indexNextEntity >= JEntityType.values.length) {
      return emit(state.copyWith(loadingStatus: LoadingStatus.done));
    }
    switch (JEntityType.values[indexNextEntity]) {
      case JEntityType.Asset:
        return add(
          SyncEntity(entityRepo: assetRepo, entityType: JEntityType.Asset),
        );
      case JEntityType.Node:
        return add(
          SyncEntity(entityRepo: nodeRepo, entityType: JEntityType.Node),
        );
      case JEntityType.ScheduledActivity:
        return add(
          SyncEntity(
            entityRepo: scheduledRepo,
            entityType: JEntityType.ScheduledActivity,
          ),
        );
      case JEntityType.User:
        return add(
          SyncEntity(entityRepo: userRepo, entityType: JEntityType.User),
        );
      case JEntityType.Schema:
        return add(
          SyncEntity(entityRepo: schemaRepo, entityType: JEntityType.Schema),
        );
      case JEntityType.Group:
        return add(
          SyncEntity(entityRepo: groupRepo, entityType: JEntityType.Group),
        );
      case JEntityType.MappingScript: // Used to sync mapping
        return add(SyncMappingMap());
      case JEntityType.Excel: // Used to sync node organization
        return add(SyncNodeOrganization());
      case JEntityType.TemplateActivity:
      case JEntityType.Attachment:
      case JEntityType.Tool:
      case JEntityType.SparePartGroup:
      case JEntityType.Warehouse:
      case JEntityType.IotDevice:
      case JEntityType.Partecipation:
      case JEntityType.Ticket:
      case JEntityType.unknown:
        emit(state.copyWith(entityType: JEntityType.values[indexNextEntity]));
        return add(SyncNextEntity());
    }
  }

  Future<void> _onSyncEntity(
    SyncEntity event,
    Emitter<SyncState> emit,
  ) async {
    final toUploadEntities = await _getToUploadEntities(event.entityRepo);

    final unUploadedEntities = <String>[];
    if (toUploadEntities.isNotEmpty) {
      emit(
        state.copyWith(
          entityType: event.entityType,
          entitySynced: state.entitySynced + 1,
          itemToSync: toUploadEntities.length,
          itemSynced: 0,
          syncChanges: SyncChanges.added,
        ),
      );
      for (final i in toUploadEntities) {
        try {
          await _uploadEntity(event.entityRepo, i, i.entity.guid! as String);
          // Align attachments
          //await _checkAttachments(i, event.entityType, event.entityRepo);
          emit(state.copyWith(itemSynced: state.itemSynced + 1));
        } on DioException catch (e) {
          if (e.type == DioExceptionType.connectionError) {
            return add(SkipSync());
          }
        } on Exception catch (e) {
          unUploadedEntities.add(i.entity.guid! as String);
          omdkLocalData.logManager.log(LogType.error, e.toString());
        }
      }
    }

    final newToUploadEntities = await _getNewToUploadEntities(event.entityRepo);
    if (newToUploadEntities.isNotEmpty) {
      emit(
        state.copyWith(
          entityType: event.entityType,
          entitySynced: state.entitySynced + 1,
          itemToSync: newToUploadEntities.length,
          itemSynced: 0,
          syncChanges: SyncChanges.added,
        ),
      );
      for (final i in newToUploadEntities) {
        try {
          await _uploadNewEntity(event.entityRepo, i, i.entity.guid! as String);
          // Align attachments
          //await _checkAttachments(i, event.entityType, event.entityRepo);
          emit(state.copyWith(itemSynced: state.itemSynced + 1));
        } on DioException catch (e) {
          if (e.type == DioExceptionType.connectionError) {
            return add(SkipSync());
          }
        } on Exception catch (e) {
          unUploadedEntities.add(i.entity.guid! as String);
          omdkLocalData.logManager.log(LogType.error, e.toString());
        }
      }
    }

    final allEntities = await event.entityRepo.readAllLocalItems();
    final list = allEntities.fold(
      (data) => data
          .where((e) => e.syncStatus != SyncStatus.unknown)
          .map((e) => '${e.guid}:${e.rowVersion}')
          .toList(),
      (failure) => <String>[],
    );

    // Ask api for changes
    SynchronizationStatus? syncStatus;
    try {
      syncStatus = await _findChanges(event.entityType, list);
      emit(
        state.copyWith(
          entityType: event.entityType,
          entitySynced: state.entitySynced + 1,
          itemToSync: syncStatus.newCount,
          itemSynced: 0,
          syncChanges: SyncChanges.added,
        ),
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        return add(SkipSync());
      }
    } on Exception catch (e) {
      omdkLocalData.logManager.log(LogType.error, e.toString());
    }

    if (syncStatus == null) {
      return emit(state.copyWith(loadingStatus: LoadingStatus.failure));
    }

    // Add new entities to DB
    for (final guidRowVersion in syncStatus.added) {
      try {
        final entityRequest = await event.entityRepo
            .getAPIItem(guid: guidRowVersion.split(':').first);
        entityRequest.fold(
          (entity) async {
            try {
              if (entity is ScheduledActivity) {
                final mappingRequest = await mappingVersionRepo.readLocalItem(
                  itemID: entity.mapping!.guid!,
                );
                mappingRequest.fold(
                  (data) => entity = entity.copyWith(
                    finalStateList: data.data.finalStateList,
                  ),
                  (f) async {
                    // Mapping not found in db, download it
                    omdkLocalData.logManager.log(LogType.info, f.toString());
                    final mappingRequest = await mappingVersionRepo.getAPIItem(
                      guid: entity.mapping!.guid! as String,
                    );
                    mappingRequest.fold(
                      (data) async {
                        await mappingVersionRepo.saveLocalItem(data);
                        entity = entity.copyWith(
                          finalStateList: data.data.finalStateList,
                        );
                      },
                      (failure) => omdkLocalData.logManager.log(
                        LogType.error,
                        failure.toString(),
                      ),
                    );
                  },
                );
              }
              await event.entityRepo.saveLocalItem(entity);
              emit(state.copyWith(itemSynced: state.itemSynced + 1));
            } on Exception catch (e) {
              omdkLocalData.logManager.log(LogType.error, e.toString());
            }
          },
          (failure) => omdkLocalData.logManager.log(
            LogType.error,
            failure.toString(),
          ),
        );
      } catch (e, s) {
        omdkLocalData.logManager
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
        final entityRequest = await event.entityRepo
            .getAPIItem(guid: guidRowVersion.split(':').first);
        entityRequest.fold(
          (entity) async {
            try {
              if (entity is ScheduledActivity) {
                final mappingRequest = await mappingVersionRepo.readLocalItem(
                  itemID: entity.mapping!.guid!,
                );
                mappingRequest.fold(
                  (data) => entity = entity.copyWith(
                    finalStateList: data.data.finalStateList,
                  ),
                  (failure) => omdkLocalData.logManager.log(
                    LogType.error,
                    failure.toString(),
                  ),
                );
              }
              await event.entityRepo.saveLocalItem(entity);
              emit(state.copyWith(itemSynced: state.itemSynced + 1));
            } on Exception catch (e) {
              omdkLocalData.logManager.log(LogType.error, e.toString());
            }
          },
          (failure) => omdkLocalData.logManager.log(
            LogType.error,
            failure.toString(),
          ),
        );
      } catch (e, s) {
        omdkLocalData.logManager.log(
          LogType.error,
          e.toString(),
          error: e,
          stackTrace: s,
        );
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

    await event.entityRepo.deleteAllLocalItems(deleteList);
    if (event.entityType == JEntityType.Asset ||
        event.entityType == JEntityType.Node) {
      await nodeOrganizationRepo.deleteAllLocalItems(deleteList);
    }
    if (event.endSync) {
      return add(SkipSync());
    } else {
      return add(SyncNextEntity());
    }
  }

  Future<void> _onSyncMappingMap(
    SyncMappingMap event,
    Emitter<SyncState> emit,
  ) async {
    emit(
      state.copyWith(
        entityType: JEntityType.MappingScript,
        entitySynced: state.entitySynced + 1,
        itemToSync: 0,
        itemSynced: 0,
        syncChanges: SyncChanges.added,
      ),
    );

    final nodeMapsRequest = await mappingMapRepo.getMappingMaps(
      entityType: JEntityType.Node,
      isDefault: true,
      isEnabled: true,
      isDraft: false,
      includeMappingData: false,
    );
    final nodeMaps = nodeMapsRequest.fold(
      (nodeMaps) => nodeMaps,
      (failure) => throw Exception(failure.toString()),
    );

    final assetMapsRequest = await mappingMapRepo.getMappingMaps(
      entityType: JEntityType.Asset,
      isDefault: true,
      isEnabled: true,
      isDraft: false,
      includeMappingData: false,
    );

    final assetMaps = assetMapsRequest.fold(
      (assetMaps) => assetMaps,
      (failure) => throw failure,
    );

    final allMappingMaps = nodeMaps.toSet().union(assetMaps.toSet()).toList();
    await mappingMapRepo.saveLocalItems(allMappingMaps);
    return add(SyncMappingEntity(allMappingMaps));
  }

  Future<void> _onSyncMappingEntity(
    SyncMappingEntity event,
    Emitter<SyncState> emit,
  ) async {
    // Retrieve all MappingVersion guid from DB
    final allMappingVersionRequest =
        await mappingVersionRepo.readAllLocalItems();
    final mappingVersionList = allMappingVersionRequest.fold(
      (data) => data.map((e) => e.guid).toList(),
      (failure) => throw failure,
    );

    var toDownloadList = <String>[];
    for (final i in event.mappingMaps) {
      toDownloadList = toDownloadList
          .toSet()
          .union(i.versions!.map((e) => e.guid!).toSet())
          .toList();
    }

    toDownloadList =
        toDownloadList.toSet().difference(mappingVersionList.toSet()).toList();

    emit(
      state.copyWith(
        itemToSync: toDownloadList.length,
        itemSynced: 0,
        syncChanges: SyncChanges.added,
      ),
    );

    for (final guid in toDownloadList) {
      final mappingVersionRequest =
          await mappingVersionRepo.getAPIItem(guid: guid);
      mappingVersionRequest.fold(
        (mappingVersion) async =>
            mappingVersionRepo.saveLocalItem(mappingVersion),
        (failure) => omdkLocalData.logManager.log(
          LogType.error,
          failure.toString(),
        ),
      );
      emit(state.copyWith(itemSynced: state.itemSynced + 1));
    }
    return add(SyncNextEntity());
  }

  Future<void> _onSyncNodeOrganization(
    SyncNodeOrganization event,
    Emitter<SyncState> emit,
  ) async {
    emit(
      state.copyWith(
        entityType: JEntityType.Excel, // last entity
        entitySynced: state.entitySynced + 1,
        itemSynced: 0,
        syncChanges: SyncChanges.added,
      ),
    );
    final nodeOrganizationRequest = await nodeOrganizationRepo.getTree(
      includeChildren: true,
    );
    try {
      final isarInstance = omdkLocalData.isarManager.dbInstance;
      await nodeOrganizationRequest.fold(
        (nodeOrganization) async => _processNodeOrganization(
          isarInstance,
          nodeOrganization,
        ),
        (failure) => throw failure,
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        return add(SkipSync());
      }
    } on Exception catch (e) {
      omdkLocalData.logManager.log(LogType.error, e.toString());
    }

    return add(SyncNextEntity());
  }

  Future<void> _processNodeOrganization(
    Isar isarInstance,
    List<OrganizationNode> orgNodes,
  ) async {
    for (final n in orgNodes) {
      switch (n.type) {
        case NodeType.Asset:
          final entityRequest = await assetRepo.readLocalItem(itemID: n.asset!);
          await entityRequest.fold(
            (entityData) async {
              final newN = n.copyWith(isRoot: true);
              newN.assetEntity.value = entityData;
              nodeOrganizationRepo.saveLocalItemSync(newN);
            },
            (failure) => null,
          );
        case NodeType.Node:
          final entityRequest = await nodeRepo.readLocalItem(itemID: n.node!);
          await entityRequest.fold(
            (entityData) async {
              final newN = n.copyWith(isRoot: true);
              newN.nodeEntity.value = entityData;
              nodeOrganizationRepo.saveLocalItemSync(newN);
              if (newN.nodes?.isNotEmpty ?? false) {
                await _processNodeOrganizationItem(
                  db: isarInstance,
                  parent: newN,
                  children: newN.nodes!,
                );
              }
            },
            (failure) => null,
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
          final entityRequest = await assetRepo.readLocalItem(
            itemID: child.asset!,
          );
          await entityRequest.fold(
            (entityData) async {
              child.assetEntity.value = entityData;
              child.nodeParent.value = parent;
              nodeOrganizationRepo.saveLocalItemSync(child);
              parent.children.add(child);
              await db.writeTxn(() async {
                await parent.children.save();
              });
            },
            (failure) => null,
          );
        case NodeType.Node:
          final entityRequest = await nodeRepo.readLocalItem(
            itemID: child.node!,
          );
          await entityRequest.fold(
            (entityData) async {
              child.nodeEntity.value = entityData;
              child.nodeParent.value = parent;
              nodeOrganizationRepo.saveLocalItemSync(child);
              parent.children.add(child);
              await db.writeTxn(() async {
                await parent.children.save();
              });
            },
            (failure) => null,
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

  Future<SynchronizationStatus> _findChanges(
    JEntityType entityType,
    List<String> guidRowVersionList, {
    String? filterBy,
  }) async {
    final syncEntityRequest = await synchronizationRepo.findChanges(
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

  // Future<void> _checkAttachments(
  //   dynamic entity,
  //   JEntityType entityType,
  //   EntityRepo<dynamic> entityRepo,
  // ) async {
  //   switch (entityType) {
  //     case JEntityType.Asset:
  //       final removedAttachments = (entity as Asset)
  //           .attachmentsList
  //           .where((e) => e.removed != null)
  //           .map((e) => e.guid)
  //           .toList();
  //       for (final guid in removedAttachments) {
  //         final attachmentRequest =
  //             await attachmentRepo.readLocalItem(itemID: guid!);
  //         attachmentRequest.fold(
  //           (attachmentData) => entity.attachments.remove(attachmentData),
  //           (failure) => null,
  //         );
  //       }
  //       await assetRepo.updateLocalItem(entity, entity.guid!);
  //     case JEntityType.Node:
  //       final removedAttachments = (entity as Node)
  //           .attachmentsList
  //           .where((e) => e.removed != null)
  //           .map((e) => e.guid)
  //           .toList();
  //       for (final guid in removedAttachments) {
  //         final attachmentRequest =
  //             await attachmentRepo.readLocalItem(itemID: guid!);
  //         attachmentRequest.fold(
  //           (attachmentData) => entity.attachments.remove(attachmentData),
  //           (failure) => null,
  //         );
  //       }
  //       await nodeRepo.updateLocalItem(entity, entity.guid!);
  //     case JEntityType.ScheduledActivity:
  //       final removedAttachments = (entity as ScheduledActivity)
  //           .attachmentsList
  //           .where((e) => e.removed != null)
  //           .map((e) => e.guid)
  //           .toList();
  //       for (final guid in removedAttachments) {
  //         final attachmentRequest =
  //             await attachmentRepo.readLocalItem(itemID: guid!);
  //         attachmentRequest.fold(
  //           (attachmentData) => entity.attachments.remove(attachmentData),
  //           (failure) => null,
  //         );
  //       }
  //       await scheduledRepo.updateLocalItem(entity, entity.guid!);
  //     case JEntityType.User:
  //     case JEntityType.Schema:
  //     case JEntityType.Group:
  //     case JEntityType.MappingScript:
  //     case JEntityType.Excel:
  //     case JEntityType.TemplateActivity:
  //     case JEntityType.Attachment:
  //     case JEntityType.Tool:
  //     case JEntityType.SparePartGroup:
  //     case JEntityType.Warehouse:
  //     case JEntityType.IotDevice:
  //     case JEntityType.Partecipation:
  //     case JEntityType.Ticket:
  //     case JEntityType.unknown:
  //       break;
  //   }
  // }

  Future<List<dynamic>> _getToUploadEntities(
    EntityRepo<dynamic> entityRepo,
  ) async {
    switch (entityRepo.entity) {
      case Asset:
        final collection = await assetRepo.entityCollection;
        return collection
            .filter()
            .syncStatusEqualTo(SyncStatus.toUpload)
            .findAll();
      case Node:
        final collection = await nodeRepo.entityCollection;
        return collection
            .filter()
            .syncStatusEqualTo(SyncStatus.toUpload)
            .findAll();
      case ScheduledActivity:
        final collection = await scheduledRepo.entityCollection;
        return collection
            .filter()
            .syncStatusEqualTo(SyncStatus.toUpload)
            .findAll();
      case TemplateActivity:
        final collection = await templateRepo.entityCollection;
        return collection
            .filter()
            .syncStatusEqualTo(SyncStatus.toUpload)
            .findAll();
      case User:
        final collection = await userRepo.entityCollection;
        return collection
            .filter()
            .syncStatusEqualTo(SyncStatus.toUpload)
            .findAll();
      case Group:
        final collection = await groupRepo.entityCollection;
        return collection
            .filter()
            .syncStatusEqualTo(SyncStatus.toUpload)
            .findAll();
      case OSchema:
        final collection = await schemaRepo.entityCollection;
        return collection
            .filter()
            .syncStatusEqualTo(SyncStatus.toUpload)
            .findAll();
      default:
        throw Exception('Entity not found');
    }
  }

  Future<List<dynamic>> _getNewToUploadEntities(
    EntityRepo<dynamic> entityRepo,
  ) async {
    switch (entityRepo.entity) {
      case Asset:
        final collection = await assetRepo.entityCollection;
        return collection
            .filter()
            .syncStatusEqualTo(SyncStatus.newToUpload)
            .findAll();
      case Node:
        final collection = await nodeRepo.entityCollection;
        return collection
            .filter()
            .syncStatusEqualTo(SyncStatus.newToUpload)
            .findAll();
      case ScheduledActivity:
        final collection = await scheduledRepo.entityCollection;
        return collection
            .filter()
            .syncStatusEqualTo(SyncStatus.newToUpload)
            .findAll();
      case TemplateActivity:
        final collection = await templateRepo.entityCollection;
        return collection
            .filter()
            .syncStatusEqualTo(SyncStatus.newToUpload)
            .findAll();
      case User:
        final collection = await userRepo.entityCollection;
        return collection
            .filter()
            .syncStatusEqualTo(SyncStatus.newToUpload)
            .findAll();
      case Group:
        final collection = await groupRepo.entityCollection;
        return collection
            .filter()
            .syncStatusEqualTo(SyncStatus.newToUpload)
            .findAll();
      case OSchema:
        final collection = await schemaRepo.entityCollection;
        return collection
            .filter()
            .syncStatusEqualTo(SyncStatus.newToUpload)
            .findAll();
      default:
        throw Exception('Entity not found');
    }
  }
}
