import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localstore/localstore.dart';

part 'theme_states.dart';

class ThemeCubit extends Cubit<ThemeStates> {
  ThemeCubit() : super(LightMode());

  void switchTheme({required bool isDarkMode}) {
    if (isDarkMode) {
      emit(DarkMode());
    } else {
      emit(LightMode());
    }
  }

  Future<void> setMode() async {
    var db = Localstore.instance;
    final data = await db.collection("preferences").doc("mode").get();

    if (data != null) {
      data["mode"] == "dark" ? emit(DarkMode()) : emit(LightMode());
    }
  }
}
