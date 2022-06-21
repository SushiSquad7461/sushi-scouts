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

  bool _nextPageExists() {
    if (widget.screenOrder[stage]! + 1 > 5) {
      return false;
    }
    return true;
  }

  bool _previousPageExists() {
    if (widget.screenOrder[stage]! - 1 < 0) {
      return false;
    }
    return true;
  }

  bool _nextPage(MatchStage stage) {
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

  bool _previousPage(MatchStage stage) {
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

  Future<bool> _setData() async {
    widget.data ??= await CardinalData.firstCreate();
    components = widget.data!.getComponents(stage);
    names = widget.data!.getNames(stage);
    values = widget.data!.getValues(stage);
    return true;
  }

  Widget _buildBody(Size mediaQuerySize){
    print(mediaQuerySize.width);
    print(mediaQuerySize.height);
    return Row(
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
                        widget.data!.getData(stage, names![index]),
                        values![index])
                    : SizedBox(
                        width: mediaQuerySize.width/12.0,
                        child: Text(
                            "The widget type ${components![index]} is not defined",
                            style: TextStyle(
                                fontFamily: "Sushi",
                                fontSize: mediaQuerySize.width/40.0,
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
                          widget.data!.getData(stage, names![index]),
                          values![index])
                      : SizedBox(
                          width: mediaQuerySize.width/12.0,
                          child: Text(
                            "The widget type ${components![index]} is not defined",
                            style: TextStyle(
                                fontFamily: "Sushi",
                                fontSize: mediaQuerySize.width/40.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                overflow:
                                    TextOverflow.ellipsis),
                          ),
                        )
              ],
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
                future: _setData(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return snapshot.hasData
                      ? _buildBody(mediaQuerySize)
                      : const CircularProgressIndicator();
                })
            : Padding(
                padding: EdgeInsets.all(mediaQuerySize.width/40.0),
                child: QrImage(data: widget.data!.stringfy()),
              ),
        Footer(
          stage: stage,
          nextPage: (_nextPageExists() ? _nextPage : null),
          previousPage: (_previousPageExists() ? _previousPage : null),
        ),
      ],
    ));
  }
}
