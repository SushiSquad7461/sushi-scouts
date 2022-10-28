import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:localstore/localstore.dart';

import '../../../logic/constants.dart';
import '../../../logic/helpers/size/screen_size.dart';
import '../../util/header/header_nav_strategy.dart';
import '../../util/header/header_title/mobile_strategy_main.dart';

class OrdinalRanking extends StatefulWidget {
  const OrdinalRanking({Key? key}) : super(key: key);

  @override
  State<OrdinalRanking> createState() => _OrdinalRankingState();
}

class _OrdinalRankingState extends State<OrdinalRanking> {
  final Map<String, Map<String, double>> ranking = {};

  @override
  void initState() {
    super.initState();
    updateRanking();
  }

  Future<void> updateRanking() async {
    final data =
        await Localstore.instance.collection(ordinalRankDatabaseName).get();

    if (data != null) {
      for (final i in data.keys) {
        print(i.split("/")[2]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            const HeaderTitleMobileStrategyMain(),
            Padding(
              padding: EdgeInsets.only(top: ScreenSize.height * 0.14),
              child: const HeaderNavStrategy(currPage: "ordinal"),
            ),
          ],
        ));
  }
}
