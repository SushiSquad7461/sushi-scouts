import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IncorrectPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Incorrect Password"),
      content: Text("Please ask you scouting lead for the correct password."),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("OK")
        )
      ]
    );
  }
}