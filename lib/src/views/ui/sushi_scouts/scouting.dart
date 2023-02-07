// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:flutter_bloc/flutter_bloc.dart";

// Project imports:
import "../../../logic/blocs/scouting_method_bloc/scouting_method_cubit.dart";
import "../../../logic/data/config_file_reader.dart";
import '../../../logic/types/device_type.dart';
import "../../../logic/helpers/size/screen_size.dart";
import "../../../logic/models/scouting_data_models/scouting_data.dart";
import "../../util/footer/scouting_footer.dart";
import "../../util/header/header_nav.dart";
import "../../util/header/header_title/header_title.dart";
import "../../util/scouting_layout.dart";

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
    // var colors = Theme.of(context);

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
                    child: ScoutingLayout(
                        currentScoutingData: currentScoutingData!,
                        error: (bool b) => error = b,
                        size: ScreenSize.get()),
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
