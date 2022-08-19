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
  List<ScoutingData> toAdd = [];

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
                  if (toAdd.length != 0)
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
                                top: ScreenSize.height * 0.03,
                                bottom: ScreenSize.height * 0.03,
                                right: ScreenSize.width * 0.02,
                                left: ScreenSize.width * 0.02),
                            child: ListView(
                              children: [
                                for (var i in toAdd) Text(i.stringfy()),
                                TextButton(
                                    onPressed: () {
                                      controller!.resumeCamera();
                                      setState(
                                          () => {toAdd = [], result = null});
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
    print("hello yo");
    this.controller = controller;
    controller.resumeCamera();
    controller.scannedDataStream.listen(handleNewData);
  }

  void handleNewData(scanData) {
    setState(() {
      result = scanData;

      if (result != null && toAdd.length == 0) {
        var reader = ConfigFileReader.instance;
        print("helo 23");
        print(result!.code!);
        Map<String, dynamic> decodedData = json.decode(result!.code!);
        for (var s in CompressedDataModel.fromJson(decodedData).data) {
          ScoutingData? data;
          Decompressor decompressor =
              Decompressor(s, reader.getScoutingMethods());
          decompressor.isBackup();
          String screen = decompressor.getScreen();
          data ??= reader.getScoutingData(screen);
          decompressor.decompress(data.getData());
          print("ADD");
          toAdd.add(data);
        }
        // controller.pauseCamera();
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
