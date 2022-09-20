// Flutter imports:
import "package:flutter/material.dart";

// Project imports:
import "../../../logic/data/data.dart";
import "../../../logic/device_type.dart";
import "../../../logic/helpers/size/screen_size.dart";

class Select extends StatefulWidget {
  final String name;
  final Data data;
  final Data defaultValue;
  final Color color;
  final Color textColor;
  final double width;
  final bool setCommonValue;
  late final List<String> values;
  late final bool isRow;
  final Map<String, bool> checked = {};
  Select(
      {Key? key,
      required this.name,
      required this.data,
      required this.defaultValue,
      required this.color,
      required this.width,
      required this.textColor,
      required this.setCommonValue,
      List<String>? values})
      : super(key: key) {
    this.values = List.from(values!);
    if (values[0] == "r") {
      isRow = true;
    } else if (values[0] == "c") {
      isRow = false;
    } else {
      throw ("row or column is not defined");
    }
    this.values.remove(values[0]);

    for (String value in this.values) {
      checked[value] = false;
    }

    if (defaultValue.setByUser) {
      double val = double.parse(defaultValue.get());
      checked[this.values[(val).floor()]] = true;
      data.set(val, setByUser: true);
    }
  }
  static Select create(
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
    return Select(
      key: key,
      name: name,
      data: data,
      width: width,
      defaultValue: defaultValue,
      color: color,
      values: values,
      setCommonValue: setCommonValue,
      textColor: textColor,
    );
  }

  @override
  SelectState createState() => SelectState();
}

class SelectState extends State<Select> {
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

  void change(String value) {
    widget.data.set(widget.values.indexOf(value) * 1.0, setByUser: true);
    setState(() {
      for (String val in widget.values) {
        widget.checked[val] = false;
      }
      widget.checked[value] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = widget.isRow ? widget.width / 2 : widget.width;
    List<Widget> options = [];
    var isPhoneScreen = isPhone(context) && !widget.isRow;
    var colors = Theme.of(context);

    for (String value in widget.values) {
      options.add(
        Padding(
          padding: EdgeInsets.only(
              top: ScreenSize.height * (isPhoneScreen ? 0.01 : 0)),
          child: Container(
              padding: EdgeInsets.only(
                  right: widget.isRow ? width / 20 : width / 60,
                  bottom: widget.isRow ? width / 50 : width / 10),
              child: GestureDetector(
                onTap: () {
                  change(value);
                },
                child: Row(
                    mainAxisAlignment: isPhoneScreen
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.start,
                    children: [
                      if (!isPhoneScreen)
                        Transform.scale(
                            scale: width / 180,
                            child: Checkbox(
                                side: BorderSide(
                                    color: widget.color,
                                    width: width / 100,
                                    style: BorderStyle.solid),
                                splashRadius: width / 10,
                                checkColor: Colors.white,
                                fillColor:
                                    MaterialStateProperty.resolveWith(getColor),
                                value: widget.checked[value],
                                onChanged: (bool? val) {
                                  change(value);
                                })),
                      GestureDetector(
                        onTap: () {
                          if (isPhoneScreen) {
                            change(value);
                          }
                        },
                        child: Container(
                          decoration: isPhoneScreen
                              ? BoxDecoration(
                                  border: Border.all(
                                    color: widget.checked[value]!
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
                          child: Text(value,
                              style: TextStyle(
                                  fontFamily: "Sushi",
                                  fontSize: isPhone(context)
                                      ? ScreenSize.height * 0.03
                                      : widget.width / 8,
                                  fontWeight: isPhoneScreen
                                      ? FontWeight.w200
                                      : FontWeight.bold,
                                  color: widget.textColor)),
                        ),
                      ),
                    ]),
              )),
        ),
      );
    }

    return widget.isRow
        ? Row(
            mainAxisAlignment: isPhoneScreen
                ? MainAxisAlignment.spaceEvenly
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: options)
        : Column(
            mainAxisAlignment: isPhoneScreen
                ? MainAxisAlignment.spaceEvenly
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: options);
  }
}
