// Flutter imports:
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

// Package imports:
import "package:google_fonts/google_fonts.dart";
import "package:localstore/localstore.dart";

// Project imports:
import "../../../logic/constants.dart";
import "../../../logic/data/config_file_reader.dart";
import "../../../logic/device_type.dart";
import "../../../logic/helpers/color/hex_color.dart";
import "../../../logic/helpers/routing_helper.dart";
import "../../../logic/helpers/size/screen_size.dart";
import "../../../logic/login_type.dart";
import "../../../logic/models/supervise_data.dart";
import "../../util/footer/supervise_footer.dart";
import "../../util/header/header_nav.dart";
import "../../util/header/header_title/header_title.dart";
import "../../util/opacityfilter.dart";
import "edit_content.dart";

class Edit extends StatefulWidget {
  const Edit({Key? key}) : super(key: key);

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  final Map<String, SuperviseData> data = {};
  final List<String> filters = [
    "ALL",
    for (var i in ConfigFileReader.instance.getScoutingMethods()) i
  ];

  String currState = "ALL";
  bool flagMode = false;
  bool deleteMode = false;
  String? editKey;

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  Future<void> refreshData() async {
    final newData =
        await Localstore.instance.collection(superviseDatabaseName).get();

    if (newData != null) {
      setState(() {
        for (var name in newData.keys) {
          data.addAll(
              {name.split("/")[2]: SuperviseData.fromJson(newData[name])});
        }
      });
    }
  }

  void updateData(String key) {
    if (flagMode || deleteMode) {
      setState(() {
        if (flagMode) {
          data[key]!.flagged = !data[key]!.flagged;
        } else if (deleteMode) {
          data[key]!.deleted = !data[key]!.deleted;
        }

        if (flagMode || deleteMode) {
          Localstore.instance
              .collection(superviseDatabaseName)
              .doc(key)
              .set(data[key]!.toJson());
        }
      });
    } else {
      RouteHelper.pushAndRemoveUntilToScreen(1, 0,
          ctx: context,
          screen: EditContent(
              currentScoutingData: data[key]!.data,
              editDB: () => updateDB(key),
              title:
                  "${data[key]!.methodName[0].toUpperCase()} - ${data[key]!.display1} - ${data[key]!.display2}"));
    }
  }

  void updateDB(key) {
    Localstore.instance
        .collection(superviseDatabaseName)
        .doc(key)
        .set(data[key]!.toJson());
  }

  List<Widget> getListView() {
    List<Widget> ret = [];

    List<String> keys = data.keys.toList();
    keys.sort(((a, b) {
      return int.parse(a.split(" - ")[1]).compareTo(int.parse(b.split(" - ")[1]));
    }));

    for (var i in keys) {
      if ((currState == "ALL" || currState == data[i]!.methodName) &&
          (deleteMode || !data[i]!.deleted)) {
        ret.add(Padding(
          padding: EdgeInsets.only(left: ScreenSize.width * 0.02),
          child: GestureDetector(
            onTap: () => updateData(i),
            child: Text(
              "${data[i]!.methodName[0].toUpperCase()} - ${data[i]!.display1} - ${data[i]!.display2}",
              style: GoogleFonts.mohave(
                  textStyle: TextStyle(
                      fontSize: ScreenSize.width * 0.06,
                      fontWeight: FontWeight.bold),
                  color: (data[i]!.flagged)
                      ? HexColor("#56CBF9")
                      : (data[i]!.deleted)
                          ? HexColor("#FCD6F6")
                          : Colors.black),
            ),
          ),
        ));
      }
    }

    return ret;
  }

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context);
    var phone = !isTable(context);

    TextStyle textStyle = TextStyle(
      fontFamily: "Sushi",
      color: colors.primaryColorDark,
    );

    return Scaffold(
      backgroundColor:
          (flagMode || deleteMode) ? HexColor("808080") : Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          OpacityFilter(
            childComponent: const HeaderTitle(type: LoginType.supervise),
            height: phone ? 0.12 : 0.07,
            opacityOn: (flagMode || deleteMode),
          ),
          OpacityFilter(
            childComponent: HeaderNav(
              currentPage: "edit",
              isSupervise: true,
            ),
            height: 0.09,
            opacityOn: (flagMode || deleteMode),
          ),
          SizedBox(
            height: ScreenSize.height * (phone ? 0.62 : 0.63),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: ScreenSize.height * (phone ? 0.07 : 0.05),
                  width: ScreenSize.width * 0.82,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: ScreenSize.height * 0.05,
                        width: ScreenSize.width * 0.25,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: ScreenSize.height * 0.035,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: currState,
                                  icon: const Icon(Icons.tune_rounded,
                                      color: Colors.black),
                                  iconSize: ScreenSize.width * 0.05,
                                  elevation: (ScreenSize.width * 0.2).floor(),
                                  dropdownColor: colors.scaffoldBackgroundColor,
                                  style: GoogleFonts.mohave(
                                    fontSize: ScreenSize.swu * 32,
                                    fontWeight: FontWeight.bold,
                                    color: colors.primaryColorDark,
                                  ),
                                  alignment: AlignmentDirectional.center,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      currState = newValue!;
                                    });
                                  },
                                  items: filters.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Center(
                                          child: Text(
                                        value,
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            SizedBox(
                                width: ScreenSize.width * 0.25,
                                height: ScreenSize.height * 0.01,
                                child: Divider(
                                    color: Colors.black,
                                    thickness: ScreenSize.height * 0.005))
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: flagMode
                                    ? HexColor("#56CBF9")
                                    : colors.primaryColorDark,
                                width: 4 * ScreenSize.shu),
                            borderRadius: BorderRadius.all(
                                Radius.circular(22 * ScreenSize.swu))),
                        height: ScreenSize.height * 0.05,
                        child: TextButton(
                            onPressed: () {
                              setState(() {
                                flagMode = !flagMode;
                                deleteMode = false;
                              });
                            },
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                "FLAG",
                                style: textStyle,
                              ),
                            )),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: deleteMode
                                    ? HexColor("#FCD6F6")
                                    : colors.primaryColorDark,
                                width: 4 * ScreenSize.shu),
                            borderRadius: BorderRadius.all(
                                Radius.circular(22 * ScreenSize.swu))),
                        height: ScreenSize.height * 0.05,
                        child: TextButton(
                            onPressed: () {
                              setState(() {
                                flagMode = false;
                                deleteMode = !deleteMode;
                              });
                            },
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                "DELETE",
                                style: textStyle,
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: ScreenSize.height * 0.55,
                  width: ScreenSize.width * 0.82,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(ScreenSize.width * 0.03),
                        border: Border.all(
                          color: Colors.black,
                          width: ScreenSize.width * 0.01,
                        )),
                    child: ListView(
                        padding: EdgeInsets.only(top: ScreenSize.height * 0.02),
                        children: getListView()),
                  ),
                )
              ],
            ),
          ),
          OpacityFilter(
            childComponent: const SuperviseFooter(),
            height: (phone ? 0.15 : 0.2),
            opacityOn: (flagMode || deleteMode),
          ),
        ],
      ),
    );
  }
}
