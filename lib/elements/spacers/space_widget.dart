import 'package:flutter/material.dart';

/// Spacer widget calculated on input data
class Space extends StatelessWidget {
  /// Return [SizedBox] widget calculated on height input
  const Space.vertical(this.height, {super.key}) : width = 0;
  /// Return [SizedBox] widget calculated on width input
  const Space.horizontal(this.width, {super.key}) : height = 0;

  /// Input data
  final double? width;
  /// Input data
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
    );
  }
}
