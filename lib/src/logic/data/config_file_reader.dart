import "dart:convert";

import "package:flutter/services.dart";
import "package:localstore/localstore.dart";

import "../helpers/Constants.dart";
import "../models/scouting_data_models/scouting_data.dart";

class ConfigFileReader {
  String configFileFolder;
  int year;
  int? teamNum;
  Map<String, dynamic>? parsedFile;
  Map<String, dynamic>? supervise;
  Map<String, ScoutingData> data = {};
  Map<String, int> commonValues = {};
  String? password;
  int? _version;
  String? _name;
  final db = Localstore.instance;
  bool defaultConfig = true;

  static final ConfigFileReader _reader =
      ConfigFileReader._(CONFIG_FILE_PATH, 2022);

  ConfigFileReader._(this.configFileFolder, this.year);

  static ConfigFileReader get instance => _reader;

  Future<void> readConfig() async {
    try {
      final String stringifiedFile =
          await rootBundle.loadString("$configFileFolder${year}config.json");
      parsedFile = await json.decode(stringifiedFile);
      teamNum = parsedFile!["teamNumber"];
      password = parsedFile!["password"];
      _version = parsedFile!["version"];
      supervise = parsedFile!["supervise"];
      parsedFile = parsedFile!["scouting"];
      defaultConfig = true;
      return;
    } catch (e) {
      rethrow;
    }
  }

  String getSuperviseDisplayString(ScoutingData data, int number) {
    if (supervise == null || supervise![data.name] == null) {
      return "ERR";
    }
    return data.getCertainData(
        supervise![data.name][number == 1 ? "first" : "second"]["page"],
        supervise![data.name][number == 1 ? "first" : "second"]["name"]);
  }

  Future<void> readInitalConfig() async {
    var user = await db.collection("preferences").doc("user").get();

    // if (user != null && user["teamNum"] != null) {
    //   var found = await db
    //       .collection("config_files")
    //       .doc(user["teamNum"].toString())
    //       .get();

    //   if (found != null) {
    //     await readConfigFromDatabase(user["teamNum"]);
    //     return;
    //   } else {
    //     await readConfig();
    //   }
    // } else {
    //   await readConfig();
    // }
    await readConfig();
  }

  Future<void> readConfigFromDatabase(int teamNum) async {
    try {
      parsedFile =
          await db.collection("config_files").doc(teamNum.toString()).get();
      teamNum = parsedFile!["teamNumber"];
      password = parsedFile!["password"];
      _version = parsedFile!["version"];
      parsedFile = parsedFile!["scouting"];
      defaultConfig = false;
      return;
    } catch (e) {
      rethrow;
    }
  }

  List<String> getScoutingMethods() {
    return parsedFile != null ? parsedFile!.keys.toList() : [];
  }

  ScoutingData getScoutingData(String scoutingMethod) {
    data[scoutingMethod] ??=
        ScoutingData(parsedFile![scoutingMethod], name: scoutingMethod);
    return data[scoutingMethod]!;
  }

  ScoutingData generateNewScoutingData(String scoutingMethod) {
    return ScoutingData(parsedFile![scoutingMethod], name: scoutingMethod);
  }

  // List<ScoutingData> getScoutingDataClasses() {
  //   List<ScoutingData> ret = [];
  //   for (var scoutingMethod in parsedFile!.keys) {
  //     ret.add(ScoutingData(parsedFile![scoutingMethod], name: scoutingMethod));
  //   }
  //   return ret;
  // }

  bool extraFeatureAccess(var AUTHORIZEDTEAMS) {
    return AUTHORIZEDTEAMS.contains(teamNum);
  }

  void setCommonValue(String key, int value) {
    commonValues[key] = value;
  }

  bool commonValuesExists(String key) {
    return commonValues.containsKey(key);
  }

  int? getCommonValue(String key) {
    if (!commonValues.containsKey(key)) {
      return null;
    }
    return commonValues[key]!;
  }

  bool checkPassword(String s) => s == (password ?? "");

  int get version => _version ?? 0;
  String get name => _name ?? "";

  set setName(String name) => _name = name;

  String get id => "${teamNum!}+${year.toString()}+${version.toString()}";
}
