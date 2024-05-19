// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/screens/recipe_detail/recipe_detail_page.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/recipe_service.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_recipe_card.dart';

class FollowingRecipesPage extends StatefulWidget {
  const FollowingRecipesPage({super.key});

  @override
  _FollowingRecipesPageState createState() => _FollowingRecipesPageState();
}

class _FollowingRecipesPageState extends State<FollowingRecipesPage> {
  List<Recipe> _followingRecipes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFollowingRecipes();
  }

  Future<void> _fetchFollowingRecipes() async {
    final followingRecipes = await RecipeService.getFollowingUsersRecipes();

    if (mounted) {
      setState(() {
        _followingRecipes = followingRecipes;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = Responsive.isDesktop(context);
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        centerTitle: true,
        title: Text(AppLocalizations.of(context)
            .translate('Recipes by following users')),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: isDesktop ? 600 : double.infinity
          ),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: _followingRecipes.length,
                itemBuilder: (context, index) {
                  final recipe = _followingRecipes[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeDetailPage(
                            recipe: recipe,
                            internalUse: '',
                            missingIngredients: const [],
                          ),
                        ),
                      );
                    },
                    child: SizedBox(
                      height: 300,
                      width: 300,
                      child: CustomRecipeCard(
                        recipe: recipe,
                        internalUse: '',
                      ),
                    ),
                  );
                },
              ),
        ),
      ),
    );
  }
}
