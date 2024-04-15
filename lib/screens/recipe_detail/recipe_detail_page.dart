import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/screens/add_recipe/add_recipe_page.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/recipe_service.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class RecipeDetailPage extends StatefulWidget {
  final Recipe recipe;
  const RecipeDetailPage({super.key, required this.recipe});

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  late bool isLiked = false;
  late bool isForEdit = false;

  @override
  void initState() {
    super.initState();
    initLikeStatus();
  }

  void initLikeStatus() async {
    String getCurrentUserId = await UserService().getCurrentUserId();
    setState(() {
      isLiked = widget.recipe.likedBy.contains(getCurrentUserId);
      isForEdit = widget.recipe.userId.contains(getCurrentUserId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    bool isANDROID = Theme.of(context).platform == TargetPlatform.android;
    final recipeImage = '${Constants.imageURL}/${widget.recipe.recipeImage}';
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              // Recipe image with optional Neomorphism effect
              SizedBox(
                height: 250.0, // Adjust height as needed
                width: double.infinity, // Take full width
                child: Stack(
                  children: [
                    // Background image with Neomorphism effect
                    DecoratedBox(
                      decoration: BoxDecoration(
                        boxShadow: [
                          // Inner shadow
                          BoxShadow(
                            color: Colors.white.withOpacity(0.6),
                            blurRadius: 12.0,
                            spreadRadius: -5.0,
                          ),
                          // Outer shadow
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 15.0,
                            spreadRadius: 2.0,
                            offset: const Offset(4.0, 4.0),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Image.network(
                        recipeImage,
                        width: screenSize.width, // Take full width
                        height: 250.0, // Adjust height as needed
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Back button positioned on top-left
                    if (isANDROID)
                      Positioned(
                        top: 16.0, // Adjust padding from top
                        left: 16.0, // Adjust padding from left
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(
                              context), // Handle back button press
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),

              // Recipe title and description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.recipe.recipeTitle,
                      style: GoogleFonts.getFont(
                        widget.recipe.categoryFont,
                        fontSize: Responsive.isDesktop(context)
                            ? Constants.desktopHeadingTitleSize
                            : Constants.mobileHeadingTitleSize,
                        fontWeight: FontWeight.bold,
                        color: HexColor(widget.recipe.categoryColor)
                            .withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      widget.recipe.description,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              // Ingredients section
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ingredients',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10.0),
                          ListView.builder(
                            shrinkWrap:
                                true, // Prevent list view from taking unnecessary space
                            itemCount: widget.recipe.ingredients.length,
                            itemBuilder: (context, index) =>
                                Text(widget.recipe.ingredients[index]),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Row(
                        children: [
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              // Call the likeRecipe method when the favorite icon is pressed
                              if (isLiked) {
                                // If already liked, call dislikeRecipe to unlike
                                RecipeService()
                                    .dislikeRecipe(widget.recipe.id ?? '')
                                    .then((_) => setState(() {
                                          // Update the UI state after the recipe is disliked
                                          isLiked = false;
                                        }))
                                    .catchError((error) {
                                  // Handle any errors that occur during the disliking process
                                  print('Error disliking recipe: $error');
                                });
                              } else {
                                // If not liked, call likeRecipe to like
                                RecipeService()
                                    .likeRecipe(widget.recipe.id ?? '')
                                    .then((_) => setState(() {
                                          // Update the UI state after the recipe is liked
                                          isLiked = true;
                                        }))
                                    .catchError((error) {
                                  // Handle any errors that occur during the liking process
                                  print('Error liking recipe: $error');
                                });
                              }
                            },
                            // Use conditional rendering to change the icon based on whether the recipe is liked
                            icon: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: isLiked ? Colors.red : null,
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.save),
                          ),
                          if (isForEdit)
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddRecipePage(
                                        recipe: widget.recipe,
                                        isForEdit: isForEdit),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.edit),
                            )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              // Steps section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context).translate('Steps'),
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10.0),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.recipe.instructions.length,
                      itemBuilder: (context, index) => Text(
                          '${AppLocalizations.of(context).translate('Step')}'
                          '${index + 1}: ${widget.recipe.instructions[index]}'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              // Comments section (optional)
              // ... (Implement comments section)
            ],
          ),
        ),
      ),
    );
  }
}
