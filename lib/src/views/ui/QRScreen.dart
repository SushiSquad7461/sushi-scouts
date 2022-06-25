import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sushi_scouts/src/logic/data/cardinalData.dart';

import '../../logic/enums/Pages.dart';
import '../util/Header/HeaderTitle.dart';
import '../util/Footer.dart';
import '../util/header/HeaderNav.dart';
import 'Cardinal.dart';

class QRScreen extends StatelessWidget {
  final Function(dynamic, {CardinalData? previousData, Pages? previousPage}) changePage;
  final Pages previousPage;
  final CardinalData? cardinalData;
  String? stringifiedData;

  QRScreen({Key? key, required this.changePage, required this.previousPage, this.cardinalData}) : super(key: key);

  void convertData(){
    stringifiedData = cardinalData!.stringfy();
  }

  @override
  Widget build(BuildContext context) {
    convertData();
    Size size = MediaQuery.of(context).size;
    double swu = size.width/600;
    double shu = size.height/900;
    return Scaffold(
        body: ListView(
          children: [
            HeaderTitle(size: size),
            HeaderNav(currentPage: previousPage, changePage: changePage, size: size),
            SizedBox(
              height: (size.height * 0.5+72000.0/size.width),
              child: QrImage(data: stringifiedData!),
            ),
            Padding(
                  padding: EdgeInsets.all(20*swu),
                  child: Container(
                      width: 200*swu,
                      height: 60*swu,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 4),
                        color: const Color(0xfafafa),
                        borderRadius: BorderRadius.circular(20*swu),
                      ),
                      child: TextButton(
                        onPressed: () => changePage(Pages.cardinal),                        
                        child: Text(
                          'Next Match',
                          style: TextStyle(
                              fontSize: 25*swu,
                              fontFamily: "Sushi",
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                ),
            Footer(pageTitle: EnumToString.convertToString(previousPage).toUpperCase(), size: size),
          ],
        )
    );
  }
}