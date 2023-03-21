import 'dart:core';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localstore/localstore.dart';

import '../../../logic/constants.dart';
import '../../../logic/data/config_file_reader.dart';
import '../../../logic/helpers/color/hex_color.dart';
import '../../../logic/helpers/size/screen_size.dart';
import '../../../logic/models/scouting_data_models/scouting_data.dart';

class RobotInfo extends StatefulWidget {
  final List<ScoutingData> selected;
  final Function exit;
  final String versionName;
  const RobotInfo(
      {Key? key,
      required this.exit,
      required this.selected,
      required this.versionName})
      : super(key: key);

  @override
  State<RobotInfo> createState() => _RobotInfoState();
}

class _RobotInfoState extends State<RobotInfo> {
  int index = 0;
  int picIndex = 0;
  List<String> picList = [];
  List<Widget> widgetPicList = [];
  Widget selectedPic = const Text("");

  final db = Localstore.instance;
  final reader = ConfigFileReader.instance;

  void generateWidgetPicList() {
    var colors = Theme.of(context);

    widgetPicList = [];

    for (final i in picList) {
      widgetPicList.add(Image.network(
        "$i.jpeg",
        width: ScreenSize.width * 0.8,
      ));
    }

    for (final i in widget.selected[index].getComponents()) {
      if (i.component == "text input") {
        widgetPicList.add(Text(
          widget.selected[index].getCertainDataByName(i.name),
          style: TextStyle(
            fontFamily: "Mohave",
            fontSize: ScreenSize.height * 0.02,
            color: colors.primaryColorDark,
          ),
        ));
      }
    }

    setPic(picIndex > widgetPicList.length-1 ? widgetPicList.length-1 : picIndex);
  }

  void setPic(int newIndex) {
    setState(() {
      if (newIndex < 0) {
        newIndex = 0;
      }

      if (newIndex > widgetPicList.length - 1) {
        newIndex = widgetPicList.length - 1;
      }

      picIndex = newIndex;
      selectedPic = widgetPicList[newIndex];
    });
  }

  Future<void> getPicList() async {
    String identifier = widget.selected[index]
        .getCertainDataByName(reader.strat!["profile"]["identifier"]);

    var databaseList = (await db
        .collection(frcApiDatabaseName)
        .doc("$identifier images")
        .get());

    picList = databaseList == null ? [] : databaseList["imageList"];

    generateWidgetPicList();
  }

  List<Widget> getRobotInfo() {
    ScoutingData version = widget.selected[index];
    List<Widget> ret = [];
    var colors = Theme.of(context);

    List<Color> underLineColors = [
      HexColor("#FF729F"),
      HexColor("#81F4E1"),
      HexColor("#56CBF9"),
      HexColor("#FCD6F6"),
      colors.primaryColor
    ];
    int underlineIndex = 0;

    for (final i in version.getComponents()) {
      String displayString = version.getCertainDataByName(i.name).toLowerCase();

      if (displayString.length > 39) {
        displayString = displayString.replaceFirst(RegExp(r'.'), "\n", 39);
      }

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
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: underLineColors[underlineIndex],
                    width: ScreenSize.height * 0.002, // Underline thickness
                  ))),
                  child: Text(
                    i.name.toUpperCase(),
                    style: TextStyle(
                      color: colors.primaryColor,
                      fontFamily: "Sushi",
                      fontSize: ScreenSize.height * 0.02,
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(left: ScreenSize.width * 0.05),
                    child: Text(
                      displayString,
                      style: TextStyle(
                        color: colors.primaryColor,
                        fontFamily: "Sushi",
                        fontSize: ScreenSize.height * 0.015,
                      ),
                    ))
              ],
            ),
          ),
        ));

        underlineIndex += 1;

        if (underlineIndex >= underLineColors.length) {
          underlineIndex = 0;
        }
      }
    }

    return ret;
  }

  @override
  void initState() {
    super.initState();
    getPicList();
  }

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context);

    // getPicList();

    return Padding(
      padding: EdgeInsets.only(top: ScreenSize.height * 0.28),
      child: GestureDetector(
        onPanUpdate: (details) {
          if (details.delta.dy > 20) {
            widget.exit();
          }
        },
        child: Container(
          height: ScreenSize.height * 0.72,
          width: ScreenSize.width,
          decoration: BoxDecoration(
              color: colors.primaryColorDark,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15 * ScreenSize.swu),
                  topRight: Radius.circular(15 * ScreenSize.swu))),
          child: Stack(alignment: Alignment.bottomRight, children: [
            SvgPicture.asset("./assets/images/pitfooterstrat.svg"),
            Column(children: [
              Padding(
                padding: EdgeInsets.only(top: ScreenSize.height * 0.012),
                child: Container(
                  width: ScreenSize.width * 0.4,
                  height: ScreenSize.height * 0.006,
                  decoration: BoxDecoration(
                      color: colors.primaryColor,
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
                      GestureDetector(
                        onTap: () => {setPic(picIndex - 1)},
                        child: Icon(
                          const IconData(0xf57b,
                              fontFamily: "MaterialIcons",
                              matchTextDirection: true),
                          size: ScreenSize.width * 0.1,
                          color: colors.primaryColor,
                        ),
                      ),
                      Container(
                          width: ScreenSize.width * 0.8,
                          height: ScreenSize.height * 0.24,
                          decoration: BoxDecoration(
                              color: colors.primaryColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(15 * ScreenSize.swu),
                              )),
                          child: Center(
                            child: selectedPic,
                          )),
                      GestureDetector(
                        onTap: () => {setPic(picIndex + 1)},
                        child: Icon(
                          const IconData(0xf57d,
                              fontFamily: "MaterialIcons",
                              matchTextDirection: true),
                          size: ScreenSize.width * 0.1,
                          color: colors.primaryColor,
                        ),
                      ),
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
                      onTap: () => setState(() {
                        index -= index > 0 ? 1 : 0;
                        generateWidgetPicList(); // TODO: make more efficent
                      }),
                      child: Padding(
                        padding:
                            EdgeInsets.only(bottom: ScreenSize.height * 0.01),
                        child: Icon(
                          const IconData(0xf57b,
                              fontFamily: "MaterialIcons",
                              matchTextDirection: true),
                          size: ScreenSize.height * 0.08,
                          color: colors.primaryColor,
                        ),
                      ),
                    ),
                    Text(
                        "${widget.versionName.toUpperCase().replaceAll("#", "")} ${widget.selected[index].getCertainDataByName(widget.versionName)}",
                        style: TextStyle(
                            fontSize: ScreenSize.height * 0.035,
                            fontFamily: "Sushi",
                            color: colors.primaryColor)),
                    GestureDetector(
                      onTap: () => setState(() {
                        index += index < widget.selected.length - 1 ? 1 : 0;
                        getPicList();
                      }),
                      child: Padding(
                        padding:
                            EdgeInsets.only(bottom: ScreenSize.height * 0.01),
                        child: Icon(
                          const IconData(0xf57d,
                              fontFamily: "MaterialIcons",
                              matchTextDirection: true),
                          size: ScreenSize.height * 0.08,
                          color: colors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ]),
          ]),
        ),
      ),
    );
  }
}
