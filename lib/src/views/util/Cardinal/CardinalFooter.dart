import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sushi_scouts/src/logic/enums/Pages.dart';

import '../../../logic/data/cardinalData.dart';
import '../footer.dart';
import 'package:sushi_scouts/src/views/ui/QRScreen.dart';

class CardinalFooter extends StatelessWidget {
  final bool Function(MatchStage)? nextPage;
  final bool Function(MatchStage)? previousPage;
  final MatchStage? stage;
  final Size size;
  final Function(dynamic, {CardinalData? previousData, Pages? previousPage}) changePage;
  final CardinalData data;
  static const Map<MatchStage, String> pageNames = {
    MatchStage.pregame: "Info",
    MatchStage.auto: "Auto",
    MatchStage.teleop: "Teleop",
    MatchStage.endgame: "Endgame",
  };

  void nextPagePressed() {
    if (!(nextPage == null)) {
      nextPage!(stage!);
    }
  }

  void previousPagePressed() {
    if (!(previousPage == null)) {
      previousPage!(stage!);
    }
  }

  const CardinalFooter({Key? key, this.stage, this.nextPage, this.previousPage, required this.size, required this.changePage, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double swu = size.width/600.0; //standardized width unit
    double shu = size.width/900.0; //standard height unit
    return Padding(
        padding: const EdgeInsets.all(0),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  IconButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: previousPagePressed,
                    iconSize: size.width/6.0,
                    icon: Icon(
                      Icons.arrow_left_rounded,
                      color: (previousPage == null
                          ? Color(0xfafafa)
                          : Colors.black),
                      semanticLabel: 'Back Arrow',
                    ),
                  ),
                  !(stage == MatchStage.endgame)
                      ? (Row(
                          children: [
                            SizedBox(
                              width: size.width/10.0, //57
                              height: size.width/10.0, //59
                              child: SvgPicture.asset(
                                "./assets/images/nori.svg",
                              )
                            ),
                            IconButton(
                              padding: const EdgeInsets.all(0),
                              onPressed: nextPagePressed,
                              iconSize: size.width/6.0,
                              icon: Icon(Icons.arrow_right_rounded,
                                  color: (nextPage == null
                                      ? Color(0xfafafa)
                                      : Colors.black),
                                  semanticLabel: 'Forward Arrow'),
                            )
                          ],
                        ))
                      : (Container(
                          width: 130*swu,
                          height: 60*swu,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 4),
                            color: const Color(0xfafafa),
                            borderRadius: BorderRadius.circular(20*swu),
                          ),
                          child: TextButton(
                            onPressed: () => changePage(Pages.qrcode, previousData: data, previousPage: Pages.cardinal),
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                  fontSize: 20*swu,
                                  fontFamily: "Sushi",
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          )))
                ]),
            Footer(pageTitle: pageNames[stage!]!, size: size)
        ]));
  }
}
