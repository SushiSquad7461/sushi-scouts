import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Footer extends StatelessWidget {
  final String pageTitle;
  final bool nextPage;
  final bool previousPage;

  const Footer({Key? key, this.pageTitle="", required this.nextPage, required this.previousPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0, top: 600, bottom: 0),
      child: Column(
        children: [
            Row (
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_left_rounded,
                  color: (previousPage ? Colors.black : Colors.white),
                  size: 100.0,
                  semanticLabel: 'Back Arrow',
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 57,
                    minHeight: 57,
                    maxWidth: 59,
                    maxHeight: 59,
                  ),
                  child: SvgPicture.asset("./assets/images/nori.svg",)
                ),
                Icon(
                  Icons.arrow_right_rounded,
                  color: (nextPage ? Colors.black : Colors.white),
                  size: 100.0,
                  semanticLabel: 'Forward Arrow',
                ),
              ]
            ),
          Image.asset("./assets/images/colorbar.png", scale: 6,),
          Padding(
            padding: const EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 0) ,
            child: Text(
              pageTitle,
              style: const TextStyle(
                fontFamily: "Sushi",
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            )
          )
        ],
      )
    );
  }
}