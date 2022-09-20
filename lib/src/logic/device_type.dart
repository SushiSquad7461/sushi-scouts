import "package:flutter/material.dart";

bool isPhone(BuildContext context) {
  // The equivalent of the "smallestWidth" qualifier on Android.
  var shortestSide = MediaQuery.of(context).size.shortestSide;

  // Determine if we should use mobile layout or not, 600 here is
  // a common breakpoint for a typical 7-inch tablet.
  final bool useMobileLayout = shortestSide < 600;
  return useMobileLayout;
}

bool isTable(BuildContext context) {
  return !isPhone(context);
}
