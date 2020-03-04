import 'package:flutter/material.dart';
import 'package:carsome_mobile_test/carsome.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carsome Mobile Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Carsome(),
    );
  }
}
