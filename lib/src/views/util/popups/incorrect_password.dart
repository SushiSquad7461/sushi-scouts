// Flutter imports:
import "package:flutter/material.dart";

class IncorrectPassword extends StatelessWidget {
  const IncorrectPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text("Incorrect Password"),
        content: const Text(
            "Please ask your scouting lead for the correct password."),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text("OK"))
        ]);
  }
}
