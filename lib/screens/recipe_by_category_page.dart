import 'package:flutter/material.dart';
import 'package:foodryp/models/category.dart';
import 'package:foodryp/models/recipe.dart'; // Import the Recipe model
import 'package:foodryp/screens/recipe_detail/recipe_detail_page.dart'; // Import the RecipeDetailPage
import 'package:foodryp/utils/recipe_service.dart'; // Import your recipe service

class RecipeByCategoryPage extends StatefulWidget {
  final CategoryModel category;
  const RecipeByCategoryPage({Key? key, required this.category}) : super(key: key);

  @override
  _RecipeByCategoryPageState createState() => _RecipeByCategoryPageState();
}

class _RecipeByCategoryPageState extends State<RecipeByCategoryPage> {
  List<Recipe> recipes = []; // List to store recipes

  @override
  void initState() {
    super.initState();
    _fetchRecipesByCategory(); // Fetch recipes when the page is initialized
  }

  Future<void> _fetchRecipesByCategory() async {
    try {
      final fetchedRecipes = await RecipeService().getRecipesByCategory(widget.category.name);
      setState(() {
        recipes = fetchedRecipes;
      });
    } catch (e) {
      // Handle error gracefully
      print('Error fetching recipes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes for ${widget.category.name}'), // Display category name in the app bar
      ),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return ListTile(
            title: Text(recipe.recipeTitle), // Display recipe title
            onTap: () {
              // Navigate to the recipe detail page when the recipe is tapped
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeDetailPage(recipe: recipe),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
