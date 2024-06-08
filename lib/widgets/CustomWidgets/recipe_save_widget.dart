// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:foodryp/utils/recipe_service.dart';

class RecipSaveWidget extends StatefulWidget {
  final String recipeId;
  final String recipeName;
  final String userId;
  final String internalUse;

  const RecipSaveWidget({
    super.key,
    required this.recipeId,
    required this.recipeName,
    required this.userId,
    required this.internalUse,
  });

  @override
  _RecipSaveWidgetState createState() => _RecipSaveWidgetState();
}

class _RecipSaveWidgetState extends State<RecipSaveWidget> {
  final RecipeService _recipeService = RecipeService();
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    _checkIfSaved();
  }

  Future<void> _checkIfSaved() async {
    try {
      List<String> savedRecipes = await _recipeService.getUserSavedRecipes();
      setState(() {
        isSaved = savedRecipes.contains(widget.recipeId);
      });
    } catch (error) {
      print('Error checking if recipe is saved: $error');
    }
  }

  Future<void> _toggleSave() async {
    try {
      if (isSaved) {
        bool success = await _recipeService.removeUserRecipe(widget.recipeId);
        if (success) {
          setState(() {
            isSaved = false;
          });
          if (widget.internalUse == 'savedUserRecipes') {
            Navigator.pop(context, true);
          }
        }
      } else {
        bool success = await _recipeService.saveUserRecipe(widget.recipeId);
        if (success) {
          setState(() {
            isSaved = true;
          });
          if (widget.internalUse == 'savedUserRecipes') {
            Navigator.pop(context, true);
          }
        }
      }
    } catch (error) {
      print('Error toggling save state: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isSaved ? Icons.bookmark : Icons.bookmark_border,
      ),
      onPressed: _toggleSave,
    );
  }
}
