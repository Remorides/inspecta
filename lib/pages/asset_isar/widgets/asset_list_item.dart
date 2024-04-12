import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opera_api_asset/opera_api_asset.dart';

import '../bloc/asset_bloc.dart';

class AssetListTile extends StatelessWidget {
  const AssetListTile({required this.asset, super.key});

  final Asset asset;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        leading: Text('${asset.id}'),
        trailing: InkWell(
          onTap: () => context
              .read<AssetBloc>()
              .add(AssetToDelete(asset: asset, assetIsarID: asset.id!)),
          child: const Icon(
            Icons.delete_forever_outlined,
            color: Colors.red,
          ),
        ),
        title: Text('${asset.entity?.name}'),
        isThreeLine: true,
        subtitle: Text('${asset.entity?.guid}'),
        dense: true,
      ),
    );
  }
}
