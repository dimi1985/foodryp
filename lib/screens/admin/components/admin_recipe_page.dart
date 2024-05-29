// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/recipe_service.dart';

class AdminRecipePage extends StatefulWidget {
  final User user;
  const AdminRecipePage({super.key, required this.user});

  @override
  State<AdminRecipePage> createState() => _AdminRecipePageState();
}

class _AdminRecipePageState extends State<AdminRecipePage> {
  late final List<Recipe> _recipes = [];
  late int _page = 1;
  final int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _fetchRecipes();
  }

  Future<void> _fetchRecipes() async {
    try {
      final List<Recipe> recipes =
          await RecipeService().getAllRecipesByPage(_page, _pageSize);
      setState(() {
        _recipes.addAll(recipes);
        _page++; // Increment page for next fetch
      });
    } catch (e) {
      // Handle error
      print('Error fetching recipes: $e');
    }
  }

  void _deleteRecipe(String recipeId) async {
    try {
      await RecipeService().deleteRecipe(recipeId);
      setState(() {
        _recipes.removeWhere((recipe) => recipe.id == recipeId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)
                .translate('Recipe deleted successfully'))),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)
                .translate('Failed to delete recipe'))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(AppLocalizations.of(context).translate('Admin Recipe Page')),
      ),
      body: _recipes.isEmpty
          ? Center(
              child: Text(AppLocalizations.of(context).translate('No recipes')),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = _recipes[index];
                      return ListTile(
                        title: Text(recipe.recipeTitle ?? Constants.emptyField),
                        subtitle: Text(
                            '${AppLocalizations.of(context).translate('By')} ${recipe.username}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _deleteRecipe(
                                  recipe.id ?? Constants.emptyField),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
