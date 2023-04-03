import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import "package:sushi_scouts/src/logic/helpers/style/text_style.dart";
import "package:sushi_scouts/src/logic/models/match_schedule.dart";

import '../../../logic/helpers/size/screen_size.dart';

class RobotDisplayIcon extends StatelessWidget {
  final String teamNum;
  final String? teamName;
  final int? rank;

  const RobotDisplayIcon(
      {Key? key, required this.teamNum, this.teamName, this.rank})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: ScreenSize.height * 0.02),
      child: Container(
        width: ScreenSize.width * 0.6,
        height: ScreenSize.height * 0.13,
        decoration: BoxDecoration(
          color: colors.primaryColorDark,
          borderRadius: BorderRadius.all(Radius.circular(15 * ScreenSize.swu)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (rank != null)
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
              padding: EdgeInsets.only(
                  top: ScreenSize.height * 0.01,
                  left: ScreenSize.width * (rank == null ? 0.02 : 0)),
              child: SizedBox(
                height: ScreenSize.height * 0.10,
                width: ScreenSize.width * 0.3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      teamNum,
                      style: TextStyle(
                        fontFamily: "Mohave",
                        fontSize: ScreenSize.height * 0.06,
                        height: 1,
                        color: colors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      teamName != null
                          ? teamName!.toUpperCase()
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
              padding: EdgeInsets.only(
                  left: ScreenSize.width * (rank == null ? 0.21 : 0.1)),
              child: SvgPicture.asset(
                "./assets/images/rankingtile.svg",
                height: ScreenSize.height * 0.13,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class GameRobotDisplayIcon extends StatelessWidget {
  final String teamNum;
  final String? teamName;
  final MatchSchedule schedule;
  final int matchNum;

  const GameRobotDisplayIcon(
      {Key? key,
      required this.teamNum,
      this.teamName,
      required this.schedule,
      required this.matchNum})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: ScreenSize.height * 0.02),
      child: Container(
        width: ScreenSize.width * 0.6,
        height: ScreenSize.height * 0.13,
        decoration: BoxDecoration(
          color: colors.primaryColorDark,
          border: Border.all(
                    color: schedule.schedule[matchNum - 1].teams.indexWhere((element) => element.number.toString() == teamNum) != -1 ? schedule.schedule[matchNum - 1].teams[schedule.schedule[matchNum - 1].teams.indexWhere((element) => element.number.toString() == teamNum)].station.contains("Blue") ? Color.fromARGB(255, 86, 203, 249) : Color.fromARGB(255, 255, 114, 159) : Colors.black,
                    width: 3,
                  ),
          borderRadius: BorderRadius.all(Radius.circular(15 * ScreenSize.swu)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: ScreenSize.height * 0.01, left: ScreenSize.width * 0),
              child: SizedBox(
                height: ScreenSize.height * 0.10,
                width: ScreenSize.width * 0.3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      teamNum,
                      style: TextStyle(
                        fontFamily: "Mohave",
                        fontSize: ScreenSize.height * 0.06,
                        height: 1,
                        color: colors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      teamName != null
                          ? teamName!.toUpperCase()
                          : "SUSSY SQUAD",
                      style: TextStyle(
                        fontFamily: "Mohave",
                        fontSize: ScreenSize.height * 0.02,
                        height: 1,
                        color: colors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: ScreenSize.width * (0.1)),
              child: SvgPicture.asset(
                "./assets/images/rankingtile.svg",
                height: ScreenSize.height * 0.13,
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: ScreenSize.height * 0.05,
              width: ScreenSize.width * 0.1,
              //daniel we don't speak of this line ok >:)
              child: Text(schedule.schedule[matchNum - 1].teams.indexWhere((element) => element.number.toString() == teamNum) != -1 ? "${schedule.schedule[matchNum - 1].teams[schedule.schedule[matchNum - 1].teams.indexWhere((element) => element.number.toString() == teamNum)].station.contains("Blue") ? "B" + schedule.schedule[matchNum - 1].teams[schedule.schedule[matchNum - 1].teams.indexWhere((element) => element.number.toString() == teamNum)].station.substring(schedule.schedule[matchNum - 1].teams[schedule.schedule[matchNum - 1].teams.indexWhere((element) => element.number.toString() == teamNum)].station.length - 1) : "R" + schedule.schedule[matchNum - 1].teams[schedule.schedule[matchNum - 1].teams.indexWhere((element) => element.number.toString() == teamNum)].station.substring(schedule.schedule[matchNum - 1].teams[schedule.schedule[matchNum - 1].teams.indexWhere((element) => element.number.toString() == teamNum)].station.length-1)}" : "idek what to put here",
                  style: TextStyles.getTitleText(30, Colors.black)),
            )
          ],
        ),
      ),
    );
  }
}
