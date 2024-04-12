import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk/elements/loaders/bottom_loader.dart';
import 'package:omdk/common/enums/loading_status.dart';
import 'package:omdk/pages/asset_isar/asset_isar.dart';
import 'package:omdk_repo/omdk_repo.dart';
import 'package:opera_api_asset/opera_api_asset.dart';

class AssetListIsarPage extends StatelessWidget {
  const AssetListIsarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AssetBloc(assetRepo: context.read<EntityRepo<Asset>>())
        ..add(AssetStreamSubscribe()),
      child: const AssetListIsar(),
    );
  }
}

class AssetListIsar extends StatefulWidget {
  const AssetListIsar({super.key});

  @override
  State<AssetListIsar> createState() => _AssetListIsarState();
}

class _AssetListIsarState extends State<AssetListIsar> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssetBloc, AssetState>(
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
                    : AssetListTile(asset: state.assets[index]);
              },
              itemCount: state.hasReachedMax
                  ? state.assets.length
                  : state.assets.length + 1,
              controller: _scrollController,
            );
          case LoadingStatus.inProgress:
            return const BottomLoader();
          case LoadingStatus.initial:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<AssetBloc>().add(AssetFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}