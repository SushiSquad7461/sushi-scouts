import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
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
      currentValue = data.setByUser ? data.get() : values[0];
    }
  static Dropdown create(Key key, String name, Data data, List<String> values, Data defaultValue, Color color, double width, Color textColor) {
    return Dropdown(key: key, name: name, data: data, width: width, defaultValue: defaultValue, color: color, values: values, textColor: textColor,);
  }
  @override 
  DropdownState createState() => DropdownState();
}
  
  
class DropdownState extends State<Dropdown>{
  @override
  Widget build(BuildContext context) {
    double width = widget.width;
    return Padding(
        padding:
            EdgeInsets.only(left: width/60, right: width/60, top: width/30, bottom: width/30),
        child: SizedBox(
          width: width*0.7,
          child: Column(
            children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text(widget.name.toUpperCase(),
                style: GoogleFonts.mohave(
                        fontSize: width/8,
                        fontWeight: FontWeight.w400,
                        color: widget.textColor,
                      ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: widget.currentValue,
                      icon: Icon(Icons.arrow_drop_down_rounded),
                      elevation: (width/100.0*3).floor(),
                      style: GoogleFonts.mohave(
                        fontSize: width/8,
                        fontWeight: FontWeight.w400,
                        color: widget.textColor,
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
            Divider(color: Colors.black, thickness: width/50)
            ]
          )
        )
    );
  }
}