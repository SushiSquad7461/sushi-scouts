// Dart imports:
import "dart:async";

// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_svg/flutter_svg.dart";

// Project imports:
import "../../logic/blocs/file_reader_bloc/file_reader_cubit.dart";
import "../../logic/blocs/scouting_method_bloc/scouting_method_cubit.dart";
import "../../logic/blocs/theme_bloc/theme_cubit.dart";
import "../../logic/data/config_file_reader.dart";
import "../../logic/helpers/routing_helper.dart";
import "../../logic/helpers/size/screen_size.dart";
import "app_choser.dart";

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  LoadingState createState() => LoadingState();
}

class LoadingState extends State<Loading> with TickerProviderStateMixin {
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
    _timer = Timer(const Duration(milliseconds: 2000), () {
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

    if (!mounted) return;
    await BlocProvider.of<FileReaderCubit>(context).readConfig();

    var reader = ConfigFileReader.instance;

    if (!mounted) return;
    BlocProvider.of<ScoutingMethodCubit>(context).changeMethod(
        reader.getScoutingMethods().isNotEmpty
            ? reader.getScoutingMethods()[0]
            : "",
        0);
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
                    width: ScreenSize.swu * 200))));
  }
}
