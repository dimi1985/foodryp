// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/models/weeklyMenu.dart';
import 'package:foodryp/screens/bottom_nav_screen.dart';
import 'package:foodryp/screens/entry_web_navigation_page.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/meal_service.dart';
import 'package:foodryp/utils/responsive.dart';

class WeeklyMenuDeletionConfirmationScreen extends StatelessWidget {
  final WeeklyMenu weeklyMenu;

  const WeeklyMenuDeletionConfirmationScreen({
    super.key,
    required this.weeklyMenu,
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
            Text(
              AppLocalizations.of(context).translate(
                  'Are you sure you want to remove this recipe from the weekly menu?'),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _removeFromWeeklyMenu(context),
              child: Text(AppLocalizations.of(context).translate('Remove')),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context).translate('Cancel')),
            ),
          ],
        ),
      ),
    );
  }

  void _removeFromWeeklyMenu(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent dismissing the dialog by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 16),
              Text(AppLocalizations.of(context).translate('Processing...')),
            ],
          ),
        );
      },
    );

    Future<void> handleRemoval() async {
      await Future.delayed(
          Duration(seconds: Random().nextInt(3) + 1)); // Add delay here
      try {
        bool value = await MealService()
            .removeFromWeeklyMenu(weeklyMenu.id, weeklyMenu.dayOfWeek);
        Navigator.pop(context); // Close the alert dialog
        if (value) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) {
              if (kIsWeb) {
                return const EntryWebNavigationPage();
              } else {
                return const BottomNavScreen(); // Default to web layout for other platforms
              }
            }),
            (Route<dynamic> route) => false,
          );
        }
      } catch (error) {
        Navigator.pop(context); // Close the alert dialog in case of error
        print('Failed to remove recipe from weekly menu: $error');
      }
    }

    handleRemoval();
  }
}
