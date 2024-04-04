part of 'asset_api_bloc.dart';

/// [AssetApiState] state
final class AssetApiState extends Equatable {
  /// Create [AssetApiState] instance with default data
  const AssetApiState({
    this.loadingStatus = LoadingStatus.initial,
    this.assets = const <AssetListItem>[],
    this.hasReachedMax = false,
    this.pageNumber = 0,
  });

  /// Loading status of bloc
  final LoadingStatus loadingStatus;
  /// List of loaded asset_isar
  final List<AssetListItem> assets;
  /// bool to know if is possible to load other assets
  final bool hasReachedMax;
  /// page number
  final int pageNumber;

  /// Update state value
  AssetApiState copyWith({
    LoadingStatus? status,
    List<AssetListItem>? assets,
    bool? hasReachedMax,
    int? pageNumber,
  }) {
    return AssetApiState(
      loadingStatus: status ?? loadingStatus,
      assets: assets ?? this.assets,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      pageNumber: pageNumber ?? this.pageNumber,
    );
  }

  @override
  List<Object?> get props => [loadingStatus, assets, hasReachedMax, pageNumber];
}
