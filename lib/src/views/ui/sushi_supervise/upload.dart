import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sushi_scouts/src/logic/helpers/size/ScreenSize.dart';
import '../../util/header/supervise_header_title.dart';

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
    return Scaffold(
      body: Column(
        children: [
          const HeaderTitle(),
          Padding(
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
                          color: Colors.black,
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
                      color: Colors.white,
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
                  )
              ],
            ),
          ),
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