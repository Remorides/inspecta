import 'dart:math';

import 'package:flutter/material.dart';
import 'package:omdk_inspecta/common/common.dart';

class LoadingLogo extends StatefulWidget {
  const LoadingLogo({
    this.color = Colors.white,
    this.firstRadius = 25 - 3,
    this.firstWidth = 6,
    this.secondRadius = 25 + 12 - 3,
    this.secondWidth = 6,
    this.secondStartAngle = (90 + 30) * pi / 180,
    this.secondSweepAngle = (180 + 10) * pi / 180,
    this.thirdRadius = 25 + 12 + 12 - 3,
    this.thirdWidth = 6,
    this.thirdStartAngle = (180 + 20) * pi / 180,
    this.thirdSweepAngle = (90 + 20) * pi / 180,
    Key? key,
  }) : super(key: key);

  final Color color;
  final double firstRadius;
  final double firstWidth;
  final double secondRadius;
  final double secondWidth;
  final double secondStartAngle;
  final double secondSweepAngle;
  final double thirdRadius;
  final double thirdWidth;
  final double thirdStartAngle;
  final double thirdSweepAngle;

  @override
  State<LoadingLogo> createState() => _State();
}

class _State extends State<LoadingLogo> with SingleTickerProviderStateMixin {
  late AnimationController controller;

  static const Curve curve = Curves.easeInOutCubic;

  static const Duration duration = Duration(milliseconds: 1100);

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: duration);
    init();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void init() {
    controller.repeat(min: 0, max: 1, period: duration);
  }

  @override
  Widget build(BuildContext context) {
    final size = 2 * (widget.thirdRadius + widget.thirdWidth / 2);
    return SizedBox.square(
      dimension: size,
      child: AnimatedBuilder(
        animation: controller,
        child: SizedBox.square(
          dimension: size,
        ),
        builder: (BuildContext context, Widget? child) {
          final v = curve.transform(controller.value);

          final secondStart =
              widget.secondStartAngle + (v.mapToRange(0, 2 * pi));
          final thirdStart = widget.thirdStartAngle - (v.mapToRange(0, 2 * pi));

          const progress = 0.1; // Progress value between 0.0 and 1.0

          return CustomPaint(
            painter: _Painter(
              color: widget.color,
              firstRadius: widget.firstRadius,
              firstWidth: widget.firstWidth,
              secondRadius: widget.secondRadius,
              secondWidth: widget.secondWidth,
              secondFromAngle: secondStart,
              secondSweepAngle: widget.secondSweepAngle,
              thirdRadius: widget.thirdRadius,
              thirdWidth: widget.thirdWidth,
              thirdFromAngle: thirdStart,
              thirdSweepAngle: widget.thirdSweepAngle,
              progress: progress,
            ),
            child: child,
          );
        },
      ),
    );
  }
}

class _Painter extends CustomPainter {
  _Painter({
    required this.color,
    required this.firstRadius,
    required this.firstWidth,
    required this.secondRadius,
    required this.secondWidth,
    required this.secondFromAngle,
    required this.secondSweepAngle,
    required this.thirdRadius,
    required this.thirdWidth,
    required this.thirdFromAngle,
    required this.thirdSweepAngle,
    required this.progress,
  });

  final Color color;
  final double firstRadius;
  final double firstWidth;

  final double secondRadius;
  final double secondWidth;
  final double secondFromAngle;

  final double secondSweepAngle;
  final double thirdRadius;
  final double thirdWidth;

  final double thirdFromAngle;
  final double thirdSweepAngle;

  final double progress; // Progress value between 0.0 and 1.0

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);

    final first = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = firstWidth;
    final second = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = secondWidth;
    final third = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = thirdWidth;

    canvas
      ..drawCircle(center, firstRadius, first)
      ..drawArc(
        Rect.fromCenter(
          center: center,
          width: secondRadius * 2,
          height: secondRadius * 2,
        ),
        secondFromAngle,
        secondSweepAngle,
        false,
        second,
      )
      ..drawArc(
        Rect.fromCenter(
          center: center,
          width: thirdRadius * 2,
          height: thirdRadius * 2,
        ),
        thirdFromAngle,
        thirdSweepAngle,
        false,
        third,
      );
  }

  @override
  bool shouldRepaint(covariant _Painter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.firstRadius != firstRadius ||
        oldDelegate.firstWidth != firstWidth ||
        oldDelegate.secondFromAngle != secondFromAngle ||
        oldDelegate.secondRadius != secondRadius ||
        oldDelegate.secondSweepAngle != secondSweepAngle ||
        oldDelegate.secondWidth != secondWidth ||
        oldDelegate.thirdFromAngle != thirdFromAngle ||
        oldDelegate.thirdRadius != thirdRadius ||
        oldDelegate.thirdSweepAngle != thirdSweepAngle ||
        oldDelegate.thirdWidth != thirdWidth ||
        oldDelegate.progress != progress;
  }
}
