
// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/screens/recipe_detail/recipe_detail_page.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/recipe_service.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_profile_recipe_card.dart';

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
  double lastScrollPosition = 0;

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
    if (_scrollController.position.pixels > lastScrollPosition) {
      if (!_isLoading &&
          _scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200) {
        _fetchMoreRecipes();
      }
    }
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
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(Responsive.isDesktop(context) ? 32 : 16),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.only(top: 16.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (Responsive.isDesktop(context)) {
                      return null;
                    }
                    final recipe = recipes[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        hoverColor: Colors.transparent,
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
                        child: SizedBox(
                          height: 350,
                          width: 350,
                          child: CustomProfileRecipeCard(
                            internalUse: '',
                            recipe: recipe,
                          ),
                        ),
                      ),
                    );
                  },
                  childCount:
                      Responsive.isDesktop(context) ? 0 : recipes.length,
                ),
              ),
            ),
            if (Responsive.isDesktop(context))
  SliverPadding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    sliver: SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 1.0,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final recipe = recipes[index];
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                hoverColor: Colors.transparent,
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
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Constants.defaultPadding),
                    color: Colors.transparent,
                  ),
                  child: SizedBox(
                      height: 200,
                          width: 200,
                    child: CustomProfileRecipeCard(
                      internalUse: '',
                      recipe: recipe,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        childCount: recipes.length,
      ),
    ),
  ),

            if (_isLoading)
              const SliverPadding(
                padding: EdgeInsets.all(16.0),
                sliver: SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
