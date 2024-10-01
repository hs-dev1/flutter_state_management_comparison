import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_example/middlewares/receipe_middleware.dart';
import 'package:redux_example/models/product_state.dart';
import 'package:redux_example/middlewares/product_middlewear.dart';
import 'package:redux_example/screens/product_page.dart';
import 'api_service.dart';
import 'models/app_state.dart';
import 'models/receipe_state.dart';

void main() {
  final apiService = ApiService();
  final store = Store<AppState>(
    appReducer,
    initialState: AppState.initial(),
    middleware: [
      ...createProductMiddleware(apiService),
      ...createRecipeMiddleware(apiService),
    ],
  );

  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store<AppState> store;

  const MyApp({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        home: ProductPage(),
      ),
    );
  }
}
