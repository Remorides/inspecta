part of 'asset_bloc.dart';

/// Event for [AssetBloc]
@immutable
sealed class AssetEvent extends Equatable {
  @override
  List<Object> get props => [];
}

/// Event to collect new assets
final class AssetFetched extends AssetEvent {}

/// Subscribe to asset_isar data stream
final class AssetStreamSubscribe extends AssetEvent {}

/// Subscribe to asset_isar data stream
final class AssetToDelete extends AssetEvent {
  /// create [AssetToDelete] instance
  AssetToDelete({
    required this.asset,
    required this.assetIsarID,
  });

  /// [Asset] instance
  final Asset asset;
  /// if of [Asset] instance in isar collection
  final int assetIsarID;

  @override
  List<Object> get props => [asset, assetIsarID];
}
