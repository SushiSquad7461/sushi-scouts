import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sushi_scouts/src/logic/color/HexColor.dart';

class HeaderNav extends StatelessWidget {
  final List<String> _pages = const ["ORDINAL", "CARDINAL", "PIT", "SETTINGS"];
  final TextStyle _pageStyle = const TextStyle(
    fontFamily: "Sushi",
    fontSize: 25,
    fontWeight: FontWeight.bold,
  );

  final String currentPage;

  const HeaderNav({Key? key, required this.currentPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0, top: 7, bottom: 0),
      child: Column(
        children: [
          const Divider(
            color: Colors.black,
            thickness: 6,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (final page in _pages) Padding(
                padding: const EdgeInsets.only(left: 0, right: 0, top: 8, bottom: 8),
                child: Container(
                  decoration: ((currentPage == page) ?  BoxDecoration(
                      border: Border.all(color: HexColor("#56CBF9"), width: 5),
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                    ) :  BoxDecoration(
                      border: Border.all(color: Colors.white)
                    )
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4, right: 4, top: 2, bottom: 2),
                    child: Text(
                      page,
                      style: GoogleFonts.mohave(
                        textStyle: _pageStyle
                      ),
                    )
                  )
                )
              )
            ]
          ),
          const Divider(
            color: Colors.black,
            thickness: 6,
          ),
        ],
      )
    );
  }
}