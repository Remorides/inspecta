import 'package:flutter/material.dart';
import 'package:omdk_inspecta/elements/elements.dart';

class OMDKAnimatedAppBar extends StatelessWidget {
  OMDKAnimatedAppBar({
    required this.builder,
    this.title,
    this.leading,
    this.actions,
    this.automaticallyImplyLeading = false,
    this.collapsedSize = 56,
    this.expandedSize = 350,
    this.scrolledUnderElevation,
    this.backgroundColor,
    super.key,
  }) : assert(
          expandedSize >= collapsedSize,
          throw Exception('expandedSize param must be >= of collapsedSize'),
        );

  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;
  final double expandedSize;
  final double collapsedSize;
  final Widget Function(BuildContext, double) builder;
  final double? scrolledUnderElevation;
  final Color? backgroundColor;

  double get _range => expandedSize - collapsedSize;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      elevation: 2,
      titleSpacing: 0,
      title: title,
      leading: leading,
      centerTitle: true,
      actions: List<Widget>.from(actions ?? [])..add(const Space.horizontal(16)),
      automaticallyImplyLeading: automaticallyImplyLeading,
      pinned: true,
      expandedHeight: expandedSize,
      collapsedHeight: collapsedSize,
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.surface,
      scrolledUnderElevation: scrolledUnderElevation,
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final size =
              constraints.maxHeight - MediaQuery.of(context).padding.top;
          final open = (size - collapsedSize) / _range;
          return Container(
            constraints: constraints,
            child: builder(context, open),
          );
        },
      ),
    );
  }
}
