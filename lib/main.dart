import 'package:flutter/material.dart';
import 'package:foodryp/screens/profile_screen/profile_screen.dart';


import 'screens/mainScreen/main_screen.dart';

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
      home:  MainScreen(),
    );
  }
}
