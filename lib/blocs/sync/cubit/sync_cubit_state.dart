part of 'sync_cubit.dart';

final class SyncCubitState extends Equatable {
  const SyncCubitState({
    this.loadingStatus = LoadingStatus.initial,
    this.itemSynced = 0,
    this.itemToSync = 0,
    this.syncChanges = SyncChanges.upload,
  });

  final LoadingStatus loadingStatus;
  final SyncChanges syncChanges;
  final int itemToSync;
  final int itemSynced;

  SyncCubitState copyWith({
    LoadingStatus? loadingStatus,
    SyncChanges? syncChanges,
    int? itemToSync,
    int? itemSynced,
  }) =>
      SyncCubitState(
        loadingStatus: loadingStatus ?? this.loadingStatus,
        syncChanges: syncChanges ?? this.syncChanges,
        itemToSync: itemToSync ?? this.itemToSync,
        itemSynced: itemSynced ?? this.itemSynced,
      );

  @override
  List<Object?> get props => [
        loadingStatus,
        syncChanges,
        itemToSync,
        itemSynced,
      ];
}
