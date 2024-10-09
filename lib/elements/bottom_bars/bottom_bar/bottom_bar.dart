import 'package:flutter/material.dart';
import 'package:omdk_inspecta/elements/elements.dart';

class OMDKBottomBar extends StatelessWidget {
  const OMDKBottomBar({
    super.key,
    this.buttons = const [],
    this.onTapAddBTN,
    this.extraButtonHeight = 18,
    this.buttonDiameter = 75,
    this.bottomPadding = 12,
    this.buttonPadding = 8,
  });

  final List<OMDKBottomBarButton> buttons;
  final void Function()? onTapAddBTN;
  final double extraButtonHeight;
  final double buttonDiameter;
  final double bottomPadding;
  final double buttonPadding;

  @override
  Widget build(BuildContext context) {
    final bottomSafe = MediaQuery.of(context).padding.bottom;
    final barHeight = 50 + (bottomSafe == 0 ? 20 : 0);

    return SizedBox(
      width: double.infinity,
      height: _totalHeight(bottomSafe, barHeight),
      child: Stack(
        children: [
          Positioned.fill(
            top: extraButtonHeight,
            child: ClipPath(
              clipper: _Clipper(
                guest: Rect.fromLTWH(
                  10 - buttonPadding,
                  -extraButtonHeight - buttonPadding,
                  buttonDiameter + buttonPadding * 2,
                  buttonDiameter + buttonPadding * 2,
                ),
              ),
              child: Material(
                color: Theme.of(context).colorScheme.primary,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 112 - 22,
                    right: 37 - 22,
                    bottom: bottomPadding + (bottomSafe > 20 ? 10 : 0),
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
            child: OMDKSimpleActionButton(onTapAddBTN: onTapAddBTN),
          ),
        ],
      ),
    );
  }

  double _totalHeight(double bottomSafe, int barHeight) =>
      bottomSafe + barHeight + extraButtonHeight + bottomPadding;

  Row _buttons(BuildContext context) {
    return Row(
      children: <Widget>[
        for (final Widget child in buttons)
          Expanded(child: Center(child: child)),
      ],
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
