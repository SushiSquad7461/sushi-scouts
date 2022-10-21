// Flutter imports:
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';

// Package imports:
import "package:flutter_svg/svg.dart";
import 'package:localstore/localstore.dart';

// Project imports:
import '../../../../logic/blocs/login_bloc/login_cubit.dart';
import '../../../../logic/blocs/theme_bloc/theme_cubit.dart';
import "../../../../logic/helpers/color/hex_color.dart";
import "../../../../logic/helpers/size/screen_size.dart";
import '../../../../logic/network/api_repository.dart';

class HeaderTitleMobileStrategyMain extends StatefulWidget {
  const HeaderTitleMobileStrategyMain({Key? key}) : super(key: key);

  @override
  State<HeaderTitleMobileStrategyMain> createState() =>
      _HeaderTitleMobileStrategyMainState();
}

class _HeaderTitleMobileStrategyMainState
    extends State<HeaderTitleMobileStrategyMain> {
  final Localstore db = Localstore.instance;
  String rank = "";

  @override
  void initState() {
    super.initState();
    updateTeamNum();
  }

  @override
  void didUpdateWidget(covariant HeaderTitleMobileStrategyMain oldWidget) {
    super.didUpdateWidget(oldWidget);
    updateTeamNum();
  }

  Future<void> updateTeamNum() async {
    String newRank = (await db.collection("frcapi").doc("rank").get())!["rank"];
    setState(() {
      rank = newRank;
    });
  }

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context);

    return Container(
      color: colors.primaryColorDark,
      height: ScreenSize.height * 0.14,
      width: ScreenSize.width * 1,
      child: Stack(alignment: Alignment.centerLeft, children: [
        SvgPicture.asset(
          "./assets/images/stratgeymainheader.svg",
          height: ScreenSize.height * 0.12,
        ),
        Padding(
          padding: EdgeInsets.only(
            top: ScreenSize.height * 0.08,
            left: ScreenSize.width * 0.55,
          ),
          child: SizedBox(
            width: ScreenSize.width * 0.378,
            height: ScreenSize.height * 0.043,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  BlocProvider.of<LoginCubit>(context).state.teamNum.toString(),
                  style: TextStyle(
                    color: colors.primaryColor,
                    fontFamily: "Sushi",
                    fontSize: ScreenSize.height * 0.045,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: ScreenSize.height * 0.008),
                  child: SvgPicture.asset(
                    "./assets/images/uparrow.svg",
                    height: ScreenSize.height * 0.03,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: ScreenSize.height * 0.006),
                  child: Text(
                    rank,
                    style: TextStyle(
                      color: HexColor("#81F4E1"),
                      fontFamily: "Sushi",
                      fontSize: ScreenSize.height * 0.035,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
