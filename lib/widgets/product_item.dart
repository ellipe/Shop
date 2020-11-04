import 'package:Shop/views/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// providers
import '../providers/product.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(ProductDetail.routeName, arguments: product.id)
                .then((_) => Scaffold.of(context).hideCurrentSnackBar());
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          leading: IconButton(
            icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              product.toggleFavoriteStatus();
            },
            color: Theme.of(context).accentColor,
          ),
          trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Item added to cart!',
                      textAlign: TextAlign.center,
                    ),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          cart.removeSingleItem(product.id);
                        }),
                  ),
                );
                cart.addItem(product.id, product.price, product.title);
              },
              color: Theme.of(context).accentColor),
          title: Text(product.title, textAlign: TextAlign.center),
          backgroundColor: Colors.black87,
        ),
      ),
    );
  }
}
