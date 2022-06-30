import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sushi_scouts/src/logic/data/Data.dart';

class Increment extends StatefulWidget {
  final String name;
  final Data data;
  final Data defaultValue;
  final Color color;
  final Color textColor;
  final double width;
  final List<String>? values;
  int value = 0;
  Increment({Key? key, required this.name, required this.data, required this.defaultValue, required this.color, required this.width, required this.textColor, this.values})
    : super(key: key);
  static Increment create(String name, Data data, List<String>? values, Data defaultValue, Color color, double width, Color textColor) {
    return Increment(name: name, data: data, width: width, defaultValue: defaultValue, color: color, values: values, textColor: textColor,);
  }
  @override 
  IncrementState createState() => IncrementState();
}
  
  
class IncrementState extends State<Increment>{

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
    double width = widget.width;
    widget.data.set(widget.value*1.0, setByUser: true);
    final TextEditingController _controller = TextEditingController();
    _controller.text = (widget.value).toString();
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
            ]),
            Center(
              child: Row(
                children: [
                  IconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: (){
                        if(widget.value>0){
                          _controller.text = (widget.value-1).toString();
                          widget.data.decrement();
                          setState(() {
                            widget.value--;
                          });
                          build(context);
                        }
                      },
                      iconSize: width/3.0,
                      icon: Icon(
                        Icons.arrow_left_rounded,
                        color: widget.color,
                        semanticLabel: 'Back Arrow',
                      ),
                    ),
                    TextFormField(
                    controller: _controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: widget.textColor,
                          width: width/10,
                          style: BorderStyle.solid
                        )
                      ),
                      constraints: BoxConstraints(maxWidth: width/5.0, maxHeight: width/5.0),
                    ),
                    style: TextStyle(
                      fontFamily: "Sushi",
                      fontSize: width/10,
                      fontWeight: FontWeight.bold,
                      color: widget.textColor
                    ),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    onFieldSubmitted: (value) {
                      widget.data.set(double.parse(value), setByUser: true);
                    }
                  ),
                  IconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: (){
                        _controller.text = (widget.value+1).toString();
                        widget.data.increment();
                        setState(() {
                          widget.value++;
                        });
                      },
                      iconSize: width/3.0,
                      icon: Icon(
                        Icons.arrow_right_rounded,
                        color: widget.color,
                        semanticLabel: 'Back Arrow',
                      ),
                    ),
                ],
              )
            )
            ]
          )
        )
    );
  }
}