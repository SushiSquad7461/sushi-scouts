import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sushi_scouts/src/logic/Constants.dart';
import 'package:sushi_scouts/src/views/util/Footer/ScoutingFooter.dart';

import '../../../ScoutingLib/logic/data/Data.dart';
import '../../../ScoutingLib/logic/data/ScoutingData.dart' as ScoutingDataHelpers;
import '../../../ScoutingLib/logic/size/ScreenSize.dart';

class Scouting extends StatefulWidget {
  final ScoutingDataHelpers.ScoutingData? data;
  final Function(String) changeScreen;
  const Scouting({Key? key, required this.data, required this.changeScreen})
      : super(key: key);
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
    double scaledWidth = (width > 500 ? 500 : width);

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

      print("data ${currData.get()}");
      
      var colors = Theme.of(context);

      builtComponents.add(COMPONENT_MAP.containsKey(currComponent.component)
          ? Padding(
              padding: EdgeInsets.only(
                  top: ScreenSize.height *
                      (i != startComponent
                          ? 0.15 / currPage!.getComponentsPerRow(currRow)
                          : 0)),
              child: COMPONENT_MAP[currComponent.component](
                  Key("${widget.data!.name}${currComponent.name}"),
                  currComponent.name,
                  currData,
                  currComponent.values,
                  currData,
                  section.getColor(colors.scaffoldBackgroundColor == Colors.black),
                  scaledWidth,
                  section.getTextColor(colors.scaffoldBackgroundColor == Colors.black)))
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
    List<Widget> builtSections = [];
    print(currPage!.stringfy());

    for (var i in currPage!.sections) {
      int rows =
          size.width / i.rows < 300 ? (size.width / 300).floor() : i.rows;
      if (i.title != "") {
        builtSections.add(Align(
          alignment: Alignment(-0.8, 0),
          child: Text(
            i.title,
            style: GoogleFonts.mohave(
                color: i.textColor,
                fontSize: size.width / 15,
                fontWeight: FontWeight.w400),
          ),
        ));
      }
      builtSections.add(Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int j = 0; j < rows; j++)
              Padding(
                  padding: EdgeInsets.only(bottom: ScreenSize.height * 0.01),
                  child: _buildSection(size.width / rows, i, j)),
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
    } else {
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
          popupContext: context,
          newPage: renderNewPage,
        ),
      ],
    );
  }
}
