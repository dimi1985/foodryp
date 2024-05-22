class Recipe {
  final String? id;
  final String? recipeTitle;
  final String? recipeImage;
  final List<String>? ingredients;
  final List<String>? instructions;
  final String? prepDuration;
  final String? cookDuration;
  final String? servingNumber;
  String? difficulty;
  final String? username;
  final String? useImage;
  final String? userId;
  final DateTime? dateCreated;
  final String? description;
  final String? categoryId;
  final String? categoryColor;
  final String? categoryFont;
  final String categoryName;
  final List<String>? recomendedBy;
  final List<String>? meal;
  final List<String>? commentId;
  bool isForDiet;
  bool isForVegetarians;
  double rating; 
  int ratingCount;
    final List<String>? cookingAdvices;
    bool checked;

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
    required this.dateCreated,
    required this.description,
    required this.categoryId,
    required this.categoryColor,
    required this.categoryFont,
    required this.categoryName,
    required this.recomendedBy,
    required this.meal,
    required this.commentId,
    required this.isForDiet,
    required this.isForVegetarians,
    required this.rating, 
    required this.ratingCount,
     required this.cookingAdvices,
     this.checked = false,
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
      dateCreated: json['dateCreated'] != null
          ? DateTime.parse(json['dateCreated'])
          : DateTime.now(),
      description: json['description'] ?? '',
      categoryId: json['categoryId']?.toString() ?? '',
      categoryColor: json['categoryColor'] ?? '',
      categoryFont: json['categoryFont'] ?? '',
      categoryName: json['categoryName'] ?? '',
      recomendedBy:
          (json['recomendedBy'] as List<dynamic>?)?.cast<String>().toList() ?? [],
      meal: (json['meal'] as List<dynamic>?)?.cast<String>().toList() ?? [],
      commentId:
          (json['commentId'] as List<dynamic>?)?.cast<String>().toList() ?? [],
      isForDiet: json['isForDiet'] ?? false,
      isForVegetarians: json['isForVegetarians'] ?? false,
      rating: json['rating']?.toDouble() ?? 0.0,
      ratingCount: json['ratingCount']?.toInt() ?? 0,
      cookingAdvices:
          (json['cookingAdvices'] as List<dynamic>?)?.cast<String>().toList() ??
              [],
    );
  }

  Map<String, Object?> toJson() {
    var map = {
      '_id': id,
      'recipeTitle': recipeTitle,
      'recipeImage': recipeImage,
      'ingredients': ingredients,
      'instructions': instructions,
      'prepDuration': prepDuration,
      'cookDuration': cookDuration,
      'servingNumber': servingNumber,
      'difficulty': difficulty,
      'username': username,
      'useImage': useImage,
      'userId': userId,
      'dateCreated': dateCreated?.toIso8601String(),
      'description': description,
      'categoryId': categoryId,
      'categoryColor': categoryColor,
      'categoryFont': categoryFont,
      'categoryName': categoryName,
      'recomendedBy': recomendedBy,
      'meal': meal,
      'commentId': commentId,
      'isForDiet': isForDiet,
      'isForVegetarians': isForVegetarians,
      'rating': rating,
      'ratingCount': ratingCount,
      'cookingAdvices': cookingAdvices,
    };
    return map;
  }
}
