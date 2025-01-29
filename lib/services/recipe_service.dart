import 'dart:convert';
import 'package:high_protein_chef/extensions/response_extension.dart';
import 'package:high_protein_chef/models/recipe.dart';
import 'package:high_protein_chef/services/logger.dart';
import 'package:http/http.dart' as http;

class RecipeService {
  static const String _apiKey = String.fromEnvironment('apiKey');

  static Future<List<Recipe>> searchRecipes(String query) async {
    final response = await http.get(Uri.parse('https://api.spoonacular.com/recipes/complexSearch?query=$query&apiKey=$_apiKey'));

    logger.d("response: ${response.debugDescription}");

    if (response.statusCode == 200) {
      // Success
      final data = json.decode(response.body);
      final List<Recipe> recipes = (data['results'] as List).map((json) => Recipe.fromJson(json)).toList();
      return recipes;
    } else {
      // Failure
      throw Exception('Failed to load recipes. status code: ${response.statusCode}');
    }
  }
}