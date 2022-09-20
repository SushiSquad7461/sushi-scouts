// Dart imports:
import "dart:convert";

// Project imports:
import "data.dart";

class Compressor {
  final List<Data> data;
  final List<bool> partial = [];
  int screen;
  int length = 0;

  Compressor(this.data, this.screen);

  static String setBackUp(String compressedData) {
    return String.fromCharCode(compressedData.runes.toList()[0] | 1) +
        compressedData.substring(1);
  }

  void encode() {
    addInt(screen + 1, 4);

    for (Data d in data) {
      if (d.currValue is bool) {
        addNum(d.currValue as bool ? 1 : 0);
      } else if (d.currValue is double) {
        addNum((d.currValue as double).floor());
      } else {
        addString(d.get());
      }
    }
  }

  String getCompressedString() {
    List<int> compressed = List.filled((partial.length / 16).floor() + 1, 0);
    for (int i = 0; i < partial.length; i++) {
      compressed[(i / 16).floor()] =
          compressed[(i / 16).floor()] | (partial[i] ? 1 : 0) << (i % 16);
    }
    return String.fromCharCodes(compressed);
  }

  String firstCompress() {
    partial.add(false);
    encode();
    String res = getCompressedString();
    length = res.length;
    return res;
  }

  String addTo(String prev, int length) {
    int rune = prev.runes.toList()[prev.length - 1];
    for (int i = 0; i < (length % 16); i++) {
      partial.add(rune & (1 << i) != 0);
    }
    encode();
    String additional = getCompressedString();
    return prev.substring(0, prev.length - 1) + additional;
  }

  static String update(String prev, int length, String newContent) {
    final List<bool> partial = [];
    int lastRune = prev.runes.toList()[prev.length - 1];
    bool firstItem = true;

    for (int i = 0; i < (length % 16); i++) {
      partial.add(lastRune & (1 << i) != 0);
    }
    List<bool> temp = [];
    for (int rune in newContent.runes) {
      for (int i = 0; i < 16; i++) {
        if (firstItem) {
          firstItem = false;
        } else {
          temp.add(rune & (1 << i) != 0);
          partial.add(rune & (1 << i) != 0);
        }
      }
    }
    List<int> compressed = List.filled((partial.length / 16).floor() + 1, 0);
    for (int i = 0; i < partial.length; i++) {
      compressed[(i / 16).floor()] =
          compressed[(i / 16).floor()] | (partial[i] ? 1 : 0) << (i % 16);
    }
    return prev.substring(0, prev.length - 1) +
        String.fromCharCodes(compressed).substring(0, compressed.length);
  }

  int getLength() => length;

  void addNum(int i) {
    if (i < 8) {
      partial.add(false);
      partial.add(false);
      addInt(i, 3);
    } else if (i < 128) {
      partial.add(false);
      partial.add(true);
      addInt(i, 7);
    } else if (i < 16384) {
      partial.add(true);
      partial.add(false);
      addInt(i, 14);
    } else {
      addString(String.fromCharCode(i));
    }
  }

  void addString(String s) {
    partial.add(true);
    partial.add(true);
    addInt(s.length, 16);
    List<int> encoded = utf8.encode(s);
    for (int s in encoded) {
      addInt(s, 8);
    }
  }

  void addInt(int num, int len) {
    for (int i = 0; i < len; i++) {
      partial.add(num & (1 << i) != 0);
    }
  }
}
