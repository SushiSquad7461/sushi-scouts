class Data {
  String type;
  String words;
  double num;
  bool setByUser;
  Data(this.type, {this.words = "", this.num = 0, this.setByUser=false});
  void set({double number = 0, String string = "", bool setByUser=false}) {
    this.setByUser=setByUser;
    if (type == "string") {
      words = string;
    }
    if (type == "number") {
      num = number;
    }
  }

  bool increment() {
    if (type == "number") {
      num++;
      return true;
    }
    return false;
  }

  bool decrement() {
    if (type == "number") {
      num--;
      return true;
    }
    return false;
  }

  String get() {
    if (type == "number") {
      return num.toString();
    } else {
      return words;
    }
  }

  @override
  String toString() {
    return get();
  }
}