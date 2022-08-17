import 'dart:convert';

import 'package:flutter/services.dart';

import '../helpers/Constants.dart';
import '../models/scouting_data_models/scouting_data.dart';

class ConfigFileReader {
  String configFileFolder;
  int year;
  int? teamNum;
  Map<String, dynamic>? parsedFile;
  Map<String, ScoutingData> data = {};
  Map<String, int> commonValues = {};
  String? password;
  double? _version;

  static final ConfigFileReader _reader = ConfigFileReader._(CONFIG_FILE_PATH, 2022);

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
      parsedFile = parsedFile!["scouting"];
      return;
    } catch (e) {
      rethrow;
    }
  }

  List<String> getScoutingMethods() {
    return parsedFile != null ? parsedFile!.keys.toList() : [];
  }

  ScoutingData getScoutingData(String scoutingMethod) {
    data[scoutingMethod] ??= ScoutingData(parsedFile![scoutingMethod], name: scoutingMethod);
    return data[scoutingMethod]!;
  }

  // List<ScoutingData> getScoutingDataClasses() {
  //   List<ScoutingData> ret = [];
  //   for (var scoutingMethod in parsedFile!.keys) {
  //     ret.add(ScoutingData(parsedFile![scoutingMethod], name: scoutingMethod));
  //   }
  //   return ret;
  // }

  bool extraFeatureAccess(var AUTHORIZED_TEAMS) {
    return AUTHORIZED_TEAMS.contains(teamNum);
  }

  void setCommonValue(String key, int value) {
    commonValues[key] = value;
  }

  bool commonValuesExists(String key) {
    return commonValues.containsKey(key);
  }

  int? getCommonValue(String key) {
    if( !commonValues.containsKey(key)) {
      return null;
    }
    return commonValues[key]!;
  }

  bool checkPassword(String s) => s == (password??"");

  double get version => _version??0; 
}