// Package imports:
import "package:localstore/localstore.dart";

// Project imports:
import '../../constants.dart';
import "../../data/config_file_reader.dart";
import "../../data/data.dart";
import "../match_schedule.dart";
import "component.dart";
import "page.dart";

/// ScoutingData class stores scouting data for one collection cycle
class ScoutingData {
  String name;
  Map<String, Screen> pages = {};
  List<String> pageNames = [];

  
  static bool hasSchedule = false;
  static MatchSchedule? schedule;

  // Indicates which page of the scouting data we are on
  int currPage = 0;

  ScoutingData(Map<String, dynamic> config, {required this.name}) {
    for (String k in config.keys.toList()) {
      pageNames.add(k);
      pages[k] = Screen.fromJson(config[k]);
    }
  }

  factory ScoutingData.fromJson(Map<String, dynamic> json) {
    final reader = ConfigFileReader.instance;

    // Generate new scouting data based on scouting method
    final newData = reader.generateNewScoutingData(json["name"]);

    for (String pageName in newData.pages.keys) {
      var values = newData.pages[pageName]!.getValues();
      var components = newData.pages[pageName]!.getComponents();

      for (int i = 0; i < values.length; i++) {
        // Set the value of data based on json
        values[i].set(json[pageName][components[i].name], setByUser: true);
      }
    }

    return newData;
  }

  List<String> notFilled() {
    return pages[pageNames[currPage]]!.notFilled();
  }

  bool canGoToNextPage() {
    return currPage < pageNames.length - 1;
  }

  bool canGoToPrevPage() {
    return currPage > 0;
  }

  bool nextPage() {
    if (!canGoToNextPage()) {
      return false;
    }

    currPage += 1;

    return true;
  }

  bool prevPage() {
    if (!canGoToPrevPage()) {
      return false;
    }
    currPage -= 1;
    return true;
  }

  String stringfy() {
    String ret = "${name[0].toUpperCase()}\n";

    for (var i in pages.values) {
      ret += i.toJson().toString();
      ret += "\n";
    }

    return ret;
  }

  Screen? getCurrentPage() {
    return pages[pageNames[currPage]];
  }

  static void updateSchedule() async {
    Localstore db = Localstore.instance;
    var json = (await db.collection(scoutingDataDatabaseName).doc("schedule").get());

    if (json != null) {
      hasSchedule = true;
      schedule = MatchSchedule.fromJson(json);
    } else {
      hasSchedule = false;
    }
  }

  /*
   * Resets data for the next match
   */
  void nextMatch({bool empty = true}) {
    var reader = ConfigFileReader.instance;
    if (empty) {
      currPage = 0;
    }
    List<Data> data = getData();
    List<Component> components = getComponents();

    int? matchNumber;
    int? station;
    int? side;
    bool isQuals = false;
    int? teamNumIndex;
    List<int?> robotNumberIndices = List<int?>.filled(3, null);

    for (int i = 0; i < components.length; i++) {
      if (components[i].name == "match #") {
        if (empty) {
          data[i].increment();
        }
        matchNumber = (data[i].currValue as double).floor();
      } else if (components[i].name == "station") {
        station = (data[i].currValue as double).floor();
      } else if (components[i].name == "match type") {
        isQuals = data[i].get() == "0.0";
      } else if (components[i].name == "team #") {
        teamNumIndex = i;
      } else if (components[i].name == "robot #1") {
        robotNumberIndices[0] = i;
      } else if (components[i].name == "robot #2") {
        robotNumberIndices[1] = i;
      } else if (components[i].name == "robot #3") {
        robotNumberIndices[2] = i;
      } else if (components[i].name == "side") {
        side = i;
      } else if (empty) {
        data[i].empty();
      }
    }
    if (hasSchedule && matchNumber != null && isQuals) {
      List<String> stations = [
        "Red1",
        "Red2",
        "Red3",
        "Blue1",
        "Blue2",
        "Blue3"
      ];
      if (station != null && teamNumIndex != null) {
        int? teamNumber;
        for (Team t in schedule!.schedule[matchNumber - 1].teams) {
          if (t.station == stations[station]) {
            teamNumber = t.number;
            // reader.setCommonValue("team #", t.number);
          }
        }
        data[teamNumIndex]
            .set((teamNumber ?? -1) * 1.0, setByUser: teamNumber != null);
      }
      if (side != null) {
        int num = 1;
        for (int? robotNumberIndex in robotNumberIndices) {
          int? robotNumber;
          if (robotNumberIndex != null) {
            for (Team t in schedule!.schedule[matchNumber - 1].teams) {
              if (t.station == "${side == 0 ? "Red" : "Blue"}$num") {
                robotNumber = t.number;
                reader.setCommonValue("robot #$num", robotNumber);
              }
            }
            data[robotNumberIndex]
                .set((robotNumber ?? -1) * 1.0, setByUser: robotNumber != null);
          }
          num++;
        }
      }
    }
  }

  List<Data> getData() {
    List<Data> data = [];

    for (Screen p in pages.values) {
      for (Data d in p.getValues()) {
        data.add(d);
      }
    }

    return data;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["name"] = name;

    for (int i = 0; i < pages.values.length; i++) {
      var p = pages.values.toList()[i];
      Map<String, dynamic> screenJson = {};
      List<Data> data = p.getValues();
      List<String> names = p.getComponents().map((e) => e.name).toList();

      for (int i = 0; i < data.length; i++) {
        screenJson[names[i]] = data[i].currValue;
      }

      json[pages.keys.toList()[i]] = screenJson;
    }

    return json;
  }

  List<Component> getComponents() {
    List<Component> components = [];

    for (Screen p in pages.values) {
      for (Component c in p.getComponents()) {
        components.add(c);
      }
    }

    return components;
  }

  String getCertainData(String pageName, String componentName) {
    if (!pageNames.contains(pageName)) {
      return "INVALID PAGE NAME";
    }

    int componentCount = 0;
    List<Component> components = pages[pageName]!.getComponents();
    List<Data> values = pages[pageName]!.getValues();
    for (var i in components) {
      if (i.name == componentName) {
        return i.values == null || i.values!.isEmpty
            ? values[componentCount].getSimplified()
            : i.values![int.parse(values[componentCount].getSimplified()) +
                (i.component == "select" ? 1 : 0)];
      }
      componentCount += 1;
    }

    return "INVALID COMPONENT NAME";
  }

  String getCertainDataByName(String componentName) {
    for (final pageName in pages.keys) {
      List<Component> components = pages[pageName]!.getComponents();
      List<Data> values = pages[pageName]!.getValues();
      int componentCount = 0;

      for (var i in components) {
        if (i.name == componentName) {
          if (i.component == "multiselect") {
            String ret = "";
            Map<String, bool> selected = decodeMultiSelectData(
                int.parse(values[componentCount].getSimplified()), i.values!);

            for (final option in selected.keys) {
              if (selected[option]!) {
                ret += "$option . ";
              }
            }

            return ret;
          } else if (i.component == "ranking") {
            return values[componentCount].getSimplified();
          }

          return i.values == null || i.values!.isEmpty
              ? values[componentCount].getSimplified()
              : i.values![int.parse(values[componentCount].getSimplified()) +
                  (i.component == "select" ? 1 : 0)];
        }
        componentCount += 1;
      }
    }
    return "INVALID COMPONENT NAME";
  }

  Map<String, bool> decodeMultiSelectData(int res, List<String> oldValues) {
    int index = 1;
    Map<String, bool> checked = {};

    List<String> values = List.from(oldValues);

    values.remove(values[0]);
    values.remove(values[0]);

    if (values[0] == "l") {
      values.remove(values[0]);
      while (values[0] != "c") {
        values.remove(values[0]);
      }
    }

    values.remove(values[0]);

    for (int i = 0; i < values.length; i++) {
      checked[values[i]] = (index & res) != 0;
      index *= 2;
    }

    return checked;
  }
}
