import "package:flutter/material.dart";
import 'package:sushi_scouts/src/logic/data/cardinalData.dart';
import 'package:sushi_scouts/src/views/util/footer.dart';
import 'package:sushi_scouts/src/views/util/Header/HeaderTitle.dart';
import 'package:sushi_scouts/src/views/util/header/HeaderNav.dart';
import 'package:sushi_scouts/src/views/util/inputs/textInput.dart';

void main() => runApp(SushiScouts());

class SushiScouts extends StatelessWidget {
  const SushiScouts({Key? key}) : super(key: key);
  //CardinalData data = await CardinalData.create();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListView(
          children: [
            HeaderTitle(),
            HeaderNav(currentPage: "ORDINAL"),
            Footer(nextPage: true, previousPage: true, pageTitle: "AUTO",),
          ],
        )
      )
    );
  }
}