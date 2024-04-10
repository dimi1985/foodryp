import 'package:foodryp/models/ingredient';

class Recipe {
  final String recipeTitle;
   final String  recipeImage;
   final List<String> ingredients; // List of strings representing ingredients
  final int duration; // Duration in minutes (optional)
  final String difficulty; // "Easy", "Medium", "Hard"
  final String username; // Username of the author (optional)
  final String? useImage; // URL for recipe image (optional)
  final String userId; // Unique ID of the recipe author
  final DateTime date;
  final String description;

  Recipe({
    required this.recipeTitle,
    required this.recipeImage,
    required this.ingredients,
    required this.duration,
    required this.difficulty,
    required this.username,
    this.useImage,
    required this.userId,
    required this.date,
    required this.description,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        recipeTitle: json['recipeTitle'],
        recipeImage: json['recipeImage'],
         ingredients: (json['ingredients'] as List)?.cast<String>() ?? [], // Handle null or non-string lists
        duration: json['duration'], // Handle optional duration
        difficulty: json['difficulty'],
        username: json['username'], // Handle optional username
        useImage: json['useImage'],
        userId: json['userId'],
        date: DateTime.parse(json['date']),
        description: json['description'],
      );
}
