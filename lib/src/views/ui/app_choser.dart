// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:flutter_device_type/flutter_device_type.dart";
import "package:flutter_svg/svg.dart";

// Project imports:
import "../../logic/helpers/routing_helper.dart";
import "../../logic/helpers/size/screen_size.dart";
import "../../logic/login_type.dart";
import "login.dart";

class AppChooser extends StatelessWidget {
  const AppChooser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: ScreenSize.height * (Device.get().hasNotch ? 0.04 : 0.02),
                left: ScreenSize.width * 0.05,
              ),
              child: Text(
                "SUSHI SQUAD____\nSCOUTING____\nINITIATIVE____",
                style: TextStyle(
                  fontSize: ScreenSize.height * 0.05,
                  fontFamily: "Sushi",
                  decoration: TextDecoration.underline,
                  decorationThickness: ScreenSize.width * 0.005,
                  color: colors.primaryColorDark,
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
                  width: ScreenSize.width * 0.75,
                ),
              ),
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
                  width: ScreenSize.width * 0.75,
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
                      "./assets/images/stratchoice.svg",
                      width: ScreenSize.width * 0.7,
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
