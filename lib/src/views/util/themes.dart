import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final ThemeData darkTheme = ThemeData(
  primaryColor: Colors.black,
  primaryColorDark: Colors.white,
  backgroundColor: Colors.black,
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle.light,
  ),
);

final ThemeData lightTheme = ThemeData(
  primaryColor: Colors.white,
  primaryColorDark: Colors.black,
  backgroundColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  ),
);
