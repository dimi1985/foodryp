import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/screens/bottom_nav_screen.dart';
import 'package:foodryp/screens/entry_web_navigation_page.dart';
import 'package:foodryp/screens/mainScreen/main_screen.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/recipe_service.dart';
import 'package:foodryp/utils/responsive.dart';

class RecipeDeletionConfirmationScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDeletionConfirmationScreen({
    super.key,
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('Confirm Deletion')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (recipe.meal?.isNotEmpty ?? false)
              Padding(
                padding:
                    EdgeInsets.all(isMobile ? Constants.defaultPadding : 2),
                child: Text(
                  AppLocalizations.of(context).translate(
                      'You cannot delete this recipe as it is part of a weekly meal\nRemove it first from weekly menu and than try to delete it again.'),
                  style: TextStyle(
                      fontSize: 16, color: Colors.red.withOpacity(0.7)),
                ),
              ),
            if (recipe.meal?.isEmpty ?? false)
              Text(
                AppLocalizations.of(context)
                    .translate('Are you sure you want to delete this recipe?'),
                style: const TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 20),
            if (recipe.meal?.isEmpty ?? false)
              ElevatedButton(
                onPressed: () => _deleteRecipe(context),
                child: Text(AppLocalizations.of(context).translate('Delete')),
              ),
            const SizedBox(height: 20),
            if (recipe.meal?.isEmpty ?? false)
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
        MaterialPageRoute(builder: (context) {
          if (kIsWeb) {
            return const EntryWebNavigationPage();
          } else {
            // Optionally handle other platforms, such as iOS
            return const BottomNavScreen(); // Default to web layout for other platforms
          }
        }),
        (Route<dynamic> route) => false,
      );
    }).catchError((error) {
      print('Failed to delete recipe: $error');
    });
  }
}
