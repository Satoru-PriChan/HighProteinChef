import 'package:flutter/material.dart';
import 'package:high_protein_chef/screens/recipe_detail_screen.dart';
import 'package:high_protein_chef/services/logger.dart';
import 'package:provider/provider.dart';
import 'package:high_protein_chef/providers/recipe_provider.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {

  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Favorites")),
      body: FutureBuilder(
        future: recipeProvider.onScreenInitialize(), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(),);
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: Failed to load favorites.'));
          } else {
            return content(recipeProvider);
          }
        }
      )
    );
  }

  Widget content(RecipeProvider recipeProvider) {

    if (recipeProvider.isLoading) {
      return Center(child: CircularProgressIndicator(),);
    } else if (recipeProvider.error != null) {
      return Center(child: Text("Error: ${recipeProvider.error!}"));
    }

    return recipeProvider.favorites.isEmpty 
        ? Center(child: Text("No favorites yet"))
        : ListView.builder(
          itemCount: recipeProvider.favorites.length, 
          itemBuilder: (context, index) {
            final recipe = recipeProvider.favorites[index];
            return ListTile(
              leading: Image.network(
                recipe.imageUrl, 
                width: 50, 
                height: 50, 
                fit: BoxFit.cover
              ),
              title: Text(recipe.title),
              trailing: IconButton(
                onPressed: () {
                  if (recipe.id != null) {
                    recipeProvider.removeFromFavorites(recipe.id!);
                  }
                }, 
                icon: Icon(Icons.delete), 
              ), 
              onTap: () {
                Navigator.pushNamed(
                  context,
                  "/recipe_detail",
                  arguments: recipe,
                );
              }
            );
          }
      );
  }
}