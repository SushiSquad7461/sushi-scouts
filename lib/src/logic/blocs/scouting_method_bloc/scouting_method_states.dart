part of 'scouting_method_cubit.dart';

abstract class ScoutingMethodStates {}

class ScoutingMethodsUninitialized extends ScoutingMethodStates {}

class ScoutingMethodsInitialized extends ScoutingMethodStates {
  final String method;
  final int pageNumber;
  ScoutingMethodsInitialized(this.method, this.pageNumber);
}

