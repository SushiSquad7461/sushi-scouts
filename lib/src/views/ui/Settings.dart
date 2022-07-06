import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sushi_scouts/src/logic/data/ScoutingData.dart';
import 'package:sushi_scouts/src/logic/size/ScreenSize.dart';
import '../util/Header/HeaderTitle.dart';
import '../util/footer.dart';
import '../util/header/HeaderNav.dart';

class Settings extends StatelessWidget {
  final Function(String newPage, String previousPage, {ScoutingData? previousData}) changePage;
  final List<String> screens;
  const Settings({Key? key, required this.changePage, required this.screens}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
          children: [
            Footer(pageTitle: "Settings", size: ScreenSize.get(),)
          ],
        )
    );
  }
}