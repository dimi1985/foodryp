import 'dart:convert';
import 'package:foodryp/models/comment.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:http/http.dart' as http;

class CommentService {
  Future<Comment> createComment(String recipeId, String text, String username,
      String userImage, List<Comment>? replies) async {
    try {
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/api/createComment'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'text': text,
          'userId': await UserService().getCurrentUserId(),
          'recipeId': recipeId,
          'username': username,
          'useImage': userImage,
          'replies': []
        }),
      );

      if (response.statusCode == 201) {
        return Comment.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to create comment');
      }
    } catch (e) {
      throw Exception('Failed to create comment: $e');
    }
  }

  Future<List<Comment>> getCommsentsByRecipeId(String recipeId) async {
    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/api/getComments/$recipeId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> decodedData = jsonDecode(response.body);
      final List<Comment> comments = decodedData
          .map((commentJson) => Comment.fromJson(commentJson))
          .toList();

      return comments;
    } else {
      throw Exception('Failed to load comments');
    }
  }

  Future<Comment> updateComment(String commentId, String newText) async {
    final response = await http.put(
      Uri.parse('${Constants.baseUrl}/api/updateComment/$commentId'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'text': newText,
      }),
    );

    if (response.statusCode == 200) {
      return Comment.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update comment');
    }
  }

  Future<void> deleteComment(String commentId) async {
    final response = await http.delete(
      Uri.parse('${Constants.baseUrl}/api/deleteComment/$commentId'),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete comment');
    }
  }
}
