import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sushi_scouts/src/logic/size/ScreenSize.dart';

class HeaderTitle extends StatelessWidget {
  const HeaderTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                fontSize: 70 * ScreenSize.swu,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Image.asset(
              "./assets/images/toprightlogo.png",
              scale: 6.0 / ScreenSize.swu,
            ),
          ],
        ));
  }
}