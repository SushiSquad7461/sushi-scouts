/*
  The Data classes purpose is to store the current value of a component.
  It currently supports strings and integers.
*/
class Data<ValueType> {
  // Current value of the component
  ValueType currValue;
  bool setByUser;

  Data(this.currValue, {this.setByUser = false});

  // Set the current value
  void set(ValueType newVal, {bool setByUser = false}) {
    this.setByUser = setByUser;
    currValue = newVal;
  }

  // Increments the current value if it is an integer and retuns true, otherwise returns false
  bool increment() {
    if (currValue is int) {
      currValue = ((currValue as int) + 1) as ValueType;
      return true;
    }
    return false;
  }

  // Decrements the current value if it is an integer and retuns true, otherwise returns false
  bool decrement() {
    if (currValue is int) {
      currValue = ((currValue as int) + 1) as ValueType;
      return true;
    }
    return false;
  }

  // Gets the current value as a string
  String get() {
    return (currValue is int) ? (currValue as int).toString() : (currValue as String);
  }
}
