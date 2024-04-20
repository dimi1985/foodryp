import 'package:foodryp/models/recipe.dart';

class WeeklyMenu {
  final String id;
  final String title;
  final List<Recipe> dayOfWeek;
  final String userId;
  final String username;
  final String userProfileImage;

  WeeklyMenu({
    required this.id,
    required this.title,
    required this.dayOfWeek,
    required this.userId,
    required this.username,
    required this.userProfileImage,
  });

factory WeeklyMenu.fromJson(Map<String, dynamic> json) {
  return WeeklyMenu(
    id: json['_id'],
    title: json['title'],
    dayOfWeek: json['dayOfWeek'] != null
        ? (json['dayOfWeek'] as List<dynamic>)
            .map((x) => Recipe.fromJson(x))
            .toList()
        : [], // Handle the case when dayOfWeek is null
    userId: json['userId'],
    username: json['username'],
    userProfileImage: json['userProfileImage'],
  );
}



}
