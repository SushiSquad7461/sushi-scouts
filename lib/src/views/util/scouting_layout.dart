// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:google_fonts/google_fonts.dart";

// Project imports:
import "../../logic/constants.dart";
import "../../logic/data/config_file_reader.dart";
import "../../logic/data/data.dart";
import "../../logic/device_type.dart";
import "../../logic/models/scouting_data_models/component.dart";
import "../../logic/models/scouting_data_models/page.dart";
import "../../logic/models/scouting_data_models/scouting_data.dart";
import "../../logic/models/scouting_data_models/section.dart";

class ScoutingLayout extends StatelessWidget {
  final ScoutingData currentScoutingData;
  final Screen? currentPage;
  final Size size;
  final Function(bool) error;
  ScoutingLayout(
      {Key? key,
      required this.currentScoutingData,
      required this.error,
      required this.size})
      : currentPage = currentScoutingData.getCurrentPage(),
        super(key: key) {
    if (currentPage == null) {
      throw ErrorDescription("No pages found");
    }
  }

  Widget _buildSection(double width, Section section, int currColumn,
      double height, BuildContext context) {
    try {
      double scaledWidth = (width > 500 ? 500 : width);
      var reader = ConfigFileReader.instance;
      List<Widget> builtComponents = [];

      int startComponent = 0;
      for (var i = 0; i < currColumn; ++i) {
        startComponent += section.componentsPerColumn[i];
      }

      for (var i = startComponent;
          i < startComponent + section.componentsPerColumn[currColumn];
          ++i) {
        Component currComponent = section.components[i];
        List<String>? valueNames = currComponent.values;
        List<String>? values;
        if (valueNames != null && currComponent.isCommonValue) {
          values = [];
          for (String val in valueNames) {
            values.add((reader.getCommonValue(val) ?? 0).toString());
          }
        } else {
          values = valueNames;
        }
        Data currData = section.values[i];

        if (!componentMap.containsKey(currComponent.component)) {
          throw ErrorDescription(
              "No component exsits called: ${currComponent.component}");
        }

        var colors = Theme.of(context);

        builtComponents.add(componentMap.containsKey(currComponent.component)
            ? Padding(
                padding: EdgeInsets.only(
                    top: size.height *
                        (i != startComponent
                            ? 0.15 /
                                currentPage!.getComponentsPerRow(currColumn)
                            : 0)),
                child: componentMap[currComponent.component](
                    Key("${currentScoutingData.name}${currComponent.name}"),
                    currComponent.name,
                    currData,
                    values,
                    currData,
                    section.getColor(
                        colors.scaffoldBackgroundColor == Colors.black),
                    scaledWidth,
                    section.getTextColor(
                        colors.scaffoldBackgroundColor == Colors.black),
                    currComponent.setCommonValue,
                    height /
                        (section.componentsPerColumn[currColumn] -
                            startComponent)),
              )
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
            mainAxisAlignment: isPhone(context)
                ? MainAxisAlignment.spaceEvenly
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: builtComponents),
      );
    } catch (e) {
      rethrow;
    }
  }

  //builds the body of the screen
  @override
  Widget build(BuildContext context) {
    try {
      List<Widget> builtSections = [];

      double height = isPhone(context) ? 0.58 : 0.61;

      for (var i in currentPage!.sections) {
        height -= i.title != "" ? 0.035 : 0;
      }

      for (var i in currentPage!.sections) {
        int rows = i.columns;
        if (i.title != "") {
          builtSections.add(Align(
            alignment: const Alignment(-0.8, 0),
            child: SizedBox(
              height: size.height * 0.035,
              child: Text(
                i.title,
                style: GoogleFonts.mohave(
                    color: i.getTextColor(
                        Theme.of(context).scaffoldBackgroundColor ==
                            Colors.black),
                    fontSize: isPhone(context)
                        ? size.height * 0.035
                        : size.width / 15,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ));
        }
        builtSections.add(Padding(
          padding: EdgeInsets.only(bottom: size.height * 0.01),
          child: SizedBox(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int j = 0; j < rows; j++)
                    Padding(
                        padding: EdgeInsets.only(bottom: size.height * 0.01),
                        child: _buildSection(
                            size.width / rows,
                            i,
                            j,
                            size.height *
                                ((height -
                                        currentPage!.sections.length * 0.01) /
                                    currentPage!.sections.length),
                            context)),
                ]),
          ),
        ));
      }
      return Column(children: builtSections);
    } catch (e) {
      error(true);
      return const Center(child: Text("Error in Config File "));
    }
  }
}
