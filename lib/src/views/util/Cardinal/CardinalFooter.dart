import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../logic/data/cardinalData.dart';
import '../footer.dart';

class CardinalFooter extends StatelessWidget {
  final bool Function(MatchStage)? nextPage;
  final bool Function(MatchStage)? previousPage;
  final MatchStage? stage;
  static const Map<MatchStage, String> pageNames = {
    MatchStage.pregame: "Info",
    MatchStage.auto: "Auto",
    MatchStage.teleop: "Teleop",
    MatchStage.endgame: "Endgame",
    MatchStage.submit: "Submit"
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

  const CardinalFooter({Key? key, this.stage, this.nextPage, this.previousPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(0),
        child: Column(children: [
          !(stage == MatchStage.submit)
              ? (Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  IconButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: previousPagePressed,
                    iconSize: 100,
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
                            ConstrainedBox(
                                constraints: const BoxConstraints(
                                  minWidth: 57,
                                  minHeight: 57,
                                  maxWidth: 59,
                                  maxHeight: 59,
                                ),
                                child: SvgPicture.asset(
                                  "./assets/images/nori.svg",
                                )),
                            IconButton(
                              padding: const EdgeInsets.all(0),
                              onPressed: nextPagePressed,
                              iconSize: 100,
                              icon: Icon(Icons.arrow_right_rounded,
                                  color: (nextPage == null
                                      ? Color(0xfafafa)
                                      : Colors.black),
                                  size: 100.0,
                                  semanticLabel: 'Forward Arrow'),
                            )
                          ],
                        ))
                      : (Container(
                          width: 130,
                          height: 60,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 4),
                            color: const Color(0xfafafa),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextButton(
                            onPressed: nextPagePressed,
                            child: const Text(
                              'Submit',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "Sushi",
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          )))
                ]))
              : Padding(
                  padding: EdgeInsets.all(20),
                  child: Container(
                      width: 200,
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 4),
                        color: const Color(0xfafafa),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextButton(
                        onPressed: nextPagePressed,
                        child: const Text(
                          'Next Match',
                          style: TextStyle(
                              fontSize: 25,
                              fontFamily: "Sushi",
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                ),
          Footer(pageTitle: pageNames[stage!]!)
        ]));
  }
}
