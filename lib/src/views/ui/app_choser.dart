import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sushi_scouts/SushiScoutingLib/logic/helpers/size/ScreenSize.dart';
import 'package:sushi_scouts/SushiScoutingLib/logic/models/scouting_data_models/page.dart';
import 'package:sushi_scouts/src/views/ui/sushi_scouts/login.dart';
import 'dart:math' as math;

import '../../../SushiScoutingLib/logic/helpers/routing_helper.dart';

class AppChooser extends StatelessWidget {
  const AppChooser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, 
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
            Padding(
              padding: EdgeInsets.only(top: ScreenSize.height * 0.02),
              child: SvgPicture.asset(
                "./assets/images/sushiheaderlogo.svg",
                width: ScreenSize.width,
              ),
            ),
            GestureDetector(
              onTap: () => {
                RouteHelper.pushReplacement(ctx: context, screen: const Login(sushi_scouts: false))
              },
              child: SvgPicture.asset(
                "./assets/images/sushisuperviselogo.svg",
                width: ScreenSize.width * 0.8,
              ),
            ),
            GestureDetector(
              onTap: () => {
                RouteHelper.pushReplacement(ctx: context, screen: const Login(sushi_scouts: true))
              },
              child: SvgPicture.asset(
                "./assets/images/sushiscoutslogo.svg",
                width: ScreenSize.width * 0.8,
              ),
            ),
             SvgPicture.asset(
              "./assets/images/choocerscoutingfooter.svg",
              width: ScreenSize.width
            ) 
        ]
      ),
    );
  }
}
