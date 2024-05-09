// ignore_for_file: use_key_in_widget_constructors

import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/screens/recipe_detail/recipe_detail_page.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/recipe_service.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_profile_recipe_card.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_recipe_card.dart';

class RecipeCardProfileSection extends StatefulWidget {
  final String publicUsername;
  const RecipeCardProfileSection({
    Key? key,
    required this.publicUsername,
  });

  @override
  State<RecipeCardProfileSection> createState() =>
      _RecipeCardProfileSectionState();
}

class _RecipeCardProfileSectionState extends State<RecipeCardProfileSection> {
  late ScrollController _scrollController;
  List<Recipe> recipes = [];
  bool _isLoading = false;
  int _currentPage = 1;
  final int _pageSize = 10;
  double lastScrollPosition =
      0; // Add a field to keep track of the last scroll position

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
    if (recipes.isEmpty) {
      _fetchRecipes();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    // Check if the current scroll position is greater than the last, indicating scrolling down
    if (_scrollController.position.pixels > lastScrollPosition) {
      if (!_isLoading &&
          _scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200) {
        _fetchMoreRecipes();
      }
    }
    // Update lastScrollPosition to the current position for the next call
    lastScrollPosition = _scrollController.position.pixels;
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
    Size screenSize = MediaQuery.of(context).size;
    final bool isAndroid = Constants.checiIfAndroid(context);
    return isAndroid
        ? _buildAndroidRecipeList(screenSize)
        : _buildWebRecipeList(screenSize);
  }

  Widget _buildAndroidRecipeList(Size screenSize) {
    return Padding(
      padding: EdgeInsets.all(Responsive.isDesktop(context) ? 32 : 16),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            
            Flexible(
              // Use Expanded instead of SizedBox to fill the available space
              child: ListView.builder(
                padding: EdgeInsets.zero,
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  final recipe = recipes[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeDetailPage(
                            recipe: recipe,
                            internalUse: Constants.emptyField,
                            missingIngredients: const [],
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.all(
                          Responsive.isDesktop(context) ? 25 : 8),
                      child: Padding(
                         padding: EdgeInsets.zero,
                        child: CustomProfileRecipeCard(
                          internalUse: Constants.emptyField,
                          recipe: recipe,
                        ),
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

  Widget _buildWebRecipeList(Size screenSize) {
    return Padding(
      padding: EdgeInsets.all(Responsive.isDesktop(context) ? 32 : 16),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: Responsive.isDesktop(context) ? 3 : 2,
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
                    child: InkWell(
                      splashColor: Colors
                          .transparent, // Ensures no splash color is shown
                      highlightColor: Colors
                          .transparent, // Ensures no highlight color on tap
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetailPage(
                              recipe: recipe,
                              internalUse: '',
                              missingIngredients: const [],
                            ),
                          ),
                        );
                      },
                      child: CustomRecipeCard(
                        internalUse: '',
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
