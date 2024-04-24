import 'package:flutter/cupertino.dart';

/// Item of drawer
class DrawerItem {
  /// Create [DrawerItem] instance
  const DrawerItem({
    required this.title,
    this.route,
    this.icon,
    this.arguments,
    this.onTap,
  });

  /// Callback action
  final String title;
  final String? route;
  final Icon? icon;
  final Object? arguments;
  final void Function()? onTap;
}
