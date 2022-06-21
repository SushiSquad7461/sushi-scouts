import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sushi_scouts/src/logic/enums/Pages.dart';

import '../util/Header/HeaderTitle.dart';
import '../util/footer.dart';
import '../util/header/HeaderNav.dart';

class Pit extends StatelessWidget {
  final ValueChanged changePage;
  const Pit({Key? key, required this.changePage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: ListView(
          children: [
            HeaderTitle(size: size),
            HeaderNav(currentPage: Pages.pit, changePage: changePage, size: size),
            Footer(pageTitle: "Pit", size: size),
          ],
        )
    );
  }
}