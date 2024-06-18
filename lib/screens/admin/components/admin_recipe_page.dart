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
  List<Recipe> _recipes = [];
  int _page = 1;
  final int _pageSize = 10;
  bool _isLoading = false;
  bool _hasMore = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchRecipes();
  }

  Future<void> _fetchRecipes() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final List<Recipe> recipes =
          await RecipeService().getAllRecipesByPage(_page, _pageSize);
      setState(() {
        _recipes.addAll(recipes);
        _page++;
        _hasMore = recipes.length == _pageSize;
        log('Fetched ${recipes.length} recipes');
      });
    } catch (e) {
      // Handle error
      log('Error fetching recipes: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
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
                    controller: _scrollController,
                    itemCount: _recipes.length + 1,
                    itemBuilder: (context, index) {
                      if (index == _recipes.length) {
                        return _hasMore
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed: _fetchRecipes,
                                  child: _isLoading
                                      ? CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : Text(AppLocalizations.of(context)
                                          .translate('Load More')),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(AppLocalizations.of(context)
                                    .translate('No more recipes')),
                              );
                      }
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
