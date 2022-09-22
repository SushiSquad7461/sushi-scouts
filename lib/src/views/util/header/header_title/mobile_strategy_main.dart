// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:flutter_svg/svg.dart";

// Project imports:
import "../../../../logic/helpers/color/hex_color.dart";
import "../../../../logic/helpers/size/screen_size.dart";

class HeaderTitleMobileStrategyMain extends StatefulWidget {
  const HeaderTitleMobileStrategyMain({Key? key}) : super(key: key);

  @override
  State<HeaderTitleMobileStrategyMain> createState() =>
      _HeaderTitleMobileStrategyMainState();
}

class _HeaderTitleMobileStrategyMainState
    extends State<HeaderTitleMobileStrategyMain> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: ScreenSize.height * 0.14,
      width: ScreenSize.width * 1,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          SvgPicture.asset(
            "./assets/images/stratgeymainheader.svg",
            height: ScreenSize.height * 0.12,
          ),
          Padding(
            padding: EdgeInsets.only(
              top: ScreenSize.height * 0.08,
              left: ScreenSize.width * 0.55,
            ),
            child: SizedBox(
              width: ScreenSize.width * 0.35,
              height: ScreenSize.height * 0.04,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "7461",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Sushi",
                      fontSize: ScreenSize.height * 0.045,
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.only(top: ScreenSize.height * 0.008),
                    child: SvgPicture.asset(
                      "./assets/images/uparrow.svg",
                      height: ScreenSize.height * 0.03,
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.only(top: ScreenSize.height * 0.006),
                    child: Text(
                      "1",
                      style: TextStyle(
                        color: HexColor("#81F4E1"),
                        fontFamily: "Sushi",
                        fontSize: ScreenSize.height * 0.035,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ]
      ),
    );
  }
}
