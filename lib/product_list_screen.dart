import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redux_example/cart_screen.dart';
import 'package:redux_example/cart_vm.dart';
import 'package:redux_example/product.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        actions: [
          Badge(
            label: Text(context.read<CartProvider>().totalItems.toString()),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              ),
            ),
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          return ListView.builder(
            itemCount: productProvider.products.length,
            itemBuilder: (context, index) {
              final product = productProvider.products[index];
              return ProductListItem(product: product);
            },
          );
        },
      ),
    );
  }
}

class ProductListItem extends StatelessWidget {
  final Product product;

  const ProductListItem({super.key, required this.product});

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
                int quantity = cart.getQuantity(product.id);
                return Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: quantity > 0 ? () => cart.removeItem(product.id) : null,
                    ),
                    Text(quantity.toString(), style: const TextStyle(fontSize: 18)),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => cart.addItem(product.id),
                    ),
                    ElevatedButton(
                      child: const Text('Add to Cart'),
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
