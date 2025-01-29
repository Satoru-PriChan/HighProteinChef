import 'package:flutter/material.dart';
import 'package:high_protein_chef/models/recipe.dart';
import 'package:high_protein_chef/providers/recipe_provider.dart';
import 'package:provider/provider.dart';
import 'package:high_protein_chef/services/logger.dart';

class RecipeDetailScreen extends StatelessWidget {

  const RecipeDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {  
    final recipeProvider = Provider.of<RecipeProvider>(context);
    final recipe = ModalRoute.of(context)!.settings.arguments as Recipe;

    return Scaffold(
      appBar: AppBar(title: Text(recipe.title)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(recipe.imageUrl, height: 400, fit: BoxFit.fitWidth),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(recipe.title, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: 
              recipeProvider.favorites.firstWhere((element){
                return element.title == recipe.title;
              }, orElse: () {
                return Recipe(title: "<DUMMY>", imageUrl: "", ingredients: [], instructions: "");
              }).title != "<DUMMY>"
              ? 
                IconButton(
                  onPressed: () {
                    if (recipe.id != null) {
                      recipeProvider.removeFromFavorites(recipe.id!);
                    } else {
                      logger.e("This recipe has no id: ${recipe.title}");
                    }
                  },   
                  icon: Icon(Icons.favorite)
                )
              :
                IconButton(
                  onPressed: () {
                    recipeProvider.addFavorites(recipe);
                  },   
                  icon: Icon(Icons.favorite_border)
                )
            ),
        ],
      ),
    );
  }
}