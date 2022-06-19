import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sushi_scouts/src/logic/enums/Pages.dart';

import '../util/Header/HeaderTitle.dart';
import '../util/footer.dart';
import '../util/header/HeaderNav.dart';
import 'package:sushi_scouts/src/logic/data/cardinalData.dart';
import 'package:sushi_scouts/src/views/util/components/NumberInput.dart';

class Cardinal extends StatefulWidget {
  CardinalData? data;
  final Map<MatchStage, int> screenOrder = {
    MatchStage.pregame: 0,
    MatchStage.auto: 1,
    MatchStage.teleop: 2,
    MatchStage.endgame: 3,
    MatchStage.submit: 4
  };
  final List<MatchStage> stages = [
    MatchStage.pregame,
    MatchStage.auto,
    MatchStage.teleop,
    MatchStage.endgame,
    MatchStage.submit
  ];
  final Map allComponents = {"number input": NumberInput.create};
  final ValueChanged changePage;
  Cardinal({Key? key, required this.changePage}) : super(key: key);
  @override
  CardinalState createState() => CardinalState(MatchStage.pregame);
}

class CardinalState extends State<Cardinal> {
  List<String>? names;
  List<String>? components;
  List<List<dynamic>?>? values;
  int index = 0;
  MatchStage stage;

  bool nextPageExists() {
    if (widget.screenOrder[stage]! + 1 > 5) {
      return false;
    }
    return true;
  }

  bool previousPageExists() {
    if (widget.screenOrder[stage]! - 1 < 0) {
      return false;
    }
    return true;
  }

  bool nextPage(MatchStage stage) {
    int nextNumber = widget.screenOrder[stage]! + 1;
    if (nextNumber > 5) {
      return false;
    }
    if (nextNumber == 5) {
      setState(() {
        widget.data = null;
        this.stage = MatchStage.pregame;
      });
    } else {
      setState(() {
        this.stage = widget.stages[nextNumber];
      });
    }
    build(context);
    return true;
  }

  bool previousPage(MatchStage stage) {
    int previousNumber = widget.screenOrder[stage]! - 1;
    if (previousNumber < 0) {
      return false;
    }
    setState(() {
      this.stage = widget.stages[previousNumber];
    });
    build(context);
    return true;
  }

  CardinalState(this.stage) : super();

  Future<bool> setData() async {
    widget.data ??= await CardinalData.firstCreate();
    components = widget.data!.getComponents(stage);
    names = widget.data!.getNames(stage);
    values = widget.data!.getValues(stage);
    return true;
  }

  void onSubmit(String name, Data value) {
    widget.data!.set(name, value, stage);
    print(widget.data!.get("match #", stage));
  }

  @override
  Widget build(BuildContext context) {
    String stringifiedData = "";
    if (widget.data != null) {
      stringifiedData = widget.data!.stringfy();
    }
    print(stringifiedData);
    final Size mediaQuerySize = MediaQuery.of(context).size;
    return Scaffold(
        body: ListView(
      children: [
        const HeaderTitle(),
        HeaderNav(
          currentPage: Pages.cardinal,
          changePage: widget.changePage,
        ),
        !(stage == MatchStage.submit)
            ? FutureBuilder(
                future: setData(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return snapshot.hasData
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: (mediaQuerySize.width * 0.5),
                              height: (mediaQuerySize.height * 0.6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  for (index = 0;
                                      index <
                                          (components!.length / 2.0 + 0.5)
                                              .floor();
                                      index++)
                                    widget.allComponents
                                            .containsKey(components![index])
                                        ? widget.allComponents[
                                                components![index]](
                                            names![index],
                                            onSubmit,
                                            values![index])
                                        : SizedBox(
                                            width: 50,
                                            child: Text(
                                                "The widget type ${components![index]} is not defined",
                                                style: const TextStyle(
                                                    fontFamily: "Sushi",
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                    overflow:
                                                        TextOverflow.ellipsis)),
                                          )
                                ],
                              ),
                            ),
                            SizedBox(
                                width: (mediaQuerySize.width * 0.5),
                                height: (mediaQuerySize.height * 0.6),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    for (index = index;
                                        index < components!.length;
                                        index++)
                                      widget.allComponents
                                              .containsKey(components![index])
                                          ? widget.allComponents[
                                                  components![index]](
                                              names![index],
                                              onSubmit,
                                              values![index])
                                          : SizedBox(
                                              width: 50,
                                              child: Text(
                                                "The widget type ${components![index]} is not defined",
                                                style: const TextStyle(
                                                    fontFamily: "Sushi",
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                            )
                                  ],
                                )),
                          ],
                        )
                      : const CircularProgressIndicator();
                })
            : Padding(
                padding: EdgeInsets.all(20),
                child: QrImage(data: stringifiedData),
              ),
        Footer(
          stage: stage,
          nextPage: (nextPageExists() ? nextPage : null),
          previousPage: (previousPageExists() ? previousPage : null),
        ),
      ],
    ));
  }
}
