import 'package:sushi_scouts/src/logic/data/scoutingData.dart';

class PitData extends ScoutingData {
  Map<String, String> _info = {};
  Map<String, String> _capabilities = {};
  Map<String, String> _problems = {};

  PitData(String configFilePath) { }

  @override
  String stringify() {
    String ret = "";
    ret += "P\nI\n${_addSection(_info, ret)}";
    ret += "C\n${_addSection(_capabilities, ret)}";
    ret += "P\n${_addSection(_problems, ret)}";
    ret += "\n";
    return ret;
  }

  String _addSection(Map<String, String> section, String string) {
    section.forEach((name, value) => string += '"$name":"$value"\n');
    return string;
  }

  bool updateVal(PitScouting section, String key, String val) {
    switch (section) {
      case PitScouting.info:
        _info[key] = val;
        break;
      case PitScouting.capabilities:
        _capabilities[key] = val;
        break;
      case PitScouting.problems:
        _problems[key] = val;
        break;
      default:
        return false;
    }
    return true;
  }

  String? getVal(String section, String key) {
    switch (section) {
      case PitScouting.info:
        return _info[key];
      case PitScouting.capabilities:
        return _capabilities[key];
      case PitScouting.problems:
        return _problems[key];
    }
    return null;
  }

}