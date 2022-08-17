import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../logic/data/Data.dart';

class Dropdown extends StatefulWidget {
  final String name;
  final Data data;
  final Data defaultValue;
  final Color color;
  final Color textColor;
  final double width;
  final bool setCommonValue;
  List<String> values;
  String currentValue = "";
  Dropdown({Key? key, required this.name, required this.data, required this.defaultValue, required this.color, required this.width, required this.textColor, required this.values, required this.setCommonValue})
    : super(key: key){
      currentValue = data.setByUser ? values[double.parse(data.get()).floor()] : " ";
      if (!this.values.contains(" ")){
        this.values.add(" ");
      }
    }
  static Dropdown create(Key key, String name, Data data, List<String> values,
      Data defaultValue, Color color, double width, Color textColor, bool setCommonValue) {
    return Dropdown(
      key: key,
      name: name,
      data: data,
      width: width,
      defaultValue: defaultValue,
      color: color,
      values: values,
      setCommonValue: setCommonValue,
      textColor: textColor,
    );
  }

  @override
  DropdownState createState() => DropdownState();
}

class DropdownState extends State<Dropdown> {
  @override
  Widget build(BuildContext context) {
    double width = widget.width;
    var colors = Theme.of(context);

    return Padding(
        padding: EdgeInsets.only(
            left: width / 60,
            right: width / 60,
            top: width / 30,
            bottom: width / 30),
        child: SizedBox(
          width: width*0.8,
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
                      isExpanded: true,
                      value: widget.currentValue,
                      icon: Icon(Icons.arrow_drop_down_rounded),
                      elevation: (width/100.0*3).floor(),
                      dropdownColor: colors.scaffoldBackgroundColor,
                      style: GoogleFonts.mohave(
                        fontSize: width/8,
                        fontWeight: FontWeight.w400,
                        color: widget.textColor,
                      ),
                      alignment: AlignmentDirectional.center,
                      onChanged: (String? newValue) {
                        if(newValue!=null){
                          widget.data.set(widget.values.indexOf(newValue)*1.0, setByUser: newValue != " ");
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
                          child: Center(child: Text(value, overflow: TextOverflow.ellipsis,)),
                        );
                      }).toList(),
                    )
                  )
                )
              )
            ]),
            Divider(color: widget.textColor, thickness: width/50)
            ]
          )
        )
    );
  }
}
