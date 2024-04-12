import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:omdk/common/enums/loading_status.dart';
import 'package:omdk_repo/omdk_repo.dart';
import 'package:opera_api_asset/opera_api_asset.dart';

part 'asset_rt_event.dart';
part 'asset_rt_state.dart';

/// Bloc to manage asset_isar list
class AssetRTBloc extends Bloc<AssetRTEvent, AssetRTState> {
  /// Create [AssetRTBloc] instance
  AssetRTBloc(this._assetRepo) : super(const AssetRTState()) {
    on<AssetRTStreamSubscribe>(_onStreamSubRequested);
  }

  /// [EntityRepo] instance
  final EntityRepo<Asset> _assetRepo;

  Future<void> _onStreamSubRequested(
    AssetRTStreamSubscribe event,
    Emitter<AssetRTState> emit,
  ) async {
    emit(state.copyWith(status: LoadingStatus.inProgress));

    final entityCollection = await _assetRepo.entityCollection;
    final query = entityCollection.filter().idGreaterThan(0).build();
    final queryChanged = query.watch(fireImmediately: true);

    await emit.forEach<List<Asset>>(
      queryChanged,
      onData: (assets) => state.copyWith(
        status: LoadingStatus.done,
        assets: assets,
      ),
      onError: (_, __) => state.copyWith(
        status: LoadingStatus.failure,
      ),
    );
  }
}
