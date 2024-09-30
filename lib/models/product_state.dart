
import '../actions/product_actions.dart';

// Define your state
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

  ProductState copyWith({
    List<dynamic>? products,
    Map<String, dynamic>? selectedProduct,
    bool? isLoading,
    String? error,
  }) {
    return ProductState(
      products: products ?? this.products,
      selectedProduct: selectedProduct ?? this.selectedProduct,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// Initial State
ProductState initialState = ProductState(
  products: [],
  selectedProduct: {},
  isLoading: false,
  error: '',
);

// Reducer function
ProductState productReducer(ProductState state, dynamic action) {
  if (action is FetchProductsAction) {
    return state.copyWith(isLoading: true);
  } else if (action is FetchProductsSuccessAction) {
    return state.copyWith(products: action.products, isLoading: false, error: '');
  } else if (action is FetchProductsErrorAction) {
    return state.copyWith(isLoading: false, error: action.error);
  } else if (action is FetchProductAction) {
    return state.copyWith(isLoading: true);
  } else if (action is FetchProductSuccessAction) {
    return state.copyWith(selectedProduct: action.product, isLoading: false, error: '');
  } else if (action is FetchProductErrorAction) {
    return state.copyWith(isLoading: false, error: action.error);
  }

  return state;
}
