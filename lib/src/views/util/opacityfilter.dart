import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../logic/helpers/color/hex_color.dart';
import '../../logic/helpers/size/ScreenSize.dart';

class OpacityFilter extends StatelessWidget {
  final Widget childComponent;
  final double height;
  final bool opacityOn;
  const OpacityFilter(
      {Key? key, required this.childComponent, required this.height, required this.opacityOn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      childComponent,
      if(opacityOn) Opacity(
        opacity: 0.75,
        child: Container(
            height: ScreenSize.height * height,
            width: ScreenSize.width,
            color: HexColor("4F4F4F")),
      ),
    ]);
  }
}
