import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sushi_scouts/src/logic/data/Data.dart';

class Dropdown extends StatefulWidget {
  final String name;
  final Data data;
  final Data defaultValue;
  final Color color;
  final Color textColor;
  final double width;
  final List<String> values;
  String currentValue = "";
  Dropdown({Key? key, required this.name, required this.data, required this.defaultValue, required this.color, required this.width, required this.textColor, required this.values})
    : super(key: key){
      currentValue = values[0];
    }
  static Dropdown create(String name, Data data, List<String> values, Data defaultValue, Color color, double width, Color textColor) {
    return Dropdown(name: name, data: data, width: width, defaultValue: defaultValue, color: color, values: values, textColor: textColor,);
  }
  @override 
  DropdownState createState() => DropdownState();
}
  
  
class DropdownState extends State<Dropdown>{
  @override
  Widget build(BuildContext context) {
    double width = widget.width;
    widget.data.set(widget.currentValue, setByUser: true);
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
              Text(widget.name,
                style: TextStyle(
                    fontFamily: "Sushi",
                    fontSize: width/10,
                    fontWeight: FontWeight.bold,
                    color: widget.textColor
                  )
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: widget.currentValue,
                      icon: Icon(Icons.arrow_drop_down_rounded),
                      elevation: (width/100.0*3).floor(),
                      style: TextStyle(
                        fontFamily: "Sushi",
                        fontSize: width/10,
                        fontWeight: FontWeight.bold,
                        color: widget.textColor,
                        overflow: TextOverflow.ellipsis
                      ),
                      alignment: AlignmentDirectional.center,
                      onChanged: (String? newValue) {
                        if(newValue!=null){
                          widget.data.set(newValue, setByUser: true);
                          setState(() {
                            widget.currentValue = newValue;
                          });
                          build(context);
                        }
                      },
                      items: widget.values
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Center(child: Text(value)),
                        );
                      }).toList(),
                    )
                  )
                )
              )
            ]),
            Divider(color: Colors.black, thickness: width/100)
            ]
          )
        )
    );
  }
}