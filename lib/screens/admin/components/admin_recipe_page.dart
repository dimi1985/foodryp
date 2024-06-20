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

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          _hasMore &&
          !_isLoading) {
        _fetchRecipes();
      }
    });
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
              .translate('Recipe deleted successfully')),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)
              .translate('Failed to delete recipe')),
        ),
      );
    }
  }

  void _invalidateCache() async {
    try {
      await RecipeService().invalidateCache();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)
              .translate('Cache invalidated successfully')),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)
              .translate('Failed to invalidate cache')),
        ),
      );
    }
  }

  void _viewRecipeDetails(Recipe recipe) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  recipe.recipeTitle ?? Constants.emptyField,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${AppLocalizations.of(context).translate('By')} ${recipe.username}',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  recipe.description ??
                      AppLocalizations.of(context)
                          .translate('No description available'),
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 10),
                if (recipe.ingredients != null) ...[
                  Text(
                    AppLocalizations.of(context).translate('Ingredients'),
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  ...recipe.ingredients!
                      .map((ingredient) => Text(
                            ingredient,
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
                          ))
                      ,
                  const SizedBox(height: 10),
                ],
                if (recipe.instructions != null) ...[
                  Text(
                    AppLocalizations.of(context).translate('Instructions'),
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  ...recipe.instructions!
                      .map((instruction) => Text(
                            instruction,
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
                          ))
                      ,
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(AppLocalizations.of(context).translate('Admin Recipe Page')),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _invalidateCache,
            tooltip: AppLocalizations.of(context).translate('Invalidate Cache'),
          ),
        ],
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
                    itemCount: _recipes.length + (_hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _recipes.length) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: _isLoading
                                ? const CircularProgressIndicator()
                                : ElevatedButton(
                                    onPressed: _fetchRecipes,
                                    child: Text(AppLocalizations.of(context)
                                        .translate('Load More')),
                                  ),
                          ),
                        );
                      }

                      final recipe = _recipes[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        child: ListTile(
                          title:
                              Text(recipe.recipeTitle ?? Constants.emptyField),
                          subtitle: Text(
                              '${AppLocalizations.of(context).translate('By')} ${recipe.username}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.visibility),
                                onPressed: () => _viewRecipeDetails(recipe),
                                tooltip: AppLocalizations.of(context)
                                    .translate('View Details'),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _deleteRecipe(
                                    recipe.id ?? Constants.emptyField),
                                tooltip: AppLocalizations.of(context)
                                    .translate('Delete Recipe'),
                              ),
                            ],
                          ),
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
