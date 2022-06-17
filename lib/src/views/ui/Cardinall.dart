import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sushi_scouts/src/logic/enums/Pages.dart';

import '../util/Header/HeaderTitle.dart';
import '../util/footer.dart';
import '../util/header/HeaderNav.dart';
import 'package:sushi_scouts/src/logic/data/cardinalData.dart';
import 'package:sushi_scouts/src/views/util/inputs/NumberInput.dart';

class Cardinal extends StatefulWidget {
  CardinalData? data;
  final ValueChanged changePage;
  Cardinal({Key? key, required this.changePage}) : super(key: key);
  @override
  Pregame createState() => Pregame();
}

class Pregame extends State<Cardinal> {
  List<String>? names;

  Future<bool> setData() async {
    widget.data = await CardinalData.firstCreate();
    names = widget.data!.getNames(MatchStage.pregame);
    return true;
  }

  void onSubmit(String name, Data value) {
    widget.data!.setPregame(name, value);
    print(widget.data!.getPregame(name));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        const HeaderTitle(),
        HeaderNav(
          currentPage: Pages.ordinal,
          changePage: widget.changePage,
        ),
        FutureBuilder(
            future: setData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return snapshot.hasData
                  ? Row(
                      children: [
                        Column(
                          children: [
                            NumberInput(name: names![0], onSubmit: onSubmit)
                          ],
                        )
                      ],
                    )
                  : const CircularProgressIndicator();
            }),
        const Footer(
          nextPage: true,
          previousPage: false,
        ),
      ],
    ));
  }
}
