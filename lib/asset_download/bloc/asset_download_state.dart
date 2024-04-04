part of 'asset_download_bloc.dart';

final class AssetDownloadState extends Equatable {

  const AssetDownloadState({
    this.loadingStatus = LoadingStatus.initial,
    this.assetGuid = '',
  });

  final LoadingStatus loadingStatus;
  final String assetGuid;

  AssetDownloadState copyWith({
    LoadingStatus? loadingStatus,
    String? assetGuid,
    bool? isValid,
  }) {
    return AssetDownloadState(
      loadingStatus: loadingStatus ?? this.loadingStatus,
      assetGuid: assetGuid ?? this.assetGuid,
    );
  }

  @override
  List<Object> get props => [loadingStatus, assetGuid];
}
