// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

// Project imports:
import '../../util/header/header_nav_strategy.dart';
import '../../util/header/header_title/mobile_strategy_main.dart';

class RobotProfiles extends StatefulWidget {
  const RobotProfiles({Key? key}) : super(key: key);

  @override
  State<RobotProfiles> createState() => _RobotProfilesState();
}

class _RobotProfilesState extends State<RobotProfiles> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: const [
          HeaderTitleMobileStrategyMain(),
          HeaderNavStrategy(currPage: "ordinal"),
        ],
      )
    );
  }
}
