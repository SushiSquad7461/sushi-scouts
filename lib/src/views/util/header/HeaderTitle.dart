import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:sushi_scouts/src/logic/size/ScreenSize.dart';

class HeaderTitle extends StatelessWidget {
  const HeaderTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context);
    return Container(
        height: ScreenSize.height*0.1,
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
                "sushi scouts",
                style: TextStyle(
                  fontFamily: "Sushi",
                  fontSize: 75 * ScreenSize.swu,
                  fontWeight: FontWeight.bold,
                  color: colors.primaryColorDark,
                ),
              ),
              Image.asset(
                colors.scaffoldBackgroundColor == Colors.black ? "./assets/images/toprightlogodark.png" : "./assets/images/toprightlogo.png",
                scale: 60 / ScreenSize.swu,
              ),
            ],
          ),
        ));
  }
}