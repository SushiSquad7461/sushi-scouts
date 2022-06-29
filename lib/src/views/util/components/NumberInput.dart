import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sushi_scouts/src/logic/data/Data.dart';

class NumberInput extends StatelessWidget {
  final String name;
  final Data data;
  final Data defaultValue;
  final Color color;
  final double width;
  const NumberInput({Key? key, required this.name, required this.data, required this.defaultValue, required this.color, required this.width})
      : super(key: key);
  static NumberInput create(String name, Data data, List<dynamic>? values, Data defaultValue, Color color, double width) {
    return NumberInput(name: name, data: data, width: width, defaultValue: defaultValue, color: color);
  }

  @override
  Widget build(BuildContext context) {
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
              Text(name,
                style: TextStyle(
                    fontFamily: "Sushi",
                    fontSize: width/10,
                    fontWeight: FontWeight.bold,
                    color:  color
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
                    color: color
                  ),
                  textAlign: TextAlign.right,
                  initialValue: double.parse(defaultValue.get()).floor().toString(),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onFieldSubmitted: (value) {
                    data.set(number: double.parse(value), setByUser: true);
                  }
                )
              )
            ]),
            Divider(color: color, thickness: width/100)
            ]
          )
        )
    );
  }
}
