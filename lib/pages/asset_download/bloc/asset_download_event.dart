part of 'asset_download_bloc.dart';

@immutable
sealed class AssetDownloadEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Event to get asset_isar from remote server
final class AssetDownload extends AssetDownloadEvent {}

final class AssetInputGuidChanged extends AssetDownloadEvent {
  AssetInputGuidChanged(this.assetGuid);

  final String assetGuid;

  @override
  List<Object> get props => [assetGuid];
}