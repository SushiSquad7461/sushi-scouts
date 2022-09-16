import 'package:flutter/material.dart';

class RequiredContent extends StatelessWidget {
  final List<String> notFilled;
  
  const RequiredContent(this.notFilled, {Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    String message = "Please fill ";
    for( String s in notFilled) {
      message = "$message$s, ";
    }
    message = message.substring(0, message.length-2);
    return AlertDialog(
      title: const Text("Required Content"),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("OK")
        )
      ]
    );
  }
}