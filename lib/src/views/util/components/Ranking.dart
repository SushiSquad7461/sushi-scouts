import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sushi_scouts/src/logic/deviceType.dart';

import '../../../logic/data/Data.dart';
import '../../../logic/helpers/size/ScreenSize.dart';

class Ranking extends StatefulWidget {
  final String name;
  final Data data;
  final Data defaultValue;
  final Color color;
  final Color textColor;
  final double width;
  final bool setCommonValue;
  final List<String>? values;

  Ranking(
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
  static Ranking create(
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
    return Ranking(
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
  RankingState createState() => RankingState();
}

class RankingState extends State<Ranking> {
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    double width = widget.width / (isPhone(context) ? 1.4 : 1.6);
    widget.data.set(widget.values!.toString(), setByUser: true);
    bool isPhoneScreen = isPhone(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.values![0],
          style: TextStyle(
              fontFamily: "Sushi",
              fontSize:
                  isPhoneScreen ? ScreenSize.height * 0.04 : widget.width / 8,
              fontWeight: FontWeight.bold,
              color: widget.textColor),
        ),
        for (int i = 1; i < widget.values!.length; i++)
          Row(
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                onPressed: () {
                  setState(() {
                    String temp = widget.values![i];
                    widget.values![i] = widget.values![i - 1];
                    widget.values![i - 1] = temp;
                    widget.data.set(widget.values!.toString(), setByUser: true);
                  });
                  build(context);
                },
                iconSize: width / (isPhoneScreen ? 3 : 3.0),
                icon: Icon(
                  Icons.arrow_left_rounded,
                  color: widget.color,
                  semanticLabel: 'Back Arrow',
                ),
              ),
              Text(
                widget.values![i],
                style: TextStyle(
                    fontFamily: "Sushi",
                    fontSize: isPhoneScreen ? ScreenSize.height * 0.04 : widget.width / 8,
                    fontWeight: FontWeight.bold,
                    color: widget.textColor),
              ),
            ],
          )
      ],
    );
  }
}
