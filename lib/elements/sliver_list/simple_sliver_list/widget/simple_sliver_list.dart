import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omdk_inspecta/blocs/mode/mode.dart';
import 'package:omdk_inspecta/elements/elements.dart';
import 'package:omdk_repo/omdk_repo.dart';

class OMDKSimpleSliverList extends StatelessWidget {
  /// Create [OMDKSimpleSliverList] instance
  const OMDKSimpleSliverList({
    required this.appBar,
    required this.children,
    required this.withSliverItems,
    super.key,
    this.anchor = 0,
    this.scrollController,
    this.sliverPadding = const EdgeInsets.all(18),
    this.sliverSeparator = const Space.vertical(15),
    this.withRefresh = false,
    this.refreshWidget,
    this.onRefresh,
  });

  final double anchor;
  final Widget appBar;
  final List<Widget> children;
  final bool withSliverItems;
  final ScrollController? scrollController;
  final EdgeInsetsGeometry? sliverPadding;
  final Widget? sliverSeparator;
  final bool withRefresh;
  final Widget? refreshWidget;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: CustomScrollView(
        anchor: anchor,
        controller: scrollController,
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          appBar,
          if (withRefresh)
            CupertinoSliverRefreshControl(
              refreshIndicatorExtent: 180,
              refreshTriggerPullDistance: 200,
              builder: (context, mode, d1, d2, d3) => context.isConnected &&
                      context.read<SessionModeCubit>().state ==
                          SessionMode.online
                  ? refreshWidget!
                  : _unSwipeable(context),
              onRefresh: context.isConnected &&
                      context.read<SessionModeCubit>().state ==
                          SessionMode.online
                  ? onRefresh
                  : null,
            ),
          if (withSliverItems)
            ...children
          else
            SliverPadding(
              padding: sliverPadding ?? const EdgeInsets.all(18),
              sliver: SliverList.separated(
                itemBuilder: (context, index) => children[index],
                itemCount: children.length,
                separatorBuilder: (context, index) =>
                    sliverSeparator ?? const Space.vertical(15),
              ),
            ),
        ],
      ),
    );
  }

  Widget _unSwipeable(BuildContext context) => ColoredBox(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.35),
        child: Center(
          child: Text(
            context.read<SessionModeCubit>().state == SessionMode.offline
                ? 'You are in OFFLINE MODE'
                : '⚠️ Internet connection not found',
          ),
        ),
      );
}
