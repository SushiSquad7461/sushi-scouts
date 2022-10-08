import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:localstore/localstore.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../logic/Constants.dart';
import '../../../logic/data/config_file_reader.dart';
import '../../../logic/helpers/size/screen_size.dart';
import '../../../logic/models/scouting_data_models/component.dart';
import '../../../logic/models/supervise_data.dart';
import '../../util/header/header_nav_strategy.dart';
import '../../util/header/header_title/mobile_strategy_main.dart';

class CardinalExport extends StatefulWidget {
  const CardinalExport({Key? key}) : super(key: key);

  @override
  State<CardinalExport> createState() => _CardinalExportState();
}

class _CardinalExportState extends State<CardinalExport> {
  final method = "cardinal";
  final db = Localstore.instance;
  final reader = ConfigFileReader.instance;
  Map<String, SuperviseData> robotMap = {};

  @override
  void initState() {
    super.initState();

    (() async {
      final scoutingData = await db.collection(stratDatabaseName).get();

      if (scoutingData != null) {
        setState(() {
          for (var name in scoutingData.keys) {
            final toAdd = SuperviseData.fromJson(scoutingData[name]);
            if (toAdd.methodName == method && toAdd.deleted == false) {
              print(toAdd.data.stringfy());
              String id = "${toAdd.display1}:${toAdd.display2}";
              print(id);

              if (robotMap.containsKey(id)) {
              } else {
                robotMap[id] = toAdd;
              }
            }
          }
        });
      }
    })();
  }

  Future<void> export() async {
    List<List<String>> exportData = [];

    exportData.add(["name", "flagged", "team num"]);

    List<Component> components = ConfigFileReader.instance
        .generateNewScoutingData(method)
        .getComponents();

    for (final i in components) {
      exportData[0].add(i.name);
    }

    for (final i in robotMap.values) {
      List<String> addData = [
        i.name,
        i.flagged.toString(),
        i.teamNum.toString()
      ];

      for (final component in components) {
        addData.add(i.data.getCertainDataByName(component.name));
      }

      exportData.add(addData);
    }

    String csvData = const ListToCsvConverter().convert(exportData);

    await Clipboard.setData(ClipboardData(text: csvData));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            const HeaderTitleMobileStrategyMain(),
            Center(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: Colors.black, width: ScreenSize.width * 0.005),
                    borderRadius:
                        BorderRadius.all(Radius.circular(20 * ScreenSize.swu))),
                child: Padding(
                  padding: EdgeInsets.all(ScreenSize.width * 0.02),
                  child: TextButton(
                      onPressed: export,
                      child: Text(
                        "export data",
                        style: TextStyle(
                          fontFamily: "Sushi",
                          color: Colors.black,
                          fontSize: ScreenSize.swu * 30,
                        ),
                      )),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: ScreenSize.height * 0.14),
              child: const HeaderNavStrategy(currPage: "cardinal"),
            ),
          ],
        ));
  }
}
