// Flutter imports:
import "package:flutter/material.dart";

// Project imports:
import "../../logic/helpers/color/hex_color.dart";
import "../../logic/helpers/size/screen_size.dart";

class OpacityFilter extends StatelessWidget {
  final Widget childComponent;
  final double height;
  final bool opacityOn;
  const OpacityFilter(
      {Key? key,
      required this.childComponent,
      required this.height,
      required this.opacityOn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      childComponent,
      if (opacityOn)
        Opacity(
          opacity: 0.75,
          child: Container(
              height: ScreenSize.height * height,
              width: ScreenSize.width,
              color: HexColor("4F4F4F")),
        ),
    ]);
  }
}
