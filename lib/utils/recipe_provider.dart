import 'package:flutter/material.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/utils/recipe_service.dart';

class RecipeProvider with ChangeNotifier {
  final RecipeService _recipeService = RecipeService();
  final List<Recipe> _recipes = [];
  bool _isLoading = false;
  bool _hasMoreData = true;
  int _currentPage = 1;
  final int _pageSize = 10;

  List<Recipe> get recipes => _recipes;
  bool get isLoading => _isLoading;
  bool get hasMoreData => _hasMoreData;

  RecipeProvider() {
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    if (_isLoading || !_hasMoreData) return;

    _isLoading = true;
    notifyListeners();

    List<Recipe> newRecipes = await _recipeService.getRecipesByPage(_currentPage, _pageSize);

    if (newRecipes.isNotEmpty) {
      _recipes.addAll(newRecipes);
      _currentPage++;
    } else {
      _hasMoreData = false;
    }

    _isLoading = false;
    notifyListeners();
  }
}
