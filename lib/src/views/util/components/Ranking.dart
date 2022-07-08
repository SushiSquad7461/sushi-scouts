import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sushi_scouts/src/logic/data/Data.dart';

class Ranking extends StatefulWidget {
  final String name;
  final Data data;
  final Data defaultValue;
  final Color color;
  final Color textColor;
  final double width;
  final List<String>? values;
  Ranking({Key? key, required this.name, required this.data, required this.defaultValue, required this.color, required this.width, required this.textColor, this.values})
    : super(key: key);
  static Ranking create(String name, Data data, List<String>? values, Data defaultValue, Color color, double width, Color textColor) {
    return Ranking(name: name, data: data, width: width, defaultValue: defaultValue, color: color, values: values, textColor: textColor,);
  }
  @override 
  RankingState createState() => RankingState();
}
  
  
class RankingState extends State<Ranking>{

  Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.black;
    }

  @override
  Widget build(BuildContext context) {
    double width = widget.width/1.3;
    widget.data.set(widget.values!.toString(), setByUser: true);
    return Center(
      child: Row(
        children: [
          Text( widget.values![0],
            style: TextStyle(
              fontFamily: "Sushi",
              fontSize: width/10,
              fontWeight: FontWeight.bold,
              color: widget.textColor
            ),
          ),
          for(int i = 1; i<widget.values!.length; i++)
            Row(
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  onPressed: (){
                    setState(() {
                      String temp = widget.values![i];
                      widget.values![i] = widget.values![i-1];
                      widget.values![i-1] = temp;
                      widget.data.set(widget.values!.toString(), setByUser: true);
                    });                           
                    build(context);
                  },
                  iconSize: width/3.0,
                  icon: Icon(
                    Icons.arrow_left_rounded,
                    color: widget.color,
                    semanticLabel: 'Back Arrow',
                  ),
                ),
                Text(widget.values![i]
                  ,style: TextStyle(
                  fontFamily: "Sushi",
                  fontSize: width/10,
                  fontWeight: FontWeight.bold,
                  color: widget.textColor
                  ),
                ),
              ],
            )
        ],
      )
    
  );
  }
}