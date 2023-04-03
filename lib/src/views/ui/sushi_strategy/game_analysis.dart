import "dart:async";
import "dart:io";

import "package:csv/csv.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:get/get.dart";
import "package:localstore/localstore.dart";
import "package:statistics/statistics.dart";
import "package:path_provider/path_provider.dart";
import "package:sushi_scouts/src/logic/blocs/login_bloc/login_cubit.dart";
import "package:sushi_scouts/src/logic/constants.dart";
import "package:sushi_scouts/src/logic/data/config_file_reader.dart";
import "package:sushi_scouts/src/logic/helpers/size/screen_size.dart";
import "package:sushi_scouts/src/logic/models/match_schedule.dart";
import "package:sushi_scouts/src/logic/models/scouting_data_models/page.dart";
import "package:sushi_scouts/src/logic/models/scouting_data_models/scouting_data.dart";
import "package:sushi_scouts/src/logic/models/supervise_data.dart";
import "package:sushi_scouts/src/logic/network/api_repository.dart";
import "package:sushi_scouts/src/views/util/header/header_nav_strategy.dart";
import "package:sushi_scouts/src/views/util/header/header_title/mobile_strategy_main.dart";
import "package:sushi_scouts/src/views/util/strategy/RobotDisplayIcon.dart";
import "package:sushi_scouts/src/views/util/strategy/RobotInfo.dart";
import "package:sushi_scouts/src/logic/helpers/style/text_style.dart";

class GameAnalysis extends StatefulWidget {
  const GameAnalysis({Key? key}) : super(key: key);

  @override
  State<GameAnalysis> createState() => _GameAnalysisState();
}

class _GameAnalysisState extends State<GameAnalysis> {
  final method = "cardinal";
  final reader = ConfigFileReader.instance;
  Map<String, List<SuperviseData>> robotMap = {};
  Map<String, List<ScoutingData>> robotMapScouting = {};
  Map<String, List<ScoutingData>> stratMapScouting = {};
  Map<String, String> robotNames = {};
  bool hasSchedule = false;
  MatchSchedule? schedule;

  TextEditingController search = TextEditingController();
  String searchQuery = "";
  String type = "quals";

  List<ScoutingData>? selected;

  @override
  void initState() {
    super.initState();
    var db = Localstore.instance;
    getNames();

    search.addListener(() => setState(() {
          searchQuery = search.text;
        }));

    (() async {
      final scoutingData = await db.collection(stratDatabaseName).get();

      if (scoutingData != null) {
        setState(() {
          for (var name in scoutingData.keys) {
            final toAdd = SuperviseData.fromJson(scoutingData[name]);
            if (toAdd.methodName == method && toAdd.deleted == false) {
              // String id = "${toAdd.display1}:${toAdd.display2}";
              String id = toAdd.data.getCertainDataByName(
                  reader.strat!["cardinal"]["identifier"]);

              if (robotMap.containsKey(id)) {
                robotMap[id]!.add(toAdd);
                robotMapScouting[id]!.add(toAdd.data);
              } else {
                robotMap[id] = [toAdd];
                robotMapScouting[id] = [toAdd.data];
              }
            }
          }
        });
      }
    })();
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  Future<void> downloadMatchSchedule() async {
    var db = Localstore.instance;
    MatchSchedule? schedule = await structures().getMatchSchedule(
        BlocProvider.of<LoginCubit>(context).state.eventCode, "quals");

    if (schedule != null) {
      db
          .collection(scoutingDataDatabaseName)
          .doc("schedule")
          .set(schedule.toJson());
    }
    ScoutingData.updateSchedule();
    ConfigFileReader.instance.updateAllData();
  }

  getRobots() async {
    downloadMatchSchedule();
    stratMapScouting = new Map<String, List<ScoutingData>>();
    schedule = ScoutingData.schedule;

    int match = getMatchNum();

    if (schedule != null) {
      for (Team team in schedule!.schedule[match - 1].teams) {
        print("${match} + ${team.number} + ${team.station}");
        if (robotMapScouting[team.number.toString()] != null) {
          stratMapScouting[team.number.toString()] =
              robotMapScouting[team.number.toString()]!;
        } else {
          stratMapScouting[team.number.toString()] = List.empty();
        }
      }
    }

    sortRobotNumList();
  }

  sortRobotNumList() {
    if (stratMapScouting == null) return;
    // mergeSort(Map.fromEntries(robotMapScouting.entries.toList()));
    stratMapScouting = Map.fromEntries(stratMapScouting.entries.toList()
      ..sort((e1, e2) => schedule!.schedule[getMatchNum() - 1].teams[schedule!.schedule[getMatchNum() - 1].teams.indexWhere((element) => element.number.toString() == e1.key)].station.compareTo(schedule!.schedule[getMatchNum() - 1].teams[schedule!.schedule[getMatchNum() - 1].teams.indexWhere((element) => element.number.toString() == e2.key)].station)));

    for (int i = 0; i < stratMapScouting.values.length; i++) {
      stratMapScouting.values.elementAt(i).sort(((a, b) {
        return (a as ScoutingData)
            .getCertainDataByName(reader.strat!["cardinal"]["version"])
            .compareTo((b as ScoutingData)
                .getCertainDataByName(reader.strat!["cardinal"]["version"]));
      }));
    }
    //get match schedule and add all teams to the current one
  }

  int getMatchNum() {
    return isNumeric(searchQuery)
        ? searchQuery.toInt() >= 1
            ? searchQuery.toInt()
            : 1
        : 1;
  }

  Future<void> getNames() async {
    Map<String, dynamic>? newRobotNames = await Localstore.instance
        .collection(frcApiDatabaseName)
        .doc("name")
        .get();

    if (newRobotNames != null) {
      setState(() {
        robotNames = Map<String, String>.from(newRobotNames);
      });
    }
  }

  Future<void> export() async {
    List<List<String>> exportData = [];

    exportData.add(["name", "flagged", "team num"]);

    Map<String, Screen> pages =
        ConfigFileReader.instance.generateNewScoutingData(method).pages;

    for (final page in pages.keys) {
      for (final i in pages[page]!.getComponents()) {
        exportData[0].add("$page:${i.name}");
      }
    }

    for (final i in robotMap.values) {
      List<String> addData = [
        i[0].name,
        i[0].flagged.toString(),
        i[0].teamNum.toString()
      ];

      for (final page in pages.keys) {
        for (final component in pages[page]!.getComponents()) {
          String data = "";
          if ((component.values != null && component.values!.isNotEmpty) ||
              ["string", "bool"].contains(component.type)) {
            Map<String, num> dataFrequency = {};

            for (final j in i) {
              String dataPoint = j.data.getCertainData(page, component.name);

              if (dataFrequency.containsKey(dataPoint)) {
                dataFrequency[dataPoint] = dataFrequency[dataPoint]! + 1;
              } else {
                dataFrequency[dataPoint] = 1;
              }
            }

            for (final val in dataFrequency.keys) {
              if (dataFrequency[data] == null ||
                  dataFrequency[val]! > dataFrequency[data]!) {
                data = val;
              }
            }
          } else {
            List<int> dataList = [];

            for (final j in i) {
              dataList
                  .add(int.parse(j.data.getCertainData(page, component.name)));
            }

            data = dataList.statistics.center.toString();
          }

          addData.add(data);
        }
      }

      exportData.add(addData);
    }

    String csvData = const ListToCsvConverter().convert(exportData);

    // Create a new file. You can create any kind of file like txt, doc , json etc.
    File file =
        await File("${await getDownloadPath()}/ScoutingData.csv").create();

    // You can write to file using writeAsString. This method takes string argument
    await file.writeAsString(csvData);
  }

  Future<String?> getDownloadPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory("/storage/emulated/0/Download");
        // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
        // ignore: avoid_slow_async_io
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      }
    } catch (err) {
      print("Cannot get download folder path");
    }
    return directory?.path;
  }

  void exit() {
    setState(() {
      selected = null;
    });
  }

  List<Widget> getRobotNumList() {
    List<Widget> ret = [];
    var colors = Theme.of(context);
    final textStyle = TextStyle(
      fontFamily: "Mohave",
      fontSize: ScreenSize.height * 0.05,
      color: colors.primaryColorDark,
    );

    for (final i in stratMapScouting.values) {
      if (i.isEmpty) continue;
      String identifier =
          i[0].getCertainDataByName(reader.strat!["cardinal"]["identifier"]);

      bool currentlySelected = selected != null &&
          identifier ==
              selected![0].getCertainDataByName(
                  reader.strat!["cardinal"]["identifier"]);

      if (selected == null || currentlySelected) {
        ret.add(Padding(
            padding: EdgeInsets.only(bottom: ScreenSize.height * 0.01),
            child: GestureDetector(
              onTap: () async {
                setState(() {
                  selected = selected != null ? null : i;
                });
              },
              child: currentlySelected
                  ? SizedBox(
                      width: ScreenSize.width * 0.8,
                      child: Text(
                        i[0].getCertainDataByName(
                            reader.strat!["cardinal"]["identifier"]),
                        style: textStyle,
                      ),
                    )
                  : GameRobotDisplayIcon(
                      teamName: robotNames[i[0].getCertainDataByName(
                          reader.strat!["profile"]["identifier"])],
                      teamNum: i[0].getCertainDataByName(
                          reader.strat!["profile"]["identifier"]),
                      schedule: schedule!,
                      matchNum: getMatchNum()),
            )));
      }
    }
    return ret;
  }

  @override
  Widget build(BuildContext context) {

    getRobots();
    var colors = Theme.of(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            const HeaderTitleMobileStrategyMain(),
            Padding(
              padding: EdgeInsets.only(
                  top: ScreenSize.height * 0.2, left: ScreenSize.width * 0.0),
              child: SizedBox(
                width: ScreenSize.width * 1,
                height: ScreenSize.height * 0.7,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: ScreenSize.width * 0.04,
                      right: ScreenSize.width * 0.04,
                      top: ScreenSize.height * 0.02),
                  child: !hasSchedule
                      ? stratMapScouting.isNotEmpty
                          ? ListView(
                              padding: EdgeInsets.zero,
                              children: getRobotNumList(),
                            )
                          : Center(
                              child: Text("No Scouting Data Found",
                                  style: TextStyles.getTitleText(
                                      30, colors.primaryColorDark)))
                      : Center(
                          child: Text("Match Schedule Not Found",
                              style: TextStyles.getTitleText(
                                  30, colors.primaryColorDark))),
                ),
              ),
            ),
            if (selected != null)
              RobotInfo(
                  exit: exit,
                  selected: selected!,
                  versionName: reader.strat!["cardinal"]["version"]),
            if (selected == null)
              Padding(
                padding: EdgeInsets.only(top: ScreenSize.height * 0.9),
                child: Center(
                  child: Container(
                    height: ScreenSize.height * 0.05,
                    width: ScreenSize.width * 0.5,
                    decoration: BoxDecoration(
                        color: colors.primaryColor,
                        border: Border.all(
                            color: colors.primaryColorDark,
                            width: ScreenSize.width * 0.005),
                        borderRadius: BorderRadius.all(
                            Radius.circular(20 * ScreenSize.swu))),
                    child: TextButton(
                        onPressed: null,
                        child: Text(
                          "${type} ${search.text}",
                          style: TextStyle(
                            fontFamily: "Sushi",
                            color: colors.primaryColorDark,
                            fontSize: ScreenSize.swu * 30,
                          ),
                        )),
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.only(top: ScreenSize.height * 0.14),
              child: HeaderNavStrategy(currPage: "game", val: search),
            ),
          ],
        ));
  }
}
