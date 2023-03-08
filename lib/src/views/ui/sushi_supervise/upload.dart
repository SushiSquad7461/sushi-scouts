// Dart imports:
import "dart:convert";
import "dart:io";

// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:flutter_svg/svg.dart";
import "package:google_fonts/google_fonts.dart";
import "package:localstore/localstore.dart";
import "package:qr_code_scanner/qr_code_scanner.dart";

// Project imports:
import "../../../logic/constants.dart";
import "../../../logic/data/config_file_reader.dart";
import "../../../logic/data/decompressor.dart";
import "../../../logic/device_type.dart";
import "../../../logic/helpers/size/screen_size.dart";
import "../../../logic/login_type.dart";
import "../../../logic/models/compressed_data_model.dart";
import "../../../logic/models/scouting_data_models/scouting_data.dart";
import "../../util/footer/supervise_footer.dart";
import "../../util/header/header_nav.dart";
import "../../util/header/header_title/header_title.dart";

class Upload extends StatefulWidget {
  const Upload({Key? key}) : super(key: key);

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  final GlobalKey qrKey = GlobalKey(debugLabel: "QR");
  final ConfigFileReader reader = ConfigFileReader.instance;
  Barcode? result;
  QRViewController? controller;
  List<ScoutingData> toAdd = [];
  bool configFile = false;
  String name = "";
  int teamNum = 0;
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

  Future<void> upload() async {
    var db = Localstore.instance;
    for (ScoutingData i in toAdd) {
      await db
          .collection(superviseDatabaseName)
          .doc(
              "${i.stringfy()[0]} - ${reader.getSuperviseDisplayString(i, 1)} - ${reader.getSuperviseDisplayString(i, 2)}::$name ${teamNum.toString()}")
          .set({
        "data": i.toJson(),
        "flagged": false,
        "deleted": false,
        "methodName": i.name,
        "display1": reader.getSuperviseDisplayString(i, 1),
        "display2": reader.getSuperviseDisplayString(i, 2),
        "name": name,
        "teamNum": teamNum,
      });
    }

    setState(() {
      toAdd = [];
      result = null;
      controller!.resumeCamera();
    });
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

    var phone = isPhone(context);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const HeaderTitle(
            type: LoginType.supervise,
          ),
          HeaderNav(
            currentPage: "upload",
            isSupervise: true,
          ),
          SizedBox(
            height: ScreenSize.height * (phone ? 0.62 : 0.63),
            child: Padding(
              padding: EdgeInsets.only(top: ScreenSize.height * 0.02),
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Container(
                      width: ScreenSize.width * (phone ? 1 : 0.8),
                      height: ScreenSize.height * (phone ? 0.65 : 0.6),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                              Radius.circular(8 * ScreenSize.swu)),
                          border: Border.all(
                            color: phone
                                ? colors.scaffoldBackgroundColor
                                : colors.primaryColorDark,
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
                        height: ScreenSize.height * (phone ? 0.5 : 0.4),
                        width: ScreenSize.width * (phone ? 0.8 : 0.6),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.white,
                              width: 0.02 * ScreenSize.width),
                          borderRadius: BorderRadius.all(
                              Radius.circular(10 * ScreenSize.swu)),
                        ),
                        child: Container(
                          width: ScreenSize.width * (phone ? 0.78 : 0.58),
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
                                  height: ScreenSize.height * 0.28,
                                  width:
                                      ScreenSize.width * (phone ? 0.78 : 0.58),
                                  child: ListView(
                                    children: [
                                      for (int i = 0; i < toAdd.length; ++i)
                                        Padding(
                                          padding: EdgeInsets.only(
                                              bottom:
                                                  ScreenSize.height * 0.005),
                                          child: SizedBox(
                                              width: ScreenSize.width *
                                                  (phone ? 0.78 : 0.58),
                                              child: Center(
                                                  child: Text(
                                                      "${toAdd[i].stringfy()[0]} - ${reader.getSuperviseDisplayString(toAdd[i], 1)} - ${reader.getSuperviseDisplayString(toAdd[i], 2)}",
                                                      style: fontStyle))),
                                        ),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              bottom:
                                                  ScreenSize.height * 0.005),
                                          child: SizedBox(
                                              width: ScreenSize.width *
                                                  (phone ? 0.78 : 0.58),
                                              child: Center(
                                                  child: Text(
                                                      "CONFIG - ${configFile ? "Y" : "N"}",
                                                      style: fontStyle)))),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              bottom:
                                                  ScreenSize.height * 0.005),
                                          child: SizedBox(
                                              width: ScreenSize.width *
                                                  (phone ? 0.78 : 0.58),
                                              child: Center(
                                                  child: Text(
                                                "CODE - ${eventCode.toUpperCase().trim()}",
                                                style: fontStyle,
                                              )))),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              bottom:
                                                  ScreenSize.height * 0.005),
                                          child: SizedBox(
                                              width: ScreenSize.width *
                                                  (phone ? 0.78 : 0.58),
                                              child: Center(
                                                  child: Text(
                                                      "$name ${teamNum.toString()}",
                                                      style: fontStyle)))),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      ScreenSize.width * (phone ? 0.78 : 0.58),
                                  child: Center(
                                    child: TextButton(
                                        onPressed: () {
                                          if (configFile) {
                                            upload();
                                          }
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.black,
                                              width: ScreenSize.width * 0.005,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                                ScreenSize.width * 0.035),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: ScreenSize.height * 0,
                                                bottom: ScreenSize.height * 0,
                                                left: ScreenSize.width * 0.03,
                                                right: ScreenSize.width * 0.03),
                                            child: Text(
                                              "UPLOAD",
                                              style: TextStyle(
                                                fontFamily: "Sushi",
                                                fontSize: (phone ? 40 : 30) *
                                                    ScreenSize.swu,
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

        configFile = decodedData.metadata.configId == reader.id;
        name = decodedData.metadata.name.toUpperCase();
        teamNum = decodedData.metadata.teamNum;
        eventCode = decodedData.metadata.eventCode;

        for (var s in decodedData.data) {
          ScoutingData newData;

          Decompressor decompressor =
              Decompressor(s, reader.getScoutingMethods());
          decompressor.isBackup();
          String screen = decompressor.getScreen();
          newData = reader.generateNewScoutingData(screen);

          decompressor.decompress(newData.getData());
          toAdd.add(newData);
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
