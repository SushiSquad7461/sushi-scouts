import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sushi_scouts/src/logic/size/ScreenSize.dart';

import '../util/Header/HeaderTitle.dart';
import '../util/Footer/Footer.dart';
import '../util/header/HeaderNav.dart';

class Login extends StatefulWidget {
  final Function(String newPage) changePage;
  const Login({Key? key, required this.changePage}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Stack(
          children: [
            SvgPicture.asset(
              "./assets/images/FooterColors.svg",
              width: ScreenSize.width,
            ),
            Padding(
              padding: EdgeInsets.only(top: ScreenSize.height * 0.2),
              child: Container(
                  width: ScreenSize.width,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                  ),
                  child: TextButton(
                    onPressed: () => widget.changePage("cardinal"),
                    child: Text(
                      'GO',
                      style: TextStyle(
                          fontSize: 35 * ScreenSize.swu,
                          fontFamily: "Sushi",
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
            ),
          ],
        )
      ],
    );
  }
}
