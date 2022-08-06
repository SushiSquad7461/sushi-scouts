import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localstore/localstore.dart';
import 'package:sushi_scouts/SushiScoutingLib/logic/data/config_file_reader.dart';
import 'package:sushi_scouts/SushiScoutingLib/logic/helpers/routing_helper.dart';
import 'package:sushi_scouts/SushiScoutingLib/logic/helpers/size/ScreenSize.dart';
import 'package:sushi_scouts/src/views/ui/scouting.dart';
import 'package:sushi_scouts/src/views/util/header/header_title.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  int? teamNum;
  String? name;
  String? eventCode;
  final db = Localstore.instance;

  void nextPage() async{
    await db.collection("preferences").doc("user").set({
      "teamNum": teamNum,
      "name": name,
      "eventCode": eventCode,
    });
    RouteHelper.pushAndRemoveUntilToScreen(ctx: context, screen: const Scouting());
  }

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          const HeaderTitle(),
          SizedBox(
            width: ScreenSize.width,
            height: ScreenSize.height * 0.9,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Align(
                  alignment: Alignment(0, -0.8),
                  child: SizedBox(
                    width: ScreenSize.width * 0.75,
                    height: ScreenSize.height * 0.07,
                    child: TextFormField(
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              width: ScreenSize.height * 0.006,
                              color: colors.primaryColorDark),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              width: ScreenSize.height * 0.006,
                              color: colors.primaryColorDark),
                        ),
                        hintText: "TEAM #",
                        hintStyle: TextStyle(color: colors.primaryColorDark),
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: ScreenSize.height * 0.005),
                      ),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.mohave(
                          textStyle: TextStyle(
                        fontSize: ScreenSize.width * 0.07,
                        color: colors.primaryColorDark,
                      )),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      onChanged: (String? val) => setState(() {
                        teamNum = (val != null ? int.parse(val) : val) as int?;
                      }),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment(0, -0.3),
                  child: SizedBox(
                    width: ScreenSize.width * 0.75,
                    height: ScreenSize.height * 0.07,
                    child: TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                width: ScreenSize.height * 0.006,
                                color: colors.primaryColorDark),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                width: ScreenSize.height * 0.006,
                                color: colors.primaryColorDark),
                          ),
                          hintText: "EVENT CODE",
                          hintStyle: TextStyle(color: colors.primaryColorDark),
                          isDense: true,
                          contentPadding:
                              EdgeInsets.symmetric(vertical: ScreenSize.height * 0.005),
                        ),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.mohave(
                            textStyle: TextStyle(
                          fontSize: ScreenSize.width * 0.07,
                          color: colors.primaryColorDark,
                        )),
                        onChanged: (String? val) => setState(() {
                              eventCode = val;
                            })),
                  ),
                ),
                Align(
                  alignment: Alignment(0, 0.2),
                  child: SizedBox(
                    width: ScreenSize.width * 0.75,
                    height: ScreenSize.height * 0.07,
                    child: TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                width: ScreenSize.height * 0.006,
                                color: colors.primaryColorDark),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                width: ScreenSize.height * 0.006,
                                color: colors.primaryColorDark),
                          ),
                          hintText: "NAME",
                          hintStyle: TextStyle(color: colors.primaryColorDark),
                          isDense: true,
                          contentPadding:
                              EdgeInsets.symmetric(vertical: ScreenSize.height * 0.005),
                        ),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.mohave(
                            textStyle: TextStyle(
                          fontSize: ScreenSize.width * 0.07,
                          color: colors.primaryColorDark,
                        )),
                        onChanged: (String? val) => setState(() {
                              name = val;
                            })),
                  ),
                ),
                Align(
                  alignment: Alignment(0, 1),
                  child: Stack(
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
                              decoration: BoxDecoration(
                                color: colors.primaryColorDark,
                              ),
                              child: TextButton(
                                onPressed: nextPage,
                                child: Text(
                                  'GO',
                                  style: TextStyle(
                                      fontSize: 35 * ScreenSize.swu,
                                      fontFamily: "Sushi",
                                      color: colors.primaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
