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
  bool setByUser;
  Data(this.type, {this.words = "", this.num = 0, this.setByUser=false});
  void set({double number = 0, String string = "", bool setByUser=false}) {
    this.setByUser=setByUser;
    if (type == "string") {
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

  bool set(String key, Data data, MatchStage stage) {
    switch (stage) {
      case MatchStage.pregame:
        {
          if (_pregameData.containsKey(key)) {
            _pregameData[key] = data;
            return true;
          }
          return false;
        }
      case MatchStage.auto:
        {
          if (_autoData.containsKey(key)) {
            _autoData[key] = data;
            return true;
          }
          return false;
        }
      case MatchStage.teleop:
        {
          if (_teleopData.containsKey(key)) {
            _teleopData[key] = data;
            return true;
          }
          return false;
        }
      case MatchStage.endgame:
        {
          if (_endgameData.containsKey(key)) {
            _endgameData[key] = data;
            return true;
          }
          return false;
        }
    }
    return false;
  }

  String get(String key, MatchStage stage) {
    switch (stage) {
      case MatchStage.pregame:
        {
          if (_pregameData.containsKey(key)) {
            return (_pregameData[key]!.get());
          }
          return "null";
        }
      case MatchStage.auto:
        {
          if (_autoData.containsKey(key)) {
            return (_autoData[key]!.get());
          }
          return "";
        }
      case MatchStage.teleop:
        {
          if (_teleopData.containsKey(key)) {
            return (_teleopData[key]!.get());
          }
          return "";
        }
      case MatchStage.endgame:
        {
          if (_endgameData.containsKey(key)) {
            return (_endgameData[key]!.get());
          }
          return "";
        }
    }
    return "";
  }

  Data getData(MatchStage stage, String key) {
    switch (stage) {
      case MatchStage.pregame:
        {
          if (_pregameData.containsKey(key)) {
            return _pregameData[key]!;
          }
        }
        break;
      case MatchStage.auto:
        {
          if (_autoData.containsKey(key)) {
            return _autoData[key]!;
          }
        }
        break;
      case MatchStage.teleop:
        {
          if (_teleopData.containsKey(key)) {
            return _teleopData[key]!;
          }
        }
        break;
      case MatchStage.endgame:
        {
          if (_endgameData.containsKey(key)) {
            return _endgameData[key]!;
          }
        }
        break;
    }
    return Data("number");
  }

  List<String> getNames(MatchStage stage) {
    List<String> empty = [];
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
    return empty;
  }

  List<List<String>?> getValues(MatchStage stage) {
    List<List<String>?> values = [];
    List<String> componentValues = [];
    switch (stage) {
      case MatchStage.pregame:
        {
          for (dynamic list in pregameConfig) {
            componentValues = [];
            if(list["values"]!=null){
              for(dynamic item in list["values"]) {
                componentValues.add(item.toString());
              }
            }
            values.add(componentValues);
          }
        }
        break;
      case MatchStage.auto:
        {
          for (dynamic list in autoConfig) {
            componentValues = [];
            if(list["values"]!=null){
              for(dynamic item in list["values"]) {
                componentValues.add(item.toString());
              }
            }
            values.add(componentValues);
          }
        }
        break;
      case MatchStage.teleop:
        {
          for (dynamic list in teleopConfig) {
            componentValues = [];
            if(list["values"]!=null){
              for(dynamic item in list["values"]) {
                componentValues.add(item.toString());
              }
            }
            values.add(componentValues);
          }
        }
        break;
      case MatchStage.endgame:
        {
          for (dynamic list in endgameConfig) {
            componentValues = [];
            if(list["values"]!=null){
              for(dynamic item in list["values"]) {
                componentValues.add(item.toString());
              }
            }
            values.add(componentValues);
          }
        }
    }
    return values;
  }

  List<String> getComponents(MatchStage stage) {
    List<String> components = [];
    switch (stage) {
      case MatchStage.pregame:
        {
          for (dynamic item in pregameConfig) {
            components.add(item["component"]);
          }
        }
        break;
      case MatchStage.auto:
        {
          for (dynamic item in autoConfig) {
            components.add(item["component"]);
          }
        }
        break;
      case MatchStage.teleop:
        {
          for (dynamic item in teleopConfig) {
            components.add(item["component"]);
          }
        }
        break;
      case MatchStage.endgame:
        {
          for (dynamic item in endgameConfig) {
            components.add(item["component"]);
          }
        }
    }
    return components;
  }

  @override
  String stringfy() {
    return ("Prematch : $_pregameData\nAuto : $_autoData\nTeleop : $_teleopData\nEndgame : $_endgameData");
  }
}
