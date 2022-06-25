import "package:flutter/material.dart";
import 'package:sushi_scouts/src/logic/data/cardinalData.dart';
import 'package:sushi_scouts/src/logic/enums/Pages.dart';
import 'package:sushi_scouts/src/views/ui/Cardinal.dart';
import 'package:sushi_scouts/src/views/ui/Login.dart';
import 'package:sushi_scouts/src/views/ui/Ordinal.dart';
import 'package:sushi_scouts/src/views/ui/Pit.dart';
import 'package:sushi_scouts/src/views/ui/QRScreen.dart';
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
  Pages _previousPage = Pages.cardinal;
  CardinalData? previousCardinalData;
  final  GlobalKey<NavigatorState> navigatorKey =  GlobalKey<NavigatorState>();

  void setCurrentPage(newPage, {CardinalData? previousData=null, Pages? previousPage = null}) {
    print("changing");
    if(previousData != null){
      print("setting");
      previousCardinalData=previousData;
      print(previousCardinalData!.stringfy());
    }
    if(previousPage != null) {
      _previousPage = previousPage;
    }
    setState(() {
      _currentPage = newPage;
      print(_currentPage.toString());
    });
    build(context);
  }

  late final Map<Pages, MaterialPage> _pages = {
    Pages.login: const MaterialPage(child: Login()),
    Pages.cardinal: MaterialPage(child: Cardinal(changePage: setCurrentPage, previousData: previousCardinalData)),
    Pages.ordinal: MaterialPage(child: Ordinal(changePage: setCurrentPage,)),
    Pages.pit: MaterialPage(child: Pit(changePage: setCurrentPage,)),
    Pages.settings: MaterialPage(child: Settings(changePage: setCurrentPage,)),
    Pages.qrcode: MaterialPage(child: QRScreen(changePage: setCurrentPage, previousPage: _previousPage, cardinalData: previousCardinalData))
  };


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Navigator(
        key: navigatorKey,
        pages: <Page<void>>[
          if(_currentPage==Pages.qrcode)
            MaterialPage(child: QRScreen(changePage: setCurrentPage, previousPage: _previousPage, cardinalData: previousCardinalData))
          else
            _pages[_currentPage]!
        ],
        onPopPage: (route, result) {
          return route.didPop(result);
        },
      )
    );
  }
}