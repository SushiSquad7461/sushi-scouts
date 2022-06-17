import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sushi_scouts/src/logic/enums/Pages.dart';

import '../util/Header/HeaderTitle.dart';
import '../util/footer.dart';
import '../util/header/HeaderNav.dart';
import 'package:sushi_scouts/src/logic/data/cardinalData.dart';
import 'package:sushi_scouts/src/views/util/components/NumberInput.dart';

class Cardinal extends StatefulWidget {
  CardinalData? data;
  final Map allComponents = {"number input": NumberInput.create};
  final ValueChanged changePage;
  Cardinal({Key? key, required this.changePage}) : super(key: key);
  @override
  Pregame createState() => Pregame();
}

class Pregame extends State<Cardinal> {
  List<String>? names;
  List<String>? components;
  int index = 0;

  Future<bool> setData() async {
    widget.data = await CardinalData.firstCreate();
    components = widget.data!.getComponents(MatchStage.pregame);
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
          currentPage: Pages.cardinal,
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
                            for (index = 0;
                                index < (components!.length / 2.0 + 0.5).floor();
                                index++)
                              widget.allComponents.containsKey(components![index])
                                  ? widget.allComponents[components![index]](
                                      names![index], onSubmit)
                                  : SizedBox(
                                    width: 100,
                                    child: Text(
                                      "The widget type ${components![index]} is not defined",
                                      style: const TextStyle(
                                      fontFamily: "Sushi",
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)
                                    ),
                                  )
                          ],
                        ),
                        Column(
                          children: [
                            for (index = index;
                                index < components!.length;
                                index++)
                              widget.allComponents.containsKey(components![index])
                                  ? widget.allComponents[components![index]](
                                      names![index], onSubmit)
                                  : SizedBox(
                                    width: 100,
                                    child: Text(
                                      "The widget type ${components![index]} is not defined",
                                      style: const TextStyle(
                                      fontFamily: "Sushi",
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)
                                    ),
                                  )
                          ],
                        ),
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
