import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  final TextEditingController controller;

  const TextInput({super.key, required this.controller});

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
        widthFactor: 0.75,
        child: TextField(
          controller: widget.controller,
          decoration: InputDecoration(border: OutlineInputBorder()),
        ));
  }
}
