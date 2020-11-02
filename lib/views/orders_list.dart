import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;

import '../widgets/order_item.dart';
import '../widgets/appDrawer.dart';

class OrdersList extends StatelessWidget {
  static const routeName = '/orders';

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
      body: ListView.builder(
          itemBuilder: (ctx, idx) => OrderItem(ordersData.orders[idx]),
          itemCount: ordersData.orders.length),
    );
  }
}
