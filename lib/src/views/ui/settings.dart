// Dart imports:
import "dart:convert";

// Flutter imports:
import "package:flutter/material.dart";
import "package:flutter/services.dart";

// Package imports:
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_svg/svg.dart";
import "package:get/get.dart";
import "package:google_fonts/google_fonts.dart";
import "package:localstore/localstore.dart";

// Project imports:
import "../../../main.dart";
import "../../logic/blocs/login_bloc/login_cubit.dart";
import "../../logic/blocs/theme_bloc/theme_cubit.dart";
import "../../logic/constants.dart";
import "../../logic/data/config_file_reader.dart";
import "../../logic/device_type.dart";
import "../../logic/helpers/routing_helper.dart";
import "../../logic/helpers/secret/secret.dart";
import "../../logic/helpers/secret/secret_loader.dart";
import "../../logic/helpers/size/screen_size.dart";
import "../../logic/login_type.dart";
import "../../logic/models/match_schedule.dart";
import "../../logic/network/api_repository.dart";
import "../util/footer/footer.dart";
import "../util/footer/supervise_footer.dart";
import "../util/header/header_nav.dart";
import "../util/header/header_title/header_title.dart";
import '../util/themes.dart';
import "app_choser.dart";
import "loading.dart";

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
        BlocProvider.of<LoginCubit>(context).state.eventCode, "qual");
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
        await Localstore.instance.collection(superviseDatabaseName).get();
    final db = FirebaseFirestore.instance;

    for (var i in upload!.keys) {
      db.collection(collectionName).doc(i.split("/")[2]).set(upload[i]);
    }
  }

  Future<void> downloadData() async {
    final toAdd =
        await FirebaseFirestore.instance.collection(collectionName).get();

    for (var i in toAdd.docs) {
      db.collection(superviseDatabaseName).doc(i.id).set(i.data());
    }
  }

  Future<void> wipeData() async {
    var db = Localstore.instance;
    final delete = await db.collection(superviseDatabaseName).get();

    for (var i in delete!.keys) {
      await db.collection(superviseDatabaseName).doc(i.split("/")[2]).delete();
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
                  type: isSupervise ? LoginType.supervise : LoginType.scout),
              HeaderNav(
                currentPage: "settings",
                isSupervise: isSupervise,
              ),
              SizedBox(
                  width: ScreenSize.width,
                  height: ScreenSize.height *
                      (isSupervise
                          ? (isPhoneScreen ? 0.62 : 0.63)
                          : (isPhoneScreen ? 0.608 : 0.64)),
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
                          height: ScreenSize.height * 0.19,
                          child: SvgPicture.asset(
                            colors.scaffoldBackgroundColor == Colors.white
                                ? "./assets/images/mobilefooter.svg"
                                : "./assets/images/mobilefooterdark.svg",
                            width: ScreenSize.width,
                            fit: BoxFit.cover,
                          ),
                        ),
              if (!isSupervise && !isPhoneScreen) const Footer(pageTitle: ""),
            ],
          );
        }));
  }
}
