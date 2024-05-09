import 'package:flutter/material.dart';
import 'package:foodryp/models/recipe.dart';


class RecipeProvider extends ChangeNotifier {
  List<Recipe> _recipes = []; 

  List<Recipe> get recipes => _recipes;

  // Method to update the list of recipes
  void updateRecipes(List<Recipe> updatedRecipes) {
    _recipes = updatedRecipes;
    notifyListeners(); // Notify listeners that the state has changed
  }

  // Other methods to manipulate the recipe list (like/dislike)
  
}