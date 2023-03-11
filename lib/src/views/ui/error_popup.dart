import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

// Package imports:
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_svg/svg.dart";
import "package:localstore/localstore.dart";

// Project imports:
import "../../logic/blocs/login_bloc/login_cubit.dart";
import "../../logic/data/config_file_reader.dart";
import '../../logic/types/device_type.dart';
import "../../logic/helpers/color/hex_color.dart";
import "../../logic/helpers/routing_helper.dart";
import "../../logic/helpers/size/screen_size.dart";
import '../../logic/types/login_type.dart';
import "../util/header/header_title/header_title.dart";
import "../util/popups/incorrect_password.dart";
import 'app_choser.dart';
import "sushi_scouts/scouting.dart";
import "sushi_strategy/robot_profiles.dart";
import "sushi_supervise/upload.dart";
import "../../logic/helpers/style/text_style.dart";

class ErrorPopup extends StatelessWidget {
  final String errorText;
  const ErrorPopup({Key? key, required this.errorText}) : super(key: key);

  static ErrorPopup onError(Object exception, StackTrace stackTrace) {
    String txt = exception.toString();
    return ErrorPopup(errorText: txt);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
        child: Container(
            color: Color.fromARGB(255, 255, 0, 0),
            child: SizedBox(
              child: Center(
                child: Text(errorText,
                    style: TextStyles.getTitleText(10, Colors.white)),
              ),
              width: 100,
              height: 100,
            )));
  }
}
