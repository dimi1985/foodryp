// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:foodryp/screens/category_page/category_page.dart';
import 'package:foodryp/screens/recipe_page/recipe_page.dart';
import 'package:foodryp/screens/weekly_menu_page/weekly_menu_page.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/widgets/CustomWidgets/heading_title_row.dart';
import 'package:foodryp/widgets/CustomWidgets/category_section.dart';
import 'package:foodryp/widgets/CustomWidgets/recipe_section.dart';
import 'package:foodryp/widgets/CustomWidgets/top_three_recipe_card_section.dart';
import 'package:foodryp/widgets/CustomWidgets/weeklyMenu_section.dart';

class DesktopMiddleSide extends StatelessWidget {
  const DesktopMiddleSide({Key? key});

  @override
  Widget build(BuildContext context) {
    bool isAndroid = Theme.of(context).platform == TargetPlatform.android;
    Size size = MediaQuery.of(context).size;
    return LayoutBuilder(
      builder: (context, constraints) {
        return SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 400,
                    child: TopThreeRecipeCardSection(),
                  ),
                  if (Responsive.isDesktop(context) || isAndroid)
                    const SizedBox(height: 25),
                  HeadingTitleRow(
                    title: AppLocalizations.of(context).translate('Categories'),
                    onPressed: () {
                      // Navigate to the corresponding page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CategoryPage()),
                      );
                    },
                    showSeeALl: true,
                  ),
                  const CategorySection(),
                  const SizedBox(height: 15.0),
                  SizedBox(
                      height: Responsive.isDesktop(context)
                          ? 100
                          : isAndroid
                              ? 10
                              : 50),
                  HeadingTitleRow(
                    title: AppLocalizations.of(context).translate('Recipes'),
                    onPressed: () {
                      // Navigate to the corresponding page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RecipePage()),
                      );
                    },
                    showSeeALl: true,
                  ),
                  const RecipeSection(isFor: 'MainScreen'),
                  const SizedBox(height: 15.0),
                  HeadingTitleRow(
                    title:
                        AppLocalizations.of(context).translate('Weekly Menus'),
                    onPressed: () {
                      // Navigate to the corresponding page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WeeklyMenuPage()),
                      );
                    },
                    showSeeALl: true,
                  ),
                  
                const  Padding(
                    padding:  EdgeInsets.all(16),
                    child:  Align(
                      alignment: Alignment.topLeft,
                      child:  WeeklyMenuSection(
                        showAll: true,
                        publicUsername: '',
                        publicUserId: '',
                      ),
                    ),
                  ),
                  const SizedBox(height: 15.0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
