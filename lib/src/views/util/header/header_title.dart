import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sushi_scouts/SushiScoutingLib/logic/helpers/size/ScreenSize.dart';
import 'package:sushi_scouts/src/logic/deviceType.dart';
import 'package:sushi_scouts/src/views/util/header/header_title_mobile.dart';
import 'package:sushi_scouts/src/views/util/header/header_title_tablet.dart';

class HeaderTitle extends StatelessWidget {
  const HeaderTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isPhone(context) ? const HeaderTitleMobile() : const HeaderTitleTablet();
  }
}
