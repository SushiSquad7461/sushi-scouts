import 'package:flutter/services.dart';
import 'package:sushi_scouts/src/logic/data/scoutingData.dart';
import 'dart:convert';

const String CONFIG_PATH = "assets/config/cardinalConfig.json";
List pregameConfig = [];
List autoConfig = [];
List teleopConfig = [];
List endgameConfig = [];

class Data {
  String type;
  String words;
  double num;
  Data(this.type, {this.words = "", this.num = 0});
  void set({double number = 0, String string = ""}) {
    if (type == "String") {
      words = string;
    }
    if (type == "number") {
      num = number;
    }
  }

  bool increment() {
    if (type == "number") {
      num++;
      return true;
    }
    return false;
  }

  bool decrement() {
    if (type == "number") {
      num--;
      return true;
    }
    return false;
  }

  String get() {
    if (type == "number") {
      return num.toString();
    } else {
      return words;
    }
  }

  @override
  String toString() {
    return get();
  }
}

enum MatchStage { pregame, auto, teleop, endgame }

class CardinalData extends ScoutingData {
  Map<String, Data> _pregameData;
  Map<String, Data> _autoData;
  Map<String, Data> _teleopData;
  Map<String, Data> _endgameData;

  CardinalData(
      this._pregameData, this._autoData, this._teleopData, this._endgameData);

  static Future<void> _getConfig() async {
    final String response = await rootBundle.loadString(CONFIG_PATH);
    final data = await json.decode(response);
    pregameConfig = data["pregame"];
    autoConfig = data["auto"];
    teleopConfig = data["teleop"];
    endgameConfig = data["endgame"];
  }

  static Future<CardinalData> firstCreate() async {
    await _getConfig();
    return create();
  }

  static CardinalData create() {
    Map<String, Data> pregameData = {};
    Map<String, Data> autoData = {};
    Map<String, Data> teleopData = {};
    Map<String, Data> endgameData = {};
    for (dynamic item in pregameConfig) {
      pregameData[item["name"]] = Data(item["type"]);
    }
    for (dynamic item in autoConfig) {
      autoData[item["name"]] = Data(item["type"]);
    }
    for (dynamic item in teleopConfig) {
      teleopData[item["name"]] = Data(item["type"]);
    }
    for (dynamic item in endgameConfig) {
      endgameData[item["name"]] = Data(item["type"]);
    }
    return CardinalData(pregameData, autoData, teleopData, endgameData);
  }

  bool setPregame(String key, Data data) {
    if (_pregameData.containsKey(key)) {
      _pregameData[key] = data;
      return true;
    }
    return false;
  }

  bool setAuto(String key, Data data) {
    if (_autoData.containsKey(key)) {
      _autoData[key] = data;
      return true;
    }
    return false;
  }

  bool setTeleop(String key, Data data) {
    if (_teleopData.containsKey(key)) {
      _teleopData[key] = data;
      return true;
    }
    return false;
  }

  bool setEndgame(String key, Data data) {
    if (_endgameData.containsKey(key)) {
      _endgameData[key] = data;
      return true;
    }
    return false;
  }

  String getPregame(String key) {
    if (_pregameData.containsKey(key)) {
      return (_pregameData[key]!.get());
    }
    return "null";
  }

  String getAuto(String key) {
    if (_autoData.containsKey(key)) {
      return (_autoData[key]!.get());
    }
    return "null";
  }

  String getTeleop(String key) {
    if (_teleopData.containsKey(key)) {
      return (_teleopData[key]!.get());
    }
    return "null";
  }

  String getEndgame(String key) {
    if (_endgameData.containsKey(key)) {
      return (_endgameData[key]!.get());
    }
    return "null";
  }

  List<String> getNames(MatchStage stage) {
    switch (stage) {
      case MatchStage.pregame:
        {
          return _pregameData.keys.toList();
        }
      case MatchStage.auto:
        {
          return _autoData.keys.toList();
        }
      case MatchStage.teleop:
        {
          return _teleopData.keys.toList();
        }
      case MatchStage.endgame:
        {
          return _endgameData.keys.toList();
        }
    }
  }

  @override
  String stringfy() {
    return ("Prematch : $_pregameData\nAuto : $_autoData\nTeleop : $_teleopData\nEndgame : $_endgameData");
  }
}
