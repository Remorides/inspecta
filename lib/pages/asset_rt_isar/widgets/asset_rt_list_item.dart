import 'package:flutter/material.dart';
import 'package:opera_api_asset/opera_api_asset.dart';

class AssetRTListTile extends StatelessWidget {
  const AssetRTListTile({required this.asset, super.key});

  final Asset asset;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        leading: Text('RT - ${asset.id}'),
        trailing: InkWell(
          onTap: () {},
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
