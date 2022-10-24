// Flutter imports:
import "package:flutter/material.dart";
import "package:flutter/services.dart";

class Themes {
  static final ThemeData dark = ThemeData(
    primaryColor: Colors.black,
    primaryColorDark: Colors.white,
    backgroundColor: Colors.black,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
  );

  static final ThemeData light = ThemeData(
    primaryColor: Colors.white,
    primaryColorDark: Colors.black,
    backgroundColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
  );
}
