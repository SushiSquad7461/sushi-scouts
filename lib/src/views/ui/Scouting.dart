import 'package:flutter/material.dart';
import 'package:sushi_scouts/src/logic/Constants.dart';
import 'package:sushi_scouts/src/logic/data/ScoutingData.dart'
    as ScoutingDataHelpers;
import 'package:sushi_scouts/src/logic/size/ScreenSize.dart';
import 'package:sushi_scouts/src/views/util/Footer/ScoutingFooter.dart';

import '../../logic/data/Data.dart';

class Scouting extends StatefulWidget {
  final ScoutingDataHelpers.ScoutingData? data;
  final Function(String) changeScreen;
  const Scouting({Key? key, required this.data, required this.changeScreen}) : super(key: key);
  @override
  ScoutingState createState() => ScoutingState();
}

class ScoutingState extends State<Scouting> {
  ScoutingDataHelpers.Page? currPage;

  void _init() {
    currPage = widget.data?.getCurrentPage();

    if (currPage == null) {
      throw ErrorDescription("No pages found");
    }
  }

  //builds the components in a certain section
  Widget _buildSection(
      double width, ScoutingDataHelpers.Section section, int currRow) {
    double scaledWidth = (width > 400 ? 400 : width);

    List<Widget> builtComponents = [];

    int startComponent = 0;
    for (var i = 0; i < currRow; ++i) {
      startComponent += section.componentsPerRow[i];
    }

    for (var i = startComponent;
        i < startComponent + section.componentsPerRow[currRow];
        ++i) {
      ScoutingDataHelpers.Component currComponent = section.components[i];
      Data currData = section.values[i];

      if (!COMPONENT_MAP.containsKey(currComponent.component)) {
        throw ErrorDescription(
            "No component exsits called: ${currComponent.component}");
      }

      builtComponents.add(COMPONENT_MAP.containsKey(currComponent.component)
          ? COMPONENT_MAP[currComponent.component](
              Key("${widget.data!.name}${currComponent.name}"),
              currComponent.name,
              currData,
              currComponent.values,
              currData,
              section.color,
              scaledWidth,
              section.textColor)
          : SizedBox(
              width: scaledWidth,
              child: Text(
                  "The widget type ${currComponent.component} is not defined",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "Sushi",
                      fontSize: scaledWidth / 40.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      overflow: TextOverflow.visible)),
            ));
    }
    return SizedBox(
      width: scaledWidth,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: builtComponents),
    );
  }

  //builds the body of the screen
  Widget _buildBody(Size size) {
    List<Row> builtSections = [];

    for (var i in currPage!.sections) {
      int rows =
          size.width / i.rows < 300 ? (size.width / 300).floor() : i.rows;

      builtSections.add(Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int j = 0; j < rows; j++)
              _buildSection(size.width / rows, i, j),
          ]));
    }
    return Column(children: builtSections);
  }

  void renderNewPage(bool submit) {
    if (!submit) {
      setState(() {
        currPage = widget.data!.getCurrentPage()!;
        build(context);
      });
    }
    else {
      widget.changeScreen('qrscreen');
    }
  }

  @override
  Widget build(BuildContext context) {
    _init();
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: ScreenSize.height * 0.02),
          child: SizedBox(
            width: ScreenSize.width,
            height: ScreenSize.height * 0.61,
            child: _buildBody(ScreenSize.get()),
          ),
        ),
        ScoutingFooter(
          key: Key(widget.data!.name),
          data: widget.data,
          newPage: renderNewPage,
        ),
      ],
    );
  }
}
