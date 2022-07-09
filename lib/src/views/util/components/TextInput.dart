import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sushi_scouts/src/logic/data/Data.dart';

class TextInput extends StatefulWidget {
  final String name;
  final Data data;
  final Color color;
  final Color textColor;
  final double width;

  TextInput(
      {Key? key,
      required this.name,
      required this.data,
      required this.color,
      required this.width,
      required this.textColor})
      : super(key: key);

  static TextInput create(Key key, String name, Data data, List<String>? values,
      Data defaultValue, Color color, double width, Color textColor) {
    return TextInput(
        key: key,
        name: name,
        data: data,
        width: width,
        color: color,
        textColor: textColor);
  }

  @override
  TextInputState createState() => TextInputState();
}

class TextInputState extends State<TextInput> {
  bool isClicked = false;
  final TextEditingController _controller = TextEditingController();
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _controller.addListener(() {
      isClicked = true;
      print(_controller.text);
      String text = _controller.text;
      if (text != "") {
        widget.data.set(text, setByUser: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.text = widget.data.setByUser ? widget.data.get() : "";
    return Padding(
        padding: EdgeInsets.only(
            left: widget.width / 60,
            right: widget.width / 60,
            top: widget.width / 30,
            bottom: widget.width / 30),
        child: Container(
            width: widget.width,
            height: widget.width * 0.6,
            decoration: BoxDecoration(
                border: Border.all(width: widget.width * 0.02),
                shape: BoxShape.rectangle,
                borderRadius:
                    BorderRadius.all(Radius.circular(widget.width * 0.1))),
            child: GestureDetector(
              onTap: () {
                _focusNode.requestFocus();
              },
              child: Stack(fit: StackFit.expand, children: [
                Align(
                  alignment: Alignment(-0.95, -0.95),
                  child: TextFormField(
                    focusNode: _focusNode,
                      controller: _controller,
                      maxLines: 10,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        constraints: BoxConstraints(
                            maxWidth: widget.width * 0.95,
                            maxHeight: widget.width * 0.56),
                      ),
                      style: GoogleFonts.mohave(
                          textStyle: TextStyle(
                              fontSize: widget.width / 15,
                              fontWeight: FontWeight.w400,
                              color: widget.textColor)),
                      keyboardType: TextInputType.multiline,                        
                      onFieldSubmitted: (value) {
                        widget.data.set(double.parse(value), setByUser: true);
                      }),
                ),
                if (!isClicked && !widget.data.setByUser)
                Align(
                  alignment: Alignment(0,0),
                  child: Text(widget.name,
                    style: TextStyle(
                      fontFamily: "Sushi",
                      fontSize: widget.width/12,
                      fontWeight: FontWeight.bold,
                      color: widget.textColor
                    ),
                  )
                )
              ]),
            )));
  }
}
