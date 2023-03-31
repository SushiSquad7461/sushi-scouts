// Flutter imports:
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import "package:flutter/services.dart";

// Package imports:
import "package:csv/csv.dart";
import "package:localstore/localstore.dart";
import 'package:path_provider/path_provider.dart';
import "package:statistics/statistics.dart";

// Project imports:
import "../../../logic/Constants.dart";
import "../../../logic/data/config_file_reader.dart";
import "../../../logic/helpers/size/screen_size.dart";
import "../../../logic/models/scouting_data_models/page.dart";
import '../../../logic/models/scouting_data_models/scouting_data.dart';
import "../../../logic/models/supervise_data.dart";
import "../../util/header/header_nav_strategy.dart";
import "../../util/header/header_title/mobile_strategy_main.dart";
import "../../util/strategy/RobotDisplayIcon.dart";
import "../../util/strategy/RobotInfo.dart";
import "../sushi_scouts/scouting.dart";

class CardinalExport extends StatefulWidget {
  const CardinalExport({Key? key}) : super(key: key);

  @override
  State<CardinalExport> createState() => _CardinalExportState();
}

class _CardinalExportState extends State<CardinalExport> {
  final method = "cardinal";
  final db = Localstore.instance;
  final reader = ConfigFileReader.instance;
  Map<String, List<SuperviseData>> robotMap = {};
  Map<String, List<ScoutingData>> robotMapScouting = {};
  Map<String, String> robotNames = {};

  TextEditingController search = TextEditingController();
  String searchQuery = "";

  List<ScoutingData>? selected;

  @override
  void initState() {
    super.initState();
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
              String exportId = "${toAdd.display1}:${toAdd.display2}";
              String id = toAdd.data.getCertainDataByName(
                  reader.strat!["cardinal"]["identifier"]);

              if (robotMapScouting.containsKey(id)) {
                // robotMap[id]!.add(toAdd);
                robotMapScouting[id]!.add(toAdd.data);
              } else {
                // robotMap[id] = [toAdd];
                robotMapScouting[id] = [toAdd.data];
              }


              if (robotMap.containsKey(exportId)) {
                robotMap[exportId]!.add(toAdd);
                // robotMapScouting[id]!.add(toAdd.data);
              } else {
                robotMap[exportId] = [toAdd];
                // robotMapScouting[id] = [toAdd.data];
              }
            }
          }
        });
      }
    })();
  }

  void sortRobotNumList() {
    if (robotMapScouting == null) return;
    // mergeSort(Map.fromEntries(robotMapScouting.entries.toList()));
    robotMapScouting = Map.fromEntries(robotMapScouting.entries.toList()
      ..sort((e1, e2) => e1.key.compareTo(e2.key)));

    for (int i = 0; i < robotMapScouting.values.length; i++) {
      robotMapScouting.values.elementAt(i).sort(((a, b) {
        return (a as ScoutingData)
            .getCertainDataByName(reader.strat!["cardinal"]["version"])
            .compareTo((b as ScoutingData)
                .getCertainDataByName(reader.strat!["cardinal"]["version"]));
      }));
    }
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

      if (kDebugMode) {
        print(i.length);
      }

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
      if (kDebugMode) {
        print("Cannot get download folder path");
      }
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

    sortRobotNumList();
    for (final i in robotMapScouting.values) {
      String identifier =
          i[0].getCertainDataByName(reader.strat!["cardinal"]["identifier"]);

      bool currentlySelected = selected != null &&
          identifier ==
              selected![0].getCertainDataByName(
                  reader.strat!["cardinal"]["identifier"]);

      if (selected == null && identifier.contains(searchQuery) ||
          currentlySelected) {
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
                  : RobotDisplayIcon(
                      teamName: robotNames[i[0].getCertainDataByName(
                          reader.strat!["profile"]["identifier"])],
                      teamNum: i[0].getCertainDataByName(
                          reader.strat!["profile"]["identifier"])),
            )));
      }
    }
    return ret;
  }

  @override
  Widget build(BuildContext context) {
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
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: getRobotNumList(),
                  ),
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
                        onPressed: export,
                        child: Text(
                          "download data",
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
              child: HeaderNavStrategy(currPage: "cardinal", val: search),
            ),
          ],
        ));
  }
}
