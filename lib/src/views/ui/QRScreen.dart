import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sushi_scouts/src/logic/data/ScoutingData.dart';
import 'package:sushi_scouts/src/logic/size/ScreenSize.dart';
import '../util/Header/HeaderTitle.dart';
import '../util/header/HeaderNav.dart';
import 'Scouting.dart';

class QRScreen extends StatelessWidget {
  final Function(String) changePage;  
  final String previousPage;
  final ScoutingData data;
  String? stringifiedData;

  QRScreen({Key? key, required this.changePage, required this.previousPage, required this.data}) : super(key: key);

  void convertData(){
    stringifiedData = data.stringfy();
  }

  @override
  Widget build(BuildContext context) {
    convertData();
    data.empty();
    return Expanded(
        child: ListView(
          children: [
            SizedBox(
              height: (ScreenSize.height * 0.5+72000.0/ScreenSize.width),
                child: QrImage(data: stringifiedData!),
            ),
            Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: Container(
                      width: 200*ScreenSize.swu,
                      height: 60*ScreenSize.swu,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 4),
                        color: const Color(0xfafafa),
                        borderRadius: BorderRadius.circular(20*ScreenSize.swu),
                      ),
                      child: TextButton(
                        onPressed: () => changePage(previousPage),                        
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
          ],
        )
    );
  }
}