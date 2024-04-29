class Recipe {
  final String? id;
  final String recipeTitle;
  final String recipeImage;
  final List<String> ingredients;
  final List<String> instructions;
  final String prepDuration;
  final String cookDuration;
  final String servingNumber;
  String difficulty;
  final String username;
  final String? useImage;
  final String userId;
  final DateTime date;
  final String description;
  final String categoryId;
  final String categoryColor;
  final String categoryFont;
  final String categoryName;
  final List<String> likedBy;
  final List<String> meal;

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
    required this.categoryFont,
    required this.categoryName,
    required this.likedBy,
    required this.meal,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['_id']?.toString() ?? '',
      recipeTitle: json['recipeTitle'] ?? '',
      recipeImage: json['recipeImage'] ?? '',
      ingredients:
          (json['ingredients'] as List<dynamic>?)?.cast<String>().toList() ??
              [],
      instructions:
          (json['instructions'] as List<dynamic>?)?.cast<String>().toList() ??
              [],
      prepDuration: json['prepDuration'] ?? '',
      cookDuration: json['cookDuration'] ?? '',
      servingNumber: json['servingNumber'] ?? '',
      difficulty: json['difficulty'] ?? '',
      username: json['username'] ?? '',
      useImage: json['useImage'] ?? '',
      userId: json['userId']?.toString() ?? '',
      date:
          json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      description: json['description'] ?? '',
      categoryId: json['categoryId']?.toString() ?? '',
      categoryColor: json['categoryColor'] ?? '',
      categoryFont: json['categoryFont'] ?? '',
      categoryName: json['categoryName'] ?? '',
      likedBy:
          (json['likedBy'] as List<dynamic>?)?.cast<String>().toList() ?? [],
      meal: (json['meal'] as List<dynamic>?)?.cast<String>().toList() ?? [],
    );
  }
}
