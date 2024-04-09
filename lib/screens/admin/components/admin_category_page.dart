import 'package:flutter/material.dart';

class AdminCategoryPage extends StatefulWidget {
  const AdminCategoryPage({Key? key}) : super(key: key);

  @override
  State<AdminCategoryPage> createState() => _AdminCategoryPageState();
}

class _AdminCategoryPageState extends State<AdminCategoryPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Categories')),
    );
  }
}
