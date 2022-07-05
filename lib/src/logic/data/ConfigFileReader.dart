import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:sushi_scouts/src/logic/Constants.dart';
import 'package:sushi_scouts/src/logic/data/ScoutingData.dart';

import 'ScoutingData.dart';

class ConfigFileReader {
  int teamNum;
  Map<String, dynamic> parsedFile;

  ConfigFileReader(this.teamNum, this.parsedFile);

  static Future<ConfigFileReader> create(String configFileFolder, int year) async {
  int teamNum;
  Map<String, dynamic> parsedFile;
    try {
      final String stringifiedFile =
          await rootBundle.loadString("$configFileFolder${year}config.json");
      parsedFile = await json.decode(stringifiedFile);
      teamNum = parsedFile!["teamNumber"];
      parsedFile = parsedFile!["scouting"];
      return ConfigFileReader(teamNum, parsedFile);
    } catch (e) {
      rethrow;
    }
  }

  List<String> getScoutingMethods() {
    return parsedFile.keys.toList();
  }

  ScoutingData generateScoutingData(String scoutingMethod) {
    return ScoutingData(parsedFile[scoutingMethod]);
  }

  bool extraFeatureAccess() {
    return AUTHORIZED_TEAMS.contains(teamNum);
  }
}