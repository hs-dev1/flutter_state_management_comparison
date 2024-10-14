import 'package:flutter/material.dart';
import 'package:redux_example/product.dart';


class CartProvider extends ChangeNotifier {
  final Map<String, int> _items = {};

  Map<String, int> get items => _items;

  void addItem(String productId) {
    _items[productId] = (_items[productId] ?? 0) + 1;
    notifyListeners();
  }

  void removeItem(String productId) {
    if (_items.containsKey(productId)) {
      if (_items[productId] == 1) {
        _items.remove(productId);
      } else {
        _items[productId] = _items[productId]! - 1;
      }
      notifyListeners();
    }
  }

  int getQuantity(String productId) {
    return _items[productId] ?? 0;
  }

  double getTotalPrice(List<Product> products) {
    return _items.entries.fold(0, (total, entry) {
      final product = products.firstWhere((p) => p.id == entry.key);
      return total + (product.price * entry.value);
    });
  }

  int get totalItems => _items.values.fold(0, (sum, quantity) => sum + quantity);
}