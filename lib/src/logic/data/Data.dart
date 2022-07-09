/*
  The Data classes purpose is to store the current value of a component.
  It currently supports strings and numbers.
*/
import 'package:sushi_scouts/src/logic/Constants.dart';

class Data<ValueType> {
  // Current value of the component
  ValueType currValue;
  Map<int, ValueType> timestamps = {};
  DateTime? initialTime;
  DateTime? lastTime;
  bool setByUser;

  Data(this.currValue, {this.setByUser = false});

  // Set the current value
  void set(ValueType newVal, {setByUser = false}) {
    currValue = newVal;
    this.setByUser = setByUser;

    if (setByUser) {
      logeTimeStamp();
    }
  }

  // Increments the current value if it is an number and retuns true, otherwise returns false
  bool increment() {
    if (currValue is double) {
      currValue = ((currValue as double) + 1) as ValueType;
      setByUser = true;
      logeTimeStamp();
      return true;
    }
    return false;
  }

  // Decrements the current value if it is an number and retuns true, otherwise returns false
  bool decrement() {
    if (currValue is double) {
      currValue = ((currValue as double) - 1) as ValueType;
      logeTimeStamp();
      setByUser = true;
      return true;
    }
    return false;
  }

  // Gets the current value as a string
  String get() {
    return (currValue is double || currValue is double)
        ? (currValue as double).toString()
        : (currValue as String);
  }

  void empty() {
    setByUser = false;
    timestamps = {};
    (currValue is double)
        ? (currValue = 0.0 as ValueType)
        : (currValue = '' as ValueType);
  }

  void logeTimeStamp() {
    if (timestamps.isEmpty) {
      timestamps[0] = currValue;
      initialTime = DateTime.now();
      lastTime = initialTime;
    } else {
      int? diffBetweenInitial =
          initialTime?.difference(DateTime.now()).inMilliseconds.abs();

      int? diffBetweenLast =
          lastTime?.difference(DateTime.now()).inMilliseconds;
      if (diffBetweenLast!.abs() > MIN_TIMESTAMP_DIFFERENCE) {
        timestamps[diffBetweenInitial!] = currValue;
        lastTime = DateTime.now();
        print("CHANGE");
      }
    }
  }
}
