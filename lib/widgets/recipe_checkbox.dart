import 'package:flutter/material.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/utils/app_localizations.dart';

class RecipeCheckbox extends StatefulWidget {
  final Recipe recipe;
  final bool isMultipleDays;
  final List<Recipe> selectedRecipes;
  final List<Recipe> unSelectedRecipes;

  RecipeCheckbox({
    required this.recipe,
    required this.isMultipleDays,
    required this.selectedRecipes,
    required this.unSelectedRecipes,
  });

  @override
  _RecipeCheckboxState createState() => _RecipeCheckboxState();
}

class _RecipeCheckboxState extends State<RecipeCheckbox> {
  int removedIndex = -1;

  void addRecipe(Recipe recipe) {
    if (widget.selectedRecipes.length < 7) {
      setState(() {
        widget.selectedRecipes.add(recipe);
        widget.unSelectedRecipes.remove(recipe);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).translate('You have reached the maximum number of selected recipes.'),
          ),
        ),
      );
    }
  }

  void removeRecipe(Recipe recipe) {
    setState(() {
      widget.selectedRecipes.removeWhere((r) => r.id == recipe.id);
      if (!widget.selectedRecipes.any((r) => r.id == recipe.id)) {
        widget.unSelectedRecipes.add(recipe);
      }
    });
  }

  void handleCheckboxChange(bool? isChecked, Recipe recipe) {
    setState(() {
      if (isChecked != null) {
        if (!isChecked) {
          removeRecipe(recipe);
        } else {
          addRecipe(recipe);
        }
        recipe.checked = isChecked;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Checkbox(
          value: widget.recipe.checked,
          onChanged: (isChecked) {
            handleCheckboxChange(isChecked, widget.recipe);
          },
        ),
        if (widget.isMultipleDays)
          Checkbox(
            value: widget.selectedRecipes.where((r) => r.id == widget.recipe.id).isNotEmpty,
            onChanged: (isChecked) {
              setState(() {
                if (isChecked != null) {
                  if (!isChecked!) {
                    int indexToRemove = widget.selectedRecipes.lastIndexWhere((r) => r.id == widget.recipe.id);
                    if (indexToRemove != -1) {
                      widget.selectedRecipes.removeAt(indexToRemove);
                      if (!widget.selectedRecipes.any((r) => r.id == widget.recipe.id)) {
                        widget.unSelectedRecipes.add(widget.recipe);
                      }
                    }
                  } else {
                    if (widget.selectedRecipes.length < 7) {
                      if (removedIndex != -1) {
                        widget.selectedRecipes.insert(removedIndex, widget.recipe);
                        removedIndex = -1;
                      } else {
                        widget.selectedRecipes.add(widget.recipe);
                      }
                      widget.unSelectedRecipes.removeWhere((r) => r.id == widget.recipe.id);
                    } else {
                      isChecked = false;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            AppLocalizations.of(context).translate('You have reached the maximum number of selected recipes.'),
                          ),
                        ),
                      );
                    }
                  }
                  widget.recipe.checked = widget.selectedRecipes.any((r) => r.id == widget.recipe.id);
                }
              });
            },
          ),
      ],
    );
  }
}
