import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:sushi_scouts/src/logic/Constants.dart';
import 'package:sushi_scouts/src/logic/data/ScoutingData.dart';

import 'ScoutingData.dart';

class ConfigFileReader {
  String configFileFolder;
  int year;
  int? teamNum;
  Map<String, dynamic>? parsedFile;

  ConfigFileReader(this.configFileFolder, this.year);

  Future<void> readConfig() async {
    try {
      final String stringifiedFile =
          await rootBundle.loadString("$configFileFolder${year}config.json");
      parsedFile = await json.decode(stringifiedFile);
      teamNum = parsedFile!["teamNumber"];
      parsedFile = parsedFile!["scouting"];
      return;
    } catch (e) {
      rethrow;
    }
  }

  List<String> getScoutingMethods() {
    return parsedFile != null ? parsedFile!.keys.toList() : [];
  }

  ScoutingData? generateScoutingData(String scoutingMethod) {
    return ScoutingData(parsedFile![scoutingMethod], name: scoutingMethod);
  }

  List<ScoutingData> getScoutingDataClasses() {
    List<ScoutingData> ret = [];
    for (var scoutingMethod in parsedFile!.keys) {
      ret.add(ScoutingData(parsedFile![scoutingMethod], name: scoutingMethod));
    }
    return ret;
  }

  bool extraFeatureAccess() {
    return AUTHORIZED_TEAMS.contains(teamNum);
  }
}
