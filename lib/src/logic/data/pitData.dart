import 'package:sushi_scouts/src/logic/data/scoutingData.dart';

class PitData extends ScoutingData {
  Map<String, String> _info = {};
  Map<String, String> _subsystems = {};
  Map<String, String> _auto = {};
  Map<String, String> _problems = {};

  @override
  String stringify() {
    String ret = "";
    ret += "P\nI\n${_addSection(_info, ret)}";
    ret += "S\n${_addSection(_subsystems, ret)}";
    ret += "A\n${_addSection(_auto, ret)}";
    ret += "P\n${_addSection(_problems, ret)}";
    ret += "\n";

    return ret;
  }

  String _addSection(Map<String, String> section, String string) {
    section.forEach((name, value) => string += '"$name":"$value"\n');
    return string;
  }

  bool updateVal(String section, String key, String val) {
    switch (section) {
      case "I":
        _info[key] = val;
        break;
      case "S":
        _subsystems[key] = val;
        break;
      case "A":
        _auto[key] = val;
        break;
      case "P":
        _problems[key] = val;
        break;
      default:
        return false;
    }
    return true;
  }

  String? getVal(String section, String key) {
    switch (section) {
      case "I":
        return _info[key];
      case "S":
        return _subsystems[key];
      case "A":
        return _auto[key];
      case "P":
        return _problems[key];
    }
    return null;
  }

}