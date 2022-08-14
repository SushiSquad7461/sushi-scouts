import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localstore/localstore.dart';

part 'login_states.dart';

class LoginCubit extends Cubit<Login> {
  LoginCubit() : super(LoggedOut());

  void loginSushiScouts(String name, int teamNum, String eventCode) {
    var db = Localstore.instance;
    db.collection("preferences").doc("user").set({
      "sushiscouts": true,
      "name": name,
      "teamNum": teamNum,
      "eventCode": eventCode,
    });

    emit(SushiScoutsLogin(name, teamNum, eventCode));
  }

  void logOut() {
    var db = Localstore.instance;
    emit(LoggedOut());
  }
}
