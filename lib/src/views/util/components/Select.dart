import 'package:flutter/material.dart';
import 'package:sushi_scouts/src/logic/data/Data.dart';

class Select extends StatefulWidget {
  final String name;
  final Data data;
  final Data defaultValue;
  final Color color;
  final Color textColor;
  final double width;
  late List<String> values;
  late final isRow;
  Map<String, bool> checked = {};
  Select({Key? key, required this.name, required this.data, required this.defaultValue, required this.color, required this.width, required this.textColor, List<String>? values})
    : super(key: key){
      this.values = List.from(values!);
      if (values[0] == 'r')
        isRow = true;
      else if (values[0] == 'c')
        isRow = false;
      else
        throw("row or column is not defined");
      this.values.remove(values[0]);

      for(String value in this.values){
        checked[value] = false;
      }

      print(this.values);

      if(this.values.contains(defaultValue.get())){
        checked[defaultValue.get()] = true;
        data.set(defaultValue.get(), setByUser: true);
      }
    }
  static Select create(Key key, String name, Data data, List<String>? values, Data defaultValue, Color color, double width, Color textColor) {
    return Select(key: key, name: name, data: data, width: width, defaultValue: defaultValue, color: color, values: values, textColor: textColor,);
  }
  @override 
  SelectState createState() => SelectState();
}
  
  
class SelectState extends State<Select>{

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

  void change(String value) {
    widget.data.set(value, setByUser: true);
    setState(() {
      for( String key in widget.checked.keys.toList()) {
        widget.checked[key] = false;
      }
      widget.checked[value] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = widget.isRow ? widget.width/2 : widget.width;
    List<Widget> options = [];
    for(String value in widget.values) {
      options.add(
        Container(
          padding: EdgeInsets.only(right: widget.isRow ? width/20 : width/60, bottom: widget.isRow ? width/50 : width/10),
          child: GestureDetector(
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
        ),
      );
    }
    return widget.isRow 
    ? Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: options
    )
    : Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: options
    );
  }
}

