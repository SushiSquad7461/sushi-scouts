import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sushi_scouts/src/logic/enums/Pages.dart';
import 'package:sushi_scouts/src/views/util/Cardinal/CardinalFooter.dart';

import '../util/Header/HeaderTitle.dart';
import '../util/components/Dropdown.dart';
import '../util/footer.dart';
import '../util/header/HeaderNav.dart';
import 'package:sushi_scouts/src/logic/data/cardinalData.dart';
import 'package:sushi_scouts/src/views/util/components/NumberInput.dart';

class Cardinal extends StatefulWidget {
  CardinalData? data;
  CardinalData? previousData;
  final Map<MatchStage, int> screenOrder = {
    MatchStage.pregame: 0,
    MatchStage.auto: 1,
    MatchStage.teleop: 2,
    MatchStage.endgame: 3,
  };
  final List<MatchStage> stages = [
    MatchStage.pregame,
    MatchStage.auto,
    MatchStage.teleop,
    MatchStage.endgame,
  ];
  final Map allComponents = {"number input": NumberInput.create, "dropdown": Dropdown.create};
  final Function(dynamic, {CardinalData? previousData, Pages? previousPage}) changePage;
  Cardinal({Key? key, required this.changePage, this.previousData}) : super(key: key);
  @override
  CardinalState createState() => CardinalState(MatchStage.pregame);
}

class CardinalState extends State<Cardinal> {
  List<String>? names;
  List<String>? components;
  List<List<String>?>? values;
  int index = 0;
  MatchStage stage;

  bool _nextPageExists() {
    if (widget.screenOrder[stage]! + 1 > 4) {
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
    if (nextNumber > 4) {
      return false;
    }
    if (nextNumber == 4) {
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

  Widget _buildComponents(double height, double width, Color color, int start, int end) {
    return SizedBox(
      width: (width),
      height: (height * 0.4+72000.0/width),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (index = start; index < end; index++)
            widget.allComponents.containsKey(components![index])
              ? widget.allComponents[components![index]](
                  names![index],
                  widget.data!.getData(stage, names![index]),
                  values![index], Data("number", num: 0), color, width)
              : SizedBox(
                width: width,
                child: Text(
                  "The widget type ${components![index]} is not defined",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Sushi",
                    fontSize: width/40.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    overflow:
                      TextOverflow.visible)),
                )
        ],
      ),
    );
  }

  Widget _buildBody(Size size, Color color){
    return size.width>=600 ? Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildComponents(size.height, size.width/2.0, color, 0, (components!.length / 2.0 + 0.5).floor()),
        _buildComponents(size.height, size.width/2.0, color, index, components!.length),
      ]
    ): Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildComponents(size.height, size.width, color, 0, (components!.length)),
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size mediaQuerySize = MediaQuery.of(context).size;
    print(mediaQuerySize.height);
    print(mediaQuerySize.width);
    return Scaffold(
      body: 
      FutureBuilder(
        future: _setData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return snapshot.hasData
            ? 
            ListView(
              children: [
                HeaderTitle(size: mediaQuerySize),
                HeaderNav(
                  currentPage: Pages.cardinal,
                  changePage: widget.changePage,
                  size: mediaQuerySize
                ),
                _buildBody(mediaQuerySize, Colors.black),
                CardinalFooter(
                  stage: stage,
                  nextPage: (_nextPageExists() ? _nextPage : null),
                  previousPage: (_previousPageExists() ? _previousPage : null),
                  size: mediaQuerySize,
                  changePage: widget.changePage,
                  data: widget.data!
                ),
              ],
            )
          : const CircularProgressIndicator();
      }),
    );
  }
}
