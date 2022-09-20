// Flutter imports:
import "package:flutter/material.dart";

// Project imports:
import "../../../../logic/device_type.dart";
import "mobile.dart";
import "mobile_supervise.dart";
import "tablet.dart";
import "tablet_supervise.dart";

class HeaderTitle extends StatelessWidget {
  final bool isSupervise;
  const HeaderTitle({Key? key, this.isSupervise = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isPhone(context)
        ? (!isSupervise
            ? const HeaderTitleMobile()
            : const HeaderTitleMobileSupervise())
        : (isSupervise
            ? const HeaderTitleTabletSupervise()
            : const HeaderTitleTablet());
  }
}
