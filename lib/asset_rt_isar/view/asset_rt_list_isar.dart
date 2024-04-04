import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk/asset_isar/widgets/bottom_loader.dart';
import 'package:omdk/asset_rt_isar/bloc/asset_rt_bloc.dart';
import 'package:omdk/asset_rt_isar/widgets/asset_rt_list_item.dart';
import 'package:omdk/common/enums/loading_status.dart';
import 'package:omdk_repo/omdk_repo.dart';
import 'package:opera_api_asset/opera_api_asset.dart';


class AssetRTListIsarPage extends StatelessWidget {
  const AssetRTListIsarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AssetRTBloc(context.read<EntityRepo<Asset>>())
        ..add(AssetRTStreamSubscribe()),
      child: const AssetRTListIsar(),
    );
  }
}

class AssetRTListIsar extends StatefulWidget {
  const AssetRTListIsar({super.key});

  @override
  State<AssetRTListIsar> createState() => _AssetListIsarState();
}

class _AssetListIsarState extends State<AssetRTListIsar> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssetRTBloc, AssetRTState>(
      builder: (context, state) {
        switch (state.loadingStatus) {
          case LoadingStatus.failure:
            return const Center(child: Text('failed to fetch assets'));
          case LoadingStatus.done:
            if (state.assets.isEmpty) {
              return const Center(child: Text('no assets'));
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
              //controller: _scrollController,
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
