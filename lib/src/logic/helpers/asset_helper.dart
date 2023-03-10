import 'package:flutter/material.dart';

String getImagePath(String input, BuildContext context, String imageType) {
  return "./assets/images/$input${Theme.of(context).scaffoldBackgroundColor ==
          Colors.white
      ? ""
      : "dark"}.$imageType";
}
