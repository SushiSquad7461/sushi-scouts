import "package:flutter/material.dart";
import 'package:sushi_scouts/src/views/util/footer.dart';

void main() => runApp(SushiScouts());

class SushiScouts extends StatelessWidget {
  const SushiScouts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListView(
          children: const [
            Footer(nextPage: true, previousPage: true, pageTitle: "AUTO",)
          ],
        )
      )
    );
  }
}