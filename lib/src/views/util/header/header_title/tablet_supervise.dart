import 'package:flutter/material.dart';
import 'package:sushi_scouts/src/logic/helpers/size/ScreenSize.dart';

class HeaderTitleTabletSupervise extends StatelessWidget {
  const HeaderTitleTabletSupervise({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context);
    return Container(
        color: colors.primaryColor,
        height: ScreenSize.height * 0.07,
        child: Padding(
          padding: EdgeInsets.only(
              left: 20 * ScreenSize.swu,
              right: 20 * ScreenSize.swu,
              top: 0,
              bottom: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "sushi supervise",
                style: TextStyle(
                  fontFamily: "Sushi",
                  fontSize: 65 * ScreenSize.swu,
                  fontWeight: FontWeight.bold,
                  color: colors.primaryColorDark,
                ),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 1, minHeight: 1), // here
                child: Image.asset(
                  colors.scaffoldBackgroundColor == Colors.black
                      ? "./assets/images/superviseheaderlogodark.png"
                      : "./assets/images/supervisehaderlogo.png",
                  scale: 16 / ScreenSize.swu,
                ),
              ),
            ],
          ),
        ));
  }
}
