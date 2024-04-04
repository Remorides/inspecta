import 'package:flutter/material.dart';
import 'package:opera_api_asset/opera_api_asset.dart';

class AssetApiListTile extends StatelessWidget {
  const AssetApiListTile({required this.asset, super.key});

  final AssetListItem asset;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        leading: Text('API - ${asset.id}'),
        trailing: InkWell(
          onTap: (){},
          child: const Icon(
            Icons.delete_forever_outlined,
            color: Colors.red,
          ),
        ),
        title: Text(asset.name),
        isThreeLine: true,
        subtitle: Text(asset.guid),
        dense: true,
      ),
    );
  }
}
