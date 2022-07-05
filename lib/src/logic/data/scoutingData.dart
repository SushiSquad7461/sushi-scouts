import 'dart:io';

import 'package:flutter/services.dart';
import 'package:sushi_scouts/src/logic/data/Data.dart';
import 'dart:convert';

class Component {
  String name;
  List<String>? values;
  String component;
  String type;
  Component(this.name, this.type, this.component, {this.values=null});
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
  late Map<int, Component> components; 
  late Map<int, Data> data;
  late Map<String, List<Section>> sections;
  String name;

  ScoutingData(Map<String, dynamic> config, {required this.name}){
    components = {};
    data = {};
    sections = {};
    int startValue = 0;
    for(String key in config.keys.toList()) {
      List<Section> section = [];
      for(dynamic item in config[key].toList()) {
        int length = item["components"].toList().length;
        Map properties = item["properties"];
        List localComponents = item["components"].toList();
        section.add(Section(startValue, length, int.parse(properties["color"])+0xff000000, properties["rows"], int.parse(properties["textColor"])+0xff000000, properties["footer"]));
        int end = startValue + length;
        int start = startValue;
        for(int i = startValue; i<end; i++) {
          Map component = localComponents[i-start]; 
          components[i] = Component(component["name"], component["type"], component["component"], values: (component["values"]!=null ? (component['values'] as List)?.map((item) => item as String)?.toList() : null));
          data[i] = component["type"]=="number" ? Data<double>(0) : Data<String>("");
          startValue++;
        }
      }
      sections[key] = section;
    }
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
      print(end);
      for(int i = startValue; i<end; i++) {
        String name = components[i]!.name;
        String value = data[i]!.get();
        stringified = "$stringified \"$name\" : \"$value\"";
        if(i < (end-1)) {
          stringified = "$stringified, ";
        }
      }
      stringified = "$stringified}\n";
      if(stages.indexOf(stage) != stages.length-1) {
        stringified = "$stringified, ";
      }
    }
    return "$stringified}";
  }
}