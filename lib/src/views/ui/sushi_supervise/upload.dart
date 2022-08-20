import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter_svg/parser.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sushi_scouts/src/logic/data/Decompressor.dart';
import 'package:sushi_scouts/src/logic/data/config_file_reader.dart';
import 'package:sushi_scouts/src/logic/helpers/size/ScreenSize.dart';
import 'package:sushi_scouts/src/logic/models/compressed_data_model.dart';
import 'package:sushi_scouts/src/logic/models/scouting_data_models/scouting_data.dart';
import 'package:sushi_scouts/src/views/util/footer/supervisefooter.dart';
import 'package:sushi_scouts/src/views/util/header/header_nav.dart';

import '../../util/header/header_title/header_title.dart';

class Upload extends StatefulWidget {
  const Upload({Key? key}) : super(key: key);

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  List<ScoutingData> toAdd = [];
  bool configFile = false;
  String login = "";
  String eventCode = "";

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    setState(() {});
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context);

    final fontStyle = GoogleFonts.mohave(
        textStyle: TextStyle(
      fontSize: 50 * ScreenSize.swu,
      fontWeight: FontWeight.w700,
      color: colors.primaryColorDark,
    ));

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const HeaderTitle(
            isSupervise: true,
          ),
          HeaderNav(
            currentPage: "upload",
            isSupervise: true,
          ),
          SizedBox(
            height: ScreenSize.height * 0.6,
            child: Padding(
              padding: EdgeInsets.only(top: ScreenSize.height * 0.02),
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Container(
                      width: ScreenSize.width * 0.8,
                      height: ScreenSize.height * 0.58,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(8 * ScreenSize.swu)),
                          border: Border.all(
                            color: colors.primaryColorDark,
                            width: 5 * ScreenSize.swu,
                          )),
                      child: QRView(
                        key: qrKey,
                        onQRViewCreated: _onQRViewCreated,
                      ),
                    ),
                  ),
                  if (toAdd.isNotEmpty)
                    Center(
                      child: Container(
                        height: ScreenSize.height * 0.4,
                        width: ScreenSize.width * 0.6,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.white,
                              width: 0.02 * ScreenSize.width),
                          borderRadius: BorderRadius.all(
                              Radius.circular(10 * ScreenSize.swu)),
                        ),
                        child: Container(
                          width: ScreenSize.width * 0.58,
                          height:
                              ScreenSize.height * 0.4 - ScreenSize.width * 0.02,
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: ScreenSize.height * 0,
                                bottom: ScreenSize.height * 0,
                                right: ScreenSize.width * 0.02,
                                left: ScreenSize.width * 0.02),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    controller!.resumeCamera();
                                    setState(() => {toAdd = [], result = null});
                                  },
                                  child: SvgPicture.asset(
                                      "./assets/images/remove.svg"),
                                ),
                                SizedBox(
                                  height: ScreenSize.height * 0.25,
                                  width: ScreenSize.width * 0.58,
                                  child: ListView(
                                    children: [
                                      for (int i = 0; i < toAdd.length; ++i)
                                        Padding(
                                          padding: EdgeInsets.only(
                                              bottom:
                                                  ScreenSize.height * 0.005),
                                          child: SizedBox(
                                              width: ScreenSize.width * 0.58,
                                              child: Center(
                                                  child: Text(
                                                      "${toAdd[i].stringfy()[0]} - ${toAdd[i].getCertainData("pregame", "match #")} - ${toAdd[i].getCertainData("pregame", "team #")}",
                                                      style: fontStyle))),
                                        ),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              bottom:
                                                  ScreenSize.height * 0.005),
                                          child: SizedBox(
                                              width: ScreenSize.width * 0.58,
                                              child: Center(
                                                  child: Text(
                                                      "CONFIG - ${configFile ? "Y" : "N"}",
                                                      style: fontStyle)))),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              bottom:
                                                  ScreenSize.height * 0.005),
                                          child: SizedBox(
                                              width: ScreenSize.width * 0.58,
                                              child: Center(
                                                  child: Text(
                                                "CODE - ${eventCode.toUpperCase()}",
                                                style: fontStyle,
                                              )))),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              bottom:
                                                  ScreenSize.height * 0.005),
                                          child: SizedBox(
                                              width: ScreenSize.width * 0.58,
                                              child: Center(
                                                  child: Text(login,
                                                      style: fontStyle)))),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: ScreenSize.width * 0.58,
                                  child: Center(
                                    child: TextButton(
                                        onPressed: () {},
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.black,
                                              width: ScreenSize.width * 0.01,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                ScreenSize.width * 0.035),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: ScreenSize.height * 0.001,
                                                bottom:
                                                    ScreenSize.height * 0.001,
                                                left: ScreenSize.width * 0.03,
                                                right: ScreenSize.width * 0.03),
                                            child: Text(
                                              "UPLOAD",
                                              style: TextStyle(
                                                fontFamily: "Sushi",
                                                fontSize: 30 * ScreenSize.swu,
                                                fontWeight: FontWeight.bold,
                                                color: colors.primaryColorDark,
                                              ),
                                            ),
                                          ),
                                        )),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
          const SuperviseFooter(),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.resumeCamera();
    controller.scannedDataStream.listen(handleNewData);
  }

  void handleNewData(scanData) {
    setState(() {
      result = scanData;

      if (result != null && toAdd.isEmpty) {
        var reader = ConfigFileReader.instance;
        CompressedDataModel decodedData =
            CompressedDataModel.fromJson(json.decode(result!.code!));

        configFile = decodedData.metadata.configId ==
            "${reader.teamNum!}+${reader.year}+${reader.version}";
        login =
            "${decodedData.metadata.name.toUpperCase()} ${decodedData.metadata.teamNum}";
        eventCode = decodedData.metadata.eventCode;

        List<String> newArray = [];
        for (var s in decodedData.data) {
          Decompressor decompressor =
              Decompressor(s, reader.getScoutingMethods());
          decompressor.isBackup();
          String screen = decompressor.getScreen();
          toAdd.add(reader.getScoutingData(screen));
          decompressor.decompress(toAdd[toAdd.length-1].getData());
          print(toAdd[toAdd.length-1].stringfy());
        }
        controller?.pauseCamera();
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
