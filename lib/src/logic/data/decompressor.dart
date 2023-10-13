// Dart imports:
import "dart:convert";

// Project imports:
import '../models/scouting_data_models/scouting_data.dart';
import "data.dart";

class Decompressor {
  /*
  *The class has instance variables:
  *screens: A list of strings representing different screens.
  *compressed: A string representing compressed data.
  *screenGotten: A boolean indicating whether a screen has been retrieved.
  *partial: A list of booleans representing partial data.
*/
  final List<String> screens;
  String compressed;
  bool screenGotten = false;

  List<bool> partial = [];

  /*
  *The Decompressor class is defined. 
  *It takes two parameters in the constructor: compressed (a string representing compressed data) 
  *and screens (a list of strings representing different screens).
*/
  Decompressor(this.compressed, this.screens) {
    for (int rune in compressed.runes) {
      int index = 1;
      for (int i = 0; i < 16; i++) {
        partial
            .add(rune & index != 0); // Store individual bits of compressed data
        index *= 2;
      }
    }
  }

  //call isBackup on the first decompressed only true means it is a backup

  /*
  *The isBackup method removes the first element from the partial list and
  * returns it. This boolean value indicates whether the decompressed data is a backup.
  */
  bool isBackup() {
    return partial.removeAt(0); // Remove and return the first bit
  }

  //must call getScreen every time before you call decompress

  /*
  *The getScreen method sets screenGotten to true, retrieves an integer value (using getInt(4)) 
  *representing the screen index, and returns the corresponding screen from the screens list. 
  *If the screen index is less than or equal to 0, an empty string is returned.
  */
  String getScreen() {
    screenGotten = true;
    int screen = getInt(4); // Get 4 bits representing the screen index
    if (screen <= 0) {
      return "";
    }
    return screens[screen - 1]; // Return the screen at the corresponding index
  }

  //returns true if there is more data

  /*
  *The decompress method decompresses the data and updates the scoutingData object. 
  *It expects the screenGotten flag to be set (true), indicating that the screen has been retrieved using getScreen.
  */
  bool decompress(ScoutingData scoutingData) {
    List<Data> data = scoutingData.getData(); // Get the list of Data objects
    if (!screenGotten) {
      throw ("get screen first"); // Throw an error if getScreen() is not called before decompress()
    }
    screenGotten = false;
    for (int index = 0; index < data.length; index++) {
      if (partial[0] && partial[1]) {
        data[index].set(
            getString()); // If the first two bits are true, set the string value for the Data object
      } else {
        if (data[index].currValue is bool) {
          data[index].set(getNum() !=
              0); // If the Data object represents a boolean, set the boolean value
        } else {
          data[index].set(getNum() *
              1.0); // If the Data object represents a numeric value, set the numeric value
        }
      }
    }
    return partial.length >=
        16; // Return true if there are more bits of compressed data
  }

  /*
  *The getNum method extracts a number from the partial list. 
  *It checks the values in partial and decides the length of bits to extract to form the number. 
  *It removes the relevant number of bits from partial and returns the extracted number.
  */
  int getNum() {
    if (partial.removeAt(0)) {
      if (!partial.removeAt(0)) {
        return getInt(
            14); // If the first two bits are "10", get 14 bits and return as an integer
      }
    } else if (partial.removeAt(0)) {
      return getInt(
          7); // If the first bit is "1", get 7 bits and return as an integer
    } else {
      return getInt(
          3); // If the first two bits are "00", get 3 bits and return as an integer
    }
    throw ("called get num on string"); // Throw an error if called on string
  }

  /*
  *The getString method extracts a string from the partial list. 
  *It removes two bits from partial and calculates the length of the string by calling getInt(16). 
  *Then, it iteratively calls getInt(8) to extract individual characters of the string and constructs the string using String.fromCharCodes.
  */
  String getString() {
    partial.removeAt(0);
    partial.removeAt(0);
    int length =
        getInt(16); // Get 16 bits representing the length of the string
    List<int> bytes = [];
    for (int i = 0; i < length; i++) {
      bytes.add(getInt(
          8)); // Get 8 bits representing each character in the string and add to the bytes list
    }
    return String.fromCharCodes(bytes); // Convert the list of bytes to a string
  }

  /*
  *The getInt method is used to extract an integer from the partial list. 
  *It iterates len times and constructs the integer value by checking the first element in partial 
  *and using bitwise OR operation (|) with the index variable. 
  *It removes the first element from partial and updates index for the next iteration. 
  *Finally, it returns the constructed integer value.
  */
  int getInt(int len) {
    int index = 1;
    int res = 0;
    for (int i = 0; i < len; i++) {
      if (partial[0]) {
        res = res |
            index; // Set the corresponding bit in the integer if the first bit is true
      }
      partial.removeAt(0); // Remove the processed bit from the partial list
      index *= 2;
    }
    return res;
  }
}
