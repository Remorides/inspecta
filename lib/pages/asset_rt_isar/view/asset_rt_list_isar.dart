import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk/elements/loaders/bottom_loader.dart';
import 'package:omdk/common/enums/loading_status.dart';
import 'package:omdk/pages/asset_rt_isar/asset_rt_isar.dart';
import 'package:omdk_repo/omdk_repo.dart';
import 'package:opera_api_asset/opera_api_asset.dart';

/// Example page to manage real time stream data from isarDB
class AssetRTListIsarPage extends StatelessWidget {
  /// Create [AssetRTListIsarPage] instance
  const AssetRTListIsarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AssetRTBloc(context.read<EntityRepo<Asset>>())
        ..add(AssetRTStreamSubscribe()),
      child: _AssetRTListIsar(),
    );
  }
}

class _AssetRTListIsar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssetRTBloc, AssetRTState>(
      builder: (context, state) {
        switch (state.loadingStatus) {
          case LoadingStatus.failure:
            return const Center(child: Text('Failed to fetch assets'));
          case LoadingStatus.done:
            if (state.assets.isEmpty) {
              return const Center(child: Text('No assets'));
            }
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return index >= state.assets.length
                    ? const BottomLoader()
                    : AssetRTListTile(asset: state.assets[index]);
              },
              itemCount: state.hasReachedMax
                  ? state.assets.length
                  : state.assets.length + 1,
            );
          case LoadingStatus.inProgress:
            return const BottomLoader();
          case LoadingStatus.initial:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
