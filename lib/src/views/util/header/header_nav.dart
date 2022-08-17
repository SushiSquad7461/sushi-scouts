import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sushi_scouts/src/logic/blocs/scouting_method_bloc/scouting_method_cubit.dart';
import 'package:sushi_scouts/src/logic/helpers/color/hex_color.dart';
import 'package:sushi_scouts/src/logic/helpers/routing_helper.dart';
import 'package:sushi_scouts/src/logic/helpers/size/ScreenSize.dart';
import 'package:sushi_scouts/src/views/ui/sushi_scouts/scouting.dart';
import 'package:sushi_scouts/src/views/ui/settings.dart';
import 'package:sushi_scouts/src/views/ui/sushi_supervise/upload.dart';

import '../../../logic/data/config_file_reader.dart';

class HeaderNav extends StatelessWidget {
  final String currentPage;
  final bool isSupervise;
  late List<String> screens;

  HeaderNav({Key? key, required this.currentPage, this.isSupervise = false})
      : super(key: key) {
    if (!isSupervise) {
      var reader = ConfigFileReader.instance;
      screens = reader.getScoutingMethods();
      screens.add("settings");
    } else {
      screens = ["upload", "settings", "stats", "edit"];
    }
  }

  void changeScreen(String screen, context) {
    if (!isSupervise) {
      if (screen != "settings") {
        BlocProvider.of<ScoutingMethodCubit>(context).changeMethod(screen, 0);
        if (currentPage == "settings") {
          RouteHelper.pushAndRemoveUntilToScreen(0, 0,
              ctx: context, screen: const Scouting());
        }
      } else if (currentPage != "settings") {
        RouteHelper.pushAndRemoveUntilToScreen(0, 0,
            ctx: context, screen: const Settings());
      }
    } else {
      if (screens.contains(screen) && currentPage != screen) {
        var toAdd;
        print("switching");
        switch (screen) {
          case "upload":
            toAdd = const Upload();
            break;
          case "settings":
            toAdd = const Settings(
              isSupervise: true,
            );
            break;
          default:
            toAdd = const Upload();
            break;
        }

        RouteHelper.pushAndRemoveUntilToScreen(0, 0,
            ctx: context, screen: toAdd);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context);
    final TextStyle pageStyle = TextStyle(
      fontSize: 25 * ScreenSize.swu,
      fontWeight: FontWeight.w700,
      color: colors.primaryColorDark,
    );
    return Container(
        height: ScreenSize.height * 0.1,
        child: Padding(
          padding: EdgeInsets.only(
              left: 0, right: 0, top: 7 * ScreenSize.shu, bottom: 0),
          child: Column(
            children: [
              Divider(
                color: colors.primaryColorDark,
                thickness: 4 * ScreenSize.shu,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                for (final String screen in screens)
                  Padding(
                      padding: EdgeInsets.only(
                          left: 0,
                          right: 0,
                          top: 0 * ScreenSize.shu,
                          bottom: 0 * ScreenSize.shu),
                      child: GestureDetector(
                          onTap: () => changeScreen(screen, context),
                          child: Container(
                              decoration: ((currentPage == screen)
                                  ? BoxDecoration(
                                      border: Border.all(
                                          color: HexColor(isSupervise
                                              ? (colors.scaffoldBackgroundColor == Colors.white ? "#FF729F" : "#81F4E1")
                                              : "#56CBF9"),
                                          width: 5 * ScreenSize.shu),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5 * ScreenSize.swu)),
                                    )
                                  : BoxDecoration(
                                      border: Border.all(
                                          color: colors.scaffoldBackgroundColor,
                                          width: 5 * ScreenSize.swu))),
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 4 * ScreenSize.swu,
                                      right: 4 * ScreenSize.swu,
                                      top: 2 * ScreenSize.swu,
                                      bottom: 2 * ScreenSize.swu),
                                  child: Text(
                                    screen.toUpperCase(),
                                    style: GoogleFonts.mohave(
                                        textStyle: pageStyle),
                                  )))))
              ]),
              Divider(
                color: colors.primaryColorDark,
                thickness: 4 * ScreenSize.shu,
              ),
            ],
          ),
        ));
  }
}
