// Flutter imports:
import "package:flutter/material.dart";

// Project imports:
import "../../../logic/data/data.dart";
import '../../../logic/types/device_type.dart';
import "../../../logic/helpers/size/screen_size.dart";
import "../../../logic/helpers/style/text_style.dart";

class TextInput extends StatefulWidget {
  final String name;
  final Data data;
  final Color color;
  final Color textColor;
  final double width;
  final bool setCommonValue;
  final double height;

  const TextInput(
      {Key? key,
      required this.name,
      required this.data,
      required this.color,
      required this.width,
      required this.textColor,
      required this.setCommonValue,
      required this.height})
      : super(key: key);

  static TextInput create(
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
    return TextInput(
      key: key,
      name: name,
      data: data,
      width: width,
      color: color,
      textColor: textColor,
      setCommonValue: setCommonValue,
      height: height,
    );
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
    var phone = isPhone(context);
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
                border: Border.all(
                    width: widget.width * (phone ? 0.01 : 0.02),
                    color: Theme.of(context).scaffoldBackgroundColor ==
                            Colors.black
                        ? Colors.white
                        : Colors.black),
                shape: BoxShape.rectangle,
                borderRadius:
                    BorderRadius.all(Radius.circular(widget.width * 0.1))),
            child: GestureDetector(
              onTap: () {
                _focusNode.requestFocus();
              },
              child: Stack(fit: StackFit.expand, children: [
                Align(
                  alignment: const Alignment(-0.95, -0.95),
                  child: TextFormField(
                      focusNode: _focusNode,
                      controller: _controller,
                      maxLines: 10,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(widget.width * 0.03),
                        constraints: BoxConstraints(
                            maxWidth: widget.width * 0.95,
                            maxHeight: widget.width * 0.56),
                      ),
                      style: TextStyles.getStandardText(
                          phone ? ScreenSize.height * 0.03 : widget.width / 15,
                          phone ? FontWeight.w100 : FontWeight.w400,
                          widget.textColor),
                      keyboardType: TextInputType.multiline,
                      onFieldSubmitted: (value) {
                        widget.data.set(double.parse(value), setByUser: true);
                      }),
                ),
                if (!isClicked && !widget.data.setByUser)
                  Align(
                      alignment: const Alignment(0, 0),
                      child: Text(
                        widget.name,
                        style: TextStyles.getTitleText(
                            phone
                                ? ScreenSize.height * 0.03
                                : widget.width / 12,
                            widget.textColor),
                      ))
              ]),
            )));
  }
}
