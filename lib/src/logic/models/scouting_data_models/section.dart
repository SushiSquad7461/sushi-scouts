import 'package:json_annotation/json_annotation.dart';
import 'package:sushi_scouts/src/logic/data/Data.dart';
import 'package:sushi_scouts/src/logic/helpers/color/hex_color.dart';

import 'component.dart';

class Section {
  Section(
      this.title,
      this.color,
      this.columns,
      this.textColor,
      this.components,
      this.componentsPerColumn,
      this.darkColor,
      this.darkTextColor,
      this.values);

  HexColor color;
  int columns;
  HexColor textColor;
  HexColor darkColor;
  HexColor darkTextColor;
  String title;
  List<Component> components;
  List<Data> values = [];
  List<int> componentsPerColumn;

  factory Section.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> properties = json["properties"];
    List<Component> components = (json["components"] as List<dynamic>)
        .map((e) => Component.fromJson(e))
        .toList();
    List<Data> values = components.map((e) => Data.fromComponent(e)).toList();
    return Section(
        properties["title"],
        HexColor(properties['color']),
        properties['rows'],
        HexColor(properties['textColor']),
        components,
        (properties['componentsInRow'] as List<dynamic>)
            .map((e) => e as int)
            .toList(),
        HexColor(properties['darkColor']),
        HexColor(properties['darkTextColor']),
        values);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> res = {};
    for (int i = 0; i < components.length; i++) {
      res[components[i].name] = values[i].get();
    }
    return res;
  }

  void empty() {
    for (int i = 0; i < values.length; ++i) {
      values[i].empty();
    }
  }

  List<String> notFilled() {
    List<String> ret = [];
    for (int i = 0; i < components.length; i++) {
      if (components[i].required && !values[i].setByUser) {
        ret.add(components[i].name);
      }
    }
    return ret;
  }

  HexColor getColor(bool darkMode) => darkMode ? darkColor : color;

  HexColor getTextColor(bool darkMode) => darkMode ? darkTextColor : textColor;

  int numComponents() => components.length;

  void fromStringfy(Map<String, dynamic> newData) {
    for (int i = 0; i < components.length; ++i) {
      if (newData.keys.contains(components[i].name)) {
        String newDataString = newData[components[i].name];

        print(components[i].type);

        switch (components[i].type) {
          case "number":
            values[i].set(double.parse(newDataString), setByUser: true);
            break;
          case "bool":
            values[i].set(newDataString == "true", setByUser: true);
            break;
          default:
            values[i].set(newDataString, setByUser: true);
        }
      }
    }
  }
}
