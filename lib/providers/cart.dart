import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem(
      {@required this.id,
      @required this.title,
      @required this.quantity,
      @required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, item) { 
      total += item.price * item.quantity;
    });
    return total;
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (currentItem) => CartItem(
          id: currentItem.id,
          title: currentItem.title,
          quantity: currentItem.quantity + 1,
          price: currentItem.price,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          quantity: 1,
          price: price,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId){
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId){
    if(!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
       _items.update(
        productId,
        (currentItem) => CartItem(
          id: currentItem.id,
          title: currentItem.title,
          quantity: currentItem.quantity - 1,
          price: currentItem.price,
        ),
      );
      notifyListeners();
    } else {
      removeItem(productId);
    }
  }

  void clearCart(){
    _items = {};
    notifyListeners();
  }
}
