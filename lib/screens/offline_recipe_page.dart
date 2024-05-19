import 'package:flutter/material.dart';
import 'package:foodryp/database/database_helper.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/screens/recipe_detail/recipe_detail_page.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_recipe_card.dart';

class OfflineRecipePage extends StatefulWidget {
  const OfflineRecipePage({super.key});

  @override
  State<OfflineRecipePage> createState() => _OfflineRecipePageState();
}

class _OfflineRecipePageState extends State<OfflineRecipePage> {
  List<Recipe> recipes = [];

  @override
  void initState() {
    super.initState();
    fetchRecipesFromDatabase();
  }

  void fetchRecipesFromDatabase() async {
    var db = getDatabase();
    await db.init();

    List<Recipe> fetchedRecipes = await db.queryAllRecipes();
    setState(() {
      recipes = fetchedRecipes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Recipes'),
      ),
      body: SafeArea(
        child: recipes.isEmpty
            ? const Center(child: Text('No recipes available offline'))
            : ListView.builder(
                shrinkWrap: true,
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  final recipe = recipes[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RecipeDetailPage(
                                  recipe: recipe,
                                  internalUse: '',
                                  missingIngredients: [],
                                )),
                      );
                    },
                    child: SizedBox(
                      height: 300,
                      width: 300,
                      child: CustomRecipeCard(
                          internalUse: Constants.emptyField, recipe: recipe),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
