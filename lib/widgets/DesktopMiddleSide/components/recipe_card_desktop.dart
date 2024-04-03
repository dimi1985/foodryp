import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:foodryp/data/demo_data.dart';
import 'package:foodryp/screens/recipe_detail_page.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_category_topthree_mobile_card.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_card_desktop.dart';
import 'package:foodryp/widgets/DesktopMiddleSide/components/top_three_recipe_card.dart';

class RecipeCardDesktop extends StatefulWidget {
  const RecipeCardDesktop({super.key});

  @override
  State<RecipeCardDesktop> createState() => _RecipeCardDesktopState();
}

class _RecipeCardDesktopState extends State<RecipeCardDesktop> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return ListView(
      children: [
        const SizedBox(
          height: 500,
          child: TopThreeRecipeCard()),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(Constants.defaultPadding),
            child: SizedBox(
              height: screenSize.height / 2,
              width: screenSize.height * .9,
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
                  scrollDirection: Axis.vertical,
                  itemCount: DemoData.regularRecipes.length,
                  itemBuilder: (context, index) {
                    final regularRecipe = DemoData.regularRecipes[index];
                    return CustomCardDesktop(
                      title: regularRecipe['title'],
                      imageUrl: regularRecipe['image'],
                      color: regularRecipe['color'],
                      itemList: regularRecipe.length.toString(),
                      internalUse: 'recipes-desktop',
                      onTap: () {
                         Navigator.push(
                        context, // Current context
                        MaterialPageRoute(
                            builder: (context) =>
                                RecipeDetailPage(regularRecipe: regularRecipe)),
                      );
                      },
                      username: regularRecipe['username'],
                      userImageURL: 'https://picsum.photos/200/300', description:  regularRecipe['description'],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 100,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
