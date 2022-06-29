import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Footer extends StatelessWidget {
  final String pageTitle;
  final Size size;
  const Footer({Key? key, required this.pageTitle, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Image.asset(
        "./assets/images/colorbar.png",
        scale: 3600.0/size.width,
      ),
      Padding(
          padding: EdgeInsets.only(left: 0, right: 0, top: size.height/90.0, bottom: 0),
          child: Text(
            pageTitle.toUpperCase(),
            style: TextStyle(
              fontFamily: "Sushi",
              fontSize: size.width/24.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ))
    ]);
  }
}
