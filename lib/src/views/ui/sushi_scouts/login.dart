import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localstore/localstore.dart';
import 'package:sushi_scouts/SushiScoutingLib/logic/data/config_file_reader.dart';
import 'package:sushi_scouts/SushiScoutingLib/logic/helpers/color/hex_color.dart';
import 'package:sushi_scouts/SushiScoutingLib/logic/helpers/routing_helper.dart';
import 'package:sushi_scouts/SushiScoutingLib/logic/helpers/size/ScreenSize.dart';
import 'package:sushi_scouts/src/logic/blocs/login_bloc/login_cubit.dart';
import 'package:sushi_scouts/src/views/ui/sushi_scouts/scouting.dart';
import 'package:sushi_scouts/src/views/ui/sushi_supervise/upload.dart';
import 'package:sushi_scouts/src/views/util/header/header_title.dart';
import 'package:sushi_scouts/src/views/util/popups/incorrect_password.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  int? teamNum;
  String? name;
  String? eventCode;
  String? password;
  bool supervisor = false;

  TextEditingController _eventCodeController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _teamNumController = new TextEditingController();

  final db = Localstore.instance;
  final reader = ConfigFileReader.instance;

  Future<void> nextPage(BuildContext context) async {
    if (!supervisor) {
      if (teamNum != null && name != null && eventCode != null) {
        await BlocProvider.of<LoginCubit>(context)
            .loginSushiScouts(name!, teamNum!, eventCode!);
        RouteHelper.pushAndRemoveUntilToScreen(0, 0,
            ctx: context, screen: const Scouting());
      }
    } else {
      if ((teamNum != null && name != null && password != null)) {
        await BlocProvider.of<LoginCubit>(context)
            .loginSushiSupervise(name!, teamNum!);
        RouteHelper.pushAndRemoveUntilToScreen(0, 0,
            ctx: context, screen: const Upload());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getSavedInfo();
  }

  Future<void> getSavedInfo() async {
    var userInfo = await db.collection("preferences").doc("user").get();

    if (userInfo != null) {
      setState(() {
        _eventCodeController.text = userInfo["eventCode"];
        eventCode = userInfo["eventCode"];
        _nameController.text = userInfo["name"];
        name = userInfo["name"];
        _teamNumController.text = userInfo["teamNum"].toString();
        teamNum = userInfo["teamNum"];    
      });
    }

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
            child: BlocBuilder<LoginCubit, LoginStates>(
              builder: ((context, state) {
                if (state is LoggedOutSupervise) {
                  supervisor = true;
                } else {
                  supervisor = false;
                }
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Align(
                      alignment: const Alignment(0, -0.9),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: TextButton(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(ScreenSize.swu*10)),
                                  border: Border.all(
                                    color: supervisor ? colors.scaffoldBackgroundColor : HexColor("#81F4E1"),
                                    width: 5 * ScreenSize.swu
                                  )
                                ),
                                child: Text( "SCOUTING",
                                  style: TextStyle( color: colors.primaryColorDark, fontSize: ScreenSize.swu*30),
                                ),
                              ),
                              onPressed: () {
                                password = null;
                                BlocProvider.of<LoginCubit>(context).logOut(false);
                              }
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: TextButton(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(ScreenSize.swu*10)),
                                  border: Border.all(
                                    color: !supervisor ? colors.scaffoldBackgroundColor : HexColor("#81F4E1"),
                                    width: 5 * ScreenSize.swu
                                  )
                                ),
                                child: Text( "SUPERVISING",
                                  style:TextStyle(color: colors.primaryColorDark, fontSize: ScreenSize.swu*30)
                                ),
                              ),
                              onPressed: () {
                                eventCode = null;
                                BlocProvider.of<LoginCubit>(context).logOut(true);
                              } 
                            ),
                          )
                        ],
                      )
                    ),
                    Align(
                      alignment: const Alignment(0, -0.6),
                      child: SizedBox(
                        width: ScreenSize.width * 0.75,
                        height: ScreenSize.height * 0.07,
                        child: TextFormField(
                          controller: _teamNumController,
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
                            contentPadding: EdgeInsets.symmetric(
                                vertical: ScreenSize.height * 0.005),
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
                    !supervisor ?
                    Align(
                      alignment: Alignment(0, -0.2),
                      child: SizedBox(
                        width: ScreenSize.width * 0.75,
                        height: ScreenSize.height * 0.07,
                        child: TextFormField(
                            controller: _eventCodeController,
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
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: ScreenSize.height * 0.005),
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
                    ) : 
                    Align(
                      alignment: Alignment(0, -0.2),
                      child: SizedBox(
                        width: ScreenSize.width * 0.75,
                        height: ScreenSize.height * 0.07,
                        child: TextFormField(
                            controller: _eventCodeController,
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
                              hintText: "PASSWORD",
                              hintStyle: TextStyle(color: colors.primaryColorDark),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: ScreenSize.height * 0.005),
                            ),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.mohave(
                                textStyle: TextStyle(
                              fontSize: ScreenSize.width * 0.07,
                              color: colors.primaryColorDark,
                            )),
                            onChanged: (String? val) => setState(() {
                                  password = val;
                                })),
                      ),
                    ),
                    Align(
                      alignment: Alignment(0, 0.2),
                      child: SizedBox(
                        width: ScreenSize.width * 0.75,
                        height: ScreenSize.height * 0.07,
                        child: TextFormField(
                            controller: _nameController,
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
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: ScreenSize.height * 0.005),
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
                          if (teamNum != null && name != null && (eventCode != null || password != null))
                            Padding(
                              padding:
                                  EdgeInsets.only(top: ScreenSize.height * 0.2),
                              child: Container(
                                  width: ScreenSize.width,
                                  decoration: BoxDecoration(
                                    color: colors.primaryColorDark,
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      if(supervisor && !reader.checkPassword(password??"")) {
                                        showDialog(
                                          context: context,
                                          builder: (context) => IncorrectPassword()
                                        );
                                      } else {
                                        nextPage(context);
                                      }
                                    },
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
                );
              })
            ),
          ),
        ],
      ),
    );
  }
}
