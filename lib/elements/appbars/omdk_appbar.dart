import 'package:flutter/material.dart';
import 'package:omdk_repo/omdk_repo.dart';

/// Customized AppBar based on OMDK theme
class OMDKAppBar extends AppBar {
  /// Create [OMDKAppBar] instance
  OMDKAppBar({super.key});

  /// Create [OMDKAppBar] instance
  AppBar appBar({
    required BuildContext context,
    required String title,
    bool automaticallyImplyLeading = true,
    bool centerTitle = true,
    Widget? leading,
    List<Widget> trailing = const [],
    double leadingWidth = 56,
  }) =>
      AppBar(
        automaticallyImplyLeading: automaticallyImplyLeading,
        centerTitle: centerTitle,
        leading: leading,
        leadingWidth: leadingWidth,
        title: Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        titleTextStyle: context.theme?.textTheme.headlineMedium?.copyWith(
          color: Colors.black,
        ),
        actions: [
          for (final Widget child in trailing) child,
        ],
      );
}
