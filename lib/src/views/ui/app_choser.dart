// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:flutter_device_type/flutter_device_type.dart";
import "package:flutter_svg/svg.dart";

// Project imports:
import '../../logic/types/device_type.dart';
import '../../logic/helpers/color/hex_color.dart';
import "../../logic/helpers/routing_helper.dart";
import "../../logic/helpers/size/screen_size.dart";
import '../../logic/types/login_type.dart';
import "login.dart";

class AppChooser extends StatelessWidget {
  const AppChooser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context);
    var phone = isPhone(context);

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
                            "./assets/images/glitchnori${colors.scaffoldBackgroundColor == Colors.white ? "" : "dark"}.svg",
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
                  "./assets/images/${colors.scaffoldBackgroundColor == Colors.white ? "superviselogo" : "superviselogodark"}.svg",
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
                  "./assets/images/scoutslogo${colors.scaffoldBackgroundColor == Colors.white ? "" : "dark"}.svg",
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
                      "./assets/images/stratchoice${colors.scaffoldBackgroundColor == Colors.white ? "" : "dark"}.svg",
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
}
