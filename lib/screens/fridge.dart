import 'package:flutter/material.dart';
import 'package:foodryp/widgets/CustomWidgets/fridge_painter.dart';

class fridge extends StatelessWidget {
  const fridge({super.key});

   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fridge Drawing'),
        ),
        body: Center(
          child: CustomPaint(
            size: Size(800, 1200), // You can change the size as needed
            painter: FridgePainter(),
          ),
        ),
      ),
    );
  }
}