// Define a class to hold both the recipe and its original index
import 'package:foodryp/models/recipe.dart';

class RecipeWithIndex {
  final Recipe recipe;
  final int originalIndex;

  RecipeWithIndex(this.recipe, this.originalIndex);
}
