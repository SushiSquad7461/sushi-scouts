// Flutter imports:
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

// Package imports:
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:localstore/localstore.dart";

// Project imports:
import "../../logic/blocs/login_bloc/login_cubit.dart";
import "../../logic/data/config_file_reader.dart";
import "../../logic/device_type.dart";
import "../../logic/helpers/color/hex_color.dart";
import "../../logic/helpers/routing_helper.dart";
import "../../logic/helpers/size/screen_size.dart";
import "../../logic/login_type.dart";
import "../util/header/header_title/header_title.dart";
import "../util/popups/incorrect_password.dart";
import "sushi_scouts/scouting.dart";
import "sushi_strategy/robot_profiles.dart";
import "sushi_supervise/upload.dart";

class Login extends StatefulWidget {
  final LoginType type;
  const Login({Key? key, this.type = LoginType.scout}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  int? teamNum;
  String? name;
  String? eventCode;
  String? password;

  final TextEditingController _eventCodeController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _teamNumController = TextEditingController();

  final db = Localstore.instance;
  final reader = ConfigFileReader.instance;

  Future<void> nextPage(BuildContext context) async {
    switch (widget.type) {
      case LoginType.scout:
        if (teamNum != null && name != null && eventCode != null) {
          await BlocProvider.of<LoginCubit>(context)
              .loginSushiScouts(name!, teamNum!, eventCode!);
          RouteHelper.pushAndRemoveUntilToScreen(0, 0,
              ctx: context, screen: const Scouting());
        }
        break;
      case LoginType.supervise:
        if ((teamNum != null && eventCode != null && password != null)) {
          await BlocProvider.of<LoginCubit>(context)
              .loginSushiSupervise(eventCode!, teamNum!);
          RouteHelper.pushAndRemoveUntilToScreen(0, 0,
              ctx: context, screen: const Upload());
        }
        break;
      case LoginType.strategy:
        if (teamNum != null && name != null && eventCode != null) {
          await BlocProvider.of<LoginCubit>(context)
              .loginSushiStrategy(name!, teamNum!, eventCode!);
          RouteHelper.pushAndRemoveUntilToScreen(0, 0,
              ctx: context, screen: const RobotProfiles());
        }
        break;
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
        if (userInfo["eventCode"] != null && userInfo["eventCode"] != "") {
          _eventCodeController.text = userInfo["eventCode"];
          eventCode = userInfo["eventCode"];
        }

        if (widget.type != LoginType.strategy) {
          if (userInfo["name"] != null && userInfo["name"] != "") {
            _nameController.text = userInfo["name"];
            name = userInfo["name"];
          }
        }

        if (userInfo["teamNum"] != null && userInfo["teamNum"] != "") {
          _teamNumController.text = userInfo["teamNum"].toString();
          teamNum = userInfo["teamNum"];
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context);
    bool isPhoneScreen = isPhone(context);

    String footerAsset = "./assets/images";

    switch (widget.type) {
      case LoginType.strategy:
        footerAsset = "$footerAsset/stratloginfooter.svg";
        break;
      case LoginType.supervise:
        footerAsset =
            "$footerAsset/${isPhoneScreen ? "mobilesupervisefooter.svg" : colors.scaffoldBackgroundColor == Colors.black ? "loginsupervisefooterdark.svg" : "./assets/images/loginfootersupervise.svg"}";
        break;
      case LoginType.scout:
        footerAsset =
            "$footerAsset/${isPhoneScreen ? "mobile_footer.svg" : "colorbar.svg"}";
        break;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          HeaderTitle(type: widget.type),
          if (widget.type == LoginType.strategy)
            Container(
              width: ScreenSize.width,
              height: ScreenSize.height * 0.03,
              decoration: BoxDecoration(
                  color: colors.primaryColorDark,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10 * ScreenSize.swu),
                      bottomLeft: Radius.circular(10 * ScreenSize.swu))),
            ),
          SizedBox(
            width: ScreenSize.width,
            height: ScreenSize.height *
                (isPhoneScreen
                    ? (widget.type == LoginType.scout
                        ? 0.89
                        : widget.type == LoginType.strategy
                            ? 0.83
                            : 0.88)
                    : 0.9),
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.bottomCenter,
              children: [
                Align(
                  alignment:
                      Alignment(0, widget.type == LoginType.strategy ? 1.1 : 1),
                  child: Stack(
                    children: [
                      SvgPicture.asset(
                        footerAsset,
                        width: ScreenSize.width * 1,
                        fit: BoxFit.fitWidth,
                      ),
                      if (teamNum != null &&
                          eventCode != null &&
                          (name != null || password != null))
                        Padding(
                          padding: EdgeInsets.only(
                            top: ScreenSize.height *
                                (isPhoneScreen
                                    ? isPhoneScreen
                                        ? widget.type == LoginType.strategy
                                            ? 0.08
                                            : widget.type == LoginType.scout
                                                ? 0.15
                                                : 0.085
                                        : (widget.type == LoginType.scout
                                            ? 0.32
                                            : 0.09)
                                    : 0.2),
                            left: ScreenSize.width *
                                (isPhoneScreen
                                    ? widget.type == LoginType.strategy
                                        ? 0.15
                                        : 0.075
                                    : 0),
                            // bottom: ScreenSize.height *
                            //     (isPhoneScreen
                            //         ? (widget.type == LoginType.scout
                            //             ? 0.12
                            //             : 0.085)
                            //         : 0),
                          ),
                          child: Container(
                              width: ScreenSize.width *
                                  (isPhoneScreen
                                      ? widget.type == LoginType.strategy
                                          ? 0.7
                                          : 0.85
                                      : 1),
                              height: ScreenSize.height * 0.06,
                              decoration: BoxDecoration(
                                color: widget.type == LoginType.supervise &&
                                        isPhoneScreen
                                    ? HexColor("#4F4F4F")
                                    : colors.primaryColorDark,
                                borderRadius: BorderRadius.all(Radius.circular(
                                    ScreenSize.swu * (isPhoneScreen ? 20 : 0))),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  if (widget.type == LoginType.supervise &&
                                      !reader.checkPassword(password ?? "")) {
                                    showDialog(
                                        context: context,
                                        builder: (context) =>
                                            const IncorrectPassword());
                                  } else {
                                    nextPage(context);
                                  }
                                },
                                child: Text(
                                  "GO",
                                  style: TextStyle(
                                      fontSize: 35 * ScreenSize.swu,
                                      fontFamily: "Sushi",
                                      color: colors.primaryColor,
                                      fontWeight: widget.type == LoginType.scout
                                          ? FontWeight.bold
                                          : FontWeight.w100),
                                ),
                              )),
                        ),
                    ],
                  ),
                ),
                Align(
                  alignment: const Alignment(0, -0.9),
                  child: SizedBox(
                    width: ScreenSize.width * 0.75,
                    height: ScreenSize.height * 0.07,
                    child: TextFormField(
                      controller: _teamNumController,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              width: ScreenSize.height *
                                  (isPhoneScreen ? 0.004 : 0.006),
                              color: colors.primaryColorDark),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              width: ScreenSize.height *
                                  (isPhoneScreen ? 0.004 : 0.006),
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
                Align(
                  alignment: const Alignment(0, -0.4),
                  child: SizedBox(
                    width: ScreenSize.width * 0.75,
                    height: ScreenSize.height * 0.07,
                    child: TextFormField(
                        controller: _eventCodeController,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                width: ScreenSize.height *
                                    (isPhoneScreen ? 0.004 : 0.006),
                                color: colors.primaryColorDark),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                width: ScreenSize.height *
                                    (isPhoneScreen ? 0.004 : 0.006),
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
                ),
                widget.type != LoginType.supervise
                    ? Align(
                        alignment: const Alignment(0, 0.1),
                        child: SizedBox(
                          width: ScreenSize.width * 0.75,
                          height: ScreenSize.height * 0.07,
                          child: TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width: ScreenSize.height *
                                          (isPhoneScreen ? 0.004 : 0.006),
                                      color: colors.primaryColorDark),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width: ScreenSize.height *
                                          (isPhoneScreen ? 0.004 : 0.006),
                                      color: colors.primaryColorDark),
                                ),
                                hintText: "NAME",
                                hintStyle:
                                    TextStyle(color: colors.primaryColorDark),
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
                      )
                    : Align(
                        alignment: const Alignment(0, 0.2),
                        child: SizedBox(
                          width: ScreenSize.width * 0.75,
                          height: ScreenSize.height * 0.07,
                          child: TextFormField(
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width: ScreenSize.height *
                                          (isPhoneScreen ? 0.004 : 0.006),
                                      color: colors.primaryColorDark),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      width: ScreenSize.height *
                                          (isPhoneScreen ? 0.004 : 0.006),
                                      color: colors.primaryColorDark),
                                ),
                                hintText: "PASSWORD",
                                hintStyle:
                                    TextStyle(color: colors.primaryColorDark),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
