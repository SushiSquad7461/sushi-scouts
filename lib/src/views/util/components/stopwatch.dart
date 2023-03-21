// Flutter imports:
import 'dart:async';

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "../../../logic/helpers/style/text_style.dart";

// Project imports:
import "../../../logic/data/data.dart";

class StopwatchC extends StatefulWidget {
  final String name;
  final Data data;
  final Data defaultValue;
  final Color color;
  final Color textColor;
  final double width;
  final List<String>? values;
  final bool setCommonValue;

  StopwatchC(
      {Key? key,
      required this.name,
      required this.data,
      required this.defaultValue,
      required this.color,
      required this.width,
      required this.textColor,
      required this.setCommonValue,
      this.values})
      : super(key: key) {
    double val = double.parse(defaultValue.get());
    data.set(val == -1.0 ? 0.0 : val, setByUser: true);
  }

  static StopwatchC create(
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
    return StopwatchC(
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
  StopwatchState createState() => StopwatchState();
}

class StopwatchState extends State<StopwatchC> {
  static const int updateTime = 30; // milliseconds
  Timer? _timer;
  var _value = 0;
  late Stopwatch stopwatch;

  @override
  void initState() {
    super.initState();
    _value = double.parse(widget.data.get()).round();
    _controller.text = _value.toString();
    stopwatch = Stopwatch();
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      setState(() {
        if (stopwatch.isRunning) {
          _controller.text = stopwatch.elapsed.inSeconds.toString();
        }
        // _controller.text = stopwatch.isRunning
        //     ? stopwatch.elapsed.inSeconds.toString()
        //     : _value.toString();
      });
    });
  }

  //stops stopwatch if its running, if its not resets
  void stop() {
    //stop or reset
    stopwatch.isRunning ? stopwatch.stop() : stopwatch.reset();
    setState(() {
      _controller.text = stopwatch.elapsed.inSeconds.toString();
      _value = stopwatch.elapsed.inSeconds;
      widget.data.set(_value.toDouble(), setByUser: true);
    });
  }

  void start() {
    stopwatch.start();
    setState(() {
      _value = stopwatch.elapsed.inSeconds;
    });
  }

  final TextEditingController _controller = TextEditingController();
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
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _value = double.parse(widget.data.get()).round();

    double width = widget.width;
    return Padding(
        padding: EdgeInsets.only(
            left: width / 60,
            right: width / 60,
            top: width / 30,
            bottom: width / 30),
        child: SizedBox(
            width: width * 0.9,
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(widget.name,
                    style:
                        TextStyles.getTitleText(width / 8, widget.textColor)),
              ]),
              Center(
                  child: Row(
                children: [
                  IconButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () {
                      stop();
                    },
                    iconSize: width / 4.0,
                    icon: Icon(
                      Icons.timer_off_outlined,
                      color: stopwatch.isRunning
                          ? widget.color
                          : Color.fromARGB(213, 252, 119, 183),
                      semanticLabel: "Stop Stopwatch",
                    ),
                  ),
                  TextFormField(
                      controller: _controller,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: widget.color,
                                width: width / 40,
                                style: BorderStyle.solid)),
                        constraints: BoxConstraints(
                            maxWidth: width / 5.0, maxHeight: width / 5.0),
                      ),
                      style:
                          TextStyles.getTitleText(width / 20, widget.textColor),
                      textAlign: TextAlign.center,
                      onFieldSubmitted: (strValue) {
                        _value = int.parse(strValue);
                        print(_value);
                        widget.data
                            .set(double.parse(strValue), setByUser: true);
                      }),
                  IconButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () {
                      start();
                    },
                    iconSize: width / 4.0,
                    icon: Icon(
                      Icons.timer_outlined,
                      color: widget.color,
                      semanticLabel: "Start / Resume Stopwatch",
                    ),
                  ),
                ],
              ))
            ])));
  }
}
