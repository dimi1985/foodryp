// services/wiki_food_service.dart

import 'dart:developer';

import 'package:foodryp/utils/contants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/wikifood.dart'; // Make sure to replace this with the correct path to your model

class WikiFoodService {
  Future<List<Wikifood>> getWikiFoodsByPage(int page, int pageSize) async {
    final response = await http.get(Uri.parse(
        '${Constants.baseUrl}/api/getWikiFoodsByPage?page=$page&pageSize=$pageSize'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body)[
          'wikifoods']; // Access the 'wikifoods' key in the response
      return jsonResponse.map((data) => Wikifood.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load wikifoods');
    }
  }

  Future<Wikifood> createWikiFood(
      String title, String text, String source) async {
    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/api/createWikiFood'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'text': text,
        'source': source,
      }),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 201) {
      return Wikifood.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create wikifood');
    }
  }

  Future<Wikifood> updateWikiFood(
      String id, String name, String text, String source) async {
    final response = await http.put(
      Uri.parse('${Constants.baseUrl}/api/updateWikiFood/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'text': text,
        'source': source,
      }),
    );

    if (response.statusCode == 200) {
      return Wikifood.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update wikifood');
    }
  }

  Future<void> deleteWikiFood(String id) async {
    final response = await http.delete(
      Uri.parse('${Constants.baseUrl}/api/deleteWikiFood/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete wikifood');
    }
  }

Future<Wikifood?> searchWikiFoodByTitle(String ingredient) async {

    final queryParameter = Uri.encodeComponent(ingredient);
    final response = await http.get(Uri.parse('${Constants.baseUrl}/api/searchWikiFoodByTitle?query=$queryParameter'));

    if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print('Response from server: $jsonResponse'); // Print the response from the server

        if (jsonResponse.containsKey('wikifood') && jsonResponse['wikifood'] != null) {
            return Wikifood.fromJson(jsonResponse['wikifood']);
        } else {
            // No wikifood found for this ingredient
            return null;
        }
    } else {
        // Failed to load wiki info
        throw Exception('Failed to load wiki info');
    }
}

}
