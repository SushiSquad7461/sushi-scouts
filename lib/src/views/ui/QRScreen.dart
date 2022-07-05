import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sushi_scouts/src/logic/data/ScoutingData.dart';
import 'package:sushi_scouts/src/logic/size/ScreenSize.dart';
import '../util/Header/HeaderTitle.dart';
import '../util/Footer.dart';
import '../util/header/HeaderNav.dart';
import 'Scouting.dart';

class QRScreen extends StatelessWidget {
  final Function(String newPage, String previousPage, {ScoutingData? previousData}) changePage;  
  final String previousPage;
  final ScoutingData? data;
  String? stringifiedData;
  List<String> screens;

  QRScreen({Key? key, required this.changePage, required this.previousPage, this.data, required this.screens}) : super(key: key);

  void convertData(){
    stringifiedData = data!.stringfy();
  }

  @override
  Widget build(BuildContext context) {
    convertData();
    return Scaffold(
        body: ListView(
          children: [
            HeaderTitle(size: ScreenSize.get()),
            HeaderNav(currentPage: previousPage, changePage: changePage, size: ScreenSize.get(), screens: screens),
            SizedBox(
              height: (ScreenSize.height * 0.5+72000.0/ScreenSize.width),
              child: QrImage(data: stringifiedData!),
            ),
            Padding(
                  padding: EdgeInsets.all(20*ScreenSize.swu),
                  child: Container(
                      width: 200*ScreenSize.swu,
                      height: 60*ScreenSize.swu,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 4),
                        color: const Color(0xfafafa),
                        borderRadius: BorderRadius.circular(20*ScreenSize.swu),
                      ),
                      child: TextButton(
                        onPressed: () => changePage(previousPage, previousPage),                        
                        child: Text(
                          'Next Match',
                          style: TextStyle(
                              fontSize: 25*ScreenSize.swu,
                              fontFamily: "Sushi",
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                ),
            Footer(pageTitle: previousPage.toUpperCase(), size: ScreenSize.get()),
          ],
        )
    );
  }
}