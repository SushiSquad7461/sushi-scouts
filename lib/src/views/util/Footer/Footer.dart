import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../SushiScoutingLib/logic/size/ScreenSize.dart';

class Footer extends StatelessWidget {
  final String pageTitle;
  const Footer({Key? key, required this.pageTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context);

    return Column(children: [
      Image.asset(
        "./assets/images/colorbar.png",
        scale: 3860.0/ScreenSize.width,
      ),
      Padding(
          padding: EdgeInsets.only(left: 0, right: 0, top: ScreenSize.height/90.0, bottom: 0),
          child: Text(
            pageTitle.toUpperCase(),
            style: TextStyle(
              fontFamily: "Sushi",
              fontSize: ScreenSize.width/17.0,
              fontWeight: FontWeight.bold,
              color: colors.primaryColorDark,
            ),
          ))
    ]);
  }
}
