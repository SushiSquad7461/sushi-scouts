import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sushi_scouts/src/logic/deviceType.dart';
import 'package:sushi_scouts/src/logic/helpers/size/ScreenSize.dart';

class SuperviseFooter extends StatelessWidget {
  const SuperviseFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context);
    var phone = !isTable(context);
    return Container(
      color: colors.primaryColor,
      width: ScreenSize.width,
      height: ScreenSize.height * (phone ? 0.15 : 0.2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Image.asset(colors.scaffoldBackgroundColor == Colors.black
              ? "./assets/images/supervisefooterdark.png"
              : "./assets/images/supervisefooter.png"),
        ],
      ),
    );
  }
}
