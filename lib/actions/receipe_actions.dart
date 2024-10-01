// actions/recipe_actions.dart
class FetchRecipesAction {}

class FetchRecipesSuccessAction {
  final List<dynamic> recipes;
  FetchRecipesSuccessAction(this.recipes);
}

class FetchRecipesFailureAction {
  final String error;
  FetchRecipesFailureAction(this.error);
}
