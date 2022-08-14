part of "login_cubit.dart";

abstract class Login {
  String get eventCode {
    return "";
  }

  int get teamNum {
    return 0;
  }
}

class LoggedOut extends Login {}

class SushiScoutsLogin extends Login {
  final String name;
  final int _teamNum;
  final String _eventCode;
  SushiScoutsLogin(this.name, this._teamNum, this._eventCode);

  @override
  String get eventCode {
    return _eventCode;
  }

  @override
  int get teamNum {
    return _teamNum;
  }
}

class SushiSuperviseLogin extends Login {
  final String _eventCode;
  final int _teamNum;
  SushiSuperviseLogin(this._eventCode, this._teamNum);

  @override
  String get eventCode {
    return _eventCode;
  }

  @override
  int get teamNum {
    return _teamNum;
  }
}
