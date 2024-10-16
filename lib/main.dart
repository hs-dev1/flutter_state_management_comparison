import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

Future<Map<String, dynamic>> fetchProduct(int id) async {
  final response = await http.get(Uri.parse('https://dummyjson.com/products/$id'));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load product');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('FutureProvider Example')),
        body: ChangeNotifierProvider(
          create: (_) => ProductProvider(),
          child: const ProductDetails(),
        ),
      ),
    );
  }
}

class ProductProvider extends ChangeNotifier {
  int _currentId = 1;
  Map<String, dynamic> _product = {'title': 'Loading...'};

  Map<String, dynamic> get product => _product;

  Future<void> fetchProducta() async {
    try {
      _product = await fetchProduct(_currentId);
      notifyListeners();
    } catch (e) {
      _product = {'title': 'Error loading product'};
      notifyListeners();
    }
  }

  void nextProduct() {
    _currentId++;
    fetchProducta();
  }

  void previousProduct() {
    if (_currentId > 1) {
      _currentId--;
      fetchProducta();
    }
  }
}

class ProductDetails extends StatefulWidget {
  const ProductDetails({super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  void initState() {
    final productProvider = Provider.of<ProductProvider>(context,listen: false);

    productProvider.nextProduct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final product = productProvider.product;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Product Title: ${product['title']}'),
          Text('Price: \$${product['price']}'),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  productProvider.previousProduct();
                },
                child: const Text('Previous'),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  productProvider.nextProduct();
                },
                child: const Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
