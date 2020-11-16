import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;

import '../widgets/order_item.dart';
import '../widgets/appDrawer.dart';

class OrdersList extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersListState createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  bool _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    Provider.of<Orders>(context, listen: false).fetchOrders().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Orders',
        ),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ordersData.orders.length != 0
              ? ListView.builder(
                  itemBuilder: (ctx, idx) => OrderItem(ordersData.orders[idx]),
                  itemCount: ordersData.orders.length,
                )
              : Center(
                  child: Text('No orders placed yet!'),
                ),
    );
  }
}
