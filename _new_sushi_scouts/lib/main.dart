import 'package:flutter/material.dart';

import 'views/home.dart';

void main() {
  // TODO initialize firebase
  // TODO initialize error builder
  runApp(const SushiScouts());
}

class SushiScouts extends StatelessWidget {
  const SushiScouts({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.lightBlue), // TODO change to sushi color
        useMaterial3: true,
      ),
      home: const Home(title: 'Flutter Demo Home Page'),
    );
  }
}
