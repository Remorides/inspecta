import 'dart:ui';

/// Utils class to get [Color] object from hex-color string
class HexColor extends Color {
  /// Create [HexColor] instance
  HexColor(String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    var hColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hColor.length == 6) {
      hColor = 'FF$hColor';
    }
    return int.parse(hColor, radix: 16);
  }
}
