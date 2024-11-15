import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class OMDKSimpleBottomSheet extends StatelessWidget {
  /// Create [OMDKSimpleBottomSheet] instance
  const OMDKSimpleBottomSheet({
    required this.body,
    super.key,
  });

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: body,
    );
  }

  static Widget get example => Material(
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: const Text('Edit'),
                leading: const Icon(Icons.edit),
                onTap: () => (),
              ),
              ListTile(
                title: const Text('Copy'),
                leading: const Icon(Icons.content_copy),
                onTap: () => (),
              ),
              ListTile(
                title: const Text('Cut'),
                leading: const Icon(Icons.content_cut),
                onTap: () => (),
              ),
              ListTile(
                title: const Text('Move'),
                leading: const Icon(Icons.folder_open),
                onTap: () => (),
              ),
              ListTile(
                title: const Text('Delete'),
                leading: const Icon(Icons.delete),
                onTap: () => (),
              ),
            ],
          ),
        ),
      );

  static void show(
    BuildContext context,
    OMDKSimpleBottomSheet widget, {
    bool expand = false,
    bool isDismissible = true,
  }) =>
      showCupertinoModalBottomSheet<void>(
        context: context,
        expand: expand,
        backgroundColor: Colors.transparent,
        isDismissible: isDismissible,
        builder: (context) => widget,
      );
}
