// Flutter imports:
import "dart:io";
import "dart:math";

import "package:flutter/material.dart";

// Package imports:
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_svg/svg.dart";
import "package:get/get.dart";

// Project imports:
import "../../../logic/blocs/scouting_method_bloc/scouting_method_cubit.dart";
import "../../../logic/data/config_file_reader.dart";
import "../../../logic/device_type.dart";
import "../../../logic/helpers/routing_helper.dart";
import "../../../logic/helpers/size/screen_size.dart";
import "../../../logic/login_type.dart";
import "../../../logic/models/scouting_data_models/scouting_data.dart";
import "../../ui/app_choser.dart";
import "../../ui/login.dart";
import "../../ui/sushi_scouts/qr_screen.dart";
import "../popups/required_content.dart";
import "footer.dart";

class ScoutingFooter extends StatefulWidget {
  final BuildContext popupContext;
  final String method;
  const ScoutingFooter({
    Key? key,
    required this.method,
    required this.popupContext,
  }) : super(key: key);

  @override
  State<ScoutingFooter> createState() => _ScoutingFooterState();
}

class _ScoutingFooterState extends State<ScoutingFooter> {
  String footer = "";
  bool nextPage = false;
  bool prevPage = false;
  ScoutingData? currentScoutingData;

  void _init() {
    var reader = ConfigFileReader.instance;
    currentScoutingData = reader.getScoutingData(widget.method);
    updateState();
  }

  void moveToNextPage() {
    currentScoutingData!.nextPage();
    BlocProvider.of<ScoutingMethodCubit>(context)
        .changeMethod(widget.method, currentScoutingData!.currPage);
    updateState();
  }

  void moveToPreviousPage() {
    currentScoutingData!.prevPage();
    BlocProvider.of<ScoutingMethodCubit>(context)
        .changeMethod(widget.method, currentScoutingData!.currPage);
    updateState();
  }

  void updateState() {
    setState(() {
      nextPage = currentScoutingData!.canGoToNextPage();
      prevPage = currentScoutingData!.canGoToPrevPage();
      footer = currentScoutingData!.getCurrentPage()!.footer;
    });
  }

  Widget buildFooter() {
    var colors = Theme.of(context);
    var isPhoneScreen = isPhone(context);
    return Container(
        height: ScreenSize.height * (isPhoneScreen ? 0.19 : 0.165),
        width: ScreenSize.width,
        padding: const EdgeInsets.all(0),
        child: isPhoneScreen
            ? Stack(
                children: [
                  SizedBox(
                    width: ScreenSize.width,
                    child: SvgPicture.asset(
                      colors.scaffoldBackgroundColor == Colors.white
                          ? "./assets/images/mobilefooter.svg"
                          : "./assets/images/mobilefooterdark.svg",
                      width: ScreenSize.width,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Align(
                      alignment: const Alignment(1, 0.6),
                      child: IconButton(
                        icon: Icon(Icons.qr_code_2_rounded,
                            color: colors.backgroundColor),
                        onPressed: () {
                          RouteHelper.pushAndRemoveUntilToScreen(1, 0,
                              ctx: context,
                              screen: QRScreen(hasNewData: false));
                        },
                        iconSize: ScreenSize.swu * 60,
                      )),
                  Padding(
                    padding: EdgeInsets.only(
                        top: ScreenSize.height * 0.1,
                        left: ScreenSize.width * 0.15),
                    child: SizedBox(
                      width: ScreenSize.width * 0.7,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () {
                              currentScoutingData!.currPage != 0
                                  ? moveToPreviousPage()
                                  : RouteHelper.pushAndRemoveUntilToScreen(1, 0,
                                      ctx: context,
                                      screen:
                                          const Login(type: LoginType.scout));
                            },
                            iconSize: ScreenSize.width / 6.0,
                            icon: Icon(
                              Icons.arrow_left_rounded,
                              color: colors.scaffoldBackgroundColor,
                              semanticLabel: "Back Arrow",
                            ),
                          ),
                          if (nextPage)
                            Text(
                              footer.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 45 * ScreenSize.swu,
                                  fontFamily: "Sushi",
                                  color: colors.primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          if (!nextPage)
                            TextButton(
                              onPressed: () {
                                List<String> notFilled =
                                    currentScoutingData!.notFilled();
                                if (notFilled.isEmpty) {
                                  RouteHelper.pushAndRemoveUntilToScreen(1, 0,
                                      ctx: context, screen: QRScreen());
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) =>
                                          RequiredContent(notFilled));
                                }
                              },
                              child: Text(
                                "SUBMIT",
                                style: TextStyle(
                                    fontSize: 45 * ScreenSize.swu,
                                    fontFamily: "Sushi",
                                    color: colors.primaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          IconButton(
                            padding: const EdgeInsets.all(0),
                            onPressed: () {
                              List<String> notFilled =
                                  currentScoutingData!.notFilled();
                              if (notFilled.isEmpty) {
                                moveToNextPage();
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (context) =>
                                        RequiredContent(notFilled));
                              }
                            },
                            iconSize: ScreenSize.width / 6.0,
                            icon: Icon(Icons.arrow_right_rounded,
                                color: nextPage
                                    ? colors.scaffoldBackgroundColor
                                    : colors.primaryColorDark,
                                semanticLabel: "Forward Arrow"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        currentScoutingData!.currPage != 0
                            ? moveToPreviousPage
                            : RouteHelper.pushAndRemoveUntilToScreen(1, 0,
                                ctx: context,
                                screen: const Login(type: LoginType.scout));
                      },
                      iconSize: ScreenSize.width / 6.0,
                      icon: Icon(
                        Icons.arrow_left_rounded,
                        color: prevPage
                            ? colors.primaryColorDark
                            : colors.scaffoldBackgroundColor,
                        semanticLabel: "Back Arrow",
                      ),
                    ),
                    (nextPage
                        ? SizedBox(
                            width: ScreenSize.width / 10.0, //57
                            height: ScreenSize.width / 10.0, //59
                            child: SvgPicture.asset(
                              "./assets/images/${colors.scaffoldBackgroundColor == Colors.black ? "darknori" : "nori"}.svg",
                            ))
                        : Container(
                            width: 150 * ScreenSize.swu,
                            height: 55 * ScreenSize.swu,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: colors.primaryColorDark, width: 3.5),
                              color: colors.scaffoldBackgroundColor,
                              borderRadius:
                                  BorderRadius.circular(10 * ScreenSize.swu),
                            ),
                            child: TextButton(
                              onPressed: () {
                                List<String> notFilled =
                                    currentScoutingData!.notFilled();
                                if (notFilled.isEmpty) {
                                  RouteHelper.pushAndRemoveUntilToScreen(1, 0,
                                      ctx: context, screen: QRScreen());
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) =>
                                          RequiredContent(notFilled));
                                }
                              },
                              child: Text(
                                "SUBMIT",
                                style: TextStyle(
                                    fontSize: 29 * ScreenSize.swu,
                                    fontFamily: "Sushi",
                                    color: colors.primaryColorDark,
                                    fontWeight: FontWeight.bold),
                              ),
                            ))),
                    IconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () {
                        List<String> notFilled =
                            currentScoutingData!.notFilled();
                        if (notFilled.isEmpty) {
                          moveToNextPage();
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) => RequiredContent(notFilled));
                        }
                      },
                      iconSize: ScreenSize.width / 6.0,
                      icon: Icon(Icons.arrow_right_rounded,
                          color: nextPage
                              ? colors.primaryColorDark
                              : colors.scaffoldBackgroundColor,
                          semanticLabel: "Forward Arrow"),
                    ),
                  ],
                ),
                Footer(pageTitle: footer)
              ]));
  }

  @override
  Widget build(BuildContext context) {
    _init();
    return buildFooter();
  }
}
