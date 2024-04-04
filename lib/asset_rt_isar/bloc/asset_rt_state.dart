part of 'asset_rt_bloc.dart';

/// [AssetRTBloc] state
final class AssetRTState extends Equatable {
  /// Create [AssetRTState] instance with default data
  const AssetRTState({
    this.loadingStatus = LoadingStatus.initial,
    this.assets = const <Asset>[],
    this.hasReachedMax = false,
  });

  /// Loading status of bloc
  final LoadingStatus loadingStatus;
  /// List of loaded asset_isar
  final List<Asset> assets;
  /// bool to know if is possible to load other assets
  final bool hasReachedMax;

  /// Update state value
  AssetRTState copyWith({
    LoadingStatus? status,
    List<Asset>? assets,
    bool? hasReachedMax,
  }) {
    return AssetRTState(
      loadingStatus: status ?? loadingStatus,
      assets: assets ?? this.assets,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [loadingStatus, assets, hasReachedMax];
}
