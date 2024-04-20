// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:foodryp/screens/category_page/category_page.dart';
import 'package:foodryp/screens/creators_page/creators_page.dart';
import 'package:foodryp/screens/recipe_page/recipe_page.dart';
import 'package:foodryp/screens/weekly_menu_page/weekly_menu_page.dart';
import 'package:foodryp/widgets/CustomWidgets/creators_section.dart';
import 'package:foodryp/widgets/CustomWidgets/heading_title_row.dart';
import 'package:foodryp/widgets/CustomWidgets/category_section.dart';
import 'package:foodryp/widgets/CustomWidgets/recipe_section.dart';
import 'package:foodryp/widgets/CustomWidgets/top_three_recipe_card.dart';

class DesktopMiddleSide extends StatelessWidget {
  const DesktopMiddleSide({Key? key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isAndroid = Theme.of(context).platform == TargetPlatform.android;
        bool isLargeScreen = constraints.maxWidth > 600;

        return SafeArea(
          child: Scaffold(
            body: ListView(
              children: [
                const SizedBox(
                  height: 400,
                  child: TopThreeRecipeCard(),
                ),
                SizedBox(
                    height: isLargeScreen
                        ? 100
                        : isAndroid
                            ? 10
                            : 50),
                HeadingTitleRow(
                  title: 'Recipes',
                  onPressed: () {
                    // Navigate to the corresponding page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RecipePage()),
                    );
                  },showSeeALl: true,
                ),
                const RecipeSection(),
                if (isLargeScreen || isAndroid) const SizedBox(height: 25),
                HeadingTitleRow(
                  title: 'Categories',
                  onPressed: () {
                    // Navigate to the corresponding page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CategoryPage()),
                    );
                  },showSeeALl: true,
                ),
                const CategorySection(),
                const SizedBox(height: 15.0),
                HeadingTitleRow(
                  title: 'Weekly Menus',
                  onPressed: () {
                    // Navigate to the corresponding page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WeeklyMenuPage()),
                    );
                  },showSeeALl: true,
                ),
                Container(),
                const SizedBox(height: 15.0),
              ],
            ),
          ),
        );
      },
    );
  }
}
