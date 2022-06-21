import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sushi_scouts/src/logic/data/cardinalData.dart';

class Footer extends StatelessWidget {
  final String pageTitle;

  const Footer({Key? key, required this.pageTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Image.asset(
        "./assets/images/colorbar.png",
        scale: 6,
      ),
      Padding(
          padding: const EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 0),
          child: Text(
            pageTitle,
            style: const TextStyle(
              fontFamily: "Sushi",
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ))
    ]);
  }
}
