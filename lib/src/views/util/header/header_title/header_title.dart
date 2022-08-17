import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sushi_scouts/src/logic/deviceType.dart';
import 'package:sushi_scouts/src/views/util/header/header_title/mobile.dart';
import 'package:sushi_scouts/src/views/util/header/header_title/tablet.dart';
import 'package:sushi_scouts/src/views/util/header/header_title/tablet_supervise.dart';

class HeaderTitle extends StatelessWidget {
  final bool isSupervise;
  const HeaderTitle({Key? key, this.isSupervise = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isPhone(context)
        ? const HeaderTitleMobile()
        : (isSupervise ? const HeaderTitleTabletSupervise() : const HeaderTitleTablet());
  }
}
