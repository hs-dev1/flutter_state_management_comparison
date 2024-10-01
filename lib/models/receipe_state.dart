// reducers/recipe_reducer.dart
import '../actions/receipe_actions.dart';

class RecipeState {
  final List<dynamic> recipes;
  final bool isLoading;
  final String error;

  RecipeState({this.recipes = const [], this.isLoading = false, this.error = ''});
  factory RecipeState.initial() {
    return RecipeState(
      recipes: [],
      isLoading: false,
      error: '',
    );
  }
}

RecipeState recipeReducer(RecipeState state, dynamic action) {
  if (action is FetchRecipesAction) {
    return RecipeState(isLoading: true);
  } else if (action is FetchRecipesSuccessAction) {
    return RecipeState(recipes: action.recipes, isLoading: false);
  } else if (action is FetchRecipesFailureAction) {
    return RecipeState(isLoading: false, error: action.error);
  }
  return state;
}
