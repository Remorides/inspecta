import 'package:flutter/material.dart';
import 'package:omdk_inspecta/elements/drawers/models/drawer_item.dart';
import 'package:omdk_repo/omdk_repo.dart';

class OMDKDrawer extends StatelessWidget {
  /// Create [OMDKDrawer] instance
  const OMDKDrawer({
    required this.items,
    super.key,
    this.headerWidget,
  });

  final List<DrawerItem> items;
  final Widget? headerWidget;


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: context.theme?.primaryColor,
            ),
            child: headerWidget,
          ),
          for(final i in items)
            ListTile(
              title: Text(
                i.title,
                style: context.theme?.textTheme.labelMedium,
              ),
              onTap: () {
                Scaffold.of(context).closeDrawer();
              },
            ),
          Divider(
            height: 1,
            color: context.theme?.dividerColor,
          ),
        ],
      ),
    );
  }
}
