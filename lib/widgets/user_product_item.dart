import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// providers
import '../providers/products.dart';

// views
import '../views/edit_product.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem({this.id, this.title, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: FittedBox(
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProduct.routeName, arguments: id);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .removeProduct(id);
                  scaffold.showSnackBar(SnackBar(
                      content: Text(
                    'Product deleted',
                    textAlign: TextAlign.center,
                  )));
                } catch (error) {}
              },
            ),
          ],
        ),
      ),
    );
  }
}
