import "package:flutter/material.dart";
import 'package:sushi_scouts/src/logic/Constants.dart';
import 'package:sushi_scouts/src/logic/data/ConfigFileReader.dart';
import 'package:sushi_scouts/src/logic/data/ScoutingData.dart';
import 'package:sushi_scouts/src/logic/size/ScreenSize.dart';
import 'package:sushi_scouts/src/views/ui/Loading.dart';
import 'package:sushi_scouts/src/views/ui/Login.dart';
import 'package:sushi_scouts/src/views/ui/Scouting.dart';
import 'package:sushi_scouts/src/views/util/header/HeaderNav.dart';
import 'package:sushi_scouts/src/views/util/header/HeaderTitle.dart';

void main() => runApp(const Wraper());

class Wraper extends StatelessWidget {
  const Wraper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SushiScouts(),
      ),
    );
  }
}

class SushiScouts extends StatefulWidget {
  const SushiScouts({Key? key}) : super(key: key);

  @override
  State<SushiScouts> createState() => _SushiScoutsState();
}

class _SushiScoutsState extends State<SushiScouts> {
  // CHANGE HOW YEAR WORKS
  ConfigFileReader fileReader = ConfigFileReader(CONFIG_FILE_PATH, 2022);
  String _currentPage = "loading";
  Map<String, ScoutingData> scoutingPages = {};
  List<String> _headerNavNeeded = [];
  String currErr = "";

  // Change current page
  void setCurrentPage(newPage) {
    setState(() {
      _currentPage = newPage;
    });
  }

  Future<void> readConfigFile() async {
    try {
      await fileReader.readConfig();

      setState(() {
        for (var i in fileReader.getScoutingDataClasses()) {
          scoutingPages[i.name] = i;
        }
        _headerNavNeeded = fileReader.getScoutingMethods();
        _headerNavNeeded.add("settings");

        _currentPage = "cardinal";
      });
    } catch (err) {
      setState(() {
        _currentPage = "error";
        currErr = err.toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    readConfigFile();
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize.width = MediaQuery.of(context).size.width;
    ScreenSize.height = MediaQuery.of(context).size.height;

    return Column(children: [
      const HeaderTitle(),
      if (_headerNavNeeded.contains(_currentPage))
        HeaderNav(
            currentPage: _currentPage,
            changePage: setCurrentPage,
            screens: _headerNavNeeded),
      SizedBox(
        height: ScreenSize.height * 0.823,
        width: ScreenSize.width,
        child: Navigator(
          pages: [
            if (_currentPage == "login")
              const MaterialPage(child: Login())
            else if (_currentPage == "loading") // TODO: FIX LOADING PAGE
              const MaterialPage(child: Loading())
            else if (_currentPage == "error") // TODO: ADD ERROR PAGE
              MaterialPage(child: Center(child: Text("Error $currErr")))
            else if (fileReader.getScoutingMethods().contains(_currentPage))
              MaterialPage(child: Scouting(data: scoutingPages[_currentPage]))
          ],
          onPopPage: (route, result) {
            return route.didPop(result);
          },
        ),
      ),
    ]);
  }
}
