class CategoryModel {
    final String? id;
  final String? name;
  final String? font;
  final String? color;
  // final String? categoryImage; 
  final List<String>? recipes; 

  CategoryModel({
    this.id,
    required this.name,
    required this.font,
    required this.color,
    // this.categoryImage,
    this.recipes,
  });

 factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
  id: json['_id'],
      name: json['name'],
      font: json['font'],
      color: json['color'],
      // categoryImage: json['categoryImage'],
      recipes: json['recipes']?.cast<String>(), // Check for null and cast
    );

Map<String, dynamic> toJson() => {
    '_id': id,
      'name': name,
      'font': font,
      'color': color,
      // 'categoryImage': categoryImage,
      'recipes': recipes, 
    };

}