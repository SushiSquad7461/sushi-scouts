import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localstore/localstore.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sushi_scouts/SushiScoutingLib/logic/data/Compressor.dart';
import 'package:sushi_scouts/SushiScoutingLib/logic/data/config_file_reader.dart';
import 'package:sushi_scouts/SushiScoutingLib/logic/data/Decompressor.dart';
import 'package:sushi_scouts/SushiScoutingLib/logic/helpers/size/ScreenSize.dart';
import 'package:sushi_scouts/SushiScoutingLib/logic/models/scouting_data_models/scouting_data.dart';


class QRScreen extends StatefulWidget {
  final Function(String) changePage;
  final String previousPage;
  final ScoutingData data;
  final int pageIndex;
  final db = Localstore.instance;
  final fileReader = ConfigFileReader.instance;

  QRScreen(
      {Key? key,
      required this.changePage,
      required this.previousPage,
      required this.data,
      required this.pageIndex})
      : super(key: key);

  @override
  State<QRScreen> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  String? stringifiedData;
  bool isBackup = false;
  bool dataConverted = false;
  bool generateCode = false;

  Future<void> convertData() async{
    if (!dataConverted) {
      final compressedData = await widget.db.collection("data").doc("current${widget.previousPage}").get();
      Compressor compressor = Compressor(widget.data.getData(), widget.pageIndex);
      String newData;
      int length;
      
      if( compressedData == null) {
        newData = compressor.firstCompress();
        length = compressor.getLength();
      } else {
        newData = compressor.addTo(compressedData["compressedData"]! as String, compressedData["length"]! as int);
        length = compressor.getLength();
      }
      widget.db.collection("data").doc("current${widget.previousPage}").set({
        "compressedData" : newData,
        "length" : length
        }
      );
    }
    dataConverted = true;
  }

  void deleteBackup() {
    widget.db.collection("data").doc("backup${widget.previousPage}").delete();
    widget.db.collection("data").doc("current${widget.previousPage}").delete();
    dataConverted = true;
  }

  Future<void> getData() async {
    await convertData();
    final compressedData = await widget.db.collection("data").doc("${isBackup?"backup":"current"}${widget.previousPage}").get();
    if( compressedData != null) {
      final decompressor = Decompressor(compressedData["compressedData"], widget.fileReader.getScoutingMethods());
      print(decompressor.isBackup());
      ScoutingData data = widget.fileReader.generateScoutingData(widget.previousPage)!;
      bool moreData = false;
      do {
        print(decompressor.getScreen());
        moreData = decompressor.decompress(data.getData());
        print(data.stringfy());
      } while( moreData );
      if( isBackup ) {
        stringifiedData = compressedData["compressedData"] as String;
      } else {
        stringifiedData = compressedData["compressedData"] as String;
        final backup = await widget.db.collection("data").doc("backup${widget.previousPage}").get();
        if (backup != null) {
          widget.db.collection("data").doc("backup${widget.previousPage}").set({
            "compressedData" : Compressor.update(backup["compressedData"], backup["length"], compressedData["compressedData"]),
            "length": backup["length"] + compressedData["length"]-1
          });
        } else {
          int length = compressedData["length"] as int;
          String compressedString = Compressor.setBackUp(compressedData["compressedData"] as String);
          widget.db.collection("data").doc("backup${widget.previousPage}").set({
            "compressedData" : compressedString,
            "length" : length
          });
        }
        widget.db.collection("data").doc("current${widget.previousPage}").delete();
      }
      setState(() {
        generateCode = true;
        build(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        generateCode ?
          Align(
            alignment: const Alignment(0, -0.5),
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                  width: ScreenSize.width * 0.8,
                  height: ScreenSize.width * 0.8,
                  decoration: BoxDecoration(
                      color: colors.primaryColorDark,
                      borderRadius: BorderRadius.all(
                          Radius.circular(ScreenSize.width * 0.1))),
                ),
                Container(
                  width: ScreenSize.width * 0.7,
                  height: ScreenSize.width * 0.7,
                  color: Colors.white,
                ),
                SizedBox(
                  height: (0.7 * ScreenSize.width),
                  child: QrImage(data: stringifiedData!),
                ),
              ],
            )
          ) :
          Align(
            alignment: const Alignment(0, -0.5),
            child: Column(
              children: [
                Container(
                  width: 350 * ScreenSize.swu,
                  height: 55 * ScreenSize.swu,
                  decoration: BoxDecoration(
                    border: Border.all(color: colors.primaryColorDark, width: 3.5),
                    color: colors.scaffoldBackgroundColor,
                    borderRadius:
                        BorderRadius.circular(10 * ScreenSize.swu),
                  ),
                  child: TextButton(
                    onPressed: () {
                      isBackup = false;
                      getData();
                    },
                    child: Text(
                      'GENERATE CODE',
                      style: TextStyle(
                          fontSize: 29 * ScreenSize.swu,
                          fontFamily: "Sushi",
                          color: colors.primaryColorDark,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  width: 350 * ScreenSize.swu,
                  height: 55 * ScreenSize.swu,
                  decoration: BoxDecoration(
                    border: Border.all(color: colors.primaryColorDark, width: 3.5),
                    color: colors.scaffoldBackgroundColor,
                    borderRadius:
                        BorderRadius.circular(10 * ScreenSize.swu),
                  ),
                  child: TextButton(
                    onPressed: () {
                      isBackup = true;
                      getData();
                    },
                    child: Text(
                      'RESTORE BACKUP',
                      style: TextStyle(
                          fontSize: 29 * ScreenSize.swu,
                          fontFamily: "Sushi",
                          color: colors.primaryColorDark,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  width: 350 * ScreenSize.swu,
                  height: 55 * ScreenSize.swu,
                  decoration: BoxDecoration(
                    border: Border.all(color: colors.primaryColorDark, width: 3.5),
                    color: colors.scaffoldBackgroundColor,
                    borderRadius:
                        BorderRadius.circular(10 * ScreenSize.swu),
                  ),
                  child: TextButton(
                    onPressed: () {
                      isBackup = true;
                      deleteBackup();
                    },
                    child: Text(
                      'DELETE BACKUP',
                      style: TextStyle(
                          fontSize: 29 * ScreenSize.swu,
                          fontFamily: "Sushi",
                          color: colors.primaryColorDark,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ]
            )
          ), 
        
        if(generateCode)
          Align(
            alignment: const Alignment(-1, -1),
            child: IconButton(
              onPressed: () {
                setState(() {
                  generateCode = false;
                });
              },
              iconSize: ScreenSize.swu * 100,
              icon: const Icon(
                Icons.arrow_back_ios
              ),
            )
          ),
        Align(
            alignment: Alignment(0, 1),
            child: SvgPicture.asset(
              "./assets/images/FooterColors.svg",
              width: ScreenSize.width,
            )),
        Align(
          alignment: Alignment(0, 0.83),
          child: Container(
              width: ScreenSize.width,
              decoration: BoxDecoration(
                color: colors.primaryColorDark,
              ),
              child: TextButton(
                onPressed: () {
                  convertData();
                  widget.data.empty();
                  widget.changePage(widget.previousPage);
                },
                child: Text(
                  'CONTINUE',
                  style: TextStyle(
                      fontSize: 35 * ScreenSize.swu,
                      fontFamily: "Sushi",
                      color: colors.primaryColor,
                      fontWeight: FontWeight.bold),
                ),
              )),
        ),
      ],
    );
  }
}
