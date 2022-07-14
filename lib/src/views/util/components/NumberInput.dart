import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../SushiScoutingLib/logic/data/Data.dart';

class NumberInput extends StatefulWidget {
  final String name;
  final Data data;
  final Color color;
  final Color textColor;
  final double width;

  NumberInput(
      {Key? key,
      required this.name,
      required this.data,
      required this.color,
      required this.width,
      required this.textColor})
      : super(key: key);

  static NumberInput create(
      Key key,
      String name,
      Data data,
      List<String>? values,
      Data defaultValue,
      Color color,
      double width,
      Color textColor) {
    return NumberInput(
        key: key,
        name: name,
        data: data,
        width: width,
        color: color,
        textColor: textColor);
  }

  @override
  NumberInputState createState() => NumberInputState();
}

class NumberInputState extends State<NumberInput> {
  late final TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    _controller = TextEditingController(
        text: widget.data.setByUser ? widget.data.get().toString() : null);
    _focusNode = FocusNode();
    _controller.addListener(() {
      if (_controller.text != "") {
        widget.data.set(double.parse(_controller.text), setByUser: true);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.textColor);
    return GestureDetector(
      onTap: () {
        _focusNode.requestFocus();
      },
      child: Padding(
          padding: EdgeInsets.only(
              left: widget.width / 60,
              right: widget.width / 60,
              top: widget.width / 30,
              bottom: widget.width / 30),
          child: SizedBox(
              width: widget.width * 0.8,
              child: Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Expanded(
                      child: TextFormField(
                          focusNode: _focusNode,
                          controller: _controller,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            constraints:
                                BoxConstraints(maxWidth: widget.width / 6.0),
                            hintText: widget.name.toUpperCase(),
                            hintStyle: TextStyle(color: widget.textColor),
                          ),
                          style: GoogleFonts.mohave(
                              textStyle: TextStyle(
                                  fontSize: widget.width / 8,
                                  fontWeight: FontWeight.w400,
                                  color: widget.textColor)),
                          textAlign: TextAlign.left,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          onFieldSubmitted: (value) {
                            widget.data
                                .set(double.parse(value), setByUser: true);
                          }))
                ]),
                Divider(color: widget.textColor, thickness: widget.width / 50)
              ]))),
    );
  }
}
