import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sushi_scouts/SushiScoutingLib/logic/data/config_file_reader.dart';
import 'package:sushi_scouts/SushiScoutingLib/logic/helpers/size/ScreenSize.dart';
import 'package:sushi_scouts/SushiScoutingLib/logic/models/scouting_data_models/component.dart';
import 'package:sushi_scouts/SushiScoutingLib/logic/models/scouting_data_models/page.dart';
import 'package:sushi_scouts/SushiScoutingLib/logic/models/scouting_data_models/scouting_data.dart';
import 'package:sushi_scouts/SushiScoutingLib/logic/models/scouting_data_models/section.dart';
import 'package:sushi_scouts/src/logic/constants.dart';
import 'package:sushi_scouts/src/views/util/Footer/scouting_footer.dart';

import '../../../SushiScoutingLib/logic/data/data.dart';

class Scouting extends StatefulWidget {
  late final ScoutingData? data;
  Scouting(String method, {Key? key})
    : super(key: key) {
    var reader = ConfigFileReader.instance;
    data = reader.getScoutingData(method);
  }
  @override
  ScoutingState createState() => ScoutingState();
}

class ScoutingState extends State<Scouting> {
  Screen? currPage;

  void _init() {
    currPage = widget.data?.getCurrentPage();

    if (currPage == null) {
      throw ErrorDescription("No pages found");
    }
  }

  //builds the components in a certain section
  Widget _buildSection(
      double width, Section section, int currRow) {
    double scaledWidth = (width > 500 ? 500 : width);

    List<Widget> builtComponents = [];

    int startComponent = 0;
    for (var i = 0; i < currRow; ++i) {
      startComponent += section.componentsPerRow[i];
    }

    for (var i = startComponent;
        i < startComponent + section.componentsPerRow[currRow];
        ++i) {
      Component currComponent = section.components[i];
      Data currData = section.values[i];

      if (!COMPONENT_MAP.containsKey(currComponent.component)) {
        throw ErrorDescription(
            "No component exsits called: ${currComponent.component}");
      }
      
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
                  section
                      .getColor(colors.scaffoldBackgroundColor == Colors.black),
                  scaledWidth,
                  section.getTextColor(
                      colors.scaffoldBackgroundColor == Colors.black)))
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
      //widget.changeScreen('qrscreen');
    }
  }

  @override
  Widget build(BuildContext context) {
    _init();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        width:ScreenSize.width,
        height: ScreenSize.height,
        child: Column(
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
        ),
      ),
    );
  }
}
