class CategoryModel {
  final String name;
  final String font;
  final String color;
  final String? categoryImage; // nullable for optional image
  final List<String>? recipes; // List of recipe IDs (String type)

  CategoryModel({
    required this.name,
    required this.font,
    required this.color,
    this.categoryImage,
    this.recipes,
  });

 factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
      name: json['name'],
      font: json['font'],
      color: json['color'],
      categoryImage: json['categoryImage'],
      recipes: json['recipes']?.cast<String>(), // Check for null and cast
    );

Map<String, dynamic> toJson() => {
      'name': name,
      'font': font,
      'color': color,
      'categoryImage': categoryImage,
      'recipes': recipes, // No changes needed here (already List<String>)
    };

}