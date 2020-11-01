// packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// providers
import '../providers/products.dart';

// widgets
import 'product_item.dart';

class ProductGrid extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    //TODO: refactor
    final products = productsData.items; 

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, idx) => ProductItem(
        products[idx].id,
        products[idx].title,
        products[idx].imageUrl,
      ),
    );
  }
}