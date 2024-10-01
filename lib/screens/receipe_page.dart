// ui/recipes_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_example/actions/receipe_actions.dart';
import 'package:redux_example/models/receipe_state.dart';

import '../models/app_state.dart';

class RecipesPage extends StatelessWidget {
  const RecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes'),
      ),
      body: StoreConnector<AppState, RecipeState>(
        converter: (store) => store.state.recipeState,
        onInit: (store) => store.dispatch(FetchRecipesAction()),
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.error.isNotEmpty) {
            return Center(child: Text('Error: ${state.error}'));
          } else if (state.recipes.isEmpty) {
            return const Center(child: Text('No recipes available'));
          }

          return ListView.builder(
            itemCount: state.recipes.length,
            itemBuilder: (context, index) {
              final recipe = state.recipes[index];
              return ListTile(
                title: Text(recipe['name']),
                subtitle: Text(recipe['cuisine']),
              );
            },
          );
        },
      ),
    );
  }
}
