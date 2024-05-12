import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/recipe_service.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/screens/recipe_detail/recipe_detail_page.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_recipe_card.dart';

class RecipeSection extends StatefulWidget {
  final isFor;
  const RecipeSection({Key? key, required this.isFor}) : super(key: key);

  @override
  State<RecipeSection> createState() => _RecipeSectionState();
}

class _RecipeSectionState extends State<RecipeSection> {
  List<Recipe> recipes = [];

  @override
  void initState() {
    super.initState();
    fetchixedRecipes();
  }

  Future<void> fetchixedRecipes() async {
    const int desiredLength = 4;
    final fetchedRecipes = await RecipeService().getFixedRecipes(desiredLength);
    setState(() {
      recipes = fetchedRecipes;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Constants.defaultPadding),
        child: SizedBox(
          height: 260,
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
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return Padding(
                  padding: const EdgeInsets.all(Constants.defaultPadding),
                  child: SizedBox(
                    width: 250,
                    child: InkWell(
                      onTap: () async{
                       await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetailPage(
                              recipe: recipe,
                              internalUse: '',
                              missingIngredients: const [],
                            ),
                          ),
                        ).then((_) {
                          fetchixedRecipes();
                          setState(() {});
                        });
                      },
                      child: CustomRecipeCard(
                        recipe: recipe,
                        internalUse: widget.isFor,
                      ),
                    ),
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
