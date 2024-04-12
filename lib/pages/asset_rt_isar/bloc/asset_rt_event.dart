part of 'asset_rt_bloc.dart';

/// Event for [AssetRTBloc]
@immutable
sealed class AssetRTEvent extends Equatable {
  @override
  List<Object> get props => [];
}

/// Subscribe to asset_isar data stream
final class AssetRTStreamSubscribe extends AssetRTEvent {}

/// Subscribe to asset_isar data stream
final class AssetRTToDelete extends AssetRTEvent {
  /// create [AssetRTToDelete] instance
  AssetRTToDelete({
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
