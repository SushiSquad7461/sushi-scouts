import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sushi_scouts/src/logic/color/HexColor.dart';
import 'package:sushi_scouts/src/logic/size/ScreenSize.dart';
import '../../../logic/data/ScoutingData.dart';

class HeaderNav extends StatelessWidget {
  final String currentPage;
  final Function(String newPage) changePage;
  List<String> screens;

  HeaderNav(
      {Key? key,
      required this.currentPage,
      required this.changePage,
      required this.screens})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle pageStyle = TextStyle(
      fontSize: 25 * ScreenSize.swu,
      fontWeight: FontWeight.w700,
    );

    return Padding(
        padding: EdgeInsets.only(left: 0, right: 0, top: 7 * ScreenSize.shu, bottom: 0),
        child: Column(
          children: [
            Divider(
              color: Colors.black,
              thickness: 4 * ScreenSize.shu,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              for (final String screen in screens)
                Padding(
                    padding: EdgeInsets.only(
                        left: 0, right: 0, top: 0 * ScreenSize.shu, bottom: 0 * ScreenSize.shu),
                    child: GestureDetector(
                        onTap: () => changePage(screen),
                        child: Container(
                            decoration: ((currentPage == screen)
                                ? BoxDecoration(
                                    border: Border.all(
                                        color: HexColor("#56CBF9"),
                                        width: 5 * ScreenSize.shu),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(5 * ScreenSize.swu)),
                                  )
                                : BoxDecoration(
                                    border: Border.all(
                                        color: Color(0xfafafa),
                                        width: 5 * ScreenSize.swu))),
                            child: Padding(
                                padding: EdgeInsets.only(
                                    left: 8 * ScreenSize.swu,
                                    right: 8 * ScreenSize.swu,
                                    top: 2 * ScreenSize.swu,
                                    bottom: 2 * ScreenSize.swu),
                                child: Text(
                                  screen.toUpperCase(),
                                  style:
                                      GoogleFonts.mohave(textStyle: pageStyle),
                                )))))
            ]),
            Divider(
              color: Colors.black,
              thickness: 4 * ScreenSize.shu,
            ),
          ],
        ));
  }
}