import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sushi_scouts/src/logic/data/Data.dart';

class Select extends StatefulWidget {
  final String name;
  final Data data;
  final Data defaultValue;
  final Color color;
  final Color textColor;
  final double width;
  final List<String>? values;
  Map<String, bool> checked = {};
  Select({Key? key, required this.name, required this.data, required this.defaultValue, required this.color, required this.width, required this.textColor, this.values})
    : super(key: key){
      for(String value in values!){
        checked[value] = false;
      }
      if(values!.contains(defaultValue.get())){
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

  @override
  Widget build(BuildContext context) {
    double width = widget.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for(String value in widget.values!)
          Padding(
            padding:
                EdgeInsets.only(left: width/10, right: width/60, top: width/30, bottom: width/30),
            child: SizedBox(
              width: width*0.9,
              child: Column(
                children: [
                Row(
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
                      widget.data.set(value, setByUser: true);
                      setState(() {
                        for( String key in widget.checked.keys.toList()) {
                          widget.checked[key] = false;
                        }
                        widget.checked[value] = true;
                      });}
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
            ]
            )
          )
        ),
      ]
    );   
  }
}