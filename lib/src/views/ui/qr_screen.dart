import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localstore/localstore.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sushi_scouts/SushiScoutingLib/logic/data/Compressor.dart';
import 'package:sushi_scouts/SushiScoutingLib/logic/data/config_file_reader.dart';
import 'package:sushi_scouts/SushiScoutingLib/logic/data/Decompressor.dart';
import 'package:sushi_scouts/SushiScoutingLib/logic/helpers/routing_helper.dart';
import 'package:sushi_scouts/SushiScoutingLib/logic/helpers/size/ScreenSize.dart';
import 'package:sushi_scouts/SushiScoutingLib/logic/models/scouting_data_models/scouting_data.dart';
import 'package:sushi_scouts/src/logic/blocs/scouting_method_bloc/scouting_method_cubit.dart';
import 'package:sushi_scouts/src/views/ui/scouting.dart';
import 'package:sushi_scouts/src/views/util/header/header_nav.dart';
import 'package:sushi_scouts/src/views/util/header/header_title.dart';


class QRScreen extends StatefulWidget {
  final db = Localstore.instance;
  final fileReader = ConfigFileReader.instance;

  QRScreen(
      {Key? key})
      : super(key: key);

  @override
  State<QRScreen> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  String? stringifiedData;
  bool isBackup = false;
  bool dataConverted = false;
  bool generateCode = false;
  ScoutingData? currentScoutingData;
  int pageIndex = 0;
  String currPage = '';

  Future<void> convertData() async{
    if (!dataConverted) {
      final compressedData = await widget.db.collection("data").doc("current${currPage}").get();
      Compressor compressor = Compressor(currentScoutingData!.getData(), pageIndex);
      String newData;
      int length;
      
      if( compressedData == null) {
        newData = compressor.firstCompress();
        length = compressor.getLength();
      } else {
        newData = compressor.addTo(compressedData["compressedData"]! as String, compressedData["length"]! as int);
        length = compressor.getLength();
      }
      widget.db.collection("data").doc("current${currPage}").set({
        "compressedData" : newData,
        "length" : length
        }
      );
    }
    dataConverted = true;
  }

  void deleteBackup() {
    widget.db.collection("data").doc("backup${currPage}").delete();
    widget.db.collection("data").doc("current${currPage}").delete();
    dataConverted = true;
  }

  Future<void> getData() async {
    await convertData();
    final compressedData = await widget.db.collection("data").doc("${isBackup?"backup":"current"}${currPage}").get();
    if( compressedData != null) {
      final decompressor = Decompressor(compressedData["compressedData"], widget.fileReader.getScoutingMethods());
      print(decompressor.isBackup());
      ScoutingData data = widget.fileReader.getScoutingData(currPage);
      bool moreData = false;
      String temp;
      do {
        temp = decompressor.getScreen();
        print(temp);
        if (temp == "") {
          break;
        }
        moreData = decompressor.decompress(data.getData());
        print(data.stringfy());
      } while( moreData );
      if( isBackup ) {
        stringifiedData = compressedData["compressedData"] as String;
      } else {
        stringifiedData = compressedData["compressedData"] as String;
        final backup = await widget.db.collection("data").doc("backup${currPage}").get();
        if (backup != null) {
          widget.db.collection("data").doc("backup${currPage}").set({
            "compressedData" : Compressor.update(backup["compressedData"], backup["length"], compressedData["compressedData"]),
            "length": backup["length"] + compressedData["length"]-1
          });
        } else {
          int length = compressedData["length"] as int;
          String compressedString = Compressor.setBackUp(compressedData["compressedData"] as String);
          widget.db.collection("data").doc("backup${currPage}").set({
            "compressedData" : compressedString,
            "length" : length
          });
        }
        widget.db.collection("data").doc("current${currPage}").delete();
      }
      setState(() {
        generateCode = true;
        build(context);
      });
    }
  }

  Future<void> back() async{
    convertData();
    currentScoutingData!.empty();
    RouteHelper.pushAndRemoveUntilToScreen(ctx: context, screen: const Scouting());
  }

  Widget buildQRCode() {
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
                Padding(
                  padding: EdgeInsets.only(top: 35*ScreenSize.swu),
                  child: Container(
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
                ),
                Padding(
                  padding: EdgeInsets.only(top: 35*ScreenSize.swu),
                  child: Container(
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
                ),
                Padding(
                  padding: EdgeInsets.only(top: 35*ScreenSize.swu),
                  child: Container(
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
                ),
              ]
            )
          ), 
        Align(
            alignment: Alignment(0, 1),
            child: SvgPicture.asset(
              "./assets/images/FooterColors.svg",
              width: ScreenSize.width,
            )),
        (!generateCode) ?
        Align(
          alignment: Alignment(0, 0.83),
          child: Container(
              width: ScreenSize.width,
              decoration: BoxDecoration(
                color: colors.primaryColorDark,
              ),
              child: TextButton(
                onPressed: () {
                  back();
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
        ) :
        Align(
          alignment: const Alignment(0, 0.83),
          child: Container(
            width: ScreenSize.width,
            decoration: BoxDecoration(
              color: colors.primaryColorDark,
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextButton(
                    onPressed: () => setState(() {
                      generateCode = false;
                    }),
                    child: Text(
                      'BACK',
                      style: TextStyle(
                        fontSize: 35 * ScreenSize.swu,
                        fontFamily: "Sushi",
                        color: colors.primaryColor,
                        fontWeight: FontWeight.bold
                      ),
                    )
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: TextButton(
                    onPressed: () => back(),
                    child: Text(
                      'CONTINUE',
                      style: TextStyle(
                        fontSize: 35 * ScreenSize.swu,
                        fontFamily: "Sushi",
                        color: colors.primaryColor,
                        fontWeight: FontWeight.bold
                      ),
                    )
                  ),
                ),
              ]
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScoutingMethodCubit, ScoutingMethodStates>(
      builder:(context, state) {
        currPage = (state as ScoutingMethodsInitialized).method;        
        var methods = widget.fileReader.getScoutingMethods();
        pageIndex = methods.indexOf(currPage);
        currentScoutingData = widget.fileReader.getScoutingData(currPage);
        return Scaffold(
          body: Column(
            children: [
              const HeaderTitle(),
              SizedBox(
                width: ScreenSize.width,
                height: ScreenSize.height*0.9,
                child: buildQRCode()
              ),
            ],
          ),
        );
      },
    );
  }
}
