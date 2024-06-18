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
  String? calories;
  bool isPremium;
  double price;
  final List<String>? buyers; // Add the new field here

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
    required this.calories,
    required this.isPremium,
    required this.price,
    required this.buyers, // Initialize it in the constructor
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['_id'] as String? ?? '',
      recipeTitle: json['recipeTitle'] as String? ?? '',
      recipeImage: json['recipeImage'] as String? ?? '',
      ingredients: (json['ingredients'] as List<dynamic>?)?.map((item) => item as String).toList() ?? [],
      instructions: (json['instructions'] as List<dynamic>?)?.map((item) => item as String).toList() ?? [],
      prepDuration: json['prepDuration'] as String? ?? '',
      cookDuration: json['cookDuration'] as String? ?? '',
      servingNumber: json['servingNumber'] as String? ?? '',
      difficulty: json['difficulty'] as String? ?? '',
      username: json['username'] as String? ?? '',
      useImage: json['useImage'] as String? ?? '',
      userId: json['userId']?.toString() ?? '',
      dateCreated: json['dateCreated'] != null ? DateTime.parse(json['dateCreated'] as String) : DateTime.now(),
      description: json['description'] as String? ?? '',
      categoryId: json['categoryId']?.toString() ?? '',
      categoryColor: json['categoryColor'] as String? ?? '',
      categoryFont: json['categoryFont'] as String? ?? '',
      categoryName: json['categoryName'] as String? ?? 'Unknown', // Ensure this is never null
      recomendedBy: (json['recomendedBy'] as List<dynamic>?)?.map((item) => item as String).toList() ?? [],
      meal: (json['meal'] as List<dynamic>?)?.map((item) => item as String).toList() ?? [],
      commentId: (json['commentId'] as List<dynamic>?)?.map((item) => item as String).toList() ?? [],
      isForDiet: json['isForDiet'] as bool? ?? false,
      isForVegetarians: json['isForVegetarians'] as bool? ?? false,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      ratingCount: (json['ratingCount'] as int?) ?? 0,
      cookingAdvices: (json['cookingAdvices'] as List<dynamic>?)?.map((item) => item as String).toList() ?? [],
      calories: json['calories'] as String? ?? '',
      isPremium: json['isPremium'] as bool? ?? false,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      buyers: (json['buyers'] as List<dynamic>?)?.map((item) => item as String).toList() ?? [], // Parse the new buyers field from JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
      'calories': calories,
      'isPremium': isPremium,
      'price': price,
      'buyers': buyers, // Add the new buyers field to the JSON
    };
  }
}
