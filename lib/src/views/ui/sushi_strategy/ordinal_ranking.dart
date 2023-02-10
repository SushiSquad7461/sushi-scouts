import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/parser.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localstore/localstore.dart';

import '../../../logic/constants.dart';
import '../../../logic/helpers/color/hex_color.dart';
import '../../../logic/helpers/size/screen_size.dart';
import '../../util/header/header_nav_strategy.dart';
import '../../util/header/header_title/mobile_strategy_main.dart';

class OrdinalRanking extends StatefulWidget {
  const OrdinalRanking({Key? key}) : super(key: key);

  @override
  State<OrdinalRanking> createState() => _OrdinalRankingState();
}

class _OrdinalRankingState extends State<OrdinalRanking> {
  Map<String, Map<String, double>> ranking = {};
  Map<String, String> robotNames = {};
  String selectedRanking = "";

  @override
  void initState() {
    super.initState();
    updateRanking();
    getNames();
  }

  Future<void> getNames() async {
    Map<String, String>? newRobotNames = await Localstore.instance
        .collection("frcapi")
        .doc("name")
        .get() as Map<String, String>?;

    if (newRobotNames != null) {
      setState(() {
        robotNames = newRobotNames;
      });
    }
  }

  Future<void> updateRanking() async {
    final data =
        await Localstore.instance.collection(ordinalRankDatabaseName).get();

    Map<String, Map<String, double>> newRanking = {};
    if (data != null) {
      for (final i in data.keys) {
        newRanking[i.split("/")[2]] = {};

        for (final j in data[i].keys) {
          newRanking[i.split("/")[2]]![j] = data[i][j];
        }
      }
    }

    setState(() {
      ranking = newRanking;
    });
  }

  List<Widget> getRankingList() {
    List<Widget> ret = [];
    var colors = Theme.of(context);

    if (ranking[selectedRanking] != null) {
      Map<String, double> rankedCategory = Map.fromEntries(
          ranking[selectedRanking]!.entries.toList()
            ..sort((e1, e2) => e1.value.compareTo(e2.value)));

      int rank = 1;
      for (int i = rankedCategory.keys.length - 1; i >= 0; --i) {
        String robotName = rankedCategory.keys.toList()[i];

        ret.add(Padding(
          padding: EdgeInsets.only(bottom: ScreenSize.height * 0.02),
          child: Container(
            width: ScreenSize.width * 0.6,
            height: ScreenSize.height * 0.13,
            decoration: BoxDecoration(
              color: colors.primaryColorDark,
              borderRadius:
                  BorderRadius.all(Radius.circular(15 * ScreenSize.swu)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: ScreenSize.width * 0.03,
                      right: ScreenSize.width * 0.02),
                  child: SizedBox(
                    width: ScreenSize.width * 0.08,
                    height: ScreenSize.width * 0.08,
                    child: Stack(children: [
                      SvgPicture.asset(
                        "./assets/images/upwardarrow${colors.backgroundColor == Colors.white ? "white" : "dark"}.svg",
                        width: ScreenSize.width * 0.08,
                      ),
                      Center(
                        child: Text(
                          rank.toString(),
                          style: TextStyle(
                              fontFamily: "Mohave",
                              fontSize: ScreenSize.height * 0.03,
                              color: colors.primaryColorDark,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ]),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: ScreenSize.height * 0.01),
                  child: SizedBox(
                    height: ScreenSize.height * 0.10,
                    width: ScreenSize.width * 0.3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          robotName,
                          style: TextStyle(
                            fontFamily: "Mohave",
                            fontSize: ScreenSize.height * 0.06,
                            height: 1,
                            color: colors.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          robotNames[robotName] != null
                              ? robotNames[robotName]!.toUpperCase()
                              : "SUSSY SQUAD",
                          style: TextStyle(
                            fontFamily: "Mohave",
                            fontSize: ScreenSize.height * 0.02,
                            height: 1,
                            color: colors.primaryColor,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: ScreenSize.width * 0.1),
                  child: SvgPicture.asset(
                    "./assets/images/rankingtile.svg",
                    height: ScreenSize.height * 0.13,
                  ),
                )
              ],
            ),
          ),
        ));

        rank += 1;
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
              padding: EdgeInsets.only(top: ScreenSize.height * 0.20),
              child: SizedBox(
                width: ScreenSize.width,
                height: ScreenSize.height * 0.8,
                child: Column(
                  children: [
                    SizedBox(
                      width: ScreenSize.width,
                      height: ScreenSize.height * 0.06,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          for (final i in ranking.keys)
                            GestureDetector(
                              onTap: () => setState(() {
                                selectedRanking = i;
                              }),
                              child: Text(
                                i.toUpperCase(),
                                style: TextStyle(
                                  fontFamily: "Mohave",
                                        fontSize: ScreenSize.height * 0.023,
                                        fontWeight: FontWeight.bold,
                                        color: selectedRanking == i
                                            ? colors.primaryColorDark
                                            : HexColor("#4F4F4F"))),
                              ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: ScreenSize.width,
                      height: ScreenSize.height * 0.74,
                      child: ListView(
                        padding: EdgeInsets.only(
                            left: ScreenSize.width * 0.02,
                            right: ScreenSize.width * 0.02),
                        children: getRankingList(),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: ScreenSize.height * 0.14),
              child: const HeaderNavStrategy(currPage: "ordinal"),
            ),
          ],
        ));
  }
}
