import 'package:flutter/material.dart';
import 'package:foodryp/screens/image_upload_page.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:provider/provider.dart';


import 'screens/mainScreen/main_screen.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => UserService(),
      child: const Foodryp(),
    ),
  );
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
