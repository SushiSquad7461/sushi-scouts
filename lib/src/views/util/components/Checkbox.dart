import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sushi_scouts/src/logic/deviceType.dart';

import '../../../logic/data/Data.dart';
import '../../../logic/helpers/size/ScreenSize.dart';

class CheckboxInput extends StatefulWidget {
  final String name;
  final Data data;
  final Data defaultValue;
  final Color color;
  final Color textColor;
  final double width;
  final List<String>? values;
  final bool setCommonValue;
  bool checked = false;
  CheckboxInput(
      {Key? key,
      required this.name,
      required this.data,
      required this.defaultValue,
      required this.color,
      required this.width,
      required this.textColor,
      required this.setCommonValue,
      this.values})
      : super(key: key);
  static CheckboxInput create(
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
    return CheckboxInput(
      key: key,
      name: name,
      data: data,
      width: width,
      defaultValue: defaultValue,
      color: color,
      values: values,
      textColor: textColor,
      setCommonValue: setCommonValue,
    );
  }

  @override
  CheckboxState createState() => CheckboxState();
}

class CheckboxState extends State<CheckboxInput> {
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.white;
    }
    return widget.color;
  }

  @override
  Widget build(BuildContext context) {
    double width = widget.width;

    if (widget.data.get() == "false") {
      widget.data.set(false, setByUser: true);
    }

    var isPhoneScreen = isPhone(context);

    return Padding(
        padding: EdgeInsets.only(
            left: width / 60,
            right: width / 60,
            top: width / 30,
            bottom: width / 30),
        child: SizedBox(
            width: width * 0.9,
            child: Column(children: [
              GestureDetector(
                onTap: () {
                  widget.data.set(!widget.checked, setByUser: true);
                  setState(() {
                    widget.checked = !widget.checked;
                  });
                },
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (!isPhoneScreen) Transform.scale(
                          scale: width / 170,
                          child: Checkbox(
                            side: BorderSide(
                                color: widget.color,
                                width: width / 100,
                                style: BorderStyle.solid),
                            splashRadius: width / 10,
                            checkColor: Colors.white,
                            fillColor:
                                MaterialStateProperty.resolveWith(getColor),
                            value: widget.data.get() == "true",
                            onChanged: (bool? value) {
                              widget.data.set(!widget.checked, setByUser: true);
                              setState(() {
                                widget.checked = !widget.checked;
                              });
                            },
                          )),
                      Container(
                        decoration: isPhoneScreen
                              ? BoxDecoration(
                                  border: Border.all(
                                    color: widget.checked ? widget.color : Colors.white,
                                    width: ScreenSize.width * 0.01,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      ScreenSize.width * 0.04),
                                )
                              : null,
                          padding: isPhoneScreen
                              ? EdgeInsets.only(
                                  top: ScreenSize.height * 0.01,
                                  bottom: ScreenSize.height * 0.01,
                                  left: ScreenSize.width * 0.015,
                                  right: ScreenSize.width * 0.015,
                                )
                              : null,
                        child: Text(widget.name,
                            style: TextStyle(
                                fontFamily: "Sushi",
                                fontSize: width / 8,
                                fontWeight: FontWeight.bold,
                                color: widget.textColor)),
                      ),
                    ]),
              ),
            ])));
  }
}
