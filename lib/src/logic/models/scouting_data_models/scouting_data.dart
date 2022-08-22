import 'package:get/get_state_manager/get_state_manager.dart';

import '../../data/Data.dart';
import 'component.dart';
import 'page.dart';

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

  void empty() {
    print('e');
    currPage = 0;
    for (var page in pageNames) {
      pages[page]!.empty();
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
            : i.values![int.parse(values[componentCount].getSimplified())];
      }
      componentCount += 1;
    }
    return "INVALID COMPOMENT NAME";
  }
}
