// Package imports:
import "package:json_annotation/json_annotation.dart";

// Project imports:
import "../../data/data.dart";
import "component.dart";
import "section.dart";

part "page.g.dart";

@JsonSerializable(explicitToJson: true)
class Screen {
  Screen(this.sections, this.footer);

  String footer;
  List<Section> sections;

  factory Screen.fromJson(Map<String, dynamic> json) => _$ScreenFromJson(json);
  Map<String, dynamic> toJson() => _$ScreenToJson(this);

  List<String> notFilled() {
    List<String> ret = [];

    for (Section i in sections) {
      for (String s in i.notFilled()) {
        ret.add(s);
      }
    }

    return ret;
  }

  List<Component> getComponents() {
    List<Component> components = [];

    for (Section s in sections) {
      for (Component c in s.components) {
        components.add(c);
      }
    }

    return components;
  }

  List<Data> getValues() {
    List<Data> data = [];

    for (Section s in sections) {
      for (Data d in s.values) {
        data.add(d);
      }
    }

    return data;
  }

  int getComponentsPerRow(int currRow) {
    int ret = 0;

    for (Section i in sections) {
      if (i.componentsPerColumn.length > currRow) {
        ret += i.componentsPerColumn[currRow];
      }
    }

    return ret;
  }
}
