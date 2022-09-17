import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sushi_scouts/src/logic/blocs/scouting_method_bloc/scouting_method_cubit.dart';
import 'package:sushi_scouts/src/logic/constants.dart';
import 'package:sushi_scouts/src/logic/helpers/size/ScreenSize.dart';
import 'package:sushi_scouts/src/logic/models/scouting_data_models/component.dart';
import 'package:sushi_scouts/src/logic/models/scouting_data_models/page.dart';
import 'package:sushi_scouts/src/logic/models/scouting_data_models/scouting_data.dart';
import 'package:sushi_scouts/src/logic/models/scouting_data_models/section.dart';
import 'package:sushi_scouts/src/views/util/footer/scouting_footer.dart';
import 'package:sushi_scouts/src/views/util/header/header_nav.dart';
import 'package:sushi_scouts/src/views/util/header/header_title/header_title.dart';
import 'package:sushi_scouts/src/views/util/scouting_layout.dart';

import '../../../logic/data/Data.dart';
import '../../../logic/data/config_file_reader.dart';
import '../../../logic/deviceType.dart';

class Scouting extends StatefulWidget {
  const Scouting({Key? key}) : super(key: key);
  @override
  ScoutingState createState() => ScoutingState();
}

class ScoutingState extends State<Scouting> {
  ScoutingData? currentScoutingData;
  bool error = false;
  @override
  Widget build(BuildContext context) {
    var isPhoneScreen = isPhone(context);
    var colors = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocBuilder<ScoutingMethodCubit, ScoutingMethodStates>(
        builder: (context, state) {
          var reader = ConfigFileReader.instance;
          if (state is ScoutingMethodsUninitialized) {
            BlocProvider.of<ScoutingMethodCubit>(context)
                .changeMethod(reader.getScoutingMethods()[0], 0);
            return const Text("Loading");
          }
          currentScoutingData = reader
              .getScoutingData((state as ScoutingMethodsInitialized).method);
          return SizedBox(
            width: ScreenSize.width,
            height: ScreenSize.height,
            child: Column(
              children: [
                const HeaderTitle(),
                HeaderNav(currentPage: state.method),
                Padding(
                  padding: EdgeInsets.only(
                      top: ScreenSize.height * (isPhoneScreen ? 0.03 : 0.02)),
                  child: SizedBox(
                    width: ScreenSize.width,
                    height: ScreenSize.height * (isPhoneScreen ? 0.58 : 0.61),
                    child: ScoutingLayout(currentScoutingData: currentScoutingData!, error: (bool b) => error=b),
                  ),
                ),
                if (!error)
                  ScoutingFooter(method: state.method, popupContext: context)
              ],
            ),
          );
        },
      ),
    );
  }
}
