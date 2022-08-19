import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localstore/localstore.dart';

import 'package:sushi_scouts/src/logic/blocs/login_bloc/login_cubit.dart';
import 'package:sushi_scouts/src/logic/blocs/theme_bloc/theme_cubit.dart';
import 'package:sushi_scouts/src/logic/helpers/routing_helper.dart';
import 'package:sushi_scouts/src/logic/helpers/secret/secret.dart';
import 'package:sushi_scouts/src/logic/helpers/secret/secret_loader.dart';
import 'package:sushi_scouts/src/logic/helpers/size/ScreenSize.dart';
import 'package:sushi_scouts/src/logic/models/match_schedule.dart';
import 'package:sushi_scouts/src/logic/network/api_repository.dart';
import 'package:sushi_scouts/src/views/ui/app_choser.dart';
import 'package:sushi_scouts/src/views/ui/loading.dart';
import 'package:sushi_scouts/src/views/util/footer/supervisefooter.dart';
import 'package:sushi_scouts/src/views/util/header/header_nav.dart';
import 'package:sushi_scouts/src/views/util/header/header_title/header_title.dart';
import 'package:sushi_scouts/src/views/util/popups/logout.dart';
import '../../../main.dart';
import '../util/Footer/Footer.dart';

class Settings extends StatefulWidget {
  final bool isSupervise;
  const Settings({Key? key, this.isSupervise = false}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final db = Localstore.instance;
  Secret? secrets;
  int? year;

  Future<void> toggleMode(String mode) async {
    BlocProvider.of<ThemeCubit>(context)
        .switchTheme(isDarkMode: mode == "dark" ? true : false);
    db.collection("preferences").doc("mode").set({
      "mode": mode,
    });

    mode == "dark"
        ? Get.changeTheme(Themes.dark)
        : Get.changeTheme(Themes.light);
  }

  Future<void> downloadMatchSchedule() async {
    MatchSchedule? schedule = await ApiRepository().getMatchSchedule(
        BlocProvider.of<LoginCubit>(context).state.eventCode, 'qual');
    if (schedule != null) {
      db.collection("data").doc("schedule").set(schedule.toJson());
    }
  }

  Future<void> downloadConfigFile() async {
    int configYear = year ?? DateTime.now().year;
    int teamNum = BlocProvider.of<LoginCubit>(context).state.teamNum;

    String? configFile =
        await ApiRepository().getConfigFile(configYear, teamNum);
    if (configFile != null) {
      var parsedFile = await json.decode((await json.decode(configFile))["config"]);
      await db
          .collection("config_files")
          .doc(parsedFile["teamNumber"].toString())
          .set(parsedFile);
      RouteHelper.pushReplacement(ctx: context, screen: const Loading());
    }
  }

  void downloadNames() {}

  void logOut() {
    BlocProvider.of<LoginCubit>(context).logOut();
    RouteHelper.pushAndRemoveUntilToScreen(-1, 0,
        ctx: context, screen: const AppChooser());
  }

  @override
  void initState() {
    super.initState();
    loadSecret();
  }

  Future<void> loadSecret() async {
    secrets = await SecretLoader(secretPath: "assets/secrets.json").load();
  }

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context);

    TextStyle textStyle = TextStyle(
      fontFamily: "Sushi",
      color: colors.primaryColorDark,
      fontSize: ScreenSize.swu * 30,
    );

    BoxDecoration boxDecoration = BoxDecoration(
        border: Border.all(
            color: colors.primaryColorDark, width: 4 * ScreenSize.shu),
        borderRadius: BorderRadius.all(Radius.circular(25 * ScreenSize.swu)));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          HeaderTitle(
            isSupervise: widget.isSupervise,
          ),
          HeaderNav(
            currentPage: "settings",
            isSupervise: widget.isSupervise,
          ),
          SizedBox(
              width: ScreenSize.width,
              height: ScreenSize.height * (widget.isSupervise ? 0.6 : 0.64),
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
                    width: ScreenSize.width * 0.47,
                    child: TextButton(
                        onPressed: downloadConfigFile,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: ScreenSize.width * 0.15,
                                height: ScreenSize.height * 0.04,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width: ScreenSize.height * 0.003,
                                          color: colors.primaryColorDark),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width: ScreenSize.height * 0.003,
                                          color: colors.primaryColorDark),
                                    ),
                                    hintText: "YEAR",
                                    hintStyle: TextStyle(
                                        color: colors.primaryColorDark),
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: ScreenSize.height * 0.005),
                                  ),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.mohave(
                                      textStyle: TextStyle(
                                    fontSize: ScreenSize.width * 0.05,
                                    color: colors.primaryColorDark,
                                    fontWeight: FontWeight.w500,
                                  )),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  onChanged: (String? val) => setState(() {
                                    year = (val != null ? int.parse(val) : val)
                                        as int?;
                                  }),
                                ),
                              ),
                              Text(
                                "config file",
                                style: textStyle,
                              ),
                            ])),
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
                  Container(
                    decoration: boxDecoration,
                    child: TextButton(
                        onPressed: () {
                          if(!widget.isSupervise) {
                            showDialog(
                              context: context,
                              builder: ((context) => const Logout())
                            );
                          } else {
                            logOut();
                          }
                        },
                        child: Text(
                          "log out",
                          style: textStyle,
                        )),
                  ),
                ],
              )),
          widget.isSupervise
              ? const SuperviseFooter()
              : Padding(
                  padding: EdgeInsets.all(ScreenSize.height * 0.01),
                  child: SizedBox(
                      width: ScreenSize.width / 10.0, //57
                      height: ScreenSize.width / 10.0, //59
                      child: SvgPicture.asset(
                        "./assets/images/${colors.scaffoldBackgroundColor == Colors.black ? "darknori" : "nori"}.svg",
                      )),
                ),
          if (!widget.isSupervise) Footer(pageTitle: ""),
        ],
      ),
    );
  }
}
