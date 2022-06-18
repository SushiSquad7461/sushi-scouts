import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sushi_scouts/src/logic/enums/Pages.dart';

import '../util/Header/HeaderTitle.dart';
import '../util/footer.dart';
import '../util/header/HeaderNav.dart';

class Ordinal extends StatelessWidget {
  final ValueChanged changePage;
  const Ordinal({Key? key, required this.changePage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
          children: [
            const HeaderTitle(),
            HeaderNav(currentPage: Pages.ordinal, changePage: changePage,),
            const Footer(),
          ],
        )
    );
  }
}