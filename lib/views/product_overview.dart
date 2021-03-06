import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// routes
import './shopping_cart.dart';

// providers
import '../providers/cart.dart';
import '../providers/products.dart';

// widgets
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../widgets/appDrawer.dart';

enum FilterOptions { Favorites, All }

class ProductOverview extends StatefulWidget {
  @override
  _ProductOverviewState createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverview> {
  bool _showFavoritesOnly = false;
  bool _isInit = false;
  bool _isLoadingProducts = false;

  @override
  Future<void> didChangeDependencies() async {
    if (!_isInit) {
      _isLoadingProducts = true;
      await Provider.of<Products>(context, listen: false).fetchAllProducts();
      setState(() {
        _isLoadingProducts = false;
      });
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shop',
        ),
        actions: [
          Consumer<Cart>(
            builder: (ctx, cart, childWidget) => Badge(
              child: childWidget,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(ShoppingCart.routeName);
              },
              icon: Icon(Icons.shopping_cart),
            ),
          ),
          PopupMenuButton(
            onSelected: (FilterOptions value) {
              setState(() {
                if (value == FilterOptions.Favorites) {
                  _showFavoritesOnly = true;
                } else {
                  _showFavoritesOnly = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text(
                  'Only Favorites',
                  style: TextStyle(
                      fontWeight: _showFavoritesOnly
                          ? FontWeight.bold
                          : FontWeight.normal),
                ),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text(
                  'Show All',
                  style: TextStyle(
                      fontWeight: !_showFavoritesOnly
                          ? FontWeight.bold
                          : FontWeight.normal),
                ),
                value: FilterOptions.All,
              ),
            ],
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoadingProducts
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(_showFavoritesOnly),
    );
  }
}
