import 'package:flutter/material.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/screens/mainScreen/main_screen.dart';
import 'package:foodryp/screens/profile_page/profile_page.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/recipe_service.dart';

class RecipeDeletionConfirmationScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDeletionConfirmationScreen({
    super.key,
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('Confirm Deletion')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              AppLocalizations.of(context)
                  .translate('Are you sure you want to delete this recipe?'),
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _deleteRecipe(context),
              child: Text(AppLocalizations.of(context).translate('Delete')),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context).translate('Cancel')),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteRecipe(BuildContext context) {
    RecipeService().deleteRecipe(recipe.id!).then((value) {
      if (value) {}
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
        (Route<dynamic> route) => false,
      );
    }).catchError((error) {
      print('Failed to delete recipe: $error');
    });
  }
}
