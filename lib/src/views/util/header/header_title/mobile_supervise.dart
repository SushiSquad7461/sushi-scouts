import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sushi_scouts/src/logic/helpers/size/ScreenSize.dart';

import '../../../../logic/deviceType.dart';

class HeaderTitleMobileSupervise extends StatelessWidget {
  const HeaderTitleMobileSupervise({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context);
    return SizedBox(
        height: ScreenSize.height * 0.1,
        child: Stack(
          children: [
            Center(
              child: Image.asset(
                colors.scaffoldBackgroundColor == Colors.black
                    ? "./assets/images/headertitlemobilesupervise.png"
                    : "./assets/images/headertitlemobilesupervise.png",
                    scale: ScreenSize.width / 11,
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(
                    top: ScreenSize.height *
                        (Device.get().hasNotch ? 0.03 : 0.01), left: 20 * ScreenSize.swu, right: 20 * ScreenSize.swu),
                child: Text(
                  "sushi supervise",
                  style: TextStyle(
                    fontFamily: "Sushi",
                    fontSize: 78 * ScreenSize.swu,
                    fontWeight: FontWeight.bold,
                    color: colors.primaryColorDark,
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
