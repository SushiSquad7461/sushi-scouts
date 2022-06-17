import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sushi_scouts/src/logic/data/cardinalData.dart';

class NumberInput extends StatelessWidget {
  final String name;
  final Function(String name, Data value) onSubmit;
  const NumberInput({
    Key? key,
    required this.name, required this.onSubmit
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:
            const EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
        child: Column(children: [
          Row(children: [
            Text(name,
                style: const TextStyle(
                    fontFamily: "Sushi",
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            SizedBox(
                width: 20,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onFieldSubmitted: (value) {
                    onSubmit(name, Data("number", num: double.parse(value)));
                    }
                ))
          ]),
          const Divider(color: Colors.black, thickness: 3)
        ]));
  }
}
