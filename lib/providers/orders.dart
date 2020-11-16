import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    const URL = 'https://shop-62d11.firebaseio.com/orders.json';
    final response = await http.get(URL);
    final List<OrderItem> loadedOrders = [];

    final parsedOrders = json.decode(response.body) as Map<String, dynamic>;
    if (parsedOrders == null ) {
      return;
    }
    parsedOrders.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>).map((item) => CartItem(
            id: item['id'],
            title: item['title'],
            price: item['price'],
            quantity: item['quantity']

          )).toList()
        ),
      );
    });

  _orders = loadedOrders.reversed.toList();
  notifyListeners();
  }

  

  Future<void> addOrder(List<CartItem> products, double total) async {
    const URL = 'https://shop-62d11.firebaseio.com/orders.json';
    final timestamp = DateTime.now();

    try {
      final response = await http.post(
        URL,
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': products
              .map((product) => {
                    'id': product.id,
                    'title': product.title,
                    'quantity': product.quantity,
                    'price': product.price
                  })
              .toList()
        }),
      );
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          dateTime: timestamp,
          products: products,
        ),
      );
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }
}
