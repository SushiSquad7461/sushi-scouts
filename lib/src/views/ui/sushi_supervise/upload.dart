import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
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

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.resumeCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    var colors = Theme.of(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const HeaderTitle(isSupervise: true,),
          HeaderNav(currentPage: "upload", isSupervise: true,),
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
                          borderRadius:
                              BorderRadius.all(Radius.circular(8 * ScreenSize.swu)),
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
                  if (result != null)
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
                                    ) ,
                        child: Container(
                          width: ScreenSize.width * 0.58,
                          height: ScreenSize.height * 0.4 - ScreenSize.width * 0.02,
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.only(top: ScreenSize.height *0.03, bottom: ScreenSize.height * 0.03, right: ScreenSize.width * 0.02, left: ScreenSize.width * 0.02),
                            child: Column(
                              children: [
                                Text(result!.code!),
                                TextButton(
                                    onPressed: () {
                                          controller!.resumeCamera();
                                          setState(() => {result = null});
                                        },
                                    child: Text("Reset"))
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
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;

        if (result != null) {
          var reader = ConfigFileReader.instance;
          ScoutingData? data;
          for( var s in CompressedDataModel.fromJson(json.decode(result!.code!)).data) {
            Decompressor decompressor = Decompressor(s, reader.getScoutingMethods());
            decompressor.isBackup();
            data ??= reader.getScoutingData(decompressor.getScreen());
            decompressor.decompress(data.getData());
          } 
          controller.pauseCamera();
        } else {
        }
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}