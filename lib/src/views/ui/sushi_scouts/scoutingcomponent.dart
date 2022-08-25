import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sushi_scouts/src/logic/blocs/scouting_method_bloc/scouting_method_cubit.dart';
import 'package:sushi_scouts/src/logic/constants.dart';
import 'package:sushi_scouts/src/logic/helpers/size/ScreenSize.dart';
import 'package:sushi_scouts/src/logic/models/scouting_data_models/component.dart';
import 'package:sushi_scouts/src/logic/models/scouting_data_models/page.dart';
import 'package:sushi_scouts/src/logic/models/scouting_data_models/scouting_data.dart';
import 'package:sushi_scouts/src/logic/models/scouting_data_models/section.dart';
import 'package:sushi_scouts/src/views/util/footer/scouting_footer.dart';
import 'package:sushi_scouts/src/views/util/header/header_nav.dart';
import 'package:sushi_scouts/src/views/util/header/header_title/header_title.dart';

import '../../../logic/data/Data.dart';
import '../../../logic/data/config_file_reader.dart';
import '../../../logic/deviceType.dart';

class ScoutingComponent extends StatefulWidget {
  final ScoutingData scoutingData;
  final Function? submitCallback;
  const ScoutingComponent(
      {Key? key, required this.scoutingData, this.submitCallback})
      : super(key: key);
  @override
  ScoutingComponentState createState() => ScoutingComponentState();
}

class ScoutingComponentState extends State<ScoutingComponent> {
  bool error = false;

  //builds the components in a certain section
  Widget _buildSection(double width, Section section, int currColumn) {
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

        if (!COMPONENT_MAP.containsKey(currComponent.component)) {
          throw ErrorDescription(
              "No component exsits called: ${currComponent.component}");
        }

        var colors = Theme.of(context);

        print(currComponent.component);
        print(currData.get());

        builtComponents.add(COMPONENT_MAP.containsKey(currComponent.component)
            ? Padding(
                padding: EdgeInsets.only(
                    top: ScreenSize.height *
                        (i != startComponent
                            ? 0.15 /
                                widget.scoutingData
                                    .getCurrentPage()!
                                    .getComponentsPerRow(currColumn)
                            : 0)),
                child: COMPONENT_MAP[currComponent.component](
                    Key("${widget.scoutingData.name}${currComponent.name}"),
                    currComponent.name,
                    currData,
                    values,
                    currData,
                    section.getColor(
                        colors.scaffoldBackgroundColor == Colors.black),
                    scaledWidth,
                    section.getTextColor(
                        colors.scaffoldBackgroundColor == Colors.black),
                    currComponent.setCommonValue))
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
    } catch (e) {
      rethrow;
    }
  }

  //builds the body of the screen
  Widget _buildBody(Size size) {
    try {
      List<Widget> builtSections = [];
      for (var i in widget.scoutingData.getCurrentPage()!.sections) {
        // idk why da hell this was here but its gone now.  check with sidarth before perment deletaion
        // int rows = size.width / i.columns < 300
        //     ? (size.width / 300).floor()
        //     : i.columns;
        int rows = i.columns;
        if (i.title != "") {
          builtSections.add(Align(
            alignment: const Alignment(-0.8, 0),
            child: Text(
              i.title,
              style: GoogleFonts.mohave(
                  color: i.getTextColor(
                      Theme.of(context).scaffoldBackgroundColor ==
                          Colors.black),
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
    } catch (e) {
      print(e);
      error = true;
      return const Center(child: Text("Error in Config File "));
    }
  }

  void submitCallback() {
    widget.submitCallback!(widget.scoutingData);
  }

  @override
  Widget build(BuildContext context) {
    var isPhoneScreen = isPhone(context);
    print("SCOUTING COMPONENT DATA");
    print(widget.scoutingData.stringfy());
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
              top: ScreenSize.height * (isPhoneScreen ? 0 : 0.02)),
          child: SizedBox(
            width: ScreenSize.width,
            height: ScreenSize.height * 0.61,
            child: _buildBody(ScreenSize.get()),
          ),
        ),
        if (!error)
          ScoutingFooter(
            method: widget.scoutingData.name,
            popupContext: context,
            submitCallback:
                widget.submitCallback == null ? null : submitCallback,
          )
      ],
    );
  }
}
