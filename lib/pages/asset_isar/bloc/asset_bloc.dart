import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:omdk/common/enums/loading_status.dart';
import 'package:omdk_repo/omdk_repo.dart';
import 'package:opera_api_asset/opera_api_asset.dart';
import 'package:stream_transform/stream_transform.dart';

part 'asset_event.dart';

part 'asset_state.dart';

/// Duration of throttle
const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> _throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

/// Bloc to manage asset_isar list
class AssetBloc extends Bloc<AssetEvent, AssetState> {
  /// Create [AssetBloc] instance
  AssetBloc({required this.assetRepo}) : super(const AssetState()) {
    on<AssetStreamSubscribe>(_onStreamSubRequested);
    on<AssetFetched>(
      _onAssetFetched,
      transformer: _throttleDroppable(throttleDuration),
    );
    on<AssetToDelete>(_onDeleteAsset);
  }

  /// [EntityRepo] instance
  final EntityRepo<Asset> assetRepo;

  Future<void> _onStreamSubRequested(
    AssetStreamSubscribe event,
    Emitter<AssetState> emit,
  ) async {
    emit(state.copyWith(status: LoadingStatus.inProgress));

    await assetRepo.readRange();

    await emit.forEach<List<Asset>>(
      assetRepo.getControllerStream(),
      onData: (assets) => state.copyWith(
        status: LoadingStatus.done,
        assets: assets,
      ),
      onError: (_, __) => state.copyWith(
        status: LoadingStatus.failure,
      ),
    );
  }

  Future<void> _onAssetFetched(
    AssetFetched event,
    Emitter<AssetState> emit,
  ) async {
    if (state.hasReachedMax) return;
    await assetRepo.readRange(
      state.assets.length,
      15,
      () => emit(state.copyWith(hasReachedMax: true)),
    );
  }

  Future<void> _onDeleteAsset(
    AssetToDelete event,
    Emitter<AssetState> emit,
  ) async {
    try {
      await assetRepo.deleteItem(event.asset, event.assetIsarID);
    } catch (_) {
      rethrow;
    }
  }
}
