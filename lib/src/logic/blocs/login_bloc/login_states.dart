part of "login_cubit.dart";

abstract class Login {
  String get eventCode {
    return "";
  }
}

class LoggedOut extends Login {}

class SushiScoutsLogin extends Login {
  final String name;
  final int teamNum;
  final String _eventCode;
  SushiScoutsLogin(this.name, this.teamNum, this._eventCode);

  @override
  String get eventCode {
    return _eventCode;
  }
}

class SushiSuperviseLogin extends Login {
  final String _eventCode;
  final int teamNum;
  SushiSuperviseLogin(this._eventCode, this.teamNum);

  @override
  String get eventCode {
    return _eventCode;
  }
}
