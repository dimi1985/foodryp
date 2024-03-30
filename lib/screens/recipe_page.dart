import 'package:flutter/material.dart';

class RecipePage extends StatelessWidget {
  // Replace with your actual recipe data model
  final Map<String, dynamic> recipeData;

  const RecipePage({Key? key, required this.recipeData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipeData['title']),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {}, // Handle sign-in logic
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeroImage(imageUrl: recipeData['image']),
            RecipeInfo(recipeData: recipeData),
            RecipeIngredients(ingredients: recipeData['ingredients']),
            // Add a widget for preparation steps here
          ],
        ),
      ),
    );
  }
}

class HeroImage extends StatelessWidget {
  final String imageUrl;

  const HeroImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: double.infinity,
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}

class RecipeInfo extends StatelessWidget {
  final Map<String, dynamic> recipeData;

  const RecipeInfo({super.key, required this.recipeData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${recipeData['duration']} mins'),
          Text('difficulty :${recipeData['difficulty']}'),
          Text('${recipeData['username']} '),
          Text('${recipeData['date']}'.toString()),
        ],
      ),
    );
  }
}

class RecipeIngredients extends StatelessWidget {
  final List<String> ingredients;

  const RecipeIngredients({Key? key, required this.ingredients})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: ingredients.length,
      itemBuilder: (context, index) {
        final ingredient = ingredients[index];
        return ListTile(
          title: Text(ingredient),
        );
      },
    );
  }
}
