import 'package:flutter/material.dart';

class Product {
  final String id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});
}

class ProductProvider extends ChangeNotifier {
  final List<Product> _products = [
    Product(id: '1', name: 'Apple', price: 0.99),
    Product(id: '2', name: 'Banana', price: 0.59),
    Product(id: '3', name: 'Orange', price: 0.79),
  ];

  List<Product> get products => _products;
}