// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:flutter_device_type/flutter_device_type.dart";

// Project imports:
import "../../../../logic/helpers/size/screen_size.dart";

class HeaderTitleMobileSupervise extends StatelessWidget {
  const HeaderTitleMobileSupervise({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context);
    return SizedBox(
        height: ScreenSize.height * 0.12,
        width: ScreenSize.width,
        child: Stack(
          children: [
            Center(
              child: Image.asset(
                colors.scaffoldBackgroundColor == Colors.black
                    ? "./assets/images/headertitlemobilesupervise.png"
                    : "./assets/images/headertitlemobilesupervise.png",
                scale: ScreenSize.width / 20,
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(
                    top:
                        ScreenSize.height * (Device.get().hasNotch ? 0.03 : 0)),
                child: SizedBox(
                  width: ScreenSize.width * 0.9,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Text("sushi supervise",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Sushi",
                          fontWeight: FontWeight.bold,
                          color: colors.primaryColorDark,
                        )),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
