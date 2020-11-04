import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// providers
import '../providers/products.dart';

// views
import './edit_product.dart';

// Widgets
import '../widgets/user_product_item.dart';
import '../widgets/appDrawer.dart';

class UserProducts extends StatelessWidget {
  static const routeName = '/products';

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Products'),
        actions: [
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProduct.routeName);
              }),
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
              itemCount: products.items.length,
              itemBuilder: (ctx, idx) => UserProductItem(
                    id: products.items[idx].id,
                    title: products.items[idx].title,
                    imageUrl: products.items[idx].imageUrl,
                  ))),
    );
  }
}
