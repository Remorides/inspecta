import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk/elements/elements.dart';
import 'package:omdk_repo/omdk_repo.dart';

/// Login form class provide all required field to login
class OMDKSimplePage extends StatelessWidget {
  /// Create [OMDKSimplePage] instance
  const OMDKSimplePage({
    required this.bodyPage,
    this.withAppbar = true,
    this.withBottomBar = true,
    this.withDrawer = true,
    this.withKeyboardShortcuts = false,
    this.appBarTitle,
    this.focusNodeList = const [],
    super.key,
    this.leading,
    this.trailing,
    this.previousRoute,
    this.onPopInvoked,
  });

  /// Choose if you want to show or not appbar
  final bool withAppbar;

  /// Choose if you want to show or not bottom bar
  final bool withBottomBar;

  /// Choose if you want to integrate drawer or not in appBar
  final bool withDrawer;

  /// Choose if you want to add shortcuts over keyboard
  final bool withKeyboardShortcuts;

  /// UI of page
  final Widget bodyPage;

  /// List of focus node items
  final List<FocusNode> focusNodeList;

  /// App bar title required to use appbar widget
  final Widget? appBarTitle;

  /// App bar leading widget
  final Widget? leading;

  /// App bar trailing widget
  final Widget? trailing;

  /// App bar details
  final String? previousRoute;

  final void Function(bool)? onPopInvoked;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OMDKSimplePageCubit(),
      child: _OMDKSimplePage(
        bodyPage: bodyPage,
        focusNodeList: focusNodeList,
        withAppbar: withAppbar,
        withBottomBar: withBottomBar,
        withDrawer: withDrawer,
        withKeyboardShortcuts: withKeyboardShortcuts,
        appBarTitle: appBarTitle,
        leading: leading,
        trailing: trailing,
        previousRoute: previousRoute,
        onPopInvoked: onPopInvoked,
      ),
    );
  }
}

class _OMDKSimplePage extends StatelessWidget {
  const _OMDKSimplePage({
    required this.focusNodeList,
    required this.bodyPage,
    required this.withAppbar,
    required this.withBottomBar,
    required this.withDrawer,
    required this.withKeyboardShortcuts,
    this.appBarTitle,
    this.leading,
    this.trailing,
    this.previousRoute,
    this.onPopInvoked,
  });

  final bool withAppbar;
  final bool withBottomBar;
  final bool withKeyboardShortcuts;
  final void Function(bool)? onPopInvoked;
  final bool withDrawer;
  final Widget bodyPage;
  final List<FocusNode> focusNodeList;
  final Widget? appBarTitle;
  final Widget? leading;
  final Widget? trailing;
  final String? previousRoute;

  @override
  Widget build(BuildContext context) {
    final cubit = context.select((OMDKSimplePageCubit cubit) => cubit.state);
    return Material(
      child: PopScope(
        onPopInvoked: onPopInvoked,
        child: withDrawer
            ? Stack(
                children: [
                  const OMDKAnimatedDrawer(),
                  AnimatedContainer(
                    transform:
                        Matrix4.translationValues(cubit.xOffsetDrawer, 0, 0),
                    duration: const Duration(milliseconds: 150),
                    child: GestureDetector(
                      onTap: () =>
                          context.read<OMDKSimplePageCubit>().collapseDrawer(),
                      child: AbsorbPointer(
                        absorbing: cubit.isDrawerExpanded,
                        child: _buildScaffold(context),
                      ),
                    ),
                  ),
                ],
              )
            : _buildScaffold(context),
      ),
    );
  }

  CupertinoPageScaffold _buildScaffold(BuildContext context) =>
      CupertinoPageScaffold(
        backgroundColor: context.theme?.colorScheme.surface,
        navigationBar: withAppbar
            ? CupertinoNavigationBar(
                backgroundColor: context.theme?.appBarTheme.backgroundColor,
                brightness: Brightness.light,
                leading: withDrawer && !Navigator.of(context).canPop()
                    ? GestureDetector(
                        child: const Icon(
                          Icons.menu_outlined,
                          size: 20,
                        ),
                        onTap: () =>
                            context.read<OMDKSimplePageCubit>().expandDrawer(),
                      )
                    : leading,
                middle: appBarTitle,
                trailing: trailing,
                previousPageTitle: previousRoute,
              )
            : null,
        child: _buildPage(context),
      );

  Widget _buildPage(BuildContext context) => withBottomBar
      ? FloatingBottom(
          bottom: const OMDKBottomBar(),
          child: _buildBodyPage(context),
        )
      : _buildBodyPage(context);

  Widget _buildBodyPage(BuildContext context) {
    if (kIsWeb) {
      return SafeArea(child: bodyPage);
    }
    return (Platform.isAndroid || Platform.isIOS) && withKeyboardShortcuts
        ? CustomKeyboardActions(
            focusNodes: focusNodeList,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: bodyPage,
            ),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: bodyPage,
          );
  }
}
