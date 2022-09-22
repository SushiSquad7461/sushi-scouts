// Flutter imports:
import "package:flutter/material.dart";

// Project imports:
import "../../../../logic/device_type.dart";
import "mobile.dart";
import "mobile_supervise.dart";
import "tablet.dart";
import "tablet_supervise.dart";
import '../../../../logic/login_type.dart';
import 'mobile_strategy_login.dart';

class HeaderTitle extends StatelessWidget {
  final LoginType type;
  const HeaderTitle({Key? key, this.type = LoginType.scout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool phone = isPhone(context);
    switch (type) {
      case LoginType.scout:
        return phone ? const HeaderTitleMobile() : const HeaderTitleTablet();
      case LoginType.supervise:
        return phone
            ? const HeaderTitleMobileSupervise()
            : const HeaderTitleTabletSupervise();
      case LoginType.strategy:
        return const HeaderTitleMobileStrategyLogin();
    }
  }
}
