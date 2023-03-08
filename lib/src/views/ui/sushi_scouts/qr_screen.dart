// Dart imports:
import "dart:convert";

// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:localstore/localstore.dart";
import "package:qr_flutter/qr_flutter.dart";

// Project imports:
import "../../../logic/blocs/login_bloc/login_cubit.dart";
import "../../../logic/blocs/scouting_method_bloc/scouting_method_cubit.dart";
import "../../../logic/data/compressor.dart";
import "../../../logic/data/config_file_reader.dart";
import "../../../logic/device_type.dart";
import "../../../logic/helpers/routing_helper.dart";
import "../../../logic/helpers/size/screen_size.dart";
import "../../../logic/models/compressed_data_model.dart";
import "../../../logic/models/scouting_data_models/scouting_data.dart";
import "../../util/header/header_title/header_title.dart";
import "scouting.dart";

class QRScreen extends StatefulWidget {
  final db = Localstore.instance;
  final fileReader = ConfigFileReader.instance;
  final bool hasNewData;

  QRScreen({Key? key, this.hasNewData = true}) : super(key: key);

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
  String currPage = "";

  Future<void> convertData() async {
    if (!dataConverted && widget.hasNewData) {
      var unprocessedData =
          await widget.db.collection("data").doc("current$currPage").get();
      Compressor compressor =
          Compressor(currentScoutingData!.getData(), pageIndex);
      String newData;

      if (!mounted) return;

      if (unprocessedData == null) {
        newData = compressor.firstCompress();
        SushiScoutsLogin state =
            BlocProvider.of<LoginCubit>(context).state as SushiScoutsLogin;
        var reader = ConfigFileReader.instance;
        widget.db.collection("data").doc("current$currPage").set({
          "data": [newData],
          "lengths": [newData.length],
          "metadata": {
            "name": state.name,
            "teamNum": state.teamNum,
            "eventCode": state.eventCode,
            "configId": "${reader.teamNum!}+${reader.year}+${reader.version}",
            "isBackup": isBackup
          }
        });
      } else {
        final compressedData = CompressedDataModel.fromJson(unprocessedData);
        newData = compressor.firstCompress();
        compressedData.addString(newData);
        widget.db
            .collection("data")
            .doc("current$currPage")
            .set(compressedData.toJson());
      }
    }
    dataConverted = true;
  }

  void deleteBackup() {
    widget.db.collection("data").doc("backup$currPage").delete();
    widget.db.collection("data").doc("current$currPage").delete();
    dataConverted = true;
  }

  Future<int?> getStringLength() async {
    return stringifiedData?.length;
  }



  Future<void> getData() async {
    
    await convertData();
    final compressedData = await widget.db
        .collection("data")
        .doc("${isBackup ? "backup" : "current"}$currPage")
        .get();
    if (compressedData != null) {
      if (isBackup) {
        stringifiedData = json.encode(compressedData);
      } else {
        stringifiedData = json.encode(compressedData);
        final backup =
            await widget.db.collection("data").doc("backup$currPage").get();
        if (backup != null) {
          var newData = CompressedDataModel.fromJson(backup);
          newData.add(CompressedDataModel.fromJson(compressedData));
          widget.db
              .collection("data")
              .doc("backup$currPage")
              .set(newData.toJson());
        } else {
          var dataModel = CompressedDataModel.fromJson(compressedData);
          dataModel.setBackUp(true);
          widget.db
              .collection("data")
              .doc("backup$currPage")
              .set(dataModel.toJson());
        }
        widget.db.collection("data").doc("current$currPage").delete();
      }
      setState(() {
        generateCode = true;
        build(context);
      });
    }
  }

  Future<void> back() async {
    await convertData();
    if (widget.hasNewData) {
      currentScoutingData!.nextMatch();
    }
    RouteHelper.pushAndRemoveUntilToScreen(-1, 0,
        ctx: context, screen: const Scouting());
  }

  Widget buildQRCode() {
    var colors = Theme.of(context);
    bool isPhoneScreen = isPhone(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        Align(
          alignment: const Alignment(0, 1),
          child: SvgPicture.asset(
            isPhoneScreen
                ? "./assets/images/mobile_footer.svg"
                : "./assets/images/FooterColors.svg",
            width: ScreenSize.width,
          ),
        ),
        generateCode
            ? Align(
                alignment: const Alignment(0, -0.65),
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Container(
                      width: ScreenSize.width * (isPhoneScreen ? 0.84 : 0.8),
                      height: ScreenSize.width * (isPhoneScreen ? 0.84 : 0.8),
                      decoration: BoxDecoration(
                          color: isPhoneScreen
                              ? colors.primaryColor
                              : colors.primaryColorDark,
                          borderRadius: BorderRadius.all(
                              Radius.circular(ScreenSize.width * 0.1))),
                    ),
                    Container(
                      width: ScreenSize.width * (isPhoneScreen ? 0.84 : 0.7),
                      height: ScreenSize.width * (isPhoneScreen ? 0.84 : 0.7),
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: ((isPhoneScreen ? 0.83 : 0.7) * ScreenSize.width),
                      child: QrImage(data: stringifiedData!),
                    ),
                  ],
                ))
            : Align(
                alignment: const Alignment(0, -1.4),
                child: SizedBox(
                  height: ScreenSize.height * 0.75,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 35 * ScreenSize.swu),
                          child: Container(
                            width: 340 * ScreenSize.swu,
                            height: (isPhoneScreen ? 75 : 65) * ScreenSize.swu,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: colors.primaryColorDark, width: 3.5),
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
                                "generate QR code",
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
                          padding: EdgeInsets.only(top: 35 * ScreenSize.swu),
                          child: Container(
                            width: (isPhoneScreen ? 295 : 277) * ScreenSize.swu,
                            height: (isPhoneScreen ? 75 : 65) * ScreenSize.swu,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: colors.primaryColorDark, width: 3.5),
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
                                "restore backup",
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
                          padding: EdgeInsets.only(top: 35 * ScreenSize.swu),
                          child: Container(
                            width: 277 * ScreenSize.swu,
                            height: (isPhoneScreen ? 75 : 65) * ScreenSize.swu,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: colors.primaryColorDark, width: 3.5),
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
                                "delete backup",
                                style: TextStyle(
                                    fontSize: 34 * ScreenSize.swu,
                                    fontFamily: "Sushi",
                                    color: colors.primaryColorDark,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ]),
                )),
        (!generateCode)
            ? Align(
                alignment: const Alignment(0, 0.83),
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
                        "CONTINUE",
                        style: TextStyle(
                            fontSize: 35 * ScreenSize.swu,
                            fontFamily: "Sushi",
                            color: colors.primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              )
            : Align(
                alignment: const Alignment(0, 0.83),
                child: Container(
                  width: ScreenSize.width * (isPhoneScreen ? 0.75 : 1),
                  decoration: BoxDecoration(
                    color: colors.primaryColorDark,
                    borderRadius: BorderRadius.all(Radius.circular(
                        ScreenSize.swu * (isPhoneScreen ? 20 : 0))),
                  ),
                  child: Row(children: [
                    Expanded(
                      flex: 1,
                      child: TextButton(
                          onPressed: () => back(),
                          child: Text(
                            "CONTINUE",
                            style: TextStyle(
                                fontSize: 35 * ScreenSize.swu,
                                fontFamily: "Sushi",
                                color: colors.primaryColor,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ]),
                ),
              )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScoutingMethodCubit, ScoutingMethodStates>(
      builder: (context, state) {
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
                  height: ScreenSize.height * 0.89,
                  child: buildQRCode()),
            ],
          ),
        );
      },
    );
  }
}
