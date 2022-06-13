import "package:flutter/material.dart";

void main() {

  runApp( MyApp() );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: const Text("help why flutter confusing"),
        ),
        body: const Center(child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Sushi Scouts"),
        )),
      )
    );
  }
}