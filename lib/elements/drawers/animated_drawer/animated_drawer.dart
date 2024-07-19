import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk/blocs/auth/auth.dart';
import 'package:omdk/common/extensions/extension_list.dart';
import 'package:omdk/elements/dividers/divider.dart';
import 'package:omdk/elements/drawers/models/drawer_item.dart';
import 'package:omdk_repo/omdk_repo.dart';

class OMDKAnimatedDrawer extends StatefulWidget {
  /// Create [OMDKAnimatedDrawer] instance
  const OMDKAnimatedDrawer({
    super.key,
    this.headerWidget,
  });

  final Widget? headerWidget;

  @override
  State<StatefulWidget> createState() => _OMDKAnimatedDrawer();
}

class _OMDKAnimatedDrawer extends State<OMDKAnimatedDrawer> {
  final _items = const <DrawerItem>[
    DrawerItem(
      title: 'Privacy Policy',
      icon: Icon(
        Icons.cookie_outlined,
      ),
    ),
    DrawerItem(
      title: 'Settings',
      icon: Icon(
        Icons.settings_outlined,
      ),
    ),
    DrawerItem(
      title: 'Sign out',
      icon: Icon(
        Icons.logout_outlined,
        color: Colors.red,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: context.theme?.primaryColor,
            borderRadius:
                const BorderRadius.only(bottomRight: Radius.circular(30)),
          ),
          child: widget.headerWidget,
        ),
        for (final i in _items)
          ListTile(
            title: Text(
              i.title,
              style: context.theme?.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: (i.title == 'Sign out')
                ? () => context
                    .read<AuthBloc>()
                    .add(LogoutRequested())
                : null,
            leading: i.icon,
          ),
      ].separateWith(const OMDKDivider()),
    );
  }
}
