// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:google_fonts/google_fonts.dart";
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

class RobotProfiles extends StatefulWidget {
  const RobotProfiles({Key? key}) : super(key: key);

  @override
  State<RobotProfiles> createState() => _RobotProfilesState();
}

class _RobotProfilesState extends State<RobotProfiles> {
  final db = Localstore.instance;
  final reader = ConfigFileReader.instance;
  List<ScoutingData>? selected;
  int index = 0;
  int picIndex = 0;
  Map<String, List<ScoutingData>> profiles = {};

  @override
  void initState() {
    super.initState();

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
    final textStyle = GoogleFonts.mohave(
        textStyle: TextStyle(
      fontSize: ScreenSize.height * 0.05,
    ));

    List<Widget> ret = [];

    for (final i in profiles.values) {
      if (selected == null ||
          i[0].getCertainDataByName(reader.strat!["profile"]["identifier"]) ==
              selected![index].getCertainDataByName(
                  reader.strat!["profile"]["identifier"])) {
        ret.add(Padding(
          padding: EdgeInsets.only(bottom: ScreenSize.height * 0.01),
          child: GestureDetector(
            onTap: () => setState(() {
              selected = selected != null ? null : i;
              index = 0;
              picIndex = 0;
            }),
            child: SizedBox(
              width: ScreenSize.width * 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    i[0].getCertainDataByName(
                        reader.strat!["profile"]["identifier"]),
                    style: textStyle,
                  ),
                  Divider(
                    height: ScreenSize.height * 0.007,
                    color: Colors.black,
                    thickness: ScreenSize.height * 0.003,
                  ),
                ],
              ),
            ),
          ),
        ));
      }
    }

    return ret;
  }

  List<Widget> getRobotInfo() {
    ScoutingData version = selected![index];
    List<Widget> ret = [];

    for (final i in version.getComponents()) {
      if (i.component != "text input" &&
          i.component != "ranking" &&
          i.name != reader.strat!["profile"]["identifier"] &&
          i.name != reader.strat!["profile"]["version"]) {
        ret.add(Padding(
          padding: EdgeInsets.only(bottom: ScreenSize.height * 0.005),
          child: SizedBox(
            width: ScreenSize.width * 0.8,
            height: ScreenSize.height * 0.05,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  i.name.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Sushi",
                    fontSize: ScreenSize.height * 0.02,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: ScreenSize.width * 0.05),
                  child: Text(
                    version.getCertainDataByName(i.name),
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Sushi",
                      fontSize: ScreenSize.height * 0.015,
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
      }
    }

    return ret;
  }

  Widget getPicture(ScoutingData data, int index) {
    List<Widget> ret = [];

    for (final i in data.getComponents()) {
      if (i.component == "text input") {
        ret.add(Text(
          data.getCertainDataByName(i.name),
          style: GoogleFonts.mohave(
              textStyle: TextStyle(
            fontSize: ScreenSize.height * 0.02,
            color: Colors.black,
          )),
        ));
      }
    }

    if (index > ret.length - 1) {
      return ret.last;
    } else if (index < 0) {
      return ret.first;
    } else {
      return ret[index];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: ScreenSize.height * 0.2),
              child: SizedBox(
                width: ScreenSize.width,
                height: ScreenSize.height * 0.8,
                child: Stack(children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: ScreenSize.width * 0.05,
                        right: ScreenSize.width * 0.15,
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
              Padding(
                padding: EdgeInsets.only(top: ScreenSize.height * 0.28),
                child: GestureDetector(
                  onPanUpdate: (details) {
                    if (details.delta.dy > 20) {
                      setState(() {
                        selected = null;
                      });
                    }
                  },
                  child: Container(
                    height: ScreenSize.height * 0.72,
                    width: ScreenSize.width,
                    decoration: BoxDecoration(
                        color: HexColor("#4F4F4F"),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15 * ScreenSize.swu),
                            topRight: Radius.circular(15 * ScreenSize.swu))),
                    child: Column(children: [
                      Padding(
                        padding:
                            EdgeInsets.only(top: ScreenSize.height * 0.012),
                        child: Container(
                          width: ScreenSize.width * 0.4,
                          height: ScreenSize.height * 0.006,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(40 * ScreenSize.swu))),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: ScreenSize.height * 0.02),
                        child: SizedBox(
                          width: ScreenSize.width,
                          height: ScreenSize.height * 0.25,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                width: ScreenSize.width * 0.8,
                                height: ScreenSize.height * 0.24,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15 * ScreenSize.swu),
                                    )),
                                child: Center(
                                    child:
                                        getPicture(selected![index], picIndex)),
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: ScreenSize.height * 0.01,
                            left: ScreenSize.width * 0.05,
                            right: ScreenSize.width * 0.05),
                        child: SizedBox(
                          width: ScreenSize.width * 0.9,
                          height: ScreenSize.height * 0.36,
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: getRobotInfo(),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: ScreenSize.width * 0.95,
                        height: ScreenSize.height * 0.06,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () =>
                                  setState(() => index -= index > 0 ? 1 : 0),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    bottom: ScreenSize.height * 0.01),
                                child: Icon(
                                  const IconData(0xf57b,
                                      fontFamily: "MaterialIcons",
                                      matchTextDirection: true),
                                  size: ScreenSize.height * 0.08,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Text(
                                "DAY ${selected![index].getCertainDataByName(reader.strat!["profile"]["version"])}",
                                style: TextStyle(
                                  fontSize: ScreenSize.height * 0.035,
                                  fontFamily: "Sushi",
                                )),
                            GestureDetector(
                              onTap: () => setState(() => index +=
                                  index < selected!.length - 1 ? 1 : 0),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    bottom: ScreenSize.height * 0.01),
                                child: Icon(
                                  const IconData(0xf57d,
                                      fontFamily: "MaterialIcons",
                                      matchTextDirection: true),
                                  size: ScreenSize.height * 0.08,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ]),
                  ),
                ),
              ),
            const HeaderTitleMobileStrategyMain(),
            Padding(
              padding: EdgeInsets.only(top: ScreenSize.height * 0.14),
              child: const HeaderNavStrategy(currPage: "pit"),
            ),
          ],
        ));
  }
}
