// Flutter imports:
import "package:flutter/material.dart";

// Project imports:
import '../../../logic/types/device_type.dart';
import "../../../logic/helpers/size/screen_size.dart";

class SuperviseFooter extends StatelessWidget {
  const SuperviseFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context);
    var phone = !isTable(context);
    return Container(
      color: colors.primaryColor,
      width: ScreenSize.width,
      height: ScreenSize.height * (phone ? 0.17 : 0.2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Image.asset(
            phone
                ? "./assets/images/supervisefootermain${ colors.scaffoldBackgroundColor == Colors.black ? "dark" : ""}.png"
                : colors.scaffoldBackgroundColor == Colors.black
                    ? "./assets/images/supervisefooterdark.png"
                    : "./assets/images/supervisefooter.png",
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
