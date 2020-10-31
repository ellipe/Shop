import 'package:flutter/material.dart';

// widgets
import '../widgets/products_grid.dart';

class ProductOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Shop',
        ),
      ),
      body: ProductGrid(),
    );
  }
}