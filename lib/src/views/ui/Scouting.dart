import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sushi_scouts/src/logic/Constants.dart';
import 'package:sushi_scouts/src/logic/data/ScoutingData.dart';
import 'package:sushi_scouts/src/logic/size/ScreenSize.dart';
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
  final ScoutingData? data;
  const Scouting({Key? key, required this.data}) : super(key: key);
  @override
  ScoutingState createState() => ScoutingState();
}

class ScoutingState extends State<Scouting> {
  List<Section>? sections;
  Map<int, Component>? components; 
  Map<int, Data>? data;
  double teamNumber = 7461;
  String stage = "uninitialized";

  //switches to the next match stage
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

  //switches to the previous match stage
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

  //constructor which takes the match stage
  ScoutingState({this.stage = "uninitialized"}) : super();

  //initially creates the data object from the json file
  void _init() {
    widget.stages = widget.data.getStages();
    if(stage=="uninitialized") {
      stage = widget.stages[0];
    }
    sections = widget.data.sections[stage];
    data = widget.data.data;
    components = widget.data.components;
  }

  //builds the components in a certain section
  Widget _buildComponents(double width, Color color, int start, int end, int rows, Color textColor) {
    double scaledWidth = (width>400 ? 400 : width);
    List<Widget> builtComponents = [];
    for (int index = start; index < end; index++) {
      Data defaultValue;
      if(data![index]!.setByUser){
        if(components![index!]!.type == "number")
          defaultValue = Data<double>(double.parse(data![index]!.get()));
        else
          defaultValue = Data<String>(data![index]!.get());
      } else {
        if(components![index]!.name=="match #")
          defaultValue = widget.previousData==null ? Data<double>(1) : Data<double>(double.parse(widget.previousData!.data[index]!.get())+1);
        else if(components![index]!.name=="team #")
          defaultValue = Data<double>(teamNumber);
        else if(components![index!]!.type == "number")
          defaultValue = Data<double>(0);
        else
          defaultValue = Data<String>("");
      }
      builtComponents.add( 
        COMPONENT_MAP.containsKey(components![index]!.component)
          ? COMPONENT_MAP[components![index]!.component](
              components![index]!.name,
              data![index]!,
              components![index]!.values, 
              defaultValue, color, scaledWidth, textColor)
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
      );
    }
    return SizedBox(
      width: scaledWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: builtComponents
      ),
    );
  }

  //builds the body of the screen
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
          _buildComponents(size.width/rows, color, (start + i*length/rows).ceil(), (start + (i+1)*length/rows).ceil(), rows, textColor),
        ]
      ));
    }
    return Column(
      children: builtSections
    );
  }

  @override
  Widget build(BuildContext context) {
    _init();    
    return Scaffold(
      //if widget data is not set yet, then we use future builder to read the json file
      body: ListView(
        children: [
          SizedBox(
            width: ScreenSize.width,
            height: ScreenSize.height*0.4+135000/ScreenSize.width,
            child: _buildBody(ScreenSize.get()),
          ),                
          // ScoutingFooter(
          //   stage: stage,
          //   nextPage: (_nextPageExists() ? _nextPage : null),
          //   previousPage: (_previousPageExists() ? _previousPage : null),
          //   size: ScreenSize.get(),
          //   changePage: widget.changePage,
          //   data: widget.data,
          //   screen: widget.screen,
          //   stages: widget.stages
          // ),
        ],
      )
    );
  }
}
