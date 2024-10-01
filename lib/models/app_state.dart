// models/app_state.dart
import 'package:redux_example/models/receipe_state.dart';

import 'product_state.dart';
// app_state.dart

class AppState {
  final ProductState productState;
  final RecipeState recipeState;

  AppState({required this.productState, required this.recipeState});
  factory AppState.initial() {
    return AppState(
      productState: ProductState.initial(),
      recipeState: RecipeState.initial(),
    );
  }
}

// app_reducer.dart

AppState appReducer(AppState state, dynamic action) {
  return AppState(
    productState: productReducer(state.productState, action),
    recipeState: recipeReducer(state.recipeState, action),
  );
}
