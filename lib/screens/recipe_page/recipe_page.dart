import 'package:flutter/material.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/recipe_service.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_recipe_card.dart';

class RecipePage extends StatefulWidget {
  const RecipePage({super.key});

  @override
  _RecipePageState createState() => _RecipePageState();
}

class _RecipePageState extends State<RecipePage> {
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
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchMoreRecipes(); // Fetch more recipes when reaching the end of the list
    }
  }

  Future<void> _fetchRecipes() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final fetchedRecipes = await RecipeService().getAllRecipesByPage(
         _currentPage,
         _pageSize,
      );
      setState(() {
        recipes = fetchedRecipes;
        _isLoading = false;
      });
    } catch (e) {
    
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
        final fetchedRecipes = await RecipeService().getAllRecipesByPage(
           _currentPage + 1, // Fetch next page
           _pageSize,
        );
        setState(() {
          recipes.addAll(fetchedRecipes);
          _currentPage++; // Increment current page
          _isLoading = false;
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
        title: const Text('Recipes'),
      ),
      body: _buildRecipeList(),
    );
  }

  Widget _buildRecipeList() {
    return Padding(
      padding: const EdgeInsets.all(Constants.defaultPadding),
      child: Center(
        child: SizedBox(
          width: 600,
          child: ListView.builder(
            controller: _scrollController,
            itemCount: recipes.length + (_isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index < recipes.length) {
                final recipe = recipes[index];
                return Padding(
                  padding: const EdgeInsets.all(Constants.defaultPadding),
                  child: SizedBox(
                    height: 300,
                    width: 300,
                    child: CustomRecipeCard(internalUse: '', onTap: (){}, recipe: recipe)),
                );
              } else {
                return _buildLoader();
              }
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
