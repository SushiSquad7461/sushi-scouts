import 'dart:ui';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  static HexColor fromString(Map<dynamic, dynamic> json, String key) {
    return HexColor(json[key]);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}