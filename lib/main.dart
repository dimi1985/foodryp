import 'package:flutter/material.dart';
import 'package:foodryp/screens/admin/components/admin_category_page.dart';
import 'package:foodryp/utils/ingredients_state.dart';
import 'package:foodryp/utils/instructions_state.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:provider/provider.dart';
import 'screens/mainScreen/main_screen.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
         ChangeNotifierProvider(create: (_) => UserService()),
        ChangeNotifierProvider(create: (_) => IngredientsState()),
        ChangeNotifierProvider(create: (_) => InstructionsState()),
      ],
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
