import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localstore/localstore.dart';

part 'login_states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoggedOutScouts());

  Future<void> loginSushiScouts(String name, int teamNum, String eventCode) async {
    var db = Localstore.instance;
    await db.collection("preferences").doc("user").set({
      "sushiscouts": true,
      "name": name,
      "teamNum": teamNum,
      "eventCode": eventCode,
    });

    emit(SushiScoutsLogin(name, teamNum, eventCode));
  }

    Future<void> loginSushiSupervise(String name, int teamNum) async {
    var db = Localstore.instance;
    await db.collection("preferences").doc("user").set({
      "sushiscouts": true,
      "name": name,
      "teamNum": teamNum,
    });

    emit(SushiSuperviseLogin(name, teamNum));
  }

  void logOut(bool supervise) {
    var db = Localstore.instance;
    db.collection("preferences").doc("user").delete();
    emit(supervise ? LoggedOutSupervise() : LoggedOutScouts());
  }
}
