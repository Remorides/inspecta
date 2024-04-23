import 'package:flutter/material.dart';

/// Utils class used to calculate widget size due different screen size
class ResponsiveWidget extends StatelessWidget {
  /// Create [ResponsiveWidget] instance
  const ResponsiveWidget({
    required this.largeScreen,
    super.key,
    this.mediumScreen,
    this.smallScreen,
  });

  /// Widget to show if screen is Large
  final Widget largeScreen;

  /// Widget to show if screen is Medium
  final Widget? mediumScreen;

  /// Widget to show if screen is Small
  final Widget? smallScreen;

  /// Small screen is any screen whose width is less than 800 pixels
  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 800;
  }

  /// Large screen is any screen whose width is more than 1200 pixels
  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 1200;
  }

  /// Medium screen is any screen whose width is less than 1200 pixels,
  /// and more than 800 pixels
  static bool isMediumScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 800 &&
        MediaQuery.of(context).size.width <= 1200;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1200) {
          return largeScreen;
        } else if (constraints.maxWidth <= 1200 &&
            constraints.maxWidth >= 800) {
          return mediumScreen ?? largeScreen;
        } else {
          return smallScreen ?? largeScreen;
        }
      },
    );
  }
}
