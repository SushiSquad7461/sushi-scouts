import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localstore/localstore.dart';

part 'login_states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoggedOut());

  Future<void> loginSushiScouts(
      String name, int teamNum, String eventCode) async {
    var db = Localstore.instance;
    await db.collection("preferences").doc("user").set({
      "name": name,
      "teamNum": teamNum,
      "eventCode": eventCode,
    });

    emit(SushiScoutsLogin(name, teamNum, eventCode));
  }

  Future<void> loginSushiSupervise(String eventCode, int teamNum) async {
    var db = Localstore.instance;
    await db
        .collection("preferences")
        .doc("user")
        .set({"eventCode": eventCode, "teamNum": teamNum, "name": ""});

    emit(SushiSuperviseLogin(eventCode, teamNum));
  }

  void logOut() {
    emit(LoggedOut());
  }
}
