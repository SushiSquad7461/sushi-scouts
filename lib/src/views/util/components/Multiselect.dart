import 'package:flutter/material.dart';

import '../../../../SushiScoutingLib/logic/data/Data.dart';

class Multiselect extends StatefulWidget {
  final String name;
  final Data data;
  final Data defaultValue;
  final Color color;
  final Color textColor;
  final double width;
  late List<String> values;
  late final int numberOfOptions;
  List<int> layout = [];
  Map<String, bool> checked = {};
  Multiselect({Key? key, required this.name, required this.data, required this.defaultValue, required this.color, required this.width, required this.textColor, List<String>? values})
    : super(key: key){
      this.values = List.from(values!);
      if (values[0] == '#o')
        numberOfOptions = int.parse(values[1]);
      else
        throw("number of options is not defined");
      this.values.remove(values[0]);
      this.values.remove(values[1]);
      if(this.values[0] == 'l') {
        this.values.remove(this.values[0]);
        while(this.values[0] != "c") {
          layout.add(int.parse(this.values[0]));
          this.values.remove(this.values[0]);
        }
      } else
        throw("layout is not defined");
      
      this.values.remove(this.values[0]);

      if(double.parse(defaultValue.get()) >= 0.0){
        decode(double.parse(defaultValue.get()).floor());
        data.set(double.parse(defaultValue.get()), setByUser: true);
      } else {
        data.set(0.0, setByUser: true);
        for(String value in this.values){
          checked[value] = false;
        }
      }
    }
  static Multiselect create(Key key, String name, Data data, List<String>? values, Data defaultValue, Color color, double width, Color textColor) {
    return Multiselect(key: key, name: name, data: data, width: width, defaultValue: defaultValue, color: color, values: values, textColor: textColor,);
  }

  int encode() {
    int res = 0;
    int index = 1;

    for( int i = 0; i<values.length; i++) {
      if(checked[values[i]]! ) {
        res = index | res;
      }
      index *=2;
    }

    return res;
  }

  void decode(int res) {
    int index = 1;
    for( int i = 0; i<values.length; i++) {
      checked[values[i]] = (index & res) != 0;
      index *=2;
    }
  }

  @override 
  MultiselectState createState() => MultiselectState();
}
  
  
class MultiselectState extends State<Multiselect>{

  Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.white;
      }
      return widget.color;
    }
  int getCheckedNum() {
    int counter = 0;
    for( String key in widget.checked.keys.toList()) {
      if(widget.checked[key]!) {
        counter++;
      }
    }
    return counter;
  }


  void change(String value) {
    setState(() {
      if( widget.checked[value]! || getCheckedNum() < widget.numberOfOptions) {
        widget.checked[value] = !widget.checked[value]!;
        widget.data.set(widget.encode() * 1.0, setByUser: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = widget.width/2;
    List<Widget> options = [];
    int index = 0;
    for(int i in widget.layout) {
      List<Widget> column = [];
      int startPostion = index;
      for( index = startPostion; index<startPostion+i; index++) {
        String value = widget.values[index];
        column.add(
          GestureDetector(
            onTap: () {
              change(value);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
              Transform.scale(
                scale: width/180,
                child: Checkbox(
                  side: BorderSide(
                    color: widget.color,
                    width: width/100,
                    style: BorderStyle.solid
                  ),
                  splashRadius: width/10,
                  checkColor: Colors.white,
                  fillColor: MaterialStateProperty.resolveWith(getColor),
                  value: widget.checked[value],
                  onChanged: (bool? val) {
                    change(value);
                  }
                )
              ),  
              Text(value,
                style: TextStyle(
                    fontFamily: "Sushi",
                    fontSize: width/8,
                    fontWeight: FontWeight.bold,
                    color: widget.textColor
                  )
              ),
            ]),
          )
        );
      }
      options.add(Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: column,));        
    }
    return Row(crossAxisAlignment: CrossAxisAlignment.start,children: options,);
  }
}
