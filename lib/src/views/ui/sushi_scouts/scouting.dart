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

class Scouting extends StatefulWidget {
  const Scouting({Key? key}) : super(key: key);
  @override
  ScoutingState createState() => ScoutingState();
}

class ScoutingState extends State<Scouting> {
  Screen? currPage;
  ScoutingData? currentScoutingData;
  bool error = false;

  void _init() {
    currPage = currentScoutingData?.getCurrentPage();

    if (currPage == null) {
      throw ErrorDescription("No pages found");
    }
  }

  //builds the components in a certain section
  Widget _buildSection(
      double width, Section section, int currColumn, double height) {
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

        builtComponents.add(COMPONENT_MAP.containsKey(currComponent.component)
            ? Padding(
                padding: EdgeInsets.only(
                    top: ScreenSize.height *
                        (i != startComponent
                            ? 0.15 / currPage!.getComponentsPerRow(currColumn)
                            : 0)),
                child: COMPONENT_MAP[currComponent.component](
                    Key("${currentScoutingData!.name}${currComponent.name}"),
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
  Widget _buildBody(Size size) {
    try {
      List<Widget> builtSections = [];

      double height = isPhone(context) ? 0.58 : 0.61;

      for (var i in currPage!.sections) {
        height -= i.title != "" ? 0.035 : 0;
      }

      for (var i in currPage!.sections) {
        int rows = i.columns;
        if (i.title != "") {
          builtSections.add(Align(
            alignment: const Alignment(-0.8, 0),
            child: SizedBox(
              height: ScreenSize.height * 0.035,
              child: Text(
                i.title,
                style: GoogleFonts.mohave(
                    color: i.getTextColor(
                        Theme.of(context).scaffoldBackgroundColor ==
                            Colors.black),
                    fontSize: isPhone(context)
                        ? ScreenSize.height * 0.035
                        : size.width / 15,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ));
        }
        builtSections.add(Padding(
          padding: EdgeInsets.only(bottom: ScreenSize.height * 0.01),
          child: SizedBox(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int j = 0; j < rows; j++)
                    Padding(
                        padding:
                            EdgeInsets.only(bottom: ScreenSize.height * 0.01),
                        child: _buildSection(
                            size.width / rows,
                            i,
                            j,
                            ScreenSize.height *
                                ((height - currPage!.sections.length * 0.01) /
                                    currPage!.sections.length))),
                ]),
          ),
        ));
      }
      return Column(children: builtSections);
    } catch (e) {
      print(e);
      error = true;
      return const Center(child: Text("Error in Config File "));
    }
  }

  @override
  Widget build(BuildContext context) {
    var isPhoneScreen = isPhone(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocBuilder<ScoutingMethodCubit, ScoutingMethodStates>(
        builder: (context, state) {
          var reader = ConfigFileReader.instance;
          if (state is ScoutingMethodsUninitialized) {
            BlocProvider.of<ScoutingMethodCubit>(context)
                .changeMethod(reader.getScoutingMethods()[0], 0);
            return Text("Loading");
          }
          currentScoutingData = reader
              .getScoutingData((state as ScoutingMethodsInitialized).method);
          _init();
          return SizedBox(
            width: ScreenSize.width,
            height: ScreenSize.height,
            child: Column(
              children: [
                const HeaderTitle(),
                HeaderNav(currentPage: state.method),
                Padding(
                  padding: EdgeInsets.only(
                      top: ScreenSize.height * (isPhoneScreen ? 0.03 : 0.02)),
                  child: SizedBox(
                    width: ScreenSize.width,
                    height: ScreenSize.height * (isPhoneScreen ? 0.58 : 0.61),
                    child: _buildBody(ScreenSize.get()),
                  ),
                ),
                if (!error)
                  ScoutingFooter(method: state.method, popupContext: context)
              ],
            ),
          );
        },
      ),
    );
  }
}
