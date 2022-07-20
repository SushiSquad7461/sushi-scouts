import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:localstore/localstore.dart';
import 'package:sushi_scouts/src/logic/Constants.dart';
import 'package:sushi_scouts/src/views/ui/Loading.dart';
import 'package:sushi_scouts/src/views/ui/Login.dart';
import 'package:sushi_scouts/src/views/ui/QRScreen.dart';
import 'package:sushi_scouts/src/views/ui/Scouting.dart';
import 'package:sushi_scouts/src/views/ui/Settings.dart';
import 'package:sushi_scouts/src/views/util/header/HeaderNav.dart';
import 'package:sushi_scouts/src/views/util/header/HeaderTitle.dart';

import 'SushiScoutingLib/logic/data/ConfigFileReader.dart';
import 'SushiScoutingLib/logic/data/ScoutingData.dart';
import 'SushiScoutingLib/logic/size/ScreenSize.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Wrapper());
}

class Themes {
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white,
    primaryColorDark: Colors.black,
    scaffoldBackgroundColor: Colors.white,
  );

  static ThemeData dark = ThemeData(
    primaryColor: Colors.black,
    primaryColorDark: Colors.white,
    scaffoldBackgroundColor: Colors.black,
  );
}

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Sushi Scouts",
      theme: Themes.light, 
      darkTheme: Themes.dark,
      themeMode: ThemeMode.system,
      home: const Scaffold(
        resizeToAvoidBottomInset: false,
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
  String _previousPage = "loading";
  String _currentPage = "loading";
  Map<String, ScoutingData> scoutingPages = {};
  List<String> _headerNavNeeded = [];
  String currErr = "";
  String pageParams = "";
  bool qrCode = false;
  final db = Localstore.instance;

  // Change current page
  void setCurrentPage(newPage) {
    setState(() {
      _previousPage = _currentPage;
      _currentPage = newPage;
    });
  }

  void goToQrCode(String qrCodeString) {
    setState(() {
      qrCode = true;
      pageParams = qrCodeString;
    });
  }

  Future<void> readConfigFile() async {
    try {
      await fileReader.readConfig();

      setState(() {
        for (var i in fileReader.getScoutingDataClasses()) {
          scoutingPages[i.name] = i as ScoutingData;
        }
        _headerNavNeeded = fileReader.getScoutingMethods();
        _headerNavNeeded.add("settings");

        _currentPage = "pit";
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
    setMode();
    readConfigFile();
  }

  Future<void> setMode() async {
    final data = await db.collection("preferences").doc("mode").get();

    if (data != null) {
      data["mode"] == "dark"
          ? Get.changeTheme(Themes.dark)
          : Get.changeTheme(Themes.light);
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize.width = MediaQuery.of(context).size.width;
    ScreenSize.height = MediaQuery.of(context).size.height;
    double pageHeight = _headerNavNeeded.contains(_currentPage)
        ? ScreenSize.height * 0.8
        : ScreenSize.height * 0.9;

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Column(children: [
        const HeaderTitle(),
        if (_headerNavNeeded.contains(_currentPage) && !qrCode)
          HeaderNav(
              currentPage: _currentPage,
              changePage: setCurrentPage,
              screens: _headerNavNeeded),
        SizedBox(
          height: pageHeight,
          width: ScreenSize.width,
          child: Navigator(
            pages: [
              if (_currentPage == "login")
                MaterialPage(
                    child: Login(
                  changePage: setCurrentPage,
                ))
              else if (_currentPage == "loading") // TODO: FIX LOADING PAGE
                const MaterialPage(child: Loading())
              else if (_currentPage == "error") // TODO: ADD ERROR PAGE
                MaterialPage(
                    child: Center(
                        child: Text(
                  "Error $currErr",
                  style: const TextStyle(color: Colors.red),
                )))
              else if (_currentPage == "settings")
                const MaterialPage(child: Settings())
              else if (_currentPage == "qrscreen")
                MaterialPage(
                    child: QRScreen(
                        changePage: setCurrentPage,
                        previousPage: _previousPage,
                        data: scoutingPages[_previousPage]!,
                        pageIndex: _headerNavNeeded.indexOf(_previousPage),))
              else if (fileReader.getScoutingMethods().contains(_currentPage))
                MaterialPage(
                    child: Scouting(
                        data: scoutingPages[_currentPage],
                        changeScreen: setCurrentPage))
            ],
            onPopPage: (route, result) {
              return route.didPop(result);
            },
          ),
        ),
      ]),
    );
  }
}
