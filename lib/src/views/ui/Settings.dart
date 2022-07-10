import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:localstore/localstore.dart';
import 'package:sushi_scouts/src/logic/data/ScoutingData.dart';
import 'package:sushi_scouts/src/logic/size/ScreenSize.dart';
import '../../../main.dart';
import '../util/Header/HeaderTitle.dart';
import '../util/Footer/Footer.dart';
import '../util/header/HeaderNav.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final db = Localstore.instance;

  Future<void> toggleMode(String mode) async {
    db.collection("preferences").doc("mode").set({
      "mode": mode,
    });

    mode == "dark"
          ? Get.changeTheme(Themes.dark)
          : Get.changeTheme(Themes.light);
  }

  void downloadMatchSchedule() {}

  void downloadConfigFile() {}

  void downloadNames() {}

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context);

    TextStyle textStyle = TextStyle(
      fontFamily: "Sushi",
      color: colors.primaryColorDark,
      fontSize: ScreenSize.swu * 30,
    );

    BoxDecoration boxDecoration = BoxDecoration(
        border: Border.all(color: colors.primaryColorDark, width: 4 * ScreenSize.shu),
        borderRadius: BorderRadius.all(Radius.circular(20 * ScreenSize.swu)));

    return Column(
      children: [
        SizedBox(
            width: ScreenSize.width,
            height: ScreenSize.height * 0.64,
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
                        padding: EdgeInsets.all(ScreenSize.width * 0.02),
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
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                              Radius.circular(20 * ScreenSize.swu))),
                      child: Padding(
                        padding: EdgeInsets.all(ScreenSize.width * 0.02),
                        child: TextButton(
                            onPressed: () => toggleMode("light"),
                            child: Text(
                              "light mode",
                              style: TextStyle(
                                fontFamily: "Sushi",
                                color: Colors.black,
                                fontSize: ScreenSize.swu * 30,
                              ),
                            )),
                      ),
                    )
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
                "./assets/images/${colors.scaffoldBackgroundColor == Colors.black ? "darknori" : "nori"}.svg",
              )),
        ),
        const Footer(pageTitle: ""),
      ],
    );
  }
}
