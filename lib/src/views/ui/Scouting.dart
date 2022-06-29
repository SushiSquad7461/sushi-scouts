import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sushi_scouts/src/logic/data/ScoutingData.dart';
import 'package:sushi_scouts/src/views/util/Scouting/ScoutingFooter.dart';
import 'package:sushi_scouts/src/views/util/components/Checkbox.dart';
import 'package:sushi_scouts/src/views/util/components/Increment.dart';

import '../../logic/data/Data.dart';
import '../util/Header/HeaderTitle.dart';
import '../util/components/Dropdown.dart';
import '../util/footer.dart';
import '../util/header/HeaderNav.dart';
import 'package:sushi_scouts/src/views/util/components/NumberInput.dart';

class Scouting extends StatefulWidget {
  ScoutingData? data;
  ScoutingData? previousData;
  List<String>? stages;
  String screen;
  List<String> screens;
  final Map allComponents = {"number input": NumberInput.create, "dropdown": Dropdown.create, "checkbox": CheckboxInput.create, "increment": Increment.create};
  final Function(String newPage, String previousPage, {ScoutingData? previousData}) changePage;
  Scouting({Key? key, required this.screen, required this.changePage, this.previousData, required this.screens}) : super(key: key);
  @override
  ScoutingState createState() => ScoutingState();
}

class ScoutingState extends State<Scouting> {
  List<Section>? sections;
  Map<int, Component>? components; 
  Map<int, Data>? data;
  String stage = "uninitialized";

  bool _nextPageExists() {
    if (widget.stages!.indexOf(stage) + 1 >= widget.stages!.length) {
      return false;
    }
    return true;
  }

  bool _previousPageExists() {
    if (widget.stages!.indexOf(stage) - 1 < 0) {
      return false;
    }
    return true;
  }

  bool _nextPage(String stage) {
    int nextNumber = widget.stages!.indexOf(stage) + 1;
    if (nextNumber > 4) {
      return false;
    } else {
      setState(() {
        this.stage = widget.stages![nextNumber];
        print(this.stage);
      });
    }
    build(context);
    return true;
  }

  bool _previousPage(String stage) {
    int previousNumber = widget.stages!.indexOf(stage) - 1;
    if (previousNumber < 0) {
      return false;
    }
    setState(() {
      this.stage = widget.stages![previousNumber];
    });
    build(context);
    return true;
  }

  ScoutingState({this.stage = "uninitialized"}) : super();

  Future<bool> _setData() async {
    widget.data ??= await ScoutingData.create(widget.screen);
    widget.stages = widget.data!.getStages();
    if(stage=="uninitialized") {
      stage = widget.stages![0];
    }
    sections = widget.data!.sections[stage];
    data = widget.data!.data;
    components = widget.data!.components;
    return true;
  }

  Widget _buildComponents(double width, Color color, int start, int end, int rows, Color textColor) {
    double scaledWidth = (width>400 ? 400 : width);
    return SizedBox(
      width: scaledWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (int index = start; index < end; index++)
            widget.allComponents.containsKey(components![index]!.component)
              ? widget.allComponents[components![index]!.component](
                  components![index]!.name,
                  data![index]!,
                  components![index]!.values, 
                  Data("number", num: 0), color, scaledWidth, textColor)
              : SizedBox(
                width: scaledWidth,
                child: Text(
                  "The widget type ${components![index]!.component} is not defined",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Sushi",
                    fontSize: scaledWidth/40.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    overflow:
                      TextOverflow.visible)),
                )
        ],
      ),
    );
  }

  Widget _buildBody(Size size){
    List<Row> builtSections = [];
    for(Section section in sections!) {
      Color color = Color(section.color);
      Color textColor = Color(section.textColor);
      int rows = size.width/section.rows<300 ? (size.width/300).floor() : section.rows;
      int start = section.startValue;
      int length = section.length;
      builtSections.add(Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for(int i = 0; i<rows; i++)
          _buildComponents(size.width/rows, color, (start + i*length/rows).floor(), (start + (i+1)*length/rows).floor(), rows, textColor),
        ]
      ));
    }
    return Column(
      children: builtSections
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
                  currentPage: widget.screen,
                  changePage: widget.changePage,
                  size: mediaQuerySize,
                  screens: widget.screens
                ),
                SizedBox(
                  width: mediaQuerySize.width,
                  height: mediaQuerySize.height*0.4+135000/mediaQuerySize.width,
                  child: _buildBody(mediaQuerySize),
                ),                
                ScoutingFooter(
                  stage: stage,
                  nextPage: (_nextPageExists() ? _nextPage : null),
                  previousPage: (_previousPageExists() ? _previousPage : null),
                  size: mediaQuerySize,
                  changePage: widget.changePage,
                  data: widget.data!,
                  screen: widget.screen,
                  stages: widget.stages!
                ),
              ],
            )
          : const CircularProgressIndicator();
      }),
    );
  }
}
