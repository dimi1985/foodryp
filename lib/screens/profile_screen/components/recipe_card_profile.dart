// ignore_for_file: use_key_in_widget_constructors

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/utils/recipe_service.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_recipe_card.dart';

class RecipeCardProfile extends StatefulWidget {
  final String publicUsername;
  const RecipeCardProfile({
    Key? key,
    required this.publicUsername,
  });

  @override
  State<RecipeCardProfile> createState() => _RecipeCardProfileState();
}

class _RecipeCardProfileState extends State<RecipeCardProfile> {
  late ScrollController _scrollController;
  List<Recipe> recipes = [];
  bool _isLoading = false;
  int _currentPage = 1;
  final int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
    _fetchRecipes(); // Fetch initial set of recipes
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (!_isLoading &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
      _fetchMoreRecipes();
    }
  }

  Future<void> _fetchRecipes() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final fetchedRecipes = await _fetchRecipesData(_currentPage, _pageSize);
      setState(() {
        recipes = fetchedRecipes.reversed.toList();
        _isLoading = false;
      });
    } catch (_) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchMoreRecipes() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
      try {
        final fetchedRecipes = await _fetchRecipesData(_currentPage, _pageSize);
        for (var recipe in fetchedRecipes) {
          if (!recipes
              .any((existingRecipe) => existingRecipe.id == recipe.id)) {
            recipes.add(recipe);
          }
        }
        setState(() {
          _currentPage++;
          _isLoading = false;
        });
      } catch (_) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<List<Recipe>> _fetchRecipesData(int currentPage, int pageSize) async {
    try {
      List<Recipe> fetchedRecipes = [];
      if (widget.publicUsername.isEmpty) {
        fetchedRecipes = await RecipeService().getUserRecipesByPage(
          currentPage,
          pageSize,
        );
      } else {
        fetchedRecipes = await RecipeService().getUserPublicRecipesByPage(
          widget.publicUsername,
          currentPage,
          pageSize,
        );
      }
      return fetchedRecipes;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildRecipeList();
  }

  Widget _buildRecipeList() {
    return Padding(
      padding: EdgeInsets.all(Responsive.isDesktop(context) ? 32 : 16),
      child: Center(
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: Responsive.isDesktop(context) ? 4 : 2,
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 20.0,
                  childAspectRatio: 1.0,
                ),
                controller: _scrollController,
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  final recipe = recipes[index];
                  return Padding(
                    padding:
                        EdgeInsets.all(Responsive.isDesktop(context) ? 25 : 8),
                    child: SizedBox(
                      height: 300,
                      width: 300,
                      child: CustomRecipeCard(
                        internalUse: '',
                        onTap: () {},
                        recipe: recipe,
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(), // Loading indicator
              ),
          ],
        ),
      ),
    );
  }
}
