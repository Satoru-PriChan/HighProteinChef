import 'package:flutter/material.dart';
import 'package:high_protein_chef/models/recipe.dart';

class RecipeEntity {
  final int? id;
  final String title;
  final String imageUrl;
  final String ingredients;
  final String instructions;
  final double? calories;
  final double? protein;
  final double? fat;

  RecipeEntity({
    this.id,
    required this.title,
    required this.imageUrl,
    required this.ingredients,
    required this.instructions,
    this.calories,
    this.protein,
    this.fat,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'title': title,
      'imageUrl': imageUrl,
      'ingredients': ingredients,
      'instructions': instructions,
    };
    if (id != null) map['id'] = id;
    if (calories != null) map['calories'] = calories;
    if (protein != null) map['protein'] = protein;
    if (fat != null) map['fat'] = fat; 
    return map;
  }

  factory RecipeEntity.fromMap(Map<String, dynamic> map) {
    return RecipeEntity(
      id: map['id'], 
      title: map['title'], 
      imageUrl: map['imageUrl'], 
      ingredients: map['ingredients'], 
      instructions: map['instructions'], 
      calories: map['calories'], 
      protein: map['protein'], 
      fat: map['fat'],
    );
  }
}