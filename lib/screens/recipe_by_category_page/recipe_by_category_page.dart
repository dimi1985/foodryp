// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:foodryp/models/category.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/screens/recipe_detail/recipe_detail_page.dart';
import 'package:foodryp/utils/recipe_service.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_recipe_card.dart';

class RecipeByCategoryPage extends StatefulWidget {
  final CategoryModel category;

  const RecipeByCategoryPage({Key? key, required this.category})
      : super(key: key);

  @override
  _RecipeByCategoryPageState createState() => _RecipeByCategoryPageState();
}

class _RecipeByCategoryPageState extends State<RecipeByCategoryPage> {
  late ScrollController _scrollController;
  List<Recipe> recipes = [];
  bool _isLoading = false;
  int _page = 1; // Initial page number
  final int _pageSize = 10; // Number of recipes per page

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
    if (recipes.isEmpty) {
      _fetchRecipesByCategory();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchMoreRecipes();
    }
  }

  Future<void> _fetchRecipesByCategory() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final fetchedRecipes = await RecipeService().getRecipesByCategory(
        widget.category.name,
        _page,
        _pageSize,
      );
      setState(() {
        recipes.addAll(fetchedRecipes);
        _isLoading = false;
        _page++; // Increment page number for the next fetch
      });
    } catch (e) {
      print('Error fetching recipes: $e');
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
        final fetchedRecipes = await RecipeService().getRecipesByCategory(
          widget.category.name,
          _page,
          _pageSize,
        );
        setState(() {
          recipes.addAll(fetchedRecipes);
          _isLoading = false;
          _page++; // Increment page number for the next fetch
        });
      } catch (e) {
        print('Error fetching more recipes: $e');
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes for ${widget.category.name}'),
      ),
      body: Center(
        child: SizedBox(
          width: 600,
          child: ListView.separated(
            controller: _scrollController,
            itemCount: recipes.length + (_isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < recipes.length) {
                final recipe = recipes[index];
                return SizedBox(
                  height: 300,
                  width: 300,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RecipeDetailPage(recipe: recipe, internalUse: '', missingIngredients: [],),
                        ),
                      );
                    },
                    child: CustomRecipeCard(
                      recipe: recipe,
                      internalUse: '',
                    ),
                  ),
                );
              } else {
                return _buildLoader();
              }
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                height: 15,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoader() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
