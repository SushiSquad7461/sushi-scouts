import 'package:flutter_bloc/flutter_bloc.dart';

part 'scouting_method_states.dart';

class ScoutingMethodCubit extends Cubit<ScoutingMethodStates> {
  ScoutingMethodCubit() : super(ScoutingMethodsUninitialized());
  void changeMethod(String method, int pageNumber) {
    emit(ScoutingMethodsInitialized(method, pageNumber));
  }
}
