import 'package:flutter/material.dart';
import 'package:high_protein_chef/models/recipe.dart';
import 'package:high_protein_chef/services/database_helper.dart';
import 'package:high_protein_chef/services/logger.dart';
import 'package:high_protein_chef/services/recipe_service.dart';

class RecipeProvider extends ChangeNotifier {
  List<Recipe> _recipes = [];
  List<Recipe> _favorites = [];
  bool _isLoading = false;
  String? _error;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  List<Recipe> get recipes => _recipes;
  List<Recipe> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> searchRecipes(String query) async {
    _isLoading = true;
    notifyListeners();

    try {
      _recipes = await RecipeService.searchRecipes(query);
      _error = null;
    } catch(e) {
      _error = "Failed to load recipes. Error Code: ${e.toString()}"; 
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Favorites
  Future<void> loadFavorites() async {
    _isLoading = true;
     notifyListeners();

    try {
      final entities = await _dbHelper.getFavorites();
      _favorites = entities.map((entity) => Recipe.fromDBEntity(entity)).toList();
      _error = null;
    } catch(e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Call the function on the screeen's appearance to refresh data 
  Future<void> onScreenInitialize() async {
    logger.d("called.");
    try {
      final entities = await _dbHelper.getFavorites();
      _favorites = entities.map((entity) => Recipe.fromDBEntity(entity)).toList();
      _error = null;
    } catch(e) {
      _error = e.toString();
    }
  }

  void addFavorites(Recipe recipe) async {
    _isLoading = true;
     notifyListeners();

    try {
      await _dbHelper.insertRecipe(recipe.toEntity());
      _favorites.add(recipe);
      _error = null;
    } catch(e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void removeFromFavorites(int recipeId) async {
    _isLoading = true;
     notifyListeners();

    try {
      await _dbHelper.deleteRecipe(recipeId);
      _favorites.removeWhere( (recipe) => recipe.id == recipeId);
      _error = null;
    } catch(e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}