// middleware/recipe_middleware.dart
import 'package:redux/redux.dart';
import 'package:redux_example/api_service.dart';
import '../actions/receipe_actions.dart';
import '../models/app_state.dart';

List<Middleware<AppState>> createRecipeMiddleware(ApiService apiService) {
  return [
    TypedMiddleware<AppState, FetchRecipesAction>(
      (store, action, next) async {
        next(action);

        try {
          final recipes = await apiService.fetchAllRecipes();
          store.dispatch(FetchRecipesSuccessAction(recipes));
        } catch (error) {
          store.dispatch(FetchRecipesFailureAction(error.toString()));
        }
      },
    ).call,
  ];
}
