import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// views
import './views/product_overview.dart';
import './views/product_detail.dart';
import './views/shopping_cart.dart';

// providers
import 'providers/products.dart';
import 'providers/cart.dart';


void main() {
  runApp(ShopApp());
}

class ShopApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Products(),),
          ChangeNotifierProvider(create: (_) => Cart(),),
        ],
        child: MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
            accentColor: Colors.deepOrangeAccent,
            fontFamily: 'Lato',
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: ProductOverview(),
          routes: {
            ProductDetail.routeName: (ctx) => ProductDetail(),
            ShoppingCart.routeName: (ctx) => ShoppingCart(),
          },
        ),
    );
  }
}
