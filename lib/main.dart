import 'package:flutter/material.dart';
import 'package:foodryp/screens/home_page.dart';

void main() {
  runApp(const Foodryp());
}

class Foodryp extends StatelessWidget {
  const Foodryp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Foodryp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}
