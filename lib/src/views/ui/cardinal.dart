import 'package:flutter/cupertino.dart';
import 'package:sushi_scouts/src/logic/data/cardinalData.dart';
import 'package:sushi_scouts/src/views/util/inputs/NumberInput.dart';

CardinalData? data;

class Cardinal extends StatefulWidget {
  const Cardinal(Key? key) : super(key: key);
  @override
  Pregame createState() => Pregame();
}

class Pregame extends State<Cardinal> {
  void onSubmit(String name, Data value) {
    data?.setPregame(name, value);
  }

  @override
  void initState() {
    if (data == null) {
      Future.delayed(Duration.zero, () async {
        data = await CardinalData.firstCreate();
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> names = data!.getNames(MatchStage.pregame);
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Column(
              children: [NumberInput(name: names[0], onSubmit: onSubmit)],
            )
          ],
        ));
  }
}
