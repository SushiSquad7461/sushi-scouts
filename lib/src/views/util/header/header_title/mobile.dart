import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:sushi_scouts/src/logic/helpers/size/ScreenSize.dart';

import '../../../../logic/deviceType.dart';

class HeaderTitleMobile extends StatelessWidget {
  final double heightExtension;
  const HeaderTitleMobile({Key? key, this.heightExtension = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context);
    return SizedBox(
        height: ScreenSize.height * (0.11 + heightExtension),
        child: Padding(
          padding: EdgeInsets.only(
              left: 20 * ScreenSize.swu,
              right: 20 * ScreenSize.swu,
              top: 0,
              bottom: 0),
          child: Stack(
            children: [
              SizedBox(
                width: ScreenSize.width,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Image.asset(
                    fit: BoxFit.cover,
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
