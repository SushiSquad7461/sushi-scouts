// Project imports:
import 'package:localstore/localstore.dart';

import "../../data/config_file_reader.dart";
import "../../data/data.dart";
import '../match_schedule.dart';
import "component.dart";
import "page.dart";

class ScoutingData {
  String name;
  Map<String, Screen> pages = {};
  List<String> pageNames = [];
  int currPage = 0;

  ScoutingData(Map<String, dynamic> config, {required this.name}) {
    for (String k in config.keys.toList()) {
      pageNames.add(k);
      pages[k] = Screen.fromJson(config[k]);
    }
  }

  factory ScoutingData.fromJson(Map<String, dynamic> json) {
    var reader = ConfigFileReader.instance;
    var emptyData = reader.getScoutingData(json["name"]);
    for (String pageName in emptyData.pages.keys) {
      var values = emptyData.pages[pageName]!.getValues();
      var components = emptyData.pages[pageName]!.getComponents();
      for (int i = 0; i < values.length; i++) {
        values[i].set(json[pageName][components[i].name], setByUser: true);
      }
    }
    return emptyData;
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
    if(currPage == 0) {
      nextMatch(empty: false);
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

  void nextMatch({bool empty = true}) async{
    currPage = 0;
    List<Data> data = getData();
    List<Component> components = getComponents();
    Localstore db = Localstore.instance;
    var json = (await db.collection("data").doc("schedule").get());
    bool hasSchedule;
    MatchSchedule? schedule;
    if(json != null) {
      hasSchedule = true;
      schedule = MatchSchedule.fromJson(json);
    } else {
      hasSchedule = false;
    }
    int? matchNumber;
    int? station;
    bool isQuals = false;
    int? teamNumIndex;

    for (int i = 0; i<components.length; i++) {
      if(components[i].name == "match #") {
        if(empty) {
          data[i].increment();
        }
        matchNumber = (data[i].currValue as double).floor();
      } else if(components[i].name == "station") {
        station = (data[i].currValue as double).floor();
      } else if(components[i].name == "match type") {
        isQuals = data[i].get() == "0.0";
      } else if(components[i].name == "team #") {
        teamNumIndex = i;
      } else if(empty){
        data[i].empty();
      }
    }
    if (hasSchedule && matchNumber != null && station != null && teamNumIndex != null && isQuals) {
      int? teamNumber;
      List<String> stations = ["Red1", "Red2", "Red3", "Blue1", "Blue2", "Blue3"];
      for (Team t in schedule!.schedule[matchNumber].teams) {
        if(t.station == stations[station]){
          teamNumber = t.number;
        }
      }
      data[teamNumIndex].set((teamNumber??-1)*1.0, setByUser: teamNumber != null);
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
}
