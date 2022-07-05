import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sushi_scouts/src/logic/data/Data.dart';

class NumberInput extends StatelessWidget {
  final String name;
  final Data data;
  final Data defaultValue;
  final Color color;
  final Color textColor;
  final double width;
  final List<String>? values;
  NumberInput({Key? key, required this.name, required this.data, required this.defaultValue, required this.color, required this.width, required this.textColor, this.values})
    : super(key: key);
  static NumberInput create(String name, Data data, List<String>? values, Data defaultValue, Color color, double width, Color textColor) {
    return NumberInput(name: name, data: data, width: width, defaultValue: defaultValue, color: color, values: values, textColor: textColor,);
  }

  @override
  Widget build(BuildContext context) {
    data.set(double.parse(defaultValue.get()), setByUser: false);
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
              Text(name.toUpperCase(),
                style: TextStyle(
                    fontFamily: "Sushi",
                    fontSize: width/10,
                    fontWeight: FontWeight.bold,
                    color:  textColor
                  )
              ),
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    constraints: BoxConstraints(maxWidth: width/6.0),
                  ),
                  style: TextStyle(
                    fontFamily: "Sushi",
                    fontSize: width/10,
                    fontWeight: FontWeight.bold,
                    color: textColor
                  ),
                  textAlign: TextAlign.right,
                  initialValue: double.parse(defaultValue.get()).floor().toString(),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onFieldSubmitted: (value) {
                    data.set(double.parse(value), setByUser: true);
                  }
                )
              )
            ]),
            Divider(color: textColor, thickness: width/100)
            ]
          )
        )
    );
  }
}
