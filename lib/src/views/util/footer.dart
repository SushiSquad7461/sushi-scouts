import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sushi_scouts/src/logic/data/cardinalData.dart';

class Footer extends StatelessWidget {
  final String pageTitle;
  final bool Function(MatchStage)? nextPage;
  final bool Function(MatchStage)? previousPage;
  final MatchStage? stage;
  static const Map<MatchStage, String> pageNames = {
    MatchStage.pregame: "Info",
    MatchStage.auto: "Auto",
    MatchStage.teleop: "Teleop",
    MatchStage.endgame: "Endgame"
  };

  String getPageTitle() {
    if(stage==null){
      return pageTitle;
    }
    return pageNames[stage]!;
  }

  void nextPagePressed() {
    if(!(nextPage==null)){
      nextPage!(stage!);
    }
  }

  void previousPagePressed() {
    if(!(previousPage==null)){
      previousPage!(stage!);
    }
  }

  const Footer({Key? key, this.pageTitle="", this.stage,  this.nextPage,  this.previousPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        children: [
            Row (
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: previousPagePressed, 
                  iconSize: 100,
                  icon:Icon(
                    Icons.arrow_left_rounded,
                    color: (previousPage==null ? Color(0xfafafa) : Colors.black),
                    semanticLabel: 'Back Arrow',
                  ),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 57,
                    minHeight: 57,
                    maxWidth: 59,
                    maxHeight: 59,
                  ),
                  child: SvgPicture.asset("./assets/images/nori.svg",)
                ),
                IconButton(
                  padding: const EdgeInsets.all(0),
                  onPressed: nextPagePressed,
                  iconSize: 100,
                  icon: Icon(
                    Icons.arrow_right_rounded,
                    color: (nextPage==null ? Color(0xfafafa) : Colors.black),
                    size: 100.0,
                    semanticLabel: 'Forward Arrow',
                  ),
                )
              ]
            ),
          Image.asset("./assets/images/colorbar.png", scale: 6,),
          Padding(
            padding: const EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 0) ,
            child: Text(
              getPageTitle(),
              style: const TextStyle(
                fontFamily: "Sushi",
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            )
          )
        ],
      )
    );
  }
}