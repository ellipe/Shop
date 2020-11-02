import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// providers
import '../providers/cart.dart' show Cart;

// widgets
import '../widgets/cart_item.dart';

class ShoppingCart extends StatelessWidget {
  static const routeName = '/shopping_cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Column(children: [
        Card(
          margin: EdgeInsets.all(15),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  width: 10,
                ),
                Spacer(),
                Chip(
                  label: Text(
                    '\$${cart.totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Theme.of(context).primaryTextTheme.headline6.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                FlatButton(
                  onPressed: () {},
                  child: Text(
                    'ORDER NOW',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemBuilder: (ctx, idx) => CartItem(
                id: cart.items.values.toList()[idx].id,
                title: cart.items.values.toList()[idx].title,
                quantity: cart.items.values.toList()[idx].quantity,
                price: cart.items.values.toList()[idx].price),
            itemCount: cart.itemCount,
          ),
        ),
      ]),
    );
  }
}
