// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/screens/category_page/category_page.dart';
import 'package:foodryp/screens/recipe_page/recipe_page.dart';
import 'package:foodryp/screens/weekly_menu_page/weekly_menu_page.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/widgets/CustomWidgets/heading_title_row.dart';
import 'package:foodryp/widgets/CustomWidgets/category_section.dart';
import 'package:foodryp/widgets/CustomWidgets/recipe_section.dart';
import 'package:foodryp/widgets/CustomWidgets/top_three_recipe_card_section.dart';
import 'package:foodryp/widgets/CustomWidgets/weeklyMenu_section.dart';

class DesktopMiddleSide extends StatelessWidget {
  final User? user;
  const DesktopMiddleSide({
    Key? key,
    this.user,
  });

  @override
  Widget build(BuildContext context) {
    bool isAndroid = Theme.of(context).platform == TargetPlatform.android;
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
                    isForDiet: false,
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
                    title: AppLocalizations.of(context)
                        .translate('Latest Recipes'),
                    onPressed: () {
                      // Navigate to the corresponding page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RecipePage(
                                  seeAll: true,
                                  user: user,
                                )),
                      );
                    },
                    showSeeALl: true,
                    isForDiet: false,
                  ),
                  RecipeSection(isFor: 'MainScreen', user: user),
                  const SizedBox(height: 15.0),
                  HeadingTitleRow(
                    title:
                        AppLocalizations.of(context).translate('Weekly Menus'),
                    onPressed: () {
                      // Navigate to the corresponding page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WeeklyMenuPage(
                                  isForDiet: false,
                                  showAll: false,
                                )),
                      );
                    },
                    showSeeALl: true,
                    isForDiet: false,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: WeeklyMenuSection(
                        showAll: true,
                        publicUsername: Constants.emptyField,
                        publicUserId: Constants.emptyField,
                        isForDiet: false,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  HeadingTitleRow(
                    title: AppLocalizations.of(context).translate(
                      'Weekly Diet Menus',
                    ),
                    onPressed: () {
                      // Navigate to the corresponding page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WeeklyMenuPage(
                                  isForDiet: true,
                                  showAll: false,
                                )),
                      );
                    },
                    showSeeALl: true,
                    isForDiet: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: WeeklyMenuSection(
                          showAll: true,
                          publicUsername: Constants.emptyField,
                          publicUserId: Constants.emptyField,
                          isForDiet: true),
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
