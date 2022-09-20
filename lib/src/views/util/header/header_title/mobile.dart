import "package:flutter/material.dart";
import "package:flutter_device_type/flutter_device_type.dart";
import "package:sushi_scouts/src/logic/helpers/size/screen_size.dart";

class HeaderTitleMobile extends StatelessWidget {
  const HeaderTitleMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context);
    return SizedBox(
        height: ScreenSize.height * 0.11,
        child: Padding(
          padding: EdgeInsets.only(
              left: 20 * ScreenSize.swu,
              right: 20 * ScreenSize.swu,
              top: 0,
              bottom: 0),
          child: Stack(
            children: [
              SizedBox(
                width: ScreenSize.width * 0.99,
                height: ScreenSize.height * 0.11,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Image.asset(
                    colors.scaffoldBackgroundColor == Colors.black
                        ? "./assets/images/header_title_mobile.png"
                        : "./assets/images/header_title_mobile.png",
                    // scale: ScreenSize.width / 12,
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: ScreenSize.height *
                          (Device.get().hasNotch ? 0.03 : 0.01)),
                  child: SizedBox(
                    width: ScreenSize.width * 0.8,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Text(
                        "sushi scouts",
                        style: TextStyle(
                          fontFamily: "Sushi",
                          fontSize: 90 * ScreenSize.swu,
                          fontWeight: FontWeight.bold,
                          color: colors.primaryColorDark,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
