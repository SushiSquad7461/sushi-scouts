import 'dart:io';

import 'package:flutter/services.dart';
import 'package:sushi_scouts/src/logic/data/Data.dart';
import 'dart:convert';

const String CONFIG_PATH = "assets/config/config.json";

class ComponentDetails {
  String name;
  List<String>? values;
  String component;
  String type;
  ComponentDetails(this.name, this.type, this.component, {this.values=null});
}

class Section {
  int startValue;
  int length;
  int color;
  int rows;
  int textColor;
  String footer;
  Section(this.startValue, this.length, this.color, this.rows, this.textColor, this.footer);
}

class ScoutingData {
  Map<int, ComponentDetails> components; 
  Map<int, Data> data;
  Map<String, List<Section>> sections;

  ScoutingData(this.components, this.data, this.sections);

  static Future<List<String>> getScreens() async{
    final String response = await rootBundle.loadString(CONFIG_PATH);
    final dynamic config = await json.decode(response);
    return config.keys.toList();
  }

  static Future<ScoutingData> create(String screen) async {
    final String response = await rootBundle.loadString(CONFIG_PATH);
    final dynamic config = await json.decode(response)[screen];
    Map<int, ComponentDetails> components = {}; 
    Map<int, Data> data = {};
    Map<String, List<Section>> sections = {};
    int startValue = 0;
    for(String key in config.keys.toList()) {
      List<Section> section = [];
      for(dynamic item in config[key].toList()) {
        int length = item["components"].toList().length;
        Map properties = item["properties"];
        List localComponents = item["components"].toList();
        section.add(Section(startValue, length, int.parse(properties["color"])+0xff000000, properties["rows"], int.parse(properties["textColor"]), properties["footer"]));
        int end = startValue + length;
        int start = startValue;
        for(int i = startValue; i<end; i++) {
          Map component = localComponents[i-start]; 
          components[i] = ComponentDetails(component["name"], component["type"], component["component"], values: (component["values"]!=null ? (component['values'] as List)?.map((item) => item as String)?.toList() : null));
          data[i] = Data(component["type"]);
          startValue++;
        }
      }
      sections[key] = section;
    }
    return ScoutingData(components, data, sections);
  }
  
  List<String> getStages() {
    return sections.keys.toList();
  }

  String stringfy() {
    String stringified = "{";
    List<String> stages = sections.keys.toList();
    for(String stage in stages) {
      int startValue = sections[stage]![0].startValue;
      int end = sections[stage]![sections[stage]!.length-1].startValue+sections[stage]![sections[stage]!.length-1].length;
      stringified = "$stringified\"$stage\" : {";
      for(int i = startValue; i<end; i++) {
        String name = components[i]!.name;
        Data value = data[i]!;
        stringified = "$stringified \"$name\" : \"$value\",";
      }
      stringified = "$stringified}\n";
    }
    return "$stringified}";
  }
}