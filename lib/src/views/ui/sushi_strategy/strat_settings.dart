// Dart imports:
import "dart:convert";

// Flutter imports:
import 'package:flutter/gestures.dart';
import "package:flutter/material.dart";
import "package:flutter/services.dart";

// Package imports:
import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:get/get.dart";
import "package:localstore/localstore.dart";

// Project imports:
import "../../../../main.dart";
import "../../../logic/Constants.dart" as Constants;
import "../../../logic/blocs/login_bloc/login_cubit.dart";
import "../../../logic/blocs/theme_bloc/theme_cubit.dart";
import '../../../logic/constants.dart';
import "../../../logic/data/config_file_reader.dart";
import '../../../logic/types/device_type.dart';
import "../../../logic/helpers/routing_helper.dart";
import "../../../logic/helpers/size/screen_size.dart";
import '../../../logic/models/scouting_data_models/component.dart';
import '../../../logic/models/supervise_data.dart';
import "../../../logic/network/api_repository.dart";
import '../../util/components/ranking.dart';
import "../../util/header/header_nav_strategy.dart";
import "../../util/header/header_title/mobile_strategy_main.dart";
import '../../util/sushiloading.dart';
import '../../util/themes.dart';
import "../app_choser.dart";
import "../loading.dart";

class StratSettings extends StatefulWidget {
  const StratSettings({Key? key}) : super(key: key);

  @override
  State<StratSettings> createState() => _StratSettingsState();
}

class _StratSettingsState extends State<StratSettings> {
  final db = Localstore.instance;
  final ConfigFileReader reader = ConfigFileReader.instance;
  int? year;
  String collectionName = "";
  bool loading = false;

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

  Future<void> downloadConfigFile() async {
    int configYear = year ?? DateTime.now().year;
    int teamNum = BlocProvider.of<LoginCubit>(context).state.teamNum;

    String? configFile =
        await structures().getConfigFile(configYear, teamNum);
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

  void logOut() {
    BlocProvider.of<LoginCubit>(context).logOut();
    RouteHelper.pushAndRemoveUntilToScreen(-1, 0,
        ctx: context, screen: const AppChooser());
  }

  Future<void> deleteData() async {
    turnOnLoading();
    final collection = await db.collection(stratDatabaseName).get();

    if (collection != null) {
      for (final i in collection.keys) {
        await db.collection(stratDatabaseName).doc(i.split("/")[2]).delete();
      }
    }
    turnOffLoading();
  }

  Future<void> downloadData() async {
    turnOnLoading();
    final toAdd =
        await FirebaseFirestore.instance.collection(collectionName).get();

    List<SuperviseData> ordinalList = [];

    for (var i in toAdd.docs) {
      db.collection(stratDatabaseName).doc(i.id).set(i.data());
      SuperviseData toAdd = SuperviseData.fromJson(i.data());

      if (toAdd.methodName == reader.strat!["ranking"]["method-name"]) {
        ordinalList.add(toAdd);
      }
    }

    await generateOrdinalRankings(ordinalList);

    String rank = (await structures().getRank(
            BlocProvider.of<LoginCubit>(context).state.eventCode.toUpperCase(),
            BlocProvider.of<LoginCubit>(context).state.teamNum))
        .toString();

    db
        .collection("frcapi")
        .doc("rank")
        .set({"rank": rank == "null" ? "1" : rank});

    Map<String, String>? teamNames = await structures().getTeamName(
        BlocProvider.of<LoginCubit>(context).state.eventCode.toUpperCase());

    if (teamNames != null) {
      db.collection("frcapi").doc("name").set(teamNames);
    }

    turnOffLoading();
  }

  Future<void> generateOrdinalRankings(List<SuperviseData> data) async {
    Map<String, Map<String, double>> rankings = {};
    if (data.isNotEmpty) {
      List<Component> rankingComponents = data[0]
          .data
          .getComponents()
          .where((element) => element.component == "ranking")
          .toList();

      for (final component in rankingComponents) {
        rankings[component.name] = {};

        for (final i in data) {
          List<String> rank = i.data
              .getCertainDataByName(component.name)
              .split("[")[1]
              .split("]")[0]
              .split(", ");

          for (int i = 0; i < rank.length; ++i) {
            double add = 1 - ((i) / (rank.length - 1));

            if (rankings[component.name]![rank[i]] == null) {
              rankings[component.name]![rank[i]] = add;
            } else {
              rankings[component.name]![rank[i]] =
                  rankings[component.name]![rank[i]]! + add;
            }
          }
        }
      }
    }

    for (final i in rankings.keys) {
      await db.collection(ordinalRankDatabaseName).doc(i).set(rankings[i]!);
    }
  }

  Future<void> getImage() async {
    turnOnLoading();
    List<int>? teamNums = await structures().getTeamNums(
        BlocProvider.of<LoginCubit>(context).state.eventCode.toUpperCase());

    if (teamNums != null) {
      for (final i in teamNums) {
        print("$i images");
        db
            .collection("frcapi")
            .doc("$i images")
            .set({"imageList": await structures().getImage(i) ?? "[]"});
      }
    }
    turnOffLoading();
  }

  void turnOnLoading() {
    setState(() {
      loading = true;
    });
  }

  void turnOffLoading() {
    setState(() {
      loading = false;
    });
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
          collectionName = "${state.eventCode}:${ConfigFileReader.instance.id}";
          return Stack(children: [
            Padding(
              padding: EdgeInsets.only(top: ScreenSize.height * 0.2),
              child: SizedBox(
                  width: ScreenSize.width,
                  height: ScreenSize.height * 0.8,
                  child: loading
                      ? const SushiLoading()
                      : Stack(
                          fit: StackFit.expand,
                          children: [
                            Align(
                              alignment: const Alignment(0, -0.8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                20 * ScreenSize.swu))),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          ScreenSize.width * 0.02),
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
                                            Radius.circular(
                                                20 * ScreenSize.swu))),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          ScreenSize.width * 0.02),
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
                              alignment:
                                  Alignment(0, isPhoneScreen ? -0.1 : -0.3),
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
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: ScreenSize.height *
                                                          0.003,
                                                      color: colors
                                                          .primaryColorDark),
                                                ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: ScreenSize.height *
                                                          0.003,
                                                      color: colors
                                                          .primaryColorDark),
                                                ),
                                                hintText: "YEAR",
                                                hintStyle: TextStyle(
                                                    color: colors
                                                        .primaryColorDark),
                                                isDense: true,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical:
                                                            ScreenSize.height *
                                                                0.005),
                                              ),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: "Mohave",
                                                fontSize:
                                                    ScreenSize.width * 0.05,
                                                color: colors.primaryColorDark,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .digitsOnly
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
                              alignment:
                                  Alignment(0, isPhoneScreen ? 0.2 : -0.3),
                              child: Container(
                                decoration: boxDecoration,
                                child: TextButton(
                                    onPressed: () {
                                      downloadData();
                                    },
                                    child: Text(
                                      "download data",
                                      style: textStyle,
                                    )),
                              ),
                            ),
                            Align(
                              alignment:
                                  Alignment(0, isPhoneScreen ? 0.5 : 0.1),
                              child: Container(
                                decoration: boxDecoration,
                                child: TextButton(
                                    onPressed: () {
                                      getImage();
                                    },
                                    child: Text(
                                      "get robot images",
                                      style: textStyle,
                                    )),
                              ),
                            ),
                            Align(
                              alignment:
                                  Alignment(0, isPhoneScreen ? -0.5 : -0.9),
                              child: Container(
                                decoration: boxDecoration,
                                child: TextButton(
                                    onPressed: () {
                                      deleteData();
                                    },
                                    child: Text(
                                      "WIPE ALL DATA",
                                      style: textStyle,
                                    )),
                              ),
                            ),
                            Align(
                              alignment:
                                  Alignment(0, isPhoneScreen ? 0.8 : 0.4),
                              child: Container(
                                decoration: boxDecoration,
                                child: TextButton(
                                    onPressed: () {
                                      logOut();
                                    },
                                    child: Text(
                                      "log out",
                                      style: textStyle,
                                    )),
                              ),
                            ),
                          ],
                        )),
            ),
            const HeaderTitleMobileStrategyMain(),
            Padding(
              padding: EdgeInsets.only(top: ScreenSize.height * 0.14),
              child: const HeaderNavStrategy(
                currPage: "settings",
              ),
            ),
          ]);
        }));
  }
}
