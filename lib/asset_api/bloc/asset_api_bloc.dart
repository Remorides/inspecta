import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:omdk/common/enums/loading_status.dart';
import 'package:omdk_repo/omdk_repo.dart';
import 'package:opera_api_asset/opera_api_asset.dart';
import 'package:stream_transform/stream_transform.dart';

part 'asset_api_event.dart';

part 'asset_api_state.dart';

/// Duration of throttle
const throttleDuration = Duration(milliseconds: 300);

EventTransformer<E> _throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class AssetApiBloc extends Bloc<AssetApiEvent, AssetApiState> {
  AssetApiBloc(this.assetRepo) : super(const AssetApiState()) {
    on<AssetApiStreamSubscribe>(_onStreamSubRequested);
    on<AssetApiFetched>(
      _onAssetFetched,
      transformer: _throttleDroppable(throttleDuration),
    );
  }

  /// [EntityRepo] instance
  final EntityRepo<AssetListItem> assetRepo;

  Future<void> _onStreamSubRequested(
    AssetApiStreamSubscribe event,
    Emitter<AssetApiState> emit,
  ) async {
    emit(state.copyWith(status: LoadingStatus.inProgress));

    await assetRepo.getPageAPIItem(
      state.pageNumber,
      15,
      () => emit(state.copyWith(hasReachedMax: true)),
    );

    await emit.forEach<List<AssetListItem>>(
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
    AssetApiFetched event,
    Emitter<AssetApiState> emit,
  ) async {
    if (state.hasReachedMax) return;
    try {
      await assetRepo.getPageAPIItem(
        state.pageNumber,
        15,
        () => emit(state.copyWith(hasReachedMax: true)),
      );
      emit(state.copyWith(pageNumber: state.pageNumber + 1));
    } catch (e) {
      emit(state.copyWith(status: LoadingStatus.failure));
    }
  }
}
