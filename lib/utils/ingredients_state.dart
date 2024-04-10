import 'package:flutter/material.dart';

class IngredientsState with ChangeNotifier {
  final List<String> _ingredients = [];

  List<String> get ingredients => _ingredients;

  void addIngredient(String ingredient) {
    _ingredients.add(ingredient);
     print("Adding ingredient: $ingredient");
    notifyListeners();
  }

  void removeIngredient(int index) {
    _ingredients.removeAt(index);
    notifyListeners();
  }
}
