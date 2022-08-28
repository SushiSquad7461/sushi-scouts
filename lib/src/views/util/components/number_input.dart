import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sushi_scouts/src/logic/helpers/size/ScreenSize.dart';
import '../../../logic/data/Data.dart';
import '../../../logic/data/config_file_reader.dart';
import '../../../logic/deviceType.dart';

class NumberInput extends StatefulWidget {
  final String name;
  final Data data;
  final Color color;
  final Color textColor;
  final double width;
  final bool setCommonValue;
  final double height;

  NumberInput(
      {Key? key,
      required this.name,
      required this.data,
      required this.color,
      required this.width,
      required this.textColor,
      required this.setCommonValue,
      required this.height})
      : super(key: key);

  static NumberInput create(
      Key key,
      String name,
      Data data,
      List<String>? values,
      Data defaultValue,
      Color color,
      double width,
      Color textColor,
      bool setCommonValue,
      double height) {
    return NumberInput(
        key: key,
        name: name,
        data: data,
        width: width,
        color: color,
        setCommonValue: setCommonValue,
        textColor: textColor,
        height: height);
  }

  @override
  NumberInputState createState() => NumberInputState();
}

class NumberInputState extends State<NumberInput> {
  late final TextEditingController _controller;
  late FocusNode _focusNode;
  late final ConfigFileReader reader;

  @override
  void initState() {
    reader = ConfigFileReader.instance;
    _controller = TextEditingController(
        text: widget.data.setByUser ? widget.data.get().toString() : null);
    _focusNode = FocusNode();
    _controller.addListener(() {
      if (_controller.text != "") {
        widget.data.set(double.parse(_controller.text), setByUser: true);
        if (widget.setCommonValue) {
          reader.setCommonValue(widget.name, int.parse(_controller.text));
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var isPhoneScreen = isPhone(context);

    return GestureDetector(
      onTap: () {
        _focusNode.requestFocus();
      },
      child: Padding(
          padding: EdgeInsets.only(
              left: widget.width / 60,
              right: widget.width / 60,
              top: widget.width / 30,
            bottom: widget.width / 30,
             ),
          child: SizedBox(
              width: widget.width * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Expanded(
                      child: SizedBox(
                        height: ScreenSize.height * 0.04,
                        child: TextFormField(
                            focusNode: _focusNode,
                            controller: _controller,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              constraints:
                                  BoxConstraints(maxWidth: widget.width / 6.0),
                              hintText: widget.name.toUpperCase(),
                              hintStyle: TextStyle(color: widget.textColor, fontSize: widget.width / (isPhoneScreen ? 6 : 8),
                                fontWeight: isPhoneScreen ? FontWeight.w100 : FontWeight.w400,),
                            ),
                            cursorHeight: ScreenSize.height * 0.041,
                            style: GoogleFonts.mohave(
                                textStyle: TextStyle(
                                    fontSize: widget.width / (isPhoneScreen ? 6.2 : 8),
                                    fontWeight: isPhoneScreen ? FontWeight.w100 : FontWeight.w400,
                                    color: widget.textColor)),
                            textAlign: TextAlign.left,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onFieldSubmitted: (value) {
                              widget.data
                                  .set(double.parse(value), setByUser: true);
                              var reader = ConfigFileReader.instance;
                              if (widget.setCommonValue) {
                                reader.setCommonValue(widget.name, int.parse(value));
                              }
                            }),
                      ))
                ]),
                Divider(color: widget.textColor, thickness: widget.width / 50)
              ]))),
    );
  }
}
