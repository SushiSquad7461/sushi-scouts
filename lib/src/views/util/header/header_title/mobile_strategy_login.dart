// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:flutter_device_type/flutter_device_type.dart";
import "package:flutter_svg/svg.dart";

// Project imports:
import "../../../../logic/helpers/size/screen_size.dart";

class HeaderTitleMobileStrategyLogin extends StatelessWidget {
  const HeaderTitleMobileStrategyLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context);
    return SizedBox(
        height: ScreenSize.height * 0.12,
        width: ScreenSize.width,
        child: Container(
          color: colors.primaryColorDark,
          child: Stack(
            children: [
              Center(
                  child: SvgPicture.asset(
                "./assets/images/stratloginheader.svg",
                width: ScreenSize.width,
              )),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: ScreenSize.height *
                          (Device.get().hasNotch ? 0.03 : 0)),
                  child: SizedBox(
                    width: ScreenSize.width * 0.8,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text("sushi strategy",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Sushi",
                            fontWeight: FontWeight.bold,
                            color: colors.primaryColor,
                          )),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
