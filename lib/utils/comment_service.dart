import 'dart:convert';
import 'package:foodryp/models/comment.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/profanity_error.dart';
import 'package:foodryp/utils/token_manager.dart';
import 'package:foodryp/utils/user_service.dart';
import 'package:http/http.dart' as http;

class CommentService {
Future<Comment?> createComment(String recipeId, String text, String username,
    String userImage, List<Comment>? replies) async {
  try {
    final token = await TokenManager.getTokenLocally();
    final headers = {'Authorization': 'Bearer $token'};

    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/api/createComment'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        ...headers, // Include authorization headers
      },
      body: jsonEncode({
        'text': text,
        'userId': await UserService().getCurrentUserId(),
        'recipeId': recipeId,
        'username': username,
        'useImage': userImage,
        'replies': replies ?? [], // Pass empty list if replies are null
      }),
    );

    if (response.statusCode == 201) {
      return Comment.fromJson(jsonDecode(response.body));
    } else {
      // Check if the error is due to inappropriate language
      final responseBody = jsonDecode(response.body);
      if (responseBody['errorCode'] == 'PROFANITY_ERROR') {
        throw ProfanityError(responseBody['message']);
      } else {
        throw Exception('Failed to create comment');
      }
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
    try {
      final token = await TokenManager.getTokenLocally();
      final headers = {'Authorization': 'Bearer $token'};

      final response = await http.put(
        Uri.parse('${Constants.baseUrl}/api/updateComment/$commentId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          ...headers, // Include authorization headers
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
    } catch (e) {
      throw Exception('Failed to update comment: $e');
    }
  }

Future<bool> deleteComment(
  String commentId, String? role, String recipeId) async {
  try {
    final Map<String, dynamic> requestBody = {
      'role': role ?? '',
      'recipeId': recipeId,
    };

    final response = await http.delete(
      Uri.parse('${Constants.baseUrl}/api/deleteComment/$commentId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 204) {
      return true; // Deletion successful
    } else {
      return false; // Deletion failed
    }
  } catch (e) {
    return false; // Exception occurred
  }
}

Future<Comment> getReportedComment(String commentId) async {
  try {
    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/api/getReportedComment/$commentId'),
    );

    if (response.statusCode == 200) {
      // If the request is successful, parse the response into a Comment object
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final Comment reportedComment = Comment.fromJson(responseData['reportedComment']);
      return reportedComment;
    } else {
      // If the request fails, throw an exception
      throw Exception('Failed to fetch reported comment');
    }
  } catch (e) {
    // Handle any errors that occur during the request
    throw Exception('Failed to fetch reported comment: $e');
  }
}

static Future<List<Comment>> getAllComments() async {
  try {
    final response = await http.get(Uri.parse('${Constants.baseUrl}/api/getAllComments'));

    if (response.statusCode == 200) {
      final dynamic decodedData = jsonDecode(response.body);

      if (decodedData.containsKey('comments')) {
        final List<dynamic> commentsData = decodedData['comments'];
        final List<Comment> comments = commentsData.map((commentJson) => Comment.fromJson(commentJson as Map<String, dynamic>)).toList();
        return comments;
      } else {
        throw Exception('Invalid JSON format: Expected a "comments" key containing a list of comments');
      }
    } else {
      throw Exception('Failed to fetch comments');
    }
  } catch (e) {
    throw Exception('Failed to fetch comments: $e');
  }
}

Future<Comment?> getCommentById(String commentId) async {
  try {
    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/api/getCommentById/$commentId'),
    );

    if (response.statusCode == 200) {
      final dynamic decodedData = jsonDecode(response.body);
      print('Server response: $decodedData');
      return Comment.fromJson(decodedData as Map<String, dynamic>);
    } else if (response.statusCode == 404) {
      // If comment with the specified ID is not found, return null
      return null;
    } else {
      throw Exception('Failed to fetch comment. Server response: ${response.body}');
    }
  } catch (e) {
    throw Exception('Failed to fetch comment: $e');
  }
}



}