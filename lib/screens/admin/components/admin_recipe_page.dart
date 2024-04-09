import 'package:flutter/material.dart';

class AdminRecipePage extends StatefulWidget {
  const AdminRecipePage({Key? key}) : super(key: key);

  @override
  State<AdminRecipePage> createState() => _AdminRecipePageState();
}

class _AdminRecipePageState extends State<AdminRecipePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Recipes')),
    );
  }
}
