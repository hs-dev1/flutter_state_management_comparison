import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redux_example/cart_vm.dart';
import 'package:redux_example/product_list_screen.dart';
import 'package:redux_example/product.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductProvider()),
        ChangeNotifierProvider(create: (context) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Cart App",
      home: ProductListScreen(),
    );
  }
}
