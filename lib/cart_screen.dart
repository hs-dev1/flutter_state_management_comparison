import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redux_example/cart_vm.dart';
import 'package:redux_example/product.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: Consumer2<CartProvider, ProductProvider>(
        builder: (context, cartProvider, productProvider, child) {
          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: cartProvider.items.entries.map((entry) {
                    final product = productProvider.products.firstWhere((p) => p.id == entry.key);
                    return CartItem(product: product, quantity: entry.value);
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Total: \$${cartProvider.getTotalPrice(productProvider.products).toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton(
                child: const Text('Checkout'),
                onPressed: () {},
              ),
            ],
          );
        },
      ),
    );
  }
}

class CartItem extends StatelessWidget {
  final Product product;
  final int quantity;

  const CartItem({super.key, required this.product, required this.quantity});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
            Consumer<CartProvider>(
              builder: (context, cart, child) {
                return Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () => cart.removeItem(product.id),
                    ),
                    Text(quantity.toString(), style: const TextStyle(fontSize: 18)),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => cart.addItem(product.id),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
