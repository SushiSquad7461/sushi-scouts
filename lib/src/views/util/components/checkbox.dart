// Flutter imports:
import "package:flutter/material.dart";

// Project imports:
import "../../../logic/data/data.dart";
import '../../../logic/types/device_type.dart';
import "../../../logic/helpers/size/screen_size.dart";
import "../../../../src/logic/helpers/style/text_style.dart";

class CheckboxInput extends StatefulWidget {
  final String name;
  final Data data;
  final Data defaultValue;
  final Color color;
  final Color textColor;
  final double width;
  final List<String>? values;
  final bool setCommonValue;
  const CheckboxInput(
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
  // Perhaps you guys intentionally had the box unchecked on widget render,
  // but this code change will make it remember state on widget render. (I think)
  // Something to just keep in mind.
  bool _checked = false;

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
    var colors = Theme.of(context);

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
                  widget.data.set(!_checked, setByUser: true);
                  setState(() {
                    _checked = !_checked;
                  });
                },
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (!isPhoneScreen)
                        Transform.scale(
                            scale: width / 170,
                            child: Checkbox(
                              side: BorderSide(
                                  color: widget.color,
                                  width: ScreenSize.width / 100,
                                  style: BorderStyle.solid),
                              splashRadius: width / 10,
                              checkColor: colors.scaffoldBackgroundColor,
                              fillColor:
                                  MaterialStateProperty.resolveWith(getColor),
                              value: widget.data.get() == "true",
                              onChanged: (bool? value) {
                                widget.data.set(!_checked, setByUser: true);
                                setState(() {
                                  _checked = !_checked;
                                });
                              },
                            )),
                      Container(
                          decoration: isPhoneScreen
                              ? BoxDecoration(
                                  border: Border.all(
                                    color: _checked
                                        ? widget.color
                                        : colors.scaffoldBackgroundColor,
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
                              style: TextStyles.getTitleText(
                                  width / 8, widget.textColor))),
                    ]),
              ),
            ])));
  }
}
