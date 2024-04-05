import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:foodryp/data/demo_data.dart';
import 'package:foodryp/screens/recipe_detail_page.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_recipe_card.dart';

class RecipeSection extends StatefulWidget {
  const RecipeSection({super.key});

  @override
  State<RecipeSection> createState() => _RecipeSectionState();
}

class _RecipeSectionState extends State<RecipeSection> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Constants.defaultPadding),
        child: SizedBox(
          height: 250,
          width: screenSize.width,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              },
            ),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: DemoData.regularRecipes.length,
              itemBuilder: (context, index) {
                final regularRecipe = DemoData.regularRecipes[index];
                return SizedBox(
                  width: 250,
                  child: CustomRecipeCard(
                    title: regularRecipe['title'],
                    imageUrl: regularRecipe['image'],
                    color: regularRecipe['color'],
                    itemList: regularRecipe.length.toString(),
                    internalUse: 'recipes',
                    onTap: () {
                      // Handle card tap here (optional)
                      Navigator.push(
                        context, // Current context
                        MaterialPageRoute(
                            builder: (context) =>
                                RecipeDetailPage(regularRecipe: regularRecipe)),
                      );
                    },
                    username: regularRecipe['username'],
                    userImageURL: 'https://picsum.photos/200/300',
                     description: regularRecipe['description'],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  width: 10,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
