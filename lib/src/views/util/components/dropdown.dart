// Flutter imports:
import "package:flutter/material.dart";

// Project imports:
import "../../../logic/data/data.dart";
import '../../../logic/types/device_type.dart';
import "../../../logic/helpers/size/screen_size.dart";
import "../../../../src/logic/helpers/style/text_style.dart";

class Dropdown extends StatefulWidget {
  final String name;
  final Data data;
  final Data defaultValue;
  final Color color;
  final Color textColor;
  final double width;
  final bool setCommonValue;
  final List<String> values;
  Dropdown(
      {Key? key,
      required this.name,
      required this.data,
      required this.defaultValue,
      required this.color,
      required this.width,
      required this.textColor,
      required this.values,
      required this.setCommonValue})
      : super(key: key) {
    if (!values.contains(" ")) {
      values.add(" ");
    }
  }
  static Dropdown create(
      Key key,
      String name,
      Data data,
      List<String> values,
      Data defaultValue,
      Color color,
      double width,
      Color textColor,
      bool setCommonValue,
      double height) {
    return Dropdown(
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
  DropdownState createState() => DropdownState();
}

class DropdownState extends State<Dropdown> {
  // Check my comment on checkbox.dart to see what effect this will have.
  String _currentValue = "";

  @override
  void initState() {
    super.initState();
    _currentValue = widget.data.setByUser
        ? widget.values[double.parse(widget.data.get()).floor()]
        : " ";
  }

  @override
  Widget build(BuildContext context) {
    double width = widget.width;
    var colors = Theme.of(context);
    var isPhoneScreen = isPhone(context);

    return Padding(
        padding: EdgeInsets.only(
            left: width / 60,
            right: width / 60,
            top: width / 30,
            bottom: width / 30),
        child: SizedBox(
            width: width * 0.8,
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Padding(
                  padding: EdgeInsets.only(
                      right: ScreenSize.width * (isPhoneScreen ? 0.01 : 0)),
                  child: Text(widget.name.toUpperCase(),
                      style: TextStyles.getStandardText(
                          isPhoneScreen
                              ? ScreenSize.height * 0.04
                              : widget.width / 8,
                          isPhoneScreen ? FontWeight.w100 : FontWeight.w400,
                          widget.textColor)),
                ),
                Expanded(
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                          isExpanded: true,
                          value: _currentValue,
                          icon: const Icon(Icons.arrow_drop_down_rounded),
                          elevation: (width / 100.0 * 3).floor(),
                          dropdownColor: colors.scaffoldBackgroundColor,
                          style: TextStyles.getStandardText(
                              widget.width / (isPhoneScreen ? 7 : 8),
                              isPhoneScreen ? FontWeight.w100 : FontWeight.w400,
                              widget.textColor),
                          alignment: AlignmentDirectional.center,
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              widget.data.set(
                                  widget.values.indexOf(newValue) * 1.0,
                                  setByUser: newValue != " ");
                              setState(() {
                                _currentValue = newValue;
                              });
                              build(context);
                            }
                          },
                          items: widget.values
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Center(
                                  child: Text(
                                value,
                                overflow: TextOverflow.ellipsis,
                              )),
                            );
                          }).toList(),
                        ))))
              ]),
              Divider(color: widget.textColor, thickness: width / 50)
            ])));
  }
}
