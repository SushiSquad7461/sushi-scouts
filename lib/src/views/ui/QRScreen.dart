import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:sushi_scouts/src/logic/data/ScoutingData.dart';
import 'package:sushi_scouts/src/logic/size/ScreenSize.dart';
import 'package:sushi_scouts/src/views/util/footer/AngledFooter.dart';
import '../util/Header/HeaderTitle.dart';
import '../util/header/HeaderNav.dart';
import 'Scouting.dart';

class QRScreen extends StatelessWidget {
  final String data;
  final Function() nextPage;

  const QRScreen({Key? key, required this.data, required this.nextPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AngledFooter(button: true, buttonText: "CONTINUE", onPressed: nextPage,),
      ],
    );
  }
}
