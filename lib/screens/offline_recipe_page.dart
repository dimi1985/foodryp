import 'package:flutter/material.dart';

class OfflineRecipePage extends StatelessWidget {
  const OfflineRecipePage({super.key});

  @override
  Widget build(BuildContext context) {
    return  const Scaffold(
      body: SafeArea(child: Center(child: Text('You are offline'))),
    );
  }
}