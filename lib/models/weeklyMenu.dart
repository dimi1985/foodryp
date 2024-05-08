// ignore_for_file: file_names
import 'package:foodryp/models/recipe.dart';

class WeeklyMenu {
  final String id;
  final String title;
  final List<Recipe> dayOfWeek;
  final String userId;
  final String username;
  final String userProfileImage;
    final DateTime dateCreated;


  WeeklyMenu({
    required this.id,
    required this.title,
    required this.dayOfWeek,
    required this.userId,
    required this.username,
    required this.userProfileImage,
     required this.dateCreated,
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
       dateCreated:
          json['dateCreated'] != null ? DateTime.parse(json['dateCreated']) : DateTime.now(),
    );
  }

  Map<String, Object?> toJson() {
  return {
    '_id': id,
    'title': title,
    'dayOfWeek': dayOfWeek.map((recipe) => recipe.toJson()).toList(),
    'userId': userId,
    'username': username,
    'userProfileImage': userProfileImage,
    'dateCreated': dateCreated.toIso8601String(),
  };
}

}
