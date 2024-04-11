class Recipe {
   final String? id;
  final String recipeTitle;
  final String recipeImage;
  final List<String> ingredients;
  final List<String> instructions;
  final String prepDuration;
  final String cookDuration;
  final String servingNumber;
  final String difficulty;
  final String username;
  final String? useImage;
  final String userId;
  final DateTime date;
  final String description;
  final String categoryId;
   final String categoryColor;

  Recipe({
      this.id,
    required this.recipeTitle,
    required this.recipeImage,
    required this.ingredients,
    required this.instructions,
    required this.prepDuration,
    required this.cookDuration,
    required this.servingNumber,
    required this.difficulty,
    required this.username,
    required this.useImage,
    required this.userId,
    required this.date,
    required this.description,
    required this.categoryId,
     required this.categoryColor,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
      id: json['_id'],
        recipeTitle: json['recipeTitle'],
        recipeImage: json['recipeImage'],
        ingredients: (json['ingredients'] as List)?.cast<String>() ?? [],
        instructions: (json['instructions'] as List)?.cast<String>() ?? [],
        prepDuration: json['prepDuration'],
        cookDuration: json['cookDuration'],
        servingNumber: json['servingNumber'],
        difficulty: json['difficulty'],
        username: json['username'],
        useImage: json['useImage'],
        userId: json['userId'],
        date: DateTime.parse(json['date']),
        description: json['description'],
        categoryId: json['categoryId'],
         categoryColor: json['categoryColor'],
      );
}
