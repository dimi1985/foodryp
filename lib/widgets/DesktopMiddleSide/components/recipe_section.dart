import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/screens/recipe_detail/recipe_detail_page.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_recipe_card.dart';

class RecipeSection extends StatefulWidget {
  const RecipeSection({Key? key}) : super(key: key);

  @override
  State<RecipeSection> createState() => _RecipeSectionState();
}

class _RecipeSectionState extends State<RecipeSection> {
  List<Recipe> recipes = [];

  @override
  void initState() {
    super.initState();
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    try {
      final response = await http.get(Uri.parse('${Constants.baseUrl}/api/recipes'));
      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body) as List<dynamic>;
        final List<Recipe> fetchedRecipes =
            decodedData.map((recipeJson) => Recipe.fromJson(recipeJson)).toList();
        setState(() {
          recipes = fetchedRecipes;
        });
      } else {
        throw Exception('Failed to load recipes');
      }
    } catch (e) {
      print('Error fetching recipes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Constants.defaultPadding),
        child: SizedBox(
          height: 250,
          width: screenSize.width,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return SizedBox(
                width: 250,
                child: CustomRecipeCard(
                  title: recipe.recipeTitle,
                  imageUrl: recipe.recipeImage,
                  color: HexColor(recipe.categoryColor),
                  itemList: recipe.ingredients.length.toString(),
                  internalUse: 'recipes',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeDetailPage(recipe: recipe),
                      ),
                    );
                  },
                  username: recipe.username,
                  userImageURL: recipe.useImage ?? '',
                  description: recipe.description,
                  categoryColor: recipe.categoryColor,
                  categoryFont: recipe.categoryFont,
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
    );
  }
}
