import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sushi_scouts/SushiScoutingLib/logic/helpers/size/ScreenSize.dart';

class HeaderTitleMobile extends StatelessWidget {
  const HeaderTitleMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context);
    return Container(
        height: ScreenSize.height * 0.1,
        child: Padding(
          padding: EdgeInsets.only(
              left: 20 * ScreenSize.swu,
              right: 20 * ScreenSize.swu,
              top: 0,
              bottom: 0),
          child: Stack(
            children: [
              Text(
                "sushi scouts",
                style: TextStyle(
                  fontFamily: "Sushi",
                  fontSize: 75 * ScreenSize.swu,
                  fontWeight: FontWeight.bold,
                  color: colors.primaryColorDark,
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(minWidth: 1, minHeight: 1), // here
                child: Image.asset(
                  colors.scaffoldBackgroundColor == Colors.black
                      ? "./assets/images/header_title_mobile.png"
                      : "./assets/images/header_title_mobile.png",
                  scale: ScreenSize.width,
                ),
              ),
            ],
          ),
        ));
  }
}
