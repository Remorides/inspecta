import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk_inspecta/common/assets/assets.dart';
import 'package:omdk_inspecta/elements/elements.dart';

/// Login form class provide all required field to login
class OMDKSimplePage extends StatelessWidget {
  /// Create [OMDKSimplePage] instance
  const OMDKSimplePage({
    required this.bodyPage,
    this.withAppbar = true,
    this.withBottomBar = true,
    this.withDrawer = true,
    this.withBackgroundImage = false,
    this.withKeyboardShortcuts = false,
    this.appBarTitle,
    this.focusNodeList = const [],
    super.key,
    this.leading,
    this.trailing,
    this.previousRoute,
    this.onPopCallback,
    this.bottomWidget,
    this.onTapAddBTN,
    this.bottomBar,
    this.floatingActionButton,
  });

  /// Choose if you want to show or not appbar
  final bool withAppbar;

  /// Choose if you want to show or not bottom bar
  final bool withBottomBar;

  /// Choose if you want to integrate drawer or not in appBar
  final bool withDrawer;

  final bool withBackgroundImage;

  final VoidCallback? onPopCallback;

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

  /// Bottom bar widget
  final Widget? bottomWidget;

  /// App bar details
  final String? previousRoute;

  final VoidCallback? onTapAddBTN;

  final Widget? bottomBar;

  final Widget? floatingActionButton;

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
        withBackgroundImage: withBackgroundImage,
        withKeyboardShortcuts: withKeyboardShortcuts,
        appBarTitle: appBarTitle,
        leading: leading,
        trailing: trailing,
        bottomWidget: bottomWidget,
        previousRoute: previousRoute,
        onPopCallback: onPopCallback,
        onTapAddBTN: onTapAddBTN,
        bottomBar: bottomBar,
        floatingActionButton: floatingActionButton,
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
    required this.withBackgroundImage,
    required this.withKeyboardShortcuts,
    this.floatingActionButton,
    this.onPopCallback,
    this.appBarTitle,
    this.leading,
    this.trailing,
    this.bottomWidget,
    this.previousRoute,
    this.onTapAddBTN,
    this.bottomBar,
  });

  final bool withAppbar;
  final bool withBottomBar;
  final bool withKeyboardShortcuts;
  final VoidCallback? onPopCallback;
  final bool withDrawer;
  final bool withBackgroundImage;
  final Widget bodyPage;
  final Widget? floatingActionButton;
  final List<FocusNode> focusNodeList;
  final Widget? appBarTitle;
  final Widget? leading;
  final Widget? trailing;
  final Widget? bottomWidget;
  final String? previousRoute;
  final VoidCallback? onTapAddBTN;
  final Widget? bottomBar;

  @override
  Widget build(BuildContext context) {
    final state = context.select((OMDKSimplePageCubit cubit) => cubit.state);
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Stack(
        children: [
          if (withDrawer)
            AnimatedContainer(
              width: 300,
              transform: Matrix4.translationValues(
                (state.isDrawerExpanded ? 0 : state.initialXOffsetDrawer),
                0,
                0,
              ),
              duration: const Duration(milliseconds: 150),
              child: const OMDKAnimatedDrawer(),
            ),
          AnimatedContainer(
            transform: Matrix4.translationValues(state.xOffsetDrawer, 0, 0),
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              image: withBackgroundImage
                  ? DecorationImage(
                      image: AssetImage(
                        CompanyAssets.operaBackground.iconAsset,
                      ),
                      alignment: Alignment.bottomRight,
                      fit: BoxFit.contain,
                    )
                  : null,
            ),
            child: GestureDetector(
              onTap: withDrawer && state.isDrawerExpanded
                  ? () => context.read<OMDKSimplePageCubit>().collapseDrawer()
                  : null,
              child: AbsorbPointer(
                absorbing: state.isDrawerExpanded,
                child: _buildScaffold(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Scaffold _buildScaffold(BuildContext context) => Scaffold(
        appBar: withAppbar
            ? CupertinoNavigationBar(
                backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                leading: withDrawer && !Navigator.of(context).canPop()
                    ? GestureDetector(
                        child: const Icon(
                          Icons.menu_outlined,
                          size: 20,
                        ),
                        onTap: () =>
                            context.read<OMDKSimplePageCubit>().expandDrawer(),
                      )
                    : leading ??
                        IconButton(
                          onPressed: onPopCallback ??
                              () => Navigator.of(context).pop(),
                          icon: Icon(
                            size: 22,
                            CupertinoIcons.back,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                middle: appBarTitle,
                trailing: trailing,
                previousPageTitle: previousRoute,
              )
            : null,
        body: _buildPage(context),
        extendBody: true,
        bottomNavigationBar: withBottomBar
            ? bottomBar ??
                OMDKBottomBar(
                  onTapAddBTN: onTapAddBTN,
                  buttons: OMDKBottomBarButton.defaultBottomButtons,
                )
            : null,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      );

  Widget _buildPage(BuildContext context) {
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
