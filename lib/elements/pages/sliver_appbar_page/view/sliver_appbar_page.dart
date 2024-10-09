import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk_inspecta/common/assets/assets.dart';
import 'package:omdk_inspecta/elements/elements.dart';

/// Login form class provide all required field to login
class OMDKSliverPage extends StatelessWidget {
  /// Create [OMDKSliverPage] instance
  const OMDKSliverPage({
    this.withBottomBar = true,
    this.withDrawer = true,
    this.withBackgroundImage = false,
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
  });

  /// Choose if you want to show or not bottom bar
  final bool withBottomBar;

  /// Choose if you want to integrate drawer or not in appBar
  final bool withDrawer;

  final bool withBackgroundImage;

  /// List of focus node items
  final List<FocusNode> focusNodeList;

  /// App bar leading widget
  final Widget? leading;

  /// App bar trailing widget
  final Widget? trailing;

  /// App bar details
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
  final Widget? refreshWidget;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OMDKSliverPageCubit(),
      child: _OMDKSliverPage(
        focusNodeList: focusNodeList,
        withBottomBar: withBottomBar,
        withDrawer: withDrawer,
        withBackgroundImage: withBackgroundImage,
        leading: leading,
        trailing: trailing,
        previousRoute: previousRoute,
        pageItems: pageItems,
        appBar: appBar,
        bottomBar: bottomBar,
        withSliverItems: withSliverItems,
        anchor: anchor,
        onTapAddBTN: onTapAddBTN,
        scrollController: scrollController,
        sliverPadding: sliverPadding,
        sliverSeparator: sliverSeparator,
        floatingActionButton: floatingActionButton,
        withRefresh: withRefresh,
        refreshWidget: refreshWidget,
        onRefresh: onRefresh,
      ),
    );
  }
}

class _OMDKSliverPage extends StatelessWidget {
  const _OMDKSliverPage({
    required this.focusNodeList,
    required this.withBottomBar,
    required this.withDrawer,
    required this.withBackgroundImage,
    required this.pageItems,
    required this.withSliverItems,
    required this.anchor,
    this.leading,
    this.trailing,
    this.floatingActionButton,
    this.previousRoute,
    this.appBar,
    this.bottomBar,
    this.onTapAddBTN,
    this.scrollController,
    this.sliverPadding,
    this.sliverSeparator,
    this.withRefresh = false,
    this.refreshWidget,
    this.onRefresh,
  });

  final bool withBottomBar;
  final bool withDrawer;
  final bool withBackgroundImage;
  final List<FocusNode> focusNodeList;
  final Widget? leading;
  final Widget? trailing;
  final Widget? floatingActionButton;
  final String? previousRoute;
  final List<Widget> pageItems;
  final Widget? appBar;
  final Widget? bottomBar;
  final bool withSliverItems;
  final double anchor;
  final VoidCallback? onTapAddBTN;
  final ScrollController? scrollController;
  final EdgeInsetsGeometry? sliverPadding;
  final Widget? sliverSeparator;
  final bool withRefresh;
  final Widget? refreshWidget;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final state = context.select((OMDKSliverPageCubit cubit) => cubit.state);
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
              onTap: state.isDrawerExpanded
                  ? () => context.read<OMDKSliverPageCubit>().collapseDrawer()
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

  Widget _buildScaffold(BuildContext context) => Scaffold(
        //backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: _buildPage(context),
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
                leadingCallback: () =>
                    context.read<OMDKSliverPageCubit>().expandDrawer(),
              ),
          children: pageItems,
        ),
      );
}
