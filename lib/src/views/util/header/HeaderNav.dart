import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sushi_scouts/src/logic/color/HexColor.dart';
import 'package:sushi_scouts/src/logic/enums/Pages.dart';
import 'package:enum_to_string/enum_to_string.dart';

import '../../../logic/data/cardinalData.dart';

class HeaderNav extends StatelessWidget {

  final Pages currentPage;
  final Function(dynamic, {CardinalData? previousData}) changePage;
  final Size size;

  HeaderNav({Key? key, required this.currentPage, required this.changePage, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double swu = size.width/600.0; //standardized width unit
    double shu = size.width/900.0; //standard height unit
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
              for (final page in Pages.values) if (page != Pages.login) Padding(
                padding: EdgeInsets.only(left: 0, right: 0, top: 8*shu, bottom: 8*shu),
                child: GestureDetector(
                  onTap: () => changePage(page),
                  child: Container(
                    decoration: ((currentPage == page) ?  BoxDecoration(
                        border: Border.all(color: HexColor("#56CBF9"), width: 5*swu),
                        borderRadius: BorderRadius.all(Radius.circular(5*swu)),
                      ) :  BoxDecoration(
                        border: Border.all(color: Color(0xfafafa), width: 5*swu)
                      )
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 4*swu, right: 4*swu, top: 2*shu, bottom: 2*shu),
                      child: Text(
                        EnumToString.convertToString(page).toUpperCase(),
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