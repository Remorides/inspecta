import 'package:flutter/material.dart';

/// Customized AppBar based on OMDK theme
AppBar OMDKAppBar({
  required BuildContext context,
  required String title,
  bool automaticallyImplyLeading = true,
  bool centerTitle = true,
  Icon? leading,
  VoidCallback? leadingCallback,
  List<Widget> trailing = const [],
  double leadingWidth = 56,
}) =>
    AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      centerTitle: centerTitle,
      leading: (leading != null)
          ? IconButton(
              icon: leading,
              onPressed: leadingCallback,
            )
          : null,
      leadingWidth: leadingWidth,
      title: Text(
        title,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
      actions: [
        for (final Widget child in trailing) child,
      ],
    );
