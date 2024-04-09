import 'package:flutter/material.dart';

class AdminRunningEventPage extends StatefulWidget {
  const AdminRunningEventPage({Key? key}) : super(key: key);

  @override
  State<AdminRunningEventPage> createState() => _AdminRunningEventPageState();
}

class _AdminRunningEventPageState extends State<AdminRunningEventPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Running Events')),
    );
  }
}
