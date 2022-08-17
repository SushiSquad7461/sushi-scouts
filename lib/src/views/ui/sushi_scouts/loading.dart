import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sushi_scouts/SushiScoutingLib/logic/data/config_file_reader.dart';
import 'package:sushi_scouts/src/logic/blocs/file_reader_bloc/file_reader_cubit.dart';
import 'package:sushi_scouts/src/logic/blocs/scouting_method_bloc/scouting_method_cubit.dart';
import 'package:sushi_scouts/src/logic/blocs/theme_bloc/theme_cubit.dart';
import 'package:sushi_scouts/src/logic/helpers/routing_helper.dart';
import 'package:sushi_scouts/src/logic/helpers/size/ScreenSize.dart';
import 'package:sushi_scouts/src/views/ui/app_choser.dart';
import 'package:sushi_scouts/src/views/ui/sushi_scouts/login.dart';

import '../../../../SushiScoutingLib/logic/data/config_file_reader.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  LoadingState createState() => LoadingState();
}

class LoadingState extends State<Loading> with TickerProviderStateMixin{
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.bounceIn,
  );
  late Timer _timer;

  LoadingState() {
    _timer = Timer(const Duration(milliseconds: 5200), () {
      RouteHelper.pushReplacement(ctx: context, screen: const AppChooser());
    }); 
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  Future<void> loadConfig() async {
    await BlocProvider.of<ThemeCubit>(context).setMode();
    await BlocProvider.of<FileReaderCubit>(context).readConfig();
    var reader = ConfigFileReader.instance;
    BlocProvider.of<ScoutingMethodCubit>(context).changeMethod(reader.getScoutingMethods()[0], 0);
  }

  @override
  Widget build(BuildContext context) {
    loadConfig();
    return Scaffold(
      body: Center(
        child: RotationTransition(
          turns: _animation,
          child: SvgPicture.asset(
            "./assets/images/${Theme.of(context).scaffoldBackgroundColor == Colors.black ? "darknori" : "nori"}.svg",
            width: ScreenSize.swu*200
          )
        )
      )
    );
  }
}
