import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sushi_scouts/src/logic/data/Data.dart';

class CheckboxInput extends StatefulWidget {
  final String name;
  final Data data;
  final Data defaultValue;
  final Color color;
  final Color textColor;
  final double width;
  final List<String>? values;
  bool checked = false;
  CheckboxInput({Key? key, required this.name, required this.data, required this.defaultValue, required this.color, required this.width, required this.textColor, this.values})
    : super(key: key);
  static CheckboxInput create(String name, Data data, List<String>? values, Data defaultValue, Color color, double width, Color textColor) {
    return CheckboxInput(name: name, data: data, width: width, defaultValue: defaultValue, color: color, values: values, textColor: textColor,);
  }
  @override 
  CheckboxState createState() => CheckboxState();
}
  
  
class CheckboxState extends State<CheckboxInput>{

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
    widget.data.set(widget.checked.toString(), setByUser: true);
    return Padding(
        padding:
            EdgeInsets.only(left: width/60, right: width/60, top: width/30, bottom: width/30),
        child: SizedBox(
          width: width*0.9,
          child: Column(
            children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Checkbox(
                splashRadius: width/10,
                checkColor: Colors.white,
                fillColor: MaterialStateProperty.resolveWith(getColor),
                value: widget.checked,
                onChanged: (bool? value) {
                widget.data.set(value.toString(), setByUser: true);
                setState(() {
                  widget.checked = value!;
                });}
              ),
              Text(widget.name,
                style: TextStyle(
                    fontFamily: "Sushi",
                    fontSize: width/10,
                    fontWeight: FontWeight.bold,
                    color: widget.textColor
                  )
              ),
          ]),   
        ]
        )
      )
    );
  }
}