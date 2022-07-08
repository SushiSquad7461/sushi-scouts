import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sushi_scouts/src/logic/data/ScoutingData.dart';
import 'package:sushi_scouts/src/logic/size/ScreenSize.dart';
import '../util/Header/HeaderTitle.dart';
import '../util/Footer/Footer.dart';
import '../util/header/HeaderNav.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            SizedBox(
              width: ScreenSize.width,
              height: ScreenSize.height * 0.74 - ScreenSize.width / 10,
              child: const Text("ur mother")
            ),
            Padding(
              padding: EdgeInsets.all(ScreenSize.height * 0.01),
              child: SizedBox(
                    width: ScreenSize.width / 10.0, //57
                    height: ScreenSize.width / 10.0, //59
                    child: SvgPicture.asset("./assets/images/nori.svg",)
              ),
            ),
            const Footer(pageTitle: ""),
          ],
        )
    );
  }
}