import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localstore/localstore.dart';
import 'package:sushi_scouts/src/logic/data/ScoutingData.dart';
import 'package:sushi_scouts/src/logic/size/ScreenSize.dart';
import '../util/Header/HeaderTitle.dart';
import '../util/Footer/Footer.dart';
import '../util/header/HeaderNav.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  TextStyle textStyle = TextStyle(
    fontFamily: "Sushi",
    color: Colors.black,
    fontSize: ScreenSize.swu * 30,
  );

  BoxDecoration boxDecoration = BoxDecoration(
      border: Border.all(color: Colors.black, width: 4 * ScreenSize.shu),
      borderRadius: BorderRadius.all(Radius.circular(20 * ScreenSize.swu)));

  final db = Localstore.instance;

  Future<void> toggleMode(String mode) async {
    db.collection("preferences").doc("mode").set({
      "mode": mode,
    });
  }

  void downloadMatchSchedule() {}

  void downloadConfigFile() {}

  void downloadNames() {}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            width: ScreenSize.width,
            height: ScreenSize.height * 0.6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(
                              Radius.circular(20 * ScreenSize.swu))),
                      child: Padding(
                        padding: EdgeInsets.all(ScreenSize.width * 0.01),
                        child: TextButton(
                            onPressed: () => toggleMode("dark"),
                            child: Text(
                              "DARK MODE",
                              style: TextStyle(
                                fontFamily: "Sushi",
                                color: Colors.white,
                                fontSize: ScreenSize.swu * 30,
                              ),
                            )),
                      ),
                    ),
                    TextButton(
                        onPressed: () => toggleMode("light"),
                        child: Text(
                          "light mode",
                          style: textStyle,
                        ))
                  ],
                ),
                Container(
                  decoration: boxDecoration,
                  child: TextButton(
                      onPressed: downloadMatchSchedule,
                      child: Text(
                        "download match schedule",
                        style: textStyle,
                      )),
                ),
                Container(
                  decoration: boxDecoration,
                  child: TextButton(
                      onPressed: downloadConfigFile,
                      child: Text(
                        "download config file",
                        style: textStyle,
                      )),
                ),
                Container(
                  decoration: boxDecoration,
                  child: TextButton(
                      onPressed: downloadNames,
                      child: Text(
                        "download names",
                        style: textStyle,
                      )),
                ),
              ],
            )),
        Padding(
          padding: EdgeInsets.all(ScreenSize.height * 0.01),
          child: SizedBox(
              width: ScreenSize.width / 10.0, //57
              height: ScreenSize.width / 10.0, //59
              child: SvgPicture.asset(
                "./assets/images/nori.svg",
              )),
        ),
        const Footer(pageTitle: ""),
      ],
    );
  }
}
