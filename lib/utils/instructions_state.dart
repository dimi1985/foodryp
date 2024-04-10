import 'package:flutter/material.dart';

class InstructionsState with ChangeNotifier {
  final List<String> _instructions = [];

  List<String> get instructions => _instructions;

  void addInstruction(String instruction) {
    _instructions.add(instruction);
     print("Adding instruction: $instruction");
    notifyListeners();
  }

  void removeInstruction(int index) {
    _instructions.removeAt(index);
    notifyListeners();
  }
}
