import 'package:flutter/material.dart';

typedef ScoutInfo = ({String name, int teamNum, String event});

class UserModel extends ChangeNotifier {
  User? _user;
  ScoutInfo? get userInfo => _user?.info;

  void setLogin(String name, int teamNum, String event) {
    _user = Scout((name: name, teamNum: teamNum, event: event));
    notifyListeners();
  }
}

sealed class User {
  ScoutInfo info;

  User(this.info);
}

class Scout extends User {
  Scout(super.info);
}

class Supervisor extends User {
  Supervisor(super.info);
}
