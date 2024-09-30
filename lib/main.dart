import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_example/models/product_state.dart';
import 'package:redux_example/reducers/product_middlewear.dart';
import 'package:redux_example/screens/product_page.dart';
import 'api_service.dart';

void main() {
  final apiService = ApiService();
  final store = Store<ProductState>(
    productReducer,
    initialState: initialState,
    middleware: createProductMiddleware(apiService),
  );

  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store<ProductState> store;

  MyApp({required this.store});

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        home: ProductPage(),
      ),
    );
  }
}
