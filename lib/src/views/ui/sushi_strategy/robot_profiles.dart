// Flutter imports:
import 'dart:convert';

import "package:flutter/material.dart";
import 'package:flutter_svg/parser.dart';
import 'package:flutter_svg/svg.dart';

// Package imports:
import "package:localstore/localstore.dart";

// Project imports:
import "../../../logic/constants.dart";
import "../../../logic/data/config_file_reader.dart";
import "../../../logic/helpers/color/hex_color.dart";
import "../../../logic/helpers/size/screen_size.dart";
import "../../../logic/models/scouting_data_models/scouting_data.dart";
import "../../../logic/models/supervise_data.dart";
import "../../util/header/header_nav_strategy.dart";
import "../../util/header/header_title/mobile_strategy_main.dart";
import '../../util/strategy/RobotDisplayIcon.dart';
import '../../util/strategy/RobotInfo.dart';

class RobotProfiles extends StatefulWidget {
  const RobotProfiles({Key? key}) : super(key: key);

  @override
  State<RobotProfiles> createState() => _RobotProfilesState();
}

class _RobotProfilesState extends State<RobotProfiles> {
  final db = Localstore.instance;
  final reader = ConfigFileReader.instance;

  List<ScoutingData>? selected;
  Map<String, List<ScoutingData>> profiles = {};

  final TextEditingController search = TextEditingController();
  String searchQuery = "";
  List<String> picUrls = [];

  Map<String, String> robotNames = {};

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
            if (toAdd.methodName == reader.strat!["profile"]["method-name"] &&
                toAdd.deleted == false) {
              String identifier = toAdd.data
                  .getCertainDataByName(reader.strat!["profile"]["identifier"]);

              if (!profiles.containsKey(identifier)) {
                profiles[identifier] = [];
              }

              profiles[identifier]!.add(toAdd.data);
            }
          }
        });
      }
    })();
  }

  List<Widget> getRobotNumList() {
    var colors = Theme.of(context);
    final textStyle = TextStyle(
      fontFamily: "Mohave",
      fontSize: ScreenSize.height * 0.05,
      color: colors.primaryColorDark,
    );

    List<Widget> ret = [];

    for (final i in profiles.values) {
      String identifier =
          i[0].getCertainDataByName(reader.strat!["profile"]["identifier"]);

      bool currentlySelected = selected != null &&
          identifier ==
              selected![0]
                  .getCertainDataByName(reader.strat!["profile"]["identifier"]);

      if ((selected == null && identifier.contains(searchQuery)) ||
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
                            reader.strat!["profile"]["identifier"]),
                        style: textStyle,
                      ),
                    )
                  : RobotDisplayIcon(
                      teamNum: i[0].getCertainDataByName(
                          reader.strat!["profile"]["identifier"]), teamName: robotNames[i[0].getCertainDataByName(
                          reader.strat!["profile"]["identifier"] as String)]
                    ),
            )));
      }
    }

    return ret;
  }

  void exit() {
    setState(() {
      selected = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: ScreenSize.height * 0.2),
              child: SizedBox(
                width: ScreenSize.width,
                height: ScreenSize.height * 0.9,
                child: Stack(children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: ScreenSize.width * 0.04,
                        right: ScreenSize.width * 0.04,
                        top: ScreenSize.height * 0.02),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: getRobotNumList(),
                    ),
                  )
                ]),
              ),
            ),
            if (selected != null)
              RobotInfo(
                  exit: exit,
                  selected: selected!,
                  versionName: reader.strat!["profile"]["version"]),
            const HeaderTitleMobileStrategyMain(),
            Padding(
              padding: EdgeInsets.only(top: ScreenSize.height * 0.14),
              child: HeaderNavStrategy(currPage: "pit", val: search),
            ),
          ],
        ));
  }
}
