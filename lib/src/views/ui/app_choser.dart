// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:flutter_device_type/flutter_device_type.dart";
import "package:flutter_svg/svg.dart";

// Project imports:
import "../../logic/helpers/routing_helper.dart";
import "../../logic/helpers/size/screen_size.dart";
import "login.dart";

class AppChooser extends StatelessWidget {
  const AppChooser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Padding(
          padding: EdgeInsets.only(
              top: ScreenSize.height * (Device.get().hasNotch ? 0.02 : 0)),
          child: SvgPicture.asset(
            "./assets/images/sushiheaderlogo.svg",
            width: ScreenSize.width,
          ),
        ),
        GestureDetector(
          onTap: () => {
            RouteHelper.pushAndRemoveUntilToScreen(0, 0,
                ctx: context, screen: const Login(sushiScouts: false))
          },
          child: SvgPicture.asset(
            "./assets/images/sushisuperviselogo.svg",
            width: ScreenSize.width * 0.75,
          ),
        ),
        GestureDetector(
          onTap: () => {
            RouteHelper.pushAndRemoveUntilToScreen(0, 0,
                ctx: context, screen: const Login(sushiScouts: true))
          },
          child: SvgPicture.asset(
            "./assets/images/sushiscoutslogo.svg",
            width: ScreenSize.width * 0.75,
          ),
        ),
        SvgPicture.asset("./assets/images/choocerscoutingfooter.svg",
            width: ScreenSize.width)
      ]),
    );
  }
}
