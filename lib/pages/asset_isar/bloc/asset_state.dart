part of 'asset_bloc.dart';

/// [AssetBloc] state
final class AssetState extends Equatable {
  /// Create [AssetState] instance with default data
  const AssetState({
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
  AssetState copyWith({
    LoadingStatus? status,
    List<Asset>? assets,
    bool? hasReachedMax,
  }) {
    return AssetState(
      loadingStatus: status ?? loadingStatus,
      assets: assets ?? this.assets,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [loadingStatus, assets, hasReachedMax];
}
