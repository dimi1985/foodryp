import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/screens/recipe_detail/recipe_detail_page.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/recipe_service.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_top_three_card.dart';
import 'package:hexcolor/hexcolor.dart';

class TopThreeRecipeCardSection extends StatefulWidget {

  const TopThreeRecipeCardSection({super.key,});

  @override
  State<TopThreeRecipeCardSection> createState() =>
      _TopThreeRecipeCardSectionState();
}

class _TopThreeRecipeCardSectionState extends State<TopThreeRecipeCardSection> {
  List<Recipe> _topRecipes = [];

  @override
  void initState() {
    super.initState();
    _fetchTopThreeRecipes();
  }

  Future<void> _fetchTopThreeRecipes() async {
    try {
      final List<Recipe> recipes = await RecipeService().fetchTopThreeRecipes();
      setState(() {
        _topRecipes = recipes;
      });
    } catch (e) {
      // Handle error
      print('Error fetching top three recipes: $e');
      // Show error message or handle error scenario
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(Constants.defaultPadding),
      child: SizedBox(
        height: screenSize.height,
        width: screenSize.width,
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
            },
          ),
          child: Row(
            children: [
              Text(
                AppLocalizations.of(context)
                    .translate('Top\nThree Recipes\nOf\nThe Week'),
                style: TextStyle(
                  fontSize: screenSize.width <= 1500 ? 30 : 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: _topRecipes.length,
                  itemBuilder: (context, index) {
                    Recipe recipe = _topRecipes[index];
                    return SizedBox(
                      width: screenSize.width <= 1100
                          ? 260
                          : screenSize.width <= 1400
                              ? screenSize.width / 7
                              : screenSize.width / 8,
                      height: screenSize.height,
                      child: CustomCategoryTopThreeCard(
                        title: recipe.recipeTitle ?? Constants.emptyField,
                        imageUrl: recipe.recipeImage ?? Constants.emptyField,
                        color: HexColor(
                            recipe.categoryColor ?? Constants.emptyField),
                        itemList: _topRecipes.length.toString(),
                        internalUse: 'top_three',
                        onTap: () {
                          // Navigate to ProfilePage
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RecipeDetailPage(
                                      recipe: recipe,
                                      internalUse: 'top_three',
                                      missingIngredients: const [],
                                    )),
                          );
                        },
                        username: recipe.username ?? Constants.emptyField,
                        userImageURL: recipe.useImage ?? Constants.emptyField,
                        date: recipe.dateCreated ?? DateTime.now(),

                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      width: Responsive.isMobile(context) ? 10 : 50,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
