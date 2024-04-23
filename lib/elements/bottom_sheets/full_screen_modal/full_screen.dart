import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class OMDKFullBottomSheet extends StatelessWidget {
  /// Create [OMDKFullBottomSheet] instance
  const OMDKFullBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: const Text('Edit'),
              leading: const Icon(Icons.edit),
              onTap: () => Navigator.of(context).pop(),
            ),
            ListTile(
              title: const Text('Copy'),
              leading: const Icon(Icons.content_copy),
              onTap: () => Navigator.of(context).pop(),
            ),
            ListTile(
              title: const Text('Cut'),
              leading: const Icon(Icons.content_cut),
              onTap: () => Navigator.of(context).pop(),
            ),
            ListTile(
              title: const Text('Move'),
              leading: const Icon(Icons.folder_open),
              onTap: () => Navigator.of(context).pop(),
            ),
            ListTile(
              title: const Text('Delete'),
              leading: const Icon(Icons.delete),
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  static void show(BuildContext context) => showCupertinoModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => OMDKFullBottomSheet(),
      );
}
