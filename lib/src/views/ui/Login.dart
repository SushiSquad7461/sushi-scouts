import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sushi_scouts/src/logic/size/ScreenSize.dart';
import 'package:sushi_scouts/src/views/util/components/TextInput.dart';

import '../../logic/data/Data.dart';
import '../util/Header/HeaderTitle.dart';
import '../util/Footer/Footer.dart';
import '../util/header/HeaderNav.dart';

class Login extends StatefulWidget {
  final Function(String newPage) changePage;
  const Login({Key? key, required this.changePage}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  int? teamNum;
  String? name;
  String? eventCode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: ScreenSize.height * 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: ScreenSize.width * 0.75,
            height: ScreenSize.height * 0.07,
            child: TextFormField(
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      width: ScreenSize.height * 0.006, color: Colors.black),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      width: ScreenSize.height * 0.006, color: Colors.black),
                ),
                hintText: "TEAM #",
                hintStyle: const TextStyle(color: Colors.black),
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: ScreenSize.height * 0.005),
              ),
              textAlign: TextAlign.center,
              style: GoogleFonts.mohave(
                  textStyle: TextStyle(
                fontSize: ScreenSize.width * 0.07,
                color: Colors.black,
              )),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              onFieldSubmitted: (String? val) => setState(() {
                teamNum = (val != null ? int.parse(val) : val) as int?;
              }),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: ScreenSize.height * 0.12),
            child: SizedBox(
              width: ScreenSize.width * 0.75,
              height: ScreenSize.height * 0.07,
              child: TextFormField(
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          width: ScreenSize.height * 0.006,
                          color: Colors.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          width: ScreenSize.height * 0.006,
                          color: Colors.black),
                    ),
                    hintText: "EVENT CODE",
                    hintStyle: const TextStyle(color: Colors.black),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                        vertical: ScreenSize.height * 0.005),
                  ),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.mohave(
                      textStyle: TextStyle(
                    fontSize: ScreenSize.width * 0.07,
                    color: Colors.black,
                  )),
                  onFieldSubmitted: (String? val) => setState(() {
                        eventCode = val;
                      })),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: ScreenSize.height * 0.12),
            child: SizedBox(
              width: ScreenSize.width * 0.75,
              height: ScreenSize.height * 0.07,
              child: TextFormField(
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          width: ScreenSize.height * 0.006,
                          color: Colors.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          width: ScreenSize.height * 0.006,
                          color: Colors.black),
                    ),
                    hintText: "NAME",
                    hintStyle: const TextStyle(color: Colors.black),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                        vertical: ScreenSize.height * 0.005),
                  ),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.mohave(
                      textStyle: TextStyle(
                    fontSize: ScreenSize.width * 0.07,
                    color: Colors.black,
                  )),
                  onFieldSubmitted: (String? val) => setState(() {
                        name = val;
                  })),
            ),
          ),
          Stack(
            children: [
              SvgPicture.asset(
                "./assets/images/FooterColors.svg",
                width: ScreenSize.width,
              ),
              if (teamNum != null && name != null && eventCode != null)
                Padding(
                  padding: EdgeInsets.only(top: ScreenSize.height * 0.2),
                  child: Container(
                      width: ScreenSize.width,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                      ),
                      child: TextButton(
                        onPressed: () => widget.changePage("cardinal"),
                        child: Text(
                          'GO',
                          style: TextStyle(
                              fontSize: 35 * ScreenSize.swu,
                              fontFamily: "Sushi",
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
