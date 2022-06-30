class Data<ValueType> {
  ValueType currValue;
  bool setByUser;

  Data(this.currValue, {this.setByUser = false});

  void set(ValueType newVal, {bool setByUser = false}) {
    this.setByUser = setByUser;
    currValue = newVal;
  }

  bool increment() {
    if (currValue is int) {
      currValue = ((currValue as int) + 1) as ValueType;
      return true;
    }
    return false;
  }

  bool decrement() {
    if (currValue is int) {
      currValue = ((currValue as int) + 1) as ValueType;
      return true;
    }
    return false;
  }

  String get() {
    return (currValue is int) ? (currValue as int).toString() : (currValue as String);
  }

  @override
  String toString() {
    return get();
  }
}
