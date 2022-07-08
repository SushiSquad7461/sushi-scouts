import 'dart:ui';

class ScreenSize {
  static double width = 0;
  static double height = 0;

  static double swu = width / 600.0; //standardized width unit
  static double shu = height / 900.0; //standard height unit

  static Size get() {
    return Size(width, height);
  }
}