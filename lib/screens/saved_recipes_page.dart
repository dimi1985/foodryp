// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/recipe_service.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_recipe_card.dart';

class SavedRecipesPage extends StatefulWidget {
  final String userId;

  const SavedRecipesPage({super.key, required this.userId});

  @override
  _SavedRecipesPageState createState() => _SavedRecipesPageState();
}

class _SavedRecipesPageState extends State<SavedRecipesPage> {
  final RecipeService _recipeService = RecipeService();
  List<Recipe> _savedRecipes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSavedRecipesDetails();
  }

  Future<void> _fetchSavedRecipesDetails() async {
    try {
      List<Recipe> savedRecipes =
          await _recipeService.getUserSavedRecipesDetails(widget.userId);
      setState(() {
        _savedRecipes = savedRecipes;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching saved recipes details: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    
    
    return Scaffold(
      appBar: AppBar(
        title:  Text(AppLocalizations.of(context).translate('Saved Recipes')),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _savedRecipes.isEmpty
              ?  Center(child: Text(AppLocalizations.of(context).translate('No saved recipes')))
              : Center(
                child: Container(
                   constraints: const BoxConstraints(maxWidth: 600),
                  child: ListView.builder(
                      itemCount: _savedRecipes.length,
                      itemBuilder: (context, index) {
                        var recipe = _savedRecipes[index];
                        return SizedBox(
                            height: 300,
                            width: 300,
                            child:
                                CustomRecipeCard(internalUse: '', recipe: recipe));
                      },
                    ),
                ),
              ),
    );
  }
}
