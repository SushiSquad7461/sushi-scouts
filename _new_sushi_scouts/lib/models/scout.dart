import 'package:flutter/material.dart';

typedef ScoutInfo = ({String name, int teamNum, String event});

class ScoutModel extends ChangeNotifier {
  ScoutInfo? _info;
  ScoutInfo? get userInfo => _info;

  void setLogin(String name, int teamNum, String event) {
    _info = (name: name, teamNum: teamNum, event: event);
    notifyListeners();
  }
}
