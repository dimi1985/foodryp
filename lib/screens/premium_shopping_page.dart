// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodryp/models/recipe.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/recipe_service.dart';
import 'package:foodryp/widgets/CustomWidgets/custom_recipe_card.dart'; // Assuming you have this widget to display recipes

class PremiumShoppingPage extends StatefulWidget {
  const PremiumShoppingPage({super.key});

  @override
  _PremiumShoppingPageState createState() => _PremiumShoppingPageState();
}

class _PremiumShoppingPageState extends State<PremiumShoppingPage> {
  List<Recipe> _premiumRecipes = [];
  bool _isLoading = true;

  // @override
  // void initState() {
  //   super.initState();
  //   _fetchPremiumRecipes();
  // }

  // Future<void> _fetchPremiumRecipes() async {
  //   try {
  //     final recipes = await RecipeService().getPremiumRecipes();
  //    if(mounted){
  //      setState(() {
  //       _premiumRecipes = recipes;
  //       _isLoading = false;
  //     });
  //    }
  //   } catch (e) {
  //     // Handle error
  //     if(mounted){
  //       setState(() {
  //       _isLoading = false;
  //     });
  //     }
  //   }
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar:kIsWeb ? null: AppBar(

  //       title:  Text( AppLocalizations.of(context).translate('Premium Shopping Page')),
  //     ),
  //     body: _isLoading
  //         ? const Center(child: CircularProgressIndicator())
  //         : _premiumRecipes.isEmpty
  //             ?  Center(child: Text(AppLocalizations.of(context).translate('Premium Shopping Page')))
  //             : Center(
  //               child: SizedBox(
  //                 width: 600,
  //                 child: ListView.builder(
  //                     itemCount: _premiumRecipes.length,
  //                     itemBuilder: (context, index) {
  //                       final recipe = _premiumRecipes[index];
  //                       return Padding(
  //                         padding: const EdgeInsets.all(8.0),
  //                         child: SizedBox(
  //                           height: 300,
  //                           width: 300,
  //                           child: CustomRecipeCard(recipe: recipe, internalUse: 'Premium Shopping',)),
  //                       );
  //                     },

  //                   ),
  //               ),
  //             ),
  //   );
  // }

  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Text(AppLocalizations.of(context).translate('Coming Soon'))),
    );
  }
}
