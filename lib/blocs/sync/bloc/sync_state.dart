part of 'sync_bloc.dart';

final class SyncState extends Equatable {
  const SyncState({
    this.loadingStatus = LoadingStatus.initial,
    this.errorText,
    this.entityType = JEntityType.unknown,
    this.entitySynced = 0,
    this.entityToSync = 9,
    this.itemSynced = 0,
    this.itemToSync = 0,
    this.syncChanges = SyncChanges.upload,
  });

  SyncState copyWith({
    LoadingStatus? loadingStatus,
    String? errorText,
    JEntityType? entityType,
    int? entitySynced,
    SyncChanges? syncChanges,
    int? itemToSync,
    int? itemSynced,
  }) =>
      SyncState(
        loadingStatus: loadingStatus ?? this.loadingStatus,
        errorText: errorText ?? this.errorText,
        entityType: entityType ?? this.entityType,
        entitySynced: entitySynced ?? this.entitySynced,
        entityToSync: entityToSync,
        syncChanges: syncChanges ?? this.syncChanges,
        itemToSync: itemToSync ?? this.itemToSync,
        itemSynced: itemSynced ?? this.itemSynced,
      );

  final LoadingStatus loadingStatus;
  final String? errorText;
  final JEntityType entityType;
  final int entitySynced;
  final int entityToSync;
  final SyncChanges syncChanges;
  final int itemToSync;
  final int itemSynced;

  @override
  List<Object?> get props => [
        loadingStatus,
        errorText,
        entityType,
        entitySynced,
        syncChanges,
        itemToSync,
        itemSynced,
      ];
}
