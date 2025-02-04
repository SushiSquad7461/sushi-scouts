// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:flutter_bloc/flutter_bloc.dart";

// Project imports:
import "../../../logic/blocs/scouting_method_bloc/scouting_method_cubit.dart";
import "../../../logic/data/config_file_reader.dart";
import '../../../logic/types/device_type.dart';
import "../../../logic/helpers/color/hex_color.dart";
import "../../../logic/helpers/routing_helper.dart";
import "../../../logic/helpers/size/screen_size.dart";
import "../../ui/settings.dart";
import "../../ui/sushi_scouts/scouting.dart";
import "../../ui/sushi_supervise/edit.dart";
import "../../ui/sushi_supervise/upload.dart";

class HeaderNav extends StatelessWidget {
  final String currentPage;
  final bool isSupervise;
  late final List<String> screens;

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
        Widget toAdd;
        switch (screen) {
          case "upload":
            toAdd = const Upload();
            break;
          case "settings":
            toAdd = const Settings();
            break;
          case "edit":
            toAdd = const Edit();
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
      fontFamily: "Mohave",
      fontSize: 25 * ScreenSize.swu,
      fontWeight: FontWeight.w700,
      color: colors.primaryColorDark,
    );
    bool isPhoneScreen = isPhone(context);
    return Container(
        color: colors.primaryColor,
        height: ScreenSize.height * 0.09,
        child: Padding(
          padding: EdgeInsets.only(
              left: 0,
              right: 0,
              top: (isPhoneScreen ? 2 : 7) * ScreenSize.shu,
              bottom: (isPhoneScreen ? 17 : 0) * ScreenSize.shu),
          child: Container(
            color: isPhoneScreen
                ? colors.primaryColorDark
                : colors.scaffoldBackgroundColor,
            child: Column(
              children: [
                isPhoneScreen
                    ? Divider(
                        height: ScreenSize.height * 0.018,
                        color: colors.primaryColorDark,
                        thickness: (isPhoneScreen ? 0 : 4) * ScreenSize.shu,
                      )
                    : Divider(
                        color: colors.primaryColorDark,
                        thickness: (isPhoneScreen ? 0 : 4) * ScreenSize.shu,
                      ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      for (final String screen in screens)
                        Padding(
                            padding: EdgeInsets.only(
                                left: 0,
                                right: 0,
                                top: 0 * ScreenSize.shu,
                                bottom: 0 * ScreenSize.shu),
                            child: GestureDetector(
                                onTap: () => changeScreen(screen, context),
                                child: isPhoneScreen
                                    ? Text(
                                        screen.toUpperCase(),
                                        style: TextStyle(
                                            fontFamily: "Mohave",
                                            fontSize: isPhoneScreen
                                                ? ScreenSize.height * 0.023
                                                : ScreenSize.width * 0.05,
                                            color: (currentPage == screen)
                                                ? colors.primaryColor
                                                : colors.scaffoldBackgroundColor == Colors.black ? HexColor("#D0D0D0") : HexColor("#4F4F4F")),
                                      )
                                    : Container(
                                        decoration: ((currentPage == screen)
                                            ? BoxDecoration(
                                                border: Border.all(
                                                    color: HexColor(isSupervise
                                                        ? (colors.scaffoldBackgroundColor ==
                                                                Colors.white
                                                            ? "#FF729F"
                                                            : "#81F4E1")
                                                        :  "#56CBF9"),
                                                    width: 5 * ScreenSize.shu),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(
                                                        5 * ScreenSize.swu)),
                                              )
                                            : BoxDecoration(
                                                border: Border.all(
                                                    color: colors
                                                        .scaffoldBackgroundColor,
                                                    width:
                                                        5 * ScreenSize.swu))),
                                        child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 4 * ScreenSize.swu,
                                                right: 4 * ScreenSize.swu,
                                                top: 2 * ScreenSize.swu,
                                                bottom: 2 * ScreenSize.swu),
                                            child: Text(
                                              screen.toUpperCase(),
                                              style: pageStyle
                                            )
                                        )
                                    )
                            )
                        )
                    ]),
                isPhoneScreen
                    ? Divider(
                        height: ScreenSize.height * 0.013,
                        color: colors.primaryColorDark,
                        thickness: (isPhoneScreen ? 0 : 4) * ScreenSize.shu,
                      )
                    : Divider(
                        color: colors.primaryColorDark,
                        thickness: (isPhoneScreen ? 0 : 4) * ScreenSize.shu,
                      ),
              ],
            ),
          ),
        ));
  }
}
