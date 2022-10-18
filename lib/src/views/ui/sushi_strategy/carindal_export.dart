// Flutter imports:
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import "package:flutter/material.dart";
import "package:flutter/services.dart";

// Package imports:
import "package:csv/csv.dart";
import "package:localstore/localstore.dart";
import 'package:path_provider/path_provider.dart';

// Project imports:
import "../../../logic/Constants.dart";
import "../../../logic/data/config_file_reader.dart";
import "../../../logic/helpers/size/screen_size.dart";
import "../../../logic/models/scouting_data_models/page.dart";
import "../../../logic/models/supervise_data.dart";
import "../../util/header/header_nav_strategy.dart";
import "../../util/header/header_title/mobile_strategy_main.dart";

class CardinalExport extends StatefulWidget {
  const CardinalExport({Key? key}) : super(key: key);

  @override
  State<CardinalExport> createState() => _CardinalExportState();
}

class _CardinalExportState extends State<CardinalExport> {
  final method = "cardinal";
  final db = Localstore.instance;
  final reader = ConfigFileReader.instance;
  Map<String, List<SuperviseData>> robotMap = {};

  @override
  void initState() {
    super.initState();

    (() async {
      final scoutingData = await db.collection(stratDatabaseName).get();

      if (scoutingData != null) {
        setState(() {
          for (var name in scoutingData.keys) {
            final toAdd = SuperviseData.fromJson(scoutingData[name]);
            if (toAdd.methodName == method && toAdd.deleted == false) {
              String id = "${toAdd.display1}:${toAdd.display2}";
              if (robotMap.containsKey(id)) {
                robotMap[id]!.add(toAdd);
              } else {
                robotMap[id] = [toAdd];
              }
            }
          }
        });
      }
    })();
  }

  Future<void> export() async {
    List<List<String>> exportData = [];

    exportData.add(["name", "flagged", "team num"]);

    Map<String, Screen> pages =
        ConfigFileReader.instance.generateNewScoutingData(method).pages;

    for (final page in pages.keys) {
      for (final i in pages[page]!.getComponents()) {
        exportData[0].add(page + i.name);
      }
    }

    for (final i in robotMap.values) {
      List<String> addData = [
        i[0].name,
        i[0].flagged.toString(),
        i[0].teamNum.toString()
      ];

      // for (final component in components) {
      //   addData.add(i.data.getCertainDataByName(component.name));
      // }

      for (final page in pages.keys) {
        for (final component in pages[page]!.getComponents()) {
          addData.add(i[0].data.getCertainData(page, component.name));
        }
      }

      exportData.add(addData);
    }

    String csvData = const ListToCsvConverter().convert(exportData);

    //this csv variable holds entire csv data
    //Now Convert or encode this csv string into utf8
    final bytes = utf8.encode(csvData);

    print(await getDownloadPath());

    // Create a new file. You can create any kind of file like txt, doc , json etc.
    File file = await File("${await getDownloadPath()}/Toastguyz.json").create();

    String fileContent = json.encode({
      "Website": {
        "Name": "Toastguyz",
        "Description": "Programming Tutorials2",
      },
    });

// You can write to file using writeAsString. This method takes string argument
// To write to text file we can use like file.writeAsString("Toastguyz file content");
    await file.writeAsString(fileContent);

    // await Clipboard.setData(ClipboardData(text: csvData));

    print(bytes);

    // Uint8List data = Uint8List.fromList(bytes);

    // // storage permission ask
    // var status = await Permission.storage.status;
    // if (!status.isGranted) {
    //   await Permission.storage.request();
    // }
    // // the downloads folder path
    // Directory tempDir = await DownloadsPathProvider.downloadsDirectory;
    // String tempPath = tempDir.path;
    // var filePath = tempPath + '/bob.csv';
    //

    // the data
    // var bytes2 = ByteData.view(data.buffer);
    // final buffer = bytes2.buffer;
    // // save the data in the path
    // File(filePath).writeAsBytes(
    //     buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));

    // final taskId = await FlutterDownloader.enqueue(
    //   // url: "data:text/plain;charset=UTF-8,$csvData",
    //   url: "https://en.wikipedia.org/wiki/Hurricane_Julia_(2022)#/media/File:Julia_2022-10-09_0710Z.jpg",
    //   saveInPublicStorage: true,
    //   savedDir: (await getDownloadPath())!,
    //   showNotification:
    //       true, // show download progress in status bar (for Android)
    //   openFileFromNotification:
    //       true, // click on notification to open downloaded file (for Android)
    // );
  }

  Future<String?> getDownloadPath() async {
    Directory? directory;
    try {
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = Directory('/storage/emulated/0/Download');
        // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
        // ignore: avoid_slow_async_io
        if (!await directory.exists())
          directory = await getExternalStorageDirectory();
      }
    } catch (err, stack) {
      print("Cannot get download folder path");
    }
    return directory?.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            const HeaderTitleMobileStrategyMain(),
            Center(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: Colors.black, width: ScreenSize.width * 0.005),
                    borderRadius:
                        BorderRadius.all(Radius.circular(20 * ScreenSize.swu))),
                child: Padding(
                  padding: EdgeInsets.all(ScreenSize.width * 0.02),
                  child: TextButton(
                      onPressed: export,
                      child: Text(
                        "export data",
                        style: TextStyle(
                          fontFamily: "Sushi",
                          color: Colors.black,
                          fontSize: ScreenSize.swu * 30,
                        ),
                      )),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: ScreenSize.height * 0.14),
              child: const HeaderNavStrategy(currPage: "cardinal"),
            ),
          ],
        ));
  }
}
