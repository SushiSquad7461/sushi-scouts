// Flutter imports:
import "package:flutter/material.dart";

// Project imports:
import "../../../../logic/helpers/size/screen_size.dart";

class HeaderTitleTablet extends StatelessWidget {
  const HeaderTitleTablet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context);
    return SizedBox(
        height: ScreenSize.height * 0.1,
        child: Padding(
          padding: EdgeInsets.only(
              left: 20 * ScreenSize.swu,
              right: 20 * ScreenSize.swu,
              top: 0.02 * ScreenSize.height,
              bottom: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "sushi scouts",
                style: TextStyle(
                  fontFamily: "Sushi",
                  fontSize: 75 * ScreenSize.swu,
                  fontWeight: FontWeight.bold,
                  color: colors.primaryColorDark,
                ),
              ),
              ConstrainedBox(
                constraints:
                    const BoxConstraints(minWidth: 1, minHeight: 1), // here
                child: Image.asset(
                  colors.scaffoldBackgroundColor == Colors.black
                      ? "./assets/images/toprightlogodark.png"
                      : "./assets/images/toprightlogo.png",
                  scale: 60 / ScreenSize.swu,
                ),
              ),
            ],
          ),
        ));
  }
}
