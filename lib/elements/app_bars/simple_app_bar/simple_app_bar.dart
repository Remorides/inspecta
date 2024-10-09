import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:omdk_inspecta/elements/elements.dart';

class OMDKSimpleAppBar extends StatelessWidget {
  const OMDKSimpleAppBar({
    required this.mainWidget,
    super.key,
    this.collapsedSize = 72,
    this.expandedSize = 100,
    this.secondaryWidget,
    this.actionsWidgets,
    this.leadingWidget,
  });

  final double collapsedSize;
  final double expandedSize;
  final Widget mainWidget;
  final Widget? secondaryWidget;
  final List<Widget>? actionsWidgets;
  final Widget? leadingWidget;

  @override
  Widget build(BuildContext context) {
    return OMDKAnimatedAppBar(
      leading: leadingWidget ??
          InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Center(
                child: Icon(
                  CupertinoIcons.back,
                  size: 25,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
      title: Center(child: mainWidget),
      actions: actionsWidgets,
      builder: (context, open) => Stack(
        clipBehavior: Clip.none,
        children: [
          if (open > 0.35 && secondaryWidget != null)
            Positioned(
              bottom: 8,
              left: 0,
              right: 0,
              child: secondaryWidget!,
            ),
        ],
      ),
      collapsedSize: collapsedSize,
      expandedSize: expandedSize,
    );
  }
}
