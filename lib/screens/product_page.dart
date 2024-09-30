import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_example/actions/product_actions.dart';
import 'package:redux_example/models/product_state.dart';


class ProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Product List")),
      body: StoreConnector<ProductState, ProductState>(
        converter: (store) => store.state,
        onInit: (store) => store.dispatch(FetchProductsAction()),
        builder: (context, state) {
          if (state.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state.error?.isNotEmpty??false) {
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

class ProductDetailPage extends StatelessWidget {
  final int productId;

  ProductDetailPage({required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Product Detail")),
      body: StoreConnector<ProductState, ProductState>(
        converter: (store) => store.state,
        onInit: (store) => store.dispatch(FetchProductAction(productId)),
        builder: (context, state) {
          if (state.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state.error?.isNotEmpty??false) {
            return Center(child: Text('Error: ${state.error}'));
          }

          final product = state.selectedProduct;
          return product.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Title: ${product['title']}', style: TextStyle(fontSize: 24)),
                    SizedBox(height: 10),
                    Text('Price: \$${product['price']}', style: TextStyle(fontSize: 18)),
                    SizedBox(height: 10),
                    Text('Description: ${product['description']}', style: TextStyle(fontSize: 16)),
                  ],
                )
              : Center(child: Text('No Product Selected'));
        },
      ),
    );
  }
}
