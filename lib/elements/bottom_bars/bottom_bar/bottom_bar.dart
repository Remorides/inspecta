import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:omdk_repo/omdk_repo.dart';

class OMDKBottomBar extends StatelessWidget {
  const OMDKBottomBar({
    super.key,
    this.widgets = const [],
    this.onTap,
  });

  final List<Widget> widgets;
  final void Function()? onTap;

  static late double barHeight;

  static const double extraButtonHeight = 18;
  static const double buttonDiameter = 75;

  static double totalHeight(double bottomSafe) =>
      bottomSafe + barHeight + extraButtonHeight + bottomPadding;

  static const double bottomPadding = 12;
  static const double buttonPadding = 8;

  static const _Clipper _clipper = _Clipper(
    guest: Rect.fromLTWH(
      10 - buttonPadding,
      -extraButtonHeight - buttonPadding,
      buttonDiameter + buttonPadding * 2,
      buttonDiameter + buttonPadding * 2,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final bottomSafe = MediaQuery.of(context).padding.bottom;
    barHeight = 50 + (bottomSafe == 0 ? 20 : 0);

    return SizedBox(
      width: double.infinity,
      height: totalHeight(bottomSafe),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            top: extraButtonHeight,
            child: ClipPath(
              clipper: _clipper,
              child: Material(
                color: context.theme?.bottomNavigationBarTheme.backgroundColor,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 112 - 22,
                    right: 37 - 22,
                    bottom: bottomPadding +
                        (bottomSafe > 20 ? 10 : 0),
                  ),
                  child: _buttons(context),
                ),
              ),
            ),
          ),
          Positioned(
            left: 10,
            top: 0,
            height: buttonDiameter,
            width: buttonDiameter,
            child: _addButton(context),
          ),
        ],
      ),
    );
  }

  Row _buttons(BuildContext context) {
    return Row(
      children: <Widget>[
        for (final Widget child in widgets)
          Expanded(child: Center(child: child)),
      ],
    );
  }

  Material _addButton(BuildContext context) => Material(
    borderRadius: BorderRadius.circular(500),
    child: InkWell(
      borderRadius: BorderRadius.circular(900),
      onTap: onTap,
      child: const Center(
        child: Icon(
          CupertinoIcons.plus,
          size: 26,
        ),
      ),
    ),
  );

  static Widget button(String asset, VoidCallback onTap) {
    return Material(
      shape: const CircleBorder(
        side: BorderSide(
          width: 1.5,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(300),
        child: SizedBox.square(
          dimension: 40,
          child: Center(
            child: Image.asset(
              asset,
              width: 17,
              height: 17,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

class _Clipper extends CustomClipper<Path> {
  const _Clipper({
    required this.guest,
  });

  final Rect guest;

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    final host = Rect.fromLTWH(0, 0, w, h);

    return const CircularNotchedRectangle().getOuterPath(host, guest);
  }

  @override
  bool shouldReclip(covariant _Clipper oldClipper) {
    return oldClipper.guest != guest;
  }
}
