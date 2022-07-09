import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sushi_scouts/src/logic/data/Data.dart';

class NumberInput extends StatelessWidget {
  final String name;
  final Data data;
  final Color color;
  final Color textColor;
  final double width;
  late final TextEditingController _controller;
  late FocusNode _focusNode;

  NumberInput(
      {Key? key,
      required this.name,
      required this.data,
      required this.color,
      required this.width,
      required this.textColor})
      : super(key: key){
        _controller = TextEditingController(text: data.setByUser ? data.get().toString() : null);
        _focusNode = FocusNode();
        _controller.addListener(() {
          if(_controller.text != "") {
            data.set(double.parse(_controller.text), setByUser: true);
          }
        });
      }

  static NumberInput create(Key key, String name, Data data, List<String>? values,
      Data defaultValue, Color color, double width, Color textColor) {
    return NumberInput(
      key: key,
      name: name,
      data: data,
      width: width,
      color: color,
      textColor: textColor
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusNode.requestFocus();
      },
      child: Padding(
          padding: EdgeInsets.only(
              left: width / 60,
              right: width / 60,
              top: width / 30,
              bottom: width / 30),
          child: SizedBox(
              width: width * 0.7,
              child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  // Text(name.toUpperCase(),
                  //   style: GoogleFonts.mohave(
                  //     textStyle: TextStyle(
                  //       fontSize: width/8,
                  //       fontWeight: FontWeight.w400,
                  //       color:  textColor
                  //     )
                  //   ),
                  // ),
                  Expanded(
                      child: TextFormField(
                        focusNode: _focusNode,
                          controller: _controller,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            constraints: BoxConstraints(maxWidth: width / 6.0),
                            hintText: name.toUpperCase(),
                            hintStyle: const TextStyle(color: Colors.black),
                          ),
                          style: GoogleFonts.mohave(
                              textStyle: TextStyle(
                                  fontSize: width / 8,
                                  fontWeight: FontWeight.w400,
                                  color: textColor)),
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onFieldSubmitted: (value) {
                            data.set(double.parse(value), setByUser: true);
                          }))
                ]),
                Divider(color: textColor, thickness: width / 50)
              ]))),
    );
  }
}
