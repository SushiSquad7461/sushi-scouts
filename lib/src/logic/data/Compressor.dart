import 'dart:convert';
import 'dart:typed_data';

import 'package:sushi_scouts/src/logic/data/Data.dart';

class Compressor{
  final List<Data> data;
  final List<bool> partial = [];
  int screen;

  Compressor(this.data, this.screen);

  String compress() {
    addInt(screen, 4);
    List<String> datum = [];

    for( Data d in data) {
      datum.add(d.get());
      if(d.currValue is bool) {
        addNum(d.currValue as bool ? 1 : 0);
      } else if(d.currValue is double) {
        addNum((d.currValue as double).floor());
      } else {
        addString(d.get());
      }
    }
    
    List<int> compressed = List.filled((partial.length/16).floor()+1, 0);
    for(int i = 0; i<partial.length; i++) {
      compressed[(i/16).floor()] = compressed[(i/16).floor()] | (partial[i] ? 1 : 0)<<(i%16);
    }
    return String.fromCharCodes(compressed);
  }

  void addNum(int i) {
    if(i < 8) {
      partial.add(false);
      partial.add(false);
      addInt(i, 3);
    } else if (i < 128 ) {
      partial.add(false);
      partial.add(true);
      addInt(i, 7);
    } else if(i< 16384 ) {
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
    for(int i = 0; i<len; i++) {
      partial.add(num&(1<<i) != 0);
    }
  }
}