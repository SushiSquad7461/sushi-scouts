import 'package:flutter/material.dart';
import 'package:sushi_scouts/views/text_input.dart';

import '../util/spacing.dart';

enum LoginType { scout, supervisor }

class Login extends StatefulWidget {
  final LoginType type;
  const Login({super.key, this.type = LoginType.scout});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _eventController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _teamNumController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          spacing: Spacing.medium,
          children: [
            TextInput(controller: _eventController),
            TextInput(controller: _nameController),
            TextInput(controller: _teamNumController),
            ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                  }
                },
                child: const Text("Sign In"))
          ],
        ));
  }
}
