// ignore_for_file: use_key_in_widget_constructors

import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/screens/recipe_detail/recipe_detail_page.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/recipe_service.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:hexcolor/hexcolor.dart';

class RecipeCardProfile extends StatefulWidget {
  final String publicUsername;
  final String currentUsername;
  const RecipeCardProfile(
      {Key? key, required this.publicUsername, required this.currentUsername});

  @override
  State<RecipeCardProfile> createState() => _RecipeCardProfileState();
}

class _RecipeCardProfileState extends State<RecipeCardProfile> {
  List<Recipe> userRecipes = [];
  List<Recipe> recipes = [];

  @override
  void initState() {
    super.initState();
    _fetchUserRecipes();
  }

  Future<void> _fetchUserRecipes() async {
    try {
      if (widget.publicUsername == widget.currentUsername) {
        // Fetch user profile if it's the logged-in user's profile

        recipes = await RecipeService().getUserRecipes();
      } else {
        // Fetch public user profile if it's a different user's profile
        recipes =
            await RecipeService().getUserPublicRecipes(widget.publicUsername);
      }

      setState(() {
        userRecipes = recipes;
      });
    } catch (e) {
      log('Error fetching user recipes: $e');
      // Handle error gracefully (e.g., show an error message)
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return SizedBox(
      height: Responsive.isDesktop(context)
          ? screenSize.width * 0.3
          : screenSize.width * 0.8,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
        ),
        child: ListView.separated(
          itemCount: userRecipes.length,
          itemBuilder: (context, index) {
            final userRecipe = userRecipes[index];
            final recipeImage =
                '${Constants.imageURL}/${userRecipe.recipeImage}';
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetailPage(recipe: userRecipe),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Card(
                  elevation: 2.0,
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.0),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(width: 10.0),
                        Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const SizedBox(height: 15.0),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5.0),
                                decoration: BoxDecoration(
                                  color: HexColor(userRecipe.categoryColor),
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Text(
                                  userRecipe.categoryName,
                                  style: TextStyle(
                                    fontSize: Responsive.isDesktop(context)
                                        ? Constants.desktopFontSize
                                        : Constants.mobileFontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 7.0),
                              Row(
                                children: [
                                  Text(
                                    userRecipe.recipeTitle,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: HexColor(userRecipe.categoryColor),
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.favorite_border_outlined,
                                      ),
                                      const SizedBox(width: 3.0),
                                      Text(
                                          userRecipe.likedBy.length.toString()),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        const Spacer(),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: screenSize.height,
                            width: screenSize.height / 2,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(recipeImage),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 20);
          },
        ),
      ),
    );
  }
}
