import 'package:high_protein_chef/entities/recipe_entity.dart';

class Recipe {
  final int? id;
  final String title;
  final String imageUrl;
  final List<String> ingredients;
  final String instructions;
  final NutritionInfo? nutrition;

  Recipe({
    this.id,
    required this.title,
    required this.imageUrl,
    required this.ingredients,
    required this.instructions,
    this.nutrition
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'], 
      title: json['title'], 
      imageUrl: json['image'], 
      ingredients: [],//Handled later 
      instructions: '',//Handled later 
      nutrition: json['nutrition'] == null ? null : NutritionInfo.fromJson(json['nutrition']),
    );
  }

  // DB
  RecipeEntity toEntity() {
    return RecipeEntity(
      id: id, 
      title: title, 
      imageUrl: imageUrl, 
      ingredients: ingredients.join(','), 
      instructions: instructions, 
      calories: nutrition?.calories, 
      protein: nutrition?.protein, 
      fat: nutrition?.fat
    );
  }

  factory Recipe.fromDBEntity(RecipeEntity entity) {
    return Recipe(
      id: entity.id, 
      title: entity.title, 
      imageUrl: entity.imageUrl, 
      ingredients: entity.ingredients.split(','), 
      instructions: entity.instructions,
      nutrition: (entity.calories != null && entity.protein != null && entity.fat != null) ?  
      NutritionInfo(
        calories: entity.calories!, 
        protein: entity.protein!, 
        fat: entity.fat!
        )
      :
      null 
      );
  }
}

class NutritionInfo {
  final double calories;
  final double protein;
  final double fat;

  NutritionInfo({
    required this.calories,
    required this.protein,
    required this.fat,
  });

  factory NutritionInfo.fromJson(Map<String, dynamic> json) {
    return NutritionInfo(
      calories: json['calories'],
      protein: json['protein'],
      fat: json['fat'],
    );
  }
}