import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localstore/localstore.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sushi_scouts/src/logic/blocs/scouting_method_bloc/scouting_method_cubit.dart';
import 'package:sushi_scouts/src/logic/data/Compressor.dart';
import 'package:sushi_scouts/src/logic/data/Decompressor.dart';
import 'package:sushi_scouts/src/logic/data/config_file_reader.dart';
import 'package:sushi_scouts/src/logic/helpers/routing_helper.dart';
import 'package:sushi_scouts/src/logic/helpers/size/ScreenSize.dart';
import 'package:sushi_scouts/src/logic/models/compressed_data_model.dart';
import 'package:sushi_scouts/src/logic/models/scouting_data_models/scouting_data.dart';
import 'package:sushi_scouts/src/views/ui/sushi_scouts/scouting.dart';
import 'package:sushi_scouts/src/views/util/header/header_title/header_title.dart';


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
      var unprocessedData = await widget.db.collection("data").doc("current$currPage").get();
      Compressor compressor = Compressor(currentScoutingData!.getData(), pageIndex);
      String newData;
      
      if( unprocessedData == null) {
        newData = compressor.firstCompress();
        widget.db.collection("data").doc("current$currPage").set({"data": [newData], "lengths" : [newData.length]});
      } else {
        final compressedData = CompressedDataModel.fromJson(unprocessedData);
        newData = compressor.firstCompress();
        compressedData.addString(newData);
        widget.db.collection("data").doc("current$currPage").set(compressedData.toJson());
      }
    }
    dataConverted = true;
  }

  void deleteBackup() {
    widget.db.collection("data").doc("backup$currPage").delete();
    widget.db.collection("data").doc("current$currPage").delete();
    dataConverted = true;
  }

  Future<void> getData() async {
    await convertData();
    final compressedData = await widget.db.collection("data").doc("${isBackup?"backup":"current"}$currPage").get();
    if( compressedData != null) {
      ScoutingData data = widget.fileReader.getScoutingData(currPage);
      
      if( isBackup ) {
        stringifiedData = compressedData.toString();
      } else {
        stringifiedData = compressedData.toString();
        final backup = await widget.db.collection("data").doc("backup$currPage").get();
        if (backup != null) {
          var newData = CompressedDataModel.fromJson(backup);
          newData.add(CompressedDataModel.fromJson(compressedData));
          widget.db.collection("data").doc("backup$currPage").set(newData.toJson());
        } else {
          widget.db.collection("data").doc("backup$currPage").set(compressedData);
        }
        widget.db.collection("data").doc("current$currPage").delete();
      }

      var compressed = CompressedDataModel.fromJson(compressedData);
      for( var s in compressed.data) {
        Decompressor decompressor = Decompressor(s, widget.fileReader.getScoutingMethods());
        decompressor.isBackup();
        print(decompressor.getScreen());
        decompressor.decompress(data.getData());
        print(data.stringfy());
      } 
      setState(() {
        generateCode = true;
        build(context);
      });
    }
  }

  Future<void> back() async{
    await convertData();
    currentScoutingData!.empty();
    RouteHelper.pushAndRemoveUntilToScreen(-1,0,ctx: context, screen: const Scouting());
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
            alignment: const Alignment(0, -1.4),
            child: Container(
              height: ScreenSize.height * 0.75,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 35*ScreenSize.swu),
                    child: Container(
                      width: 340 * ScreenSize.swu,
                      height: 65 * ScreenSize.swu,
                      decoration: BoxDecoration(
                        border: Border.all(color: colors.primaryColorDark, width: 3.5),
                        color: colors.scaffoldBackgroundColor,
                        borderRadius:
                            BorderRadius.circular(20 * ScreenSize.swu),
                      ),
                      child: TextButton(
                        onPressed: () {
                          isBackup = false;
                          getData();
                        },
                        child: Text(
                          'generate QR code',
                          style: TextStyle(
                              fontSize: 34 * ScreenSize.swu,
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
                      width: 277 * ScreenSize.swu,
                      height: 65 * ScreenSize.swu,
                      decoration: BoxDecoration(
                        border: Border.all(color: colors.primaryColorDark, width: 3.5),
                        color: colors.scaffoldBackgroundColor,
                        borderRadius:
                            BorderRadius.circular(20 * ScreenSize.swu),
                      ),
                      child: TextButton(
                        onPressed: () {
                          isBackup = true;
                          getData();
                        },
                        child: Text(
                          'restore backup',
                          style: TextStyle(
                              fontSize: 34 * ScreenSize.swu,
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
                      width: 277 * ScreenSize.swu,
                      height: 65 * ScreenSize.swu,
                      decoration: BoxDecoration(
                        border: Border.all(color: colors.primaryColorDark, width: 3.5),
                        color: colors.scaffoldBackgroundColor,
                        borderRadius:
                            BorderRadius.circular(20 * ScreenSize.swu),
                      ),
                      child: TextButton(
                        onPressed: () {
                          isBackup = true;
                          deleteBackup();
                        },
                        child: Text(
                          'delete backup',
                          style: TextStyle(
                              fontSize: 34 * ScreenSize.swu,
                              fontFamily: "Sushi",
                              color: colors.primaryColorDark,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ]
              ),
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
