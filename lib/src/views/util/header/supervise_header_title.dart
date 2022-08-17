import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sushi_scouts/src/logic/helpers/size/ScreenSize.dart';

class HeaderTitle extends StatelessWidget {
  const HeaderTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context);
    return SizedBox(
        height: ScreenSize.height * 0.1,
        child: Padding(
          padding: EdgeInsets.only(
              left: ScreenSize.width * 0.04,
              right: ScreenSize.width * 0.04,
              top: 0,
              bottom: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "sushi supervise",
                style: TextStyle(
                  fontFamily: "Sushi",
                  fontSize: ScreenSize.width * 0.1,
                  fontWeight: FontWeight.bold,
                  color: colors.primaryColorDark,
                ),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 1, minHeight: 1), // here
                child: Image.asset(
                  colors.scaffoldBackgroundColor == Colors.black
                      ? "./assets/images/lightrect.png"
                      : "./assets/images/lightrect.png",
                  scale: 0.1 / ScreenSize.swu,
                  width: ScreenSize.width * 0.2,
                  height: ScreenSize.height * 0.1,
                ),
              ),
            ],
          ),
      )
    );
  }
}