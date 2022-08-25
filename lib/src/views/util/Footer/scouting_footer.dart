import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sushi_scouts/src/logic/blocs/scouting_method_bloc/scouting_method_cubit.dart';
import 'package:sushi_scouts/src/logic/helpers/routing_helper.dart';
import 'package:sushi_scouts/src/logic/helpers/size/ScreenSize.dart';
import 'package:sushi_scouts/src/logic/models/scouting_data_models/scouting_data.dart';
import 'package:sushi_scouts/src/views/ui/sushi_scouts/qr_screen.dart';
import 'package:sushi_scouts/src/views/util/popups/required_content.dart';
import '../../../logic/data/config_file_reader.dart';
import '../../../logic/deviceType.dart';
import 'footer.dart';

class ScoutingFooter extends StatefulWidget {
  final BuildContext popupContext;
  final String method;
  final Function? submitCallback;
  const ScoutingFooter({
    Key? key,
    required this.method,
    required this.popupContext,
    this.submitCallback,
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

  void submit() {
    List<String> notFilled = currentScoutingData!.notFilled();
    if (notFilled.isEmpty) {
      widget.submitCallback ??
          RouteHelper.pushAndRemoveUntilToScreen(1, 0,
              ctx: context, screen: QRScreen());
    } else {
      showDialog(
          context: context, builder: (context) => RequiredContent(notFilled));
    }
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
                      "./assets/images/mobilefooter.svg",
                      width: ScreenSize.width,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
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
                            onPressed: moveToPreviousPage,
                            iconSize: ScreenSize.width / 6.0,
                            icon: Icon(
                              Icons.arrow_left_rounded,
                              color: prevPage
                                  ? colors.scaffoldBackgroundColor
                                  : colors.primaryColorDark,
                              semanticLabel: 'Back Arrow',
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
                              onPressed: submit,
                              child: Text(
                                'SUBMIT',
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
                                semanticLabel: 'Forward Arrow'),
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
                      onPressed: moveToPreviousPage,
                      iconSize: ScreenSize.width / 6.0,
                      icon: Icon(
                        Icons.arrow_left_rounded,
                        color: prevPage
                            ? colors.primaryColorDark
                            : colors.scaffoldBackgroundColor,
                        semanticLabel: 'Back Arrow',
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
                              onPressed: submit,
                              child: Text(
                                'SUBMIT',
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
                          semanticLabel: 'Forward Arrow'),
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
