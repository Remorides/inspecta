import 'package:flutter/material.dart';

class OMDKTextButton extends TextButton {
  /// Create [OMDKTextButton] instance
  const OMDKTextButton({
    super.key,
    required this.onPressed,
    required this.child,
    required this.width,
    required this.text,
    this.onLongPress,
    this.fontWeight,
    this.textAlign = TextAlign.center,
    this.textColor,
    this.height = 60,
  }) : super(
          onPressed: onPressed,
          child: child,
        );

  final void Function() onPressed;
  final void Function()? onLongPress;
  final Widget child;
  final double width;
  final double height;
  final String text;
  final TextAlign textAlign;
  final Color? textColor;
  final FontWeight? fontWeight;

  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      onLongPress: onLongPress,
      child: Text('Login'.toUpperCase()),
    );
  }
}
