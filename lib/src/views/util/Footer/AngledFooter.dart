import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';

import '../../../logic/size/ScreenSize.dart';

class AngledFooter extends StatelessWidget {
  final Function()? onPressed;
  final String? buttonText;
  final bool button;

  const AngledFooter({Key? key, this.button = false, this.buttonText, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SizedBox(
          width: ScreenSize.width,
          height: ScreenSize.width / 1.76,
          child: SvgPicture.asset(
            "./assets/images/footer.svg",
          )
      ),
      if (button) Padding(
        padding:  EdgeInsets.only(
              left: 0, right: 0, top: ScreenSize.height * 0.2, bottom: 0),
        child: Container(
          width: ScreenSize.width,
          decoration: const BoxDecoration(
            color: Colors.black
          ),
          child: TextButton(
            onPressed: () => onPressed!(), 
            child: Text(
              buttonText!,
              style: TextStyle(
                fontFamily: "Sushi",
                color: Colors.white,
                fontSize: ScreenSize.width * 0.05,
              ),
          )),
        ),
      ),
    ]);
  }
}
