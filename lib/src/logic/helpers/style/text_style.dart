import 'package:flutter/material.dart';
import 'package:sushi_scouts/src/logic/helpers/style/sizes.dart';

import '../color/hex_color.dart';
import '../size/screen_size.dart';

class Fonts {
  static const String sushi = "Sushi";
  static const String mohave = "Mohave";
}

class TextStyles {
  static TextStyle getButtonText(var context) {
    return TextStyle(
      fontFamily: Fonts.sushi,
      color: Theme.of(context).primaryColorDark,
      fontSize: Sizes.buttonFontSize,
    );
  }

  static TextStyle getButtonColoredText(Color color) {
    return TextStyle(
      fontFamily: Fonts.sushi,
      color: color,
      fontSize: Sizes.buttonFontSize,
    );
  }

  static TextStyle getButtonWeightedText(var context, FontWeight weight,) {
    return TextStyle(
      fontFamily: Fonts.sushi,
      color: Theme.of(context).primaryColorDark,
      fontSize: Sizes.buttonFontSize,
      fontWeight: weight
    );
  }
}
