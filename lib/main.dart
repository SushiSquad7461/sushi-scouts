import "package:flutter/material.dart";
import 'package:sushi_scouts/src/logic/enums/Pages.dart';
import 'package:sushi_scouts/src/views/ui/Cardinal.dart';
import 'package:sushi_scouts/src/views/ui/Login.dart';
import 'package:sushi_scouts/src/views/ui/Ordinal.dart';
import 'package:sushi_scouts/src/views/ui/Pit.dart';
import 'package:sushi_scouts/src/views/ui/Settings.dart';
import 'package:sushi_scouts/src/views/util/footer.dart';
import 'package:sushi_scouts/src/views/util/Header/HeaderTitle.dart';
import 'package:sushi_scouts/src/views/util/header/HeaderNav.dart';

void main() => runApp(const SushiScouts());

class SushiScouts extends StatefulWidget {
  const SushiScouts({Key? key}) : super(key: key);
  //CardinalData data = await CardinalData.create();
  @override
  State<SushiScouts> createState() => _SushiScoutsState();
}

class _SushiScoutsState extends State<SushiScouts> {
  // TODO: CHANGE VAL TO Pages.login WHEN LOGIN PAGE IS MADE
  Pages _currentPage = Pages.cardinal;

  void setCurrentPage(newPage) {
    setState(() {
      _currentPage = newPage;
    });
  }

  late final Map<Pages, MaterialPage> _pages = {
    Pages.login: const MaterialPage(child: Login()),
    Pages.cardinal: MaterialPage(child: Cardinal(changePage: setCurrentPage,)),
    Pages.ordinal: MaterialPage(child: Ordinal(changePage: setCurrentPage,)),
    Pages.pit: MaterialPage(child: Pit(changePage: setCurrentPage,)),
    Pages.settings: MaterialPage(child: Settings(changePage: setCurrentPage,)),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Navigator(
        pages: [
          _pages[_currentPage]!
        ],
        onPopPage: (route, result) {
          return route.didPop(result);
        },
      )
    );
  }
}