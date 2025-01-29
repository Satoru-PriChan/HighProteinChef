import 'package:flutter/material.dart';
import 'package:high_protein_chef/providers/recipe_provider.dart';
import 'package:high_protein_chef/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:high_protein_chef/routers/app_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("High Protein Chef"),
        actions: [
          _stateButton(context, authProvider),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/favorites");
            }, 
            icon: const Icon(Icons.favorite)
          )
        ],
      ),
      body: Consumer2<RecipeProvider, AuthProvider>(
        builder: (context, recipeProvider, authProvider, child) {
          // Error message
          if (recipeProvider.error != null) {
            AppRouter.showDialogs(context, recipeProvider.error!, (){
                recipeProvider.clearError();
            }); 
          }
          if (authProvider.error != null) {
            AppRouter.showDialogs(context, authProvider.error!, (){
              authProvider.clearError();
            });
          }

          return _body(context, recipeProvider, authProvider);
        }
      )
    );
  }

  IconButton _stateButton(BuildContext context, AuthProvider authProvider) {
    if (authProvider.user == null) {
      return IconButton(
        onPressed: () {
          Navigator.pushNamed(context, "/login");
        }, 
        icon: const Icon(Icons.login)
      );
    } else {
        return IconButton(
          onPressed: () {
            Navigator.pushNamed(context, "/profile");
          }, 
          icon: const Icon(Icons.person)
        );
    }
  }

  Widget _body(BuildContext context, RecipeProvider recipeProvider, AuthProvider authProvider) {
    if (authProvider.user == null) {
      return Center(
        child: TextButton(
          onPressed: () {
            Navigator.pushNamed(context, "/login");
          }, 
          child: const Text("Please login to use recipe search function.")
        ),
      );
    } else {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onSubmitted: (query) {
                recipeProvider.searchRecipes(query);
              },
              decoration: const InputDecoration(
                labelText: 'Search Recipes',
                border: OutlineInputBorder(),
              ),
            ),
          ),

          recipeProvider.isLoading 
            ? const Center(child: CircularProgressIndicator())
            : Expanded(
              child: ListView.builder(
                itemCount: recipeProvider.recipes.length,
                itemBuilder: (context, index) {
                  final recipe = recipeProvider.recipes[index];
                  return ListTile(
                    leading: Image.network(recipe.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(recipe.title),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        "/recipe_detail",
                        arguments: recipe,
                      );
                    },
                  );
                },
              )
            ),
        ],
      );
    }
  }
}