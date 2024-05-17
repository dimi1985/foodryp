class CategoryModel {
  final String? id;
  final String name;
  final String font;
  final String color;
  final String? categoryImage;
  final List<String>? recipes;
  final bool isForDiet;
  final bool isForVegetarians;

  CategoryModel({
    this.id,
    required this.name,
    required this.font,
    required this.color,
    this.categoryImage,
    this.recipes,
    required this.isForDiet,
    required this.isForVegetarians,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'],
      name: json['name'] ?? '',
      font: json['font'] ?? '',
      color: json['color'] ?? '',
      categoryImage: json['categoryImage'],
      recipes: (json['recipes'] != null && json['recipes'] != '')
          ? List<String>.from(json['recipes'])
          : null,
      isForDiet: json['isForDiet'] ?? false,
      isForVegetarians: json['isForVegetarians'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'font': font,
        'color': color,
        'categoryImage': categoryImage,
        'recipes': recipes,
        'isForDiet': isForDiet,
        'isForVegetarians': isForVegetarians,
      };
}
