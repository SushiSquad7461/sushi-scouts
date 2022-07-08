/*
  The Data classes purpose is to store the current value of a component.
  It currently supports strings and numbers.
*/
class Data<ValueType> {
  // Current value of the component
  ValueType currValue;
  bool setByUser;

  Data(this.currValue, {this.setByUser = false});

  // Set the current value
  void set(ValueType newVal, {setByUser = false}) {
    currValue = newVal;
    this.setByUser = setByUser;
  }

  // Increments the current value if it is an number and retuns true, otherwise returns false
  bool increment() {
    if (currValue is double) {
      currValue = ((currValue as double) + 1) as ValueType;
      return true;
    }
    return false;
  }

  // Decrements the current value if it is an number and retuns true, otherwise returns false
  bool decrement() {
    if (currValue is double) {
      currValue = ((currValue as double) - 1) as ValueType;
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
    (currValue is double) 
      ? (currValue = 0.0 as ValueType)
      : (currValue = '' as ValueType);
  }
}
