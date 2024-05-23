import 'package:flutter/material.dart';

class FridgePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Draw the fridge body
    Rect fridgeBody = Rect.fromLTWH(50, 50, 100, 300);
    canvas.drawRect(fridgeBody, paint);

    // Draw the fridge doors
    paint.color = Colors.grey[300]!;
    Rect topDoor = Rect.fromLTWH(50, 50, 100, 150);
    Rect bottomDoor = Rect.fromLTWH(50, 200, 100, 150);
    canvas.drawRect(topDoor, paint);
    canvas.drawRect(bottomDoor, paint);

    // Draw the handles
    paint.color = Colors.black;
    Rect topHandle = Rect.fromLTWH(130, 100, 10, 50);
    Rect bottomHandle = Rect.fromLTWH(130, 250, 10, 50);
    canvas.drawRect(topHandle, paint);
    canvas.drawRect(bottomHandle, paint);

    // Draw the fridge outline
    paint
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRect(fridgeBody, paint);
    canvas.drawRect(topDoor, paint);
    canvas.drawRect(bottomDoor, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}