// Actions for fetching all products
class FetchProductsAction {}

class FetchProductsSuccessAction {
  final List<dynamic> products;

  FetchProductsSuccessAction(this.products);
}

class FetchProductsErrorAction {
  final String error;

  FetchProductsErrorAction(this.error);
}

// Actions for fetching a single product
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
