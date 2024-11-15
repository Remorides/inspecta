import 'dart:math';

import 'package:flutter/material.dart';
import 'package:omdk_inspecta/elements/alerts/alerts.dart';
import 'package:omdk_inspecta/elements/elements.dart';

/// OMDK default alert example
class OMDKAlert extends StatelessWidget {
  /// Create [OMDKAlert] instance
  const OMDKAlert({
    required this.title,
    required this.message,
    required this.confirm,
    required this.onConfirm,
    required this.type,
    this.close,
    this.onClose,
    this.executePop = true,
    this.buttonAlignment = ActionButtonAlignment.horizontal,
    super.key,
  });

  /// Method to call to show alert
  static void show(
      BuildContext context,
      OMDKAlert alert, {
        bool barrierDismissible = false,
        Color? barrierColor,
      }) =>
      showDialog<void>(
        barrierColor: barrierColor ?? Colors.black.withOpacity(0.5),
        barrierDismissible: false,
        context: context,
        builder: (BuildContext alertContext) {
          return alert;
        },
      );

  /// Example widget
  static OMDKAlert get example => OMDKAlert(
    title: 'Example',
    message: const Text('Example body widget'),
    confirm: 'Confirm',
    close: 'Close',
    onConfirm: () {
      debugPrint('Confirm button pressed');
    },
    onClose: () {
      debugPrint('Close button pressed');
    },
    buttonAlignment: ActionButtonAlignment.vertical,
    type: AlertType.info,
  );

  final AlertType type;

  /// Title text
  final String title;

  /// Alert body widget
  final Widget message;

  /// Confirm button text name
  final String confirm;

  /// Close button text name
  final String? close;

  /// Call back action on confirm event
  final VoidCallback onConfirm;

  /// Call back action on close event
  final VoidCallback? onClose;

  /// Auto pop route
  final bool executePop;

  /// Choose display mode of action buttons
  final ActionButtonAlignment buttonAlignment;

  static const double _circleRadius = 38;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Spacer(),
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: <Widget>[
            Material(
              borderRadius: BorderRadius.circular(14),
              elevation: Theme.of(context).dialogTheme.elevation ?? 20,
              shadowColor: Theme.of(context).dialogTheme.shadowColor,
              color: Theme.of(context).dialogTheme.backgroundColor,
              child: SizedBox(
                width: min(300, MediaQuery.of(context).size.width - 40),
                child: _content(context),
              ),
            ),
            Positioned(
              top: -_circleRadius,
              left: 0,
              right: 0,
              child: Row(
                children: <Widget>[
                  const Spacer(),
                  _iconCircle(context),
                  const Spacer(),
                ],
              ),
            ),
          ],
        ),
        const Spacer(),
      ],
    );
  }

  Column _content(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      const Space.vertical(_circleRadius + 18),
      _titleWidget,
      const Space.vertical(14),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: message,
      ),
      const Space.vertical(20),
      if (buttonAlignment == ActionButtonAlignment.horizontal)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: _actionButton(context)),
              if (close != null) const Space.horizontal(10),
              if (close != null)
                Expanded(child: _closeButton(context)),
            ],
          ),
        )
      else
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _actionButton(context),
                  ),
                ],
              ),
              const Space.vertical(10),
              if (close != null)
                Row(
                  children: [
                    Expanded(
                      child: _closeButton(context),
                    ),
                  ],
                ),
            ],
          ),
        ),
      const Space.vertical(20),
    ],
  );

  Widget _iconCircle(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: switch (type) {
        AlertType.info => Colors.blue,
        AlertType.warning => Colors.yellow,
        AlertType.error => Colors.red,
        AlertType.fatalError => Colors.red,
        AlertType.success => Colors.green,
      },
      borderRadius: BorderRadius.circular(_circleRadius),
    ),
    width: _circleRadius * 2,
    height: _circleRadius * 2,
    child: Center(
      child: switch(type){
        AlertType.info => Icon(
          Icons.info_outline,
          size: 40,
          color: Theme.of(context).colorScheme.onInverseSurface,
        ),
        AlertType.warning => Icon(
          Icons.warning_amber_rounded,
          size: 40,
          color: Theme.of(context).colorScheme.onInverseSurface,
        ),
        AlertType.error => Icon(
          Icons.report_gmailerrorred_outlined,
          size: 40,
          color: Theme.of(context).colorScheme.onInverseSurface,
        ),
        AlertType.fatalError => Icon(
          Icons.bug_report_outlined,
          size: 40,
          color: Theme.of(context).colorScheme.onInverseSurface,
        ),
        AlertType.success => Icon(
          Icons.done,
          size: 40,
          color: Theme.of(context).colorScheme.onInverseSurface,
        ),
      },
    ),
  );

  // Widgets

  Widget _actionButton(BuildContext context) {
    return OMDKElevatedButton(
      child: Text(confirm),
      onPressed: () {
        if (executePop) {
          Navigator.pop(context);
        }
        onConfirm();
      },
    );
  }

  Widget _closeButton(BuildContext context) {
    return OMDKOutlinedButton(
      onPressed: () {
        Navigator.of(context).pop();
        onClose?.call();
      },
      child: Text(close!),
    );
  }

  Widget get _titleWidget => Text(
    title,
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
    textAlign: TextAlign.center,
    style: const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 20,
    ),
  );
}
