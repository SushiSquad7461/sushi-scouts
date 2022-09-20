import "package:flutter/material.dart";

class RouteHelper {
  static void pushAndRemoveUntilToScreen(double beginX, double beginY,
      {required BuildContext ctx, required Widget screen}) {
    Navigator.pushAndRemoveUntil(
        ctx, createRoute(screen, beginX, beginY), (route) => false);
  }

  static void pushReplacement({
    required BuildContext ctx,
    required Widget screen,
  }) {
    final route = MaterialPageRoute(
      builder: (ctx) => screen,
    );
    Navigator.pushReplacement(ctx, route);
  }

  static void pushToScreen({
    required BuildContext ctx,
    bool fullscreenDialog = false,
    required Widget screen,
  }) {
    final route = MaterialPageRoute(
      builder: (ctx) => screen,
      fullscreenDialog: fullscreenDialog,
    );
    Navigator.push(ctx, route);
  }

  static Route createRoute(Widget screen, double beginX, double beginY) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(beginX, beginY);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
