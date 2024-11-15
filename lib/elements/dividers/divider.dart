import 'package:flutter/material.dart';

class OMDKDivider extends StatelessWidget {
  /// Create [OMDKDivider] instance
  const OMDKDivider({
    super.key,
    this.height = 1,
    this.thickness,
    this.color,
  });

  final double height;
  final double? thickness;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height,
      thickness: thickness,
      color: color,
    );
  }
}
