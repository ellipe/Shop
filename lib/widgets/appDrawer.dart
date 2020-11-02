import 'package:flutter/material.dart';
import '../views/orders_list.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context).settings.name;
    print(currentRoute);
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Hello Friend'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text(
              'Shop',
              style: TextStyle(
                  fontWeight: currentRoute == '/'
                      ? FontWeight.w900
                      : FontWeight.normal),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Orders',
                style: TextStyle(
                    fontWeight: currentRoute == OrdersList.routeName
                        ? FontWeight.w900
                        : FontWeight.normal)),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrdersList.routeName);
            },
          ),
        ],
      ),
    );
  }
}
