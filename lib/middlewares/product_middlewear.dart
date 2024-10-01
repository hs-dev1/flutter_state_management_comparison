// ignore_for_file: implicit_call_tearoffs

import 'package:redux/redux.dart';
import 'package:redux_example/actions/product_actions.dart';
import 'package:redux_example/models/product_state.dart';
import '../api_service.dart';
import '../models/app_state.dart';

List<Middleware<AppState>> createProductMiddleware(ApiService apiService) {
  return [
    TypedMiddleware<AppState, FetchProductsAction>(
      (store, action, next) async {
        next(action);

        try {
          final products = await apiService.fetchAllProducts();
          store.dispatch(FetchProductsSuccessAction(products));
        } catch (error) {
          store.dispatch(FetchProductsErrorAction(error.toString()));
        }
      },
    ),
    TypedMiddleware<AppState, FetchProductAction>(
      (store, action, next) async {
        next(action);

        try {
          final product = await apiService.fetchProduct(action.id);
          store.dispatch(FetchProductSuccessAction(product));
        } catch (error) {
          store.dispatch(FetchProductErrorAction(error.toString()));
        }
      },
    ),
  ];
}
