import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sushi_scouts/src/logic/color/HexColor.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:sushi_scouts/src/logic/data/Data.dart';
import '../../../logic/data/ScoutingData.dart';

class HeaderNav extends StatelessWidget {

  final String currentPage;
  final Function(String newPage, String previousPage, {ScoutingData? previousData}) changePage;
  final Size size;
  final List<String> screens;

  HeaderNav({Key? key, required this.currentPage, required this.changePage, required this.size, required this.screens}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double swu = size.width/600.0; //standardized width unit
    double shu = size.width/900.0; //standard height unit
    List<String> allScreens = List<String>.from(screens);
    allScreens.add("settings");
    final TextStyle _pageStyle = TextStyle(
      fontFamily: "Sushi",
      fontSize: 25*swu,
      fontWeight: FontWeight.bold,
    );
    return Padding(
      padding: EdgeInsets.only(left: 0, right: 0, top: 7*shu, bottom: 0),
      child: Column(
        children: [
          Divider(
            color: Colors.black,
            thickness: 6*shu,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (final String screen in allScreens) Padding(
                padding: EdgeInsets.only(left: 0, right: 0, top: 8*shu, bottom: 8*shu),
                child: GestureDetector(
                  onTap: () => changePage(screen, currentPage),
                  child: Container(
                    decoration: ((currentPage == screen) ?  BoxDecoration(
                        border: Border.all(color: HexColor("#56CBF9"), width: 5*swu),
                        borderRadius: BorderRadius.all(Radius.circular(5*swu)),
                      ) :  BoxDecoration(
                        border: Border.all(color: Color(0xfafafa), width: 5*swu)
                      )
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 4*swu, right: 4*swu, top: 2*shu, bottom: 2*shu),
                      child: Text(
                        screen.toUpperCase(),
                        style: GoogleFonts.mohave(
                          textStyle: _pageStyle
                        ),
                      )
                    )
                  )
                )
              )
            ]
          ),
          Divider(
            color: Colors.black,
            thickness: 6*shu,
          ),
        ],
      )
    );
  }
}