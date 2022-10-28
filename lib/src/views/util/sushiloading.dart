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

class SushiLoading extends StatefulWidget {
  const SushiLoading({Key? key}) : super(key: key);

  @override
  SushiLoadingState createState() => SushiLoadingState();
}

class SushiLoadingState extends State<SushiLoading> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.bounceIn,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
            child: RotationTransition(
                turns: _animation,
                child: SvgPicture.asset(
                    "./assets/images/${Theme.of(context).scaffoldBackgroundColor == Colors.black ? "darknori" : "nori"}.svg",
                    width: ScreenSize.swu * 200)));
  }
}
