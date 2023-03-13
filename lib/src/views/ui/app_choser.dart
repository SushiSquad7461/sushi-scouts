// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:flutter_device_type/flutter_device_type.dart";
import "package:flutter_svg/svg.dart";

// Project imports:
import '../../logic/helpers/asset_helper.dart';
import '../../logic/types/device_type.dart';
import '../../logic/helpers/color/hex_color.dart';
import "../../logic/helpers/routing_helper.dart";
import "../../logic/helpers/size/screen_size.dart";
import '../../logic/types/login_type.dart';
import "login.dart";

class AppChooser extends StatefulWidget {
  static int SCOUTING_PAGE = 0;
  static int SUPERVISE_PAGE = 1;
  static int STRATEGY_PAGE = 2;

  final int startingPage;

  const AppChooser({Key? key, this.startingPage = 0}) : super(key: key);

  @override
  State<AppChooser> createState() => _AppChooserState();
}

class _AppChooserState extends State<AppChooser> {
  int index = 0;

  final Color selectColor = Color.fromARGB(255, 0, 0, 0);
  final Color otherColor = Color.fromARGB(125, 0, 0, 0);

  LoginType getType(int i) {
    if (i == AppChooser.SCOUTING_PAGE) return LoginType.scout;
    if (i == AppChooser.SUPERVISE_PAGE) return LoginType.supervise;
    if (i == AppChooser.STRATEGY_PAGE) return LoginType.strategy;
    return LoginType.scout;
  }

  Widget iconWidget(int t) {
    return Icon(
        size: 20,
        Icons.circle,
        color: getType(index) == getType(t) ? selectColor : otherColor);
  }

  Widget appIndicator(PageController controller) {
    return Positioned(
        bottom: 20,
        left: ScreenSize.width * 0.5 - 45,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                constraints: BoxConstraints(minWidth: 30),
                padding: EdgeInsetsDirectional.zero,
                onPressed: () {
                  setState(() {
                    controller.animateToPage(AppChooser.SCOUTING_PAGE,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut);
                  });
                },
                iconSize: 20,
                icon: iconWidget(AppChooser.SCOUTING_PAGE)),
            IconButton(
                constraints: BoxConstraints(minWidth: 30),
                padding: EdgeInsets.all(0),
                onPressed: () {
                  setState(() {
                    controller.animateToPage(AppChooser.SUPERVISE_PAGE,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut);
                  });
                },
                iconSize: 20,
                icon: iconWidget(AppChooser.SUPERVISE_PAGE)),
            IconButton(
                constraints: BoxConstraints(minWidth: 30),
                padding: EdgeInsets.all(0),
                onPressed: () {
                  setState(() {
                    controller.animateToPage(AppChooser.STRATEGY_PAGE,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut);
                  });
                },
                iconSize: 20,
                icon: iconWidget(AppChooser.STRATEGY_PAGE))
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context);
    var phone = isPhone(context);
    final controller = PageController(initialPage: widget.startingPage);

    return Stack(
      children: [
        PageView(
            onPageChanged: (index) {
              setState(() {
                this.index = index;
              });
            },
            controller: controller,
            children: [
              const Login(type: LoginType.scout),
              const Login(type: LoginType.supervise),
              const Login(type: LoginType.strategy)
            ]),
        appIndicator(controller)
      ],
    );
  }
}

/*
class AppChoserWidget extends StatelessWidget {
  const AppChoserWidget({
    Key? key,
    required this.colors,
    required this.phone,
  }) : super(key: key);

  final ThemeData colors;
  final bool phone;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: ScreenSize.height * (Device.get().hasNotch ? 0.045 : 0.02),
                left: ScreenSize.width * 0.03,
              ),
              child: SizedBox(
                height: ScreenSize.height * 0.25,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "SUSHI SQUAD",
                          style: TextStyle(
                            fontSize: ScreenSize.height * 0.045,
                            fontFamily: "Sushi",
                            color: colors.primaryColorDark,
                          ),
                        ),
                        SizedBox(
                          width: ScreenSize.width * 0.75,
                          child: Divider(
                            height: 1,
                            thickness: ScreenSize.height * 0.008,
                            color: HexColor("#FF89AF"),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "SCOUTING",
                          style: TextStyle(
                            fontSize: ScreenSize.height * 0.045,
                            fontFamily: "Sushi",
                            color: colors.primaryColorDark,
                          ),
                        ),
                        SizedBox(
                          width: ScreenSize.width * 0.65,
                          child: Divider(
                            height: 1,
                            thickness: ScreenSize.height * 0.008,
                            color: HexColor("#56CBF9"),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "INITIATIVE",
                              style: TextStyle(
                                fontSize: ScreenSize.height * 0.045,
                                fontFamily: "Sushi",
                                color: colors.primaryColorDark,
                              ),
                            ),
                            SizedBox(
                              width: ScreenSize.width * 0.55,
                              child: Divider(
                                height: 1,
                                thickness: ScreenSize.height * 0.008,
                                color: HexColor("#81F4E1"),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: ScreenSize.width * 0.3,
                          child: SvgPicture.asset(
                            getImagePath("glitchnori", context, "svg")
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: ScreenSize.width,
              child: GestureDetector(
                onTap: () => {
                  RouteHelper.pushAndRemoveUntilToScreen(0, 0,
                      ctx: context,
                      screen: const Login(type: LoginType.supervise))
                },
                child: SvgPicture.asset(
                  getImagePath("superviselogo", context, "svg"),
                  width: ScreenSize.width * (phone ? 0.75 : 0.6),
                ),
              ),
            ),
            SizedBox(
              height: 3,
            ),
            SizedBox(
              width: ScreenSize.width,
              child: GestureDetector(
                onTap: () => {
                  RouteHelper.pushAndRemoveUntilToScreen(0, 0,
                      ctx: context, screen: const Login(type: LoginType.scout))
                },
                child: SvgPicture.asset(
                  getImagePath("scoutslogo", context, "svg"),
                  width: ScreenSize.width * 0.8 * (phone ? 0.85 : 0.7),
                ),
              ),
            ),
            SizedBox(
              child: SizedBox(
                width: ScreenSize.width,
                child: Center(
                  child: GestureDetector(
                    onTap: () => {
                      RouteHelper.pushAndRemoveUntilToScreen(0, 0,
                          ctx: context,
                          screen: const Login(type: LoginType.strategy))
                    },
                    child: SvgPicture.asset(
                      getImagePath("stratchoice", context, "svg"),
                      width: ScreenSize.width * 0.9 * (phone ? 0.75 : 0.6),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: ScreenSize.height * 0.02),
              child: SvgPicture.asset(
                  "./assets/images/${colors.scaffoldBackgroundColor == Colors.white ? "choicefooter.svg" : "choocerfooterdark.svg"}",
                  width: ScreenSize.width),
            )
          ]),
    );
  }
}*/
