import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk_inspecta/common/assets/assets.dart';
import 'package:omdk_inspecta/elements/elements.dart';

/// Login form class provide all required field to login
class OMDKSliverPage extends StatelessWidget {
  /// Create [OMDKSliverPage] instance
  OMDKSliverPage({
    this.withBottomBar = true,
    this.withDrawer = true,
    this.withBackgroundImage = false,
    this.withKeyboardShortcuts = false,
    this.focusNodeList = const [],
    this.pageItems = const [],
    super.key,
    this.leading,
    this.trailing,
    this.floatingActionButton,
    this.previousRoute,
    this.appBar,
    this.bottomBar,
    this.withSliverItems = false,
    this.anchor = 0.0,
    this.onTapAddBTN,
    this.scrollController,
    this.sliverPadding,
    this.sliverSeparator,
    this.withRefresh = false,
    this.refreshWidget,
    this.onRefresh,
    this.isForm = false,
    this.formKey,
    this.canPop = true,
    this.onPopInvokedWithResult,
  });

  final bool withKeyboardShortcuts;
  final bool withBottomBar;
  final bool withDrawer;
  final bool withBackgroundImage;
  final List<FocusNode> focusNodeList;
  final Widget? leading;
  final Widget? trailing;
  final String? previousRoute;
  final List<Widget> pageItems;
  final Widget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomBar;
  final bool withSliverItems;
  final double anchor;
  final VoidCallback? onTapAddBTN;
  final ScrollController? scrollController;
  final EdgeInsetsGeometry? sliverPadding;
  final Widget? sliverSeparator;
  final bool withRefresh;
  final bool isForm;
  final GlobalKey<FormState>? formKey;
  final Widget? refreshWidget;
  final Future<void> Function()? onRefresh;
  final bool canPop;
  final void Function(bool, dynamic)? onPopInvokedWithResult;

  final OMDKSliverPageCubit _cubit = OMDKSliverPageCubit();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: PopScope(
        canPop: canPop,
        onPopInvokedWithResult: onPopInvokedWithResult,
        child: BlocBuilder<OMDKSliverPageCubit, SliverPageState>(
          bloc: _cubit,
          builder: (context, state) => Stack(
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
                  onTap: state.isDrawerExpanded ? _cubit.collapseDrawer : null,
                  child: AbsorbPointer(
                    absorbing: state.isDrawerExpanded,
                    child: _buildScaffold(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScaffold(BuildContext context) => Scaffold(
        body: _keyboardShortcut(
          context,
          child: isForm
              ? Form(key: formKey, child: _buildPage(context))
              : _buildPage(context),
        ),
        extendBody: true,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
        bottomNavigationBar: withBottomBar
            ? bottomBar ??
                OMDKBottomBar(
                  onTapAddBTN: onTapAddBTN,
                  buttons: OMDKBottomBarButton.defaultBottomButtons,
                )
            : null,
      );

  Widget _keyboardShortcut(
    BuildContext context, {
    required Widget child,
  }) =>
      (Platform.isAndroid || Platform.isIOS) && withKeyboardShortcuts
          ? CustomKeyboardActions(focusNodes: focusNodeList, child: child)
          : child;

  Widget _buildPage(BuildContext context) => SafeArea(
        top: false,
        bottom: false,
        child: OMDKSimpleSliverList(
          scrollController: scrollController,
          anchor: anchor,
          withSliverItems: withSliverItems,
          sliverPadding: sliverPadding,
          sliverSeparator: sliverSeparator,
          withRefresh: withRefresh,
          refreshWidget: refreshWidget,
          onRefresh: onRefresh,
          appBar: appBar ??
              OMDKLogoSliverAppBar(
                withLeading: withDrawer,
                leadingCallback: _cubit.expandDrawer,
              ),
          children: pageItems,
        ),
      );
}
