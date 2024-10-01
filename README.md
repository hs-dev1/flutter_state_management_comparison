

# Redux Tutorial - Level 4: API Integration with Products & Recipes

In this tutorial, we'll extend the Redux-based Flutter application by integrating API calls. We will implement two key features:
- Fetching all products and a single product from an API.
- Fetching a list of recipes from a different API.

The following APIs are used:
- Get all products: `https://dummyjson.com/products`
- Get a single product: `https://dummyjson.com/products/{id}`
- Get all recipes: `https://dummyjson.com/recipes`

## Overview

By the end of this level, you'll be able to:
- Structure an application with two separate states (`ProductState` and `RecipeState`), reducers, and middleware.
- Use `TypedMiddleware` to intercept actions and fetch data asynchronously using the `http` package.
- Combine multiple reducers and connect them to your `AppState`.
- Connect your UI to the Redux store and display data fetched from an API.

### App Structure
The app will be structured into the following parts:
- **State Management**: Redux will manage two pieces of state: `ProductState` and `RecipeState`.
- **API Service**: A service to handle all API requests.
- **Middleware**: We’ll use middleware to dispatch actions for fetching data asynchronously.
- **Reducers**: Reducers will manage changes to `ProductState` and `RecipeState`.
- **UI**: Display products and recipes using `StoreConnector` to listen to the Redux state.

---

## Project Setup

### 1. Add Dependencies

In your `pubspec.yaml`, ensure the following dependencies are added:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_redux: ^0.8.2
  redux: ^5.0.0
  http: ^0.13.3
```

Run `flutter pub get` to install the dependencies.

---

### 2. Define State Classes

We'll manage two separate pieces of state: one for products and another for recipes.

#### `product_state.dart`

```dart
class ProductState {
  final List<dynamic> products;
  final Map<String, dynamic> selectedProduct;
  final bool isLoading;
  final String error;

  ProductState({
    required this.products,
    required this.selectedProduct,
    required this.isLoading,
    required this.error,
  });

  factory ProductState.initial() {
    return ProductState(
      products: [],
      selectedProduct: {},
      isLoading: false,
      error: '',
    );
  }
}
```

#### `recipe_state.dart`

```dart
class RecipeState {
  final List<dynamic> recipes;
  final bool isLoading;
  final String error;

  RecipeState({
    required this.recipes,
    required this.isLoading,
    required this.error,
  });

  factory RecipeState.initial() {
    return RecipeState(
      recipes: [],
      isLoading: false,
      error: '',
    );
  }
}
```

---

### 3. Create API Service

This service handles the API requests for products and recipes.

#### `api_service.dart`

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final baseUrl = 'https://dummyjson.com';

  Future<List<dynamic>> fetchAllProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['products'];
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<Map<String, dynamic>> fetchProduct(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/products/$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load product');
    }
  }

  Future<List<dynamic>> fetchAllRecipes() async {
    final response = await http.get(Uri.parse('$baseUrl/recipes'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['recipes'];
    } else {
      throw Exception('Failed to load recipes');
    }
  }
}
```

---

### 4. Set up Middleware

Middleware will handle the asynchronous API requests by dispatching success or error actions.

#### `product_middleware.dart`

```dart
import 'package:redux/redux.dart';
import 'product_actions.dart';
import 'product_state.dart';
import '../api_service.dart';

List<Middleware<ProductState>> createProductMiddleware(ApiService apiService) {
  return [
    TypedMiddleware<ProductState, FetchProductsAction>(
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
    TypedMiddleware<ProductState, FetchProductAction>(
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
```

#### `recipe_middleware.dart`

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';
import 'recipe_actions.dart';
import 'recipe_state.dart';

void recipeMiddleware(Store<RecipeState> store, dynamic action, NextDispatcher next) async {
  if (action is FetchRecipesAction) {
    try {
      final response = await http.get(Uri.parse('https://dummyjson.com/recipes'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['recipes'];
        store.dispatch(FetchRecipesSuccessAction(data));
      } else {
        store.dispatch(FetchRecipesFailureAction('Failed to load recipes'));
      }
    } catch (error) {
      store.dispatch(FetchRecipesFailureAction('Error: $error'));
    }
  }
  next(action);
}
```

---

### 5. Create Actions

Define actions that will be dispatched for products and recipes.

#### `product_actions.dart`

```dart
class FetchProductsAction {}

class FetchProductsSuccessAction {
  final List<dynamic> products;
  FetchProductsSuccessAction(this.products);
}

class FetchProductsErrorAction {
  final String error;
  FetchProductsErrorAction(this.error);
}

class FetchProductAction {
  final int id;
  FetchProductAction(this.id);
}

class FetchProductSuccessAction {
  final Map<String, dynamic> product;
  FetchProductSuccessAction(this.product);
}

class FetchProductErrorAction {
  final String error;
  FetchProductErrorAction(this.error);
}
```

#### `recipe_actions.dart`

```dart
class FetchRecipesAction {}

class FetchRecipesSuccessAction {
  final List<dynamic> recipes;
  FetchRecipesSuccessAction(this.recipes);
}

class FetchRecipesFailureAction {
  final String error;
  FetchRecipesFailureAction(this.error);
}
```

---

### 6. Combine Reducers

Combine `ProductState` and `RecipeState` reducers into a single `AppState`.

#### `app_reducer.dart`

```dart
import 'product_reducer.dart';
import 'recipe_reducer.dart';
import 'app_state.dart';

AppState appReducer(AppState state, dynamic action) {
  return AppState(
    productState: productReducer(state.productState, action),
    recipeState: recipeReducer(state.recipeState, action),
  );
}
```

---

### 7. Setup the `AppState`

#### `app_state.dart`

```dart
import 'product_state.dart';
import 'recipe_state.dart';

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
```

---

### 8. Integrating in `main.dart`

In the `main.dart` file, combine the reducers, middleware, and state. Here's an example of how to initialize the store and wrap your app:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'app_reducer.dart';
import 'app_state.dart';
import 'api_service.dart';
import 'product_middleware.dart';
import 'recipe_middleware.dart';

void main() {
  final apiService = ApiService();

  final store = Store<AppState>(
    appReducer,
    initialState: AppState.initial(),
    middleware: [
      ...createProductMiddleware(apiService),
      recipeMiddleware,
    ],
  );

  runApp(StoreProvider<AppState>(
    store: store,
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Redux Example',
      home: ProductPage(),
    );
  }
}
```

---

### 9. Creating the UI

#### `product_page.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_example/actions/product_actions.dart';
import 'package:redux_example/models/product_state.dart';
import 'product_detail_page.dart';

class ProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product List")),
     

 body: StoreConnector<AppState, ProductState>(
        converter: (store) => store.state.productState,
        onInit: (store) => store.dispatch(FetchProductsAction()),
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error.isNotEmpty) {
            return Center(child: Text('Error: ${state.error}'));
          }

          return ListView.builder(
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              final product = state.products[index];
              return ListTile(
                title: Text(product['title']),
                subtitle: Text('Price: \$${product['price']}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailPage(productId: product['id']),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
```

---

### 10. Conclusion

By following this tutorial, you have successfully:
- Implemented API integration for fetching products and recipes.
- Structured your Redux app with separate states for different API data.
- Used middleware to handle asynchronous API calls.
- Combined multiple reducers into a unified `AppState`.
  
This concludes **Level 4** of the Redux tutorial series. In the next level, we’ll dive deeper into optimizing Redux patterns and possibly caching API data for offline support.

