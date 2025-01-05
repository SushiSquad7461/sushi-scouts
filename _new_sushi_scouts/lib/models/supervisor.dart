import 'package:flutter/material.dart';

typedef SupervisorInfo = ({String name, int teamNum, String event});

class ScoutModel extends ChangeNotifier {
  SupervisorInfo? _info;
  SupervisorInfo? get userInfo => _info;

  void setLogin(String name, int teamNum, String event) {
    _info = (name: name, teamNum: teamNum, event: event);
    notifyListeners();
  }
}
