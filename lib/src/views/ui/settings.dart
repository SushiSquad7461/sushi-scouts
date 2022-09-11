import 'dart:convert';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
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
import 'package:sushi_scouts/src/logic/Constants.dart';

import 'package:sushi_scouts/src/logic/blocs/login_bloc/login_cubit.dart';
import 'package:sushi_scouts/src/logic/blocs/theme_bloc/theme_cubit.dart';
import 'package:sushi_scouts/src/logic/data/config_file_reader.dart';
import 'package:sushi_scouts/src/logic/deviceType.dart';
import 'package:sushi_scouts/src/logic/helpers/routing_helper.dart';
import 'package:sushi_scouts/src/logic/helpers/secret/secret.dart';
import 'package:sushi_scouts/src/logic/helpers/secret/secret_loader.dart';
import 'package:sushi_scouts/src/logic/helpers/size/ScreenSize.dart';
import 'package:sushi_scouts/src/logic/models/match_schedule.dart';
import 'package:sushi_scouts/src/logic/network/api_repository.dart';
import 'package:sushi_scouts/src/views/ui/app_choser.dart';
import 'package:sushi_scouts/src/views/ui/loading.dart';
import 'package:sushi_scouts/src/views/ui/sushi_scouts/qr_screen.dart';
import 'package:sushi_scouts/src/views/util/footer/supervisefooter.dart';
import 'package:sushi_scouts/src/views/util/header/header_nav.dart';
import 'package:sushi_scouts/src/views/util/header/header_title/header_title.dart';
import '../../../main.dart';
import '../util/Footer/Footer.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final db = Localstore.instance;
  Secret? secrets;
  int? year;
  bool isLoggingOut = false;
  String collectionName = "";

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
      var parsedFile =
          await json.decode((await json.decode(configFile))["config"]);
      await db
          .collection("config_files")
          .doc(parsedFile["teamNumber"].toString())
          .set(parsedFile);
      RouteHelper.pushReplacement(ctx: context, screen: const Loading());
    }
  }

  void downloadNames() {}

  void logOut() {
    deleteData();
    BlocProvider.of<LoginCubit>(context).logOut();
    RouteHelper.pushAndRemoveUntilToScreen(-1, 0,
        ctx: context, screen: const AppChooser());
  }

  void deleteData() {
    var db = Localstore.instance;
    var reader = ConfigFileReader.instance;
    for (var screen in reader.getScoutingMethods()) {
      db.collection("data").doc("backup$screen").delete();
      db.collection("data").doc("current$screen").delete();
    }
  }

  @override
  void initState() {
    super.initState();
    loadSecret();
  }

  void setLogout() {
    setState(() {
      isLoggingOut = true;
    });
  }

  Future<void> loadSecret() async {
    secrets = await SecretLoader(secretPath: "assets/secrets.json").load();
  }

  Future<void> uploadData() async {
    final upload =
        await Localstore.instance.collection(SUPERVISE_DATABASE_NAME).get();
    final db = FirebaseFirestore.instance;

    for (var i in upload!.keys) {
      db.collection(collectionName).doc(i.split("/")[2]).set(upload[i]);
    }
  }

  Future<void> downloadData() async {
    final toAdd =
        await FirebaseFirestore.instance.collection(collectionName).get();

    print("asdawsd");
    print(toAdd.size);
    for (var i in toAdd.docs) {
      print("adding");
      db.collection(SUPERVISE_DATABASE_NAME).doc(i.id).set(i.data());
    }
  }

  Future<void> wipeData() async {
    var db = Localstore.instance;
    final delete = await db.collection(SUPERVISE_DATABASE_NAME).get();

    for (var i in delete!.keys) {
      await db
          .collection(SUPERVISE_DATABASE_NAME)
          .doc(i.split("/")[2])
          .delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context);

    TextStyle textStyle = TextStyle(
      fontFamily: "Sushi",
      color: colors.primaryColorDark,
      fontSize: ScreenSize.swu * 30,
    );

    var isPhoneScreen = isPhone(context);

    BoxDecoration boxDecoration = BoxDecoration(
        border: Border.all(
            color: colors.primaryColorDark, width: 4 * ScreenSize.shu),
        borderRadius: BorderRadius.all(Radius.circular(25 * ScreenSize.swu)));

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocBuilder<LoginCubit, LoginStates>(builder: (context, state) {
          bool isSupervise = state is SushiSuperviseLogin;
          collectionName = "${state.eventCode}:${ConfigFileReader.instance.id}";
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              HeaderTitle(
                isSupervise: isSupervise,
              ),
              HeaderNav(
                currentPage: "settings",
                isSupervise: isSupervise,
              ),
              SizedBox(
                  width: ScreenSize.width,
                  height: ScreenSize.height *
                      (isSupervise
                          ? (isPhoneScreen ? 0.63 : 0.63)
                          : (isPhoneScreen ? 0.55 : 0.64)),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Align(
                        alignment: const Alignment(0, -0.8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(20 * ScreenSize.swu))),
                              child: Padding(
                                padding:
                                    EdgeInsets.all(ScreenSize.width * 0.02),
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
                                padding:
                                    EdgeInsets.all(ScreenSize.width * 0.02),
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
                      ),
                      Align(
                        alignment: Alignment(0, isPhoneScreen ? -0.4 : -0.5),
                        child: isSupervise
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    decoration: boxDecoration,
                                    child: TextButton(
                                        onPressed: downloadData,
                                        child: Text(
                                          "download data",
                                          style: textStyle,
                                        )),
                                  ),
                                  Container(
                                    decoration: boxDecoration,
                                    child: TextButton(
                                        onPressed: uploadData,
                                        child: Text(
                                          "upload data",
                                          style: textStyle,
                                        )),
                                  ),
                                ],
                              )
                            : Container(
                                decoration: boxDecoration,
                                child: TextButton(
                                    onPressed: downloadMatchSchedule,
                                    child: Text(
                                      "download match schedule",
                                      style: textStyle,
                                    )),
                              ),
                      ),
                      Align(
                        alignment: Alignment(0, isPhoneScreen ? 0 : -0.2),
                        child: Container(
                          decoration: boxDecoration,
                          width: ScreenSize.width * 0.47,
                          child: TextButton(
                              onPressed: downloadConfigFile,
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width: ScreenSize.width * 0.15,
                                      height: ScreenSize.height * 0.04,
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                width:
                                                    ScreenSize.height * 0.003,
                                                color: colors.primaryColorDark),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                width:
                                                    ScreenSize.height * 0.003,
                                                color: colors.primaryColorDark),
                                          ),
                                          hintText: "YEAR",
                                          hintStyle: TextStyle(
                                              color: colors.primaryColorDark),
                                          isDense: true,
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical:
                                                  ScreenSize.height * 0.005),
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
                                        onChanged: (String? val) =>
                                            setState(() {
                                          year = (val != null
                                              ? int.parse(val)
                                              : val) as int?;
                                        }),
                                      ),
                                    ),
                                    Text(
                                      "config file",
                                      style: textStyle,
                                    ),
                                  ])),
                        ),
                      ),
                      Align(
                        alignment: Alignment(0, isPhoneScreen ? 0.4 : 0.01),
                        child: Container(
                          decoration: boxDecoration,
                          child: isSupervise
                              ? TextButton(
                                  onPressed: wipeData,
                                  child: Text(
                                    "WIPE ALL DATA",
                                    style: TextStyle(
                                      fontFamily: "Sushi",
                                      color: colors.primaryColorDark,
                                      fontSize: ScreenSize.swu * 30,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ))
                              : TextButton(
                                  onPressed: downloadNames,
                                  child: Text(
                                    "download names",
                                    style: textStyle,
                                  )),
                        ),
                      ),
                      Align(
                        alignment: Alignment(0, isPhoneScreen ? 0.8 : 0.4),
                        child: Container(
                          decoration: boxDecoration,
                          child: TextButton(
                              onPressed: () {
                                setLogout();
                              },
                              child: Text(
                                "log out",
                                style: textStyle,
                              )),
                        ),
                      ),
                      if (isLoggingOut)
                        AlertDialog(
                          title: const Text("Unsent data will be deleted"),
                          content: const Text(
                              "Please go to the QR code screen to send data to your scouting admin."),
                          actions: [
                            TextButton(
                                onPressed: logOut, child: const Text("OK")),
                            TextButton(
                                onPressed: () => setState(() {
                                      isLoggingOut = false;
                                    }),
                                child: const Text("CANCEL"))
                          ],
                        )
                    ],
                  )),
              isSupervise
                  ? const SuperviseFooter()
                  : !isPhoneScreen
                      ? Padding(
                          padding: EdgeInsets.all(ScreenSize.height * 0.01),
                          child: SizedBox(
                              width: ScreenSize.width / 10.0, //57
                              height: ScreenSize.width / 10.0, //59
                              child: SvgPicture.asset(
                                "./assets/images/${colors.scaffoldBackgroundColor == Colors.black ? "darknori" : "nori"}.svg",
                              )),
                        )
                      : SizedBox(
                          width: ScreenSize.width,
                          child: SvgPicture.asset(
                            "./assets/images/mobilefooter.svg",
                            width: ScreenSize.width,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
              if (!isSupervise && !isPhoneScreen) Footer(pageTitle: ""),
            ],
          );
        }));
  }
}
