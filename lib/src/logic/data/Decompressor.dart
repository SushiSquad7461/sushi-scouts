import 'dart:convert';

import 'package:sushi_scouts/src/logic/data/Data.dart';
import 'package:sushi_scouts/src/logic/data/scoutingData.dart';

class Decompressor {
  final List<String> screens;
  String compressed;
  bool screenGotten = false;

  List<bool> partial = [];
  
  Decompressor(this.compressed, this.screens){
    for (int rune in compressed.runes) {
      int index = 1;
      for (int i = 0; i<16; i++) {
        partial.add(rune & index != 0);
        index *= 2;
      }
    }
  }

  String getScreen() {
    screenGotten = true;
    return screens[getInt(4)];
  }

  void decompress(List<Data> data) {
    if(!screenGotten) {
      throw("get screen first");
    }
    for( int index = 0; index < data.length; index++) {
      if (partial[0] && partial[1]) {
        data[index].set(getString());
      } else {
        if (data[index].currValue is bool) {
          data[index].set(getNum()!=0);
        } else {
          data[index].set(getNum()*1.0);
        }
      }
    }
  }

  int getNum() {
    if (partial.removeAt(0)) {
      if (!partial.removeAt(0)) {
        return getInt(14);
      }
    } else if (partial.removeAt(0)) {
      return getInt(7);
    } else {
      return getInt(3);
    }
    throw("called get num on string");
  }

  String getString() {
    partial.removeAt(0);
    partial.removeAt(0);
    int length = getInt(16);
    List<int> bytes = [];
    for (int i = 0; i<length; i++) {
      bytes.add(getInt(8));
    }
    return utf8.decode(bytes);
  }

  int getInt(int len) {
    int index = 1;
    int res = 0;
    for (int i = 0; i<len; i++) {
      if( partial[0] ) {
        res = res | index;
      }
      partial.removeAt(0);
      index*=2;
    }
    return res;
  }
}