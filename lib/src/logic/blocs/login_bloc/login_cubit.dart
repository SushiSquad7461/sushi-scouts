import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_states.dart';

class LoginCubit extends Cubit<Login> {
  LoginCubit() : super(LoggedOut());

  void loginSushiSquad(String name, int teamNum, String eventCode) {
    emit(SushiScoutsLogin(name, teamNum, eventCode));
  }

  void logOut() {
    emit(LoggedOut());
  }
}
