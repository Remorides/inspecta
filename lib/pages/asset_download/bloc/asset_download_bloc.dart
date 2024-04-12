import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:omdk/common/enums/loading_status.dart';
import 'package:omdk_api/omdk_api.dart';
import 'package:omdk_repo/omdk_repo.dart';
import 'package:opera_api_asset/opera_api_asset.dart';

part 'asset_download_event.dart';

part 'asset_download_state.dart';

class AssetDownloadBloc extends Bloc<AssetDownloadEvent, AssetDownloadState> {
  /// Create [AssetDownloadBloc] instance
  AssetDownloadBloc({required this.assetRepo})
      : super(const AssetDownloadState()) {
    on<AssetInputGuidChanged>(_onAssetInputGuidChanged);
    on<AssetDownload>(_onAssetDownload);
  }

  /// [OMDKRepo] instance
  final EntityRepo<Asset> assetRepo;

  Future<void> _onAssetInputGuidChanged(
    AssetInputGuidChanged event,
    Emitter<AssetDownloadState> emit,
  ) async {
    emit(
      state.copyWith(
        assetGuid: event.assetGuid,
      ),
    );
  }

  Future<void> _onAssetDownload(
    AssetDownload event,
    Emitter<AssetDownloadState> emit,
  ) async {
    emit(state.copyWith(loadingStatus: LoadingStatus.inProgress));
    try {
      final response = await assetRepo.getAPIItem(guid: state.assetGuid);
      final result = switch (response) {
        Success<dynamic, Exception>(value: final asset) => asset,
        Failure<dynamic, Exception>(exception: final e) => throw e,
      };
      if (result is Asset) {
        await assetRepo.addItem(result);
      }
      emit(state.copyWith(loadingStatus: LoadingStatus.done));
    } catch (_) {
      emit(state.copyWith(loadingStatus: LoadingStatus.failure));
    }
  }
}
