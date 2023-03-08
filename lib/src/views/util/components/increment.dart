// Flutter imports:
import "package:flutter/material.dart";
import "package:flutter/services.dart";

// Project imports:
import "../../../logic/data/data.dart";

class Increment extends StatefulWidget {
  final String name;
  final Data data;
  final Data defaultValue;
  final Color color;
  final Color textColor;
  final double width;
  final List<String>? values;
  final bool setCommonValue;
  Increment(
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

  static Increment create(
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
    return Increment(
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
  IncrementState createState() => IncrementState();
}

class IncrementState extends State<Increment> {
  int _value = 0;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = widget.width;
    _value = double.parse(widget.data.get()).round();
    _controller.text = (_value).toString();
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
                    style: TextStyle(
                        fontFamily: "Sushi",
                        fontSize: width / 8,
                        fontWeight: FontWeight.bold,
                        color: widget.textColor)),
              ]),
              Center(
                  child: Row(
                children: [
                  IconButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () {
                      if (_value > 0) {
                        _controller.text = (_value - 1).toString();
                        widget.data.decrement();
                        setState(() {
                          _value--;
                        });
                        build(context);
                      }
                    },
                    iconSize: width / 3.0,
                    icon: Icon(
                      Icons.arrow_left_rounded,
                      color: widget.color,
                      semanticLabel: "Back Arrow",
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
                      style: TextStyle(
                          fontFamily: "Sushi",
                          fontSize: width / 20,
                          fontWeight: FontWeight.bold,
                          color: widget.textColor),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      onFieldSubmitted: (strValue) {
                        _value = int.parse(strValue);
                        widget.data
                            .set(double.parse(strValue), setByUser: true);
                      }),
                  IconButton(
                    padding: const EdgeInsets.all(0),
                    onPressed: () {
                      _controller.text = (_value + 1).toString();
                      widget.data.increment();
                      setState(() {
                        _value++;
                      });
                    },
                    iconSize: width / 3.0,
                    icon: Icon(
                      Icons.arrow_right_rounded,
                      color: widget.color,
                      semanticLabel: "Forward Arrow",
                    ),
                  ),
                ],
              ))
            ])));
  }
}
