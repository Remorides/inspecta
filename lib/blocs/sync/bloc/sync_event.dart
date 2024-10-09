part of 'sync_bloc.dart';

sealed class SyncEvent extends Equatable {
  const SyncEvent();

  @override
  List<Object?> get props => [];
}

final class SyncNextEntity extends SyncEvent {}

final class SkipSync extends SyncEvent {}

final class SyncEntity extends SyncEvent {
  const SyncEntity({
    required this.entityRepo,
    required this.entityType,
    this.endSync = false,
  });

  final EntityRepo<dynamic> entityRepo;
  final JEntityType entityType;
  final bool endSync;
}

final class SyncMappingMap extends SyncEvent {}

final class SyncNodeOrganization extends SyncEvent {}

final class SyncMappingEntity extends SyncEvent {
  SyncMappingEntity(this.mappingMaps);

  final List<MappingMap> mappingMaps;
}
