import 'package:flutter/material.dart';

class FloatingBottom extends StatelessWidget {

  const FloatingBottom({
    required this.child,
    required this.bottom,
    super.key,
  });

  static const double bottomSize = 120;

  final Widget child;
  final Widget bottom;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(child: child),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: bottom,
        ),
      ],
    );
  }
}
