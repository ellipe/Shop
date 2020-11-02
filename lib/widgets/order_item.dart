import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import '../providers/orders.dart' as prov;

class OrderItem extends StatefulWidget {
  final prov.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Column(children: [
        ListTile(
          title: Text('\$${widget.order.amount.toStringAsFixed(2)}'),
          subtitle: Text(
            DateFormat.yMMMMd().add_jm().format(widget.order.dateTime),
          ),
          trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              }),
        ),
        if (_expanded)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: min(widget.order.products.length * 20.0 + 10, 180),
            child: ListView.builder(
                itemBuilder: (ctx, idx) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.order.products[idx].title}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text('${widget.order.products[idx].quantity} x ${widget.order.products[idx].price}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.grey,
                          ))
                      ],
                    ),
                itemCount: widget.order.products.length),
          ),
      ]),
    );
  }
}
