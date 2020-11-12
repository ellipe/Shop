import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './product.dart';

// this is central store allowing set reducers to the state.
class Products with ChangeNotifier {
  final apiUrl = 'https://shop-62d11.firebaseio.com/products.json';

  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Future<void> fetchAllProducts() async {
    try {
      final response = await http.get(apiUrl);
      final parsedData = json.decode(response.body) as Map<String, dynamic>;
      List<Product> loadedProducts = [];
      parsedData.forEach((productId, productData) {
        loadedProducts.add(Product(
          id: productId,
          title: productData['title'],
          price: productData['price'],
          description: productData['description'],
          imageUrl: productData['imageUrl'],
          isFavorite: productData['isFavorite'],
        ));

        _items = loadedProducts;
        notifyListeners();
      });
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final response = await http.post(
        apiUrl,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'isFavorite': product.isFavorite
        }),
      );

      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
          isFavorite: product.isFavorite);
      _items.add(newProduct);
      notifyListeners();
    } catch (err) {
      print('error in model');
      print(err);
      throw err;
    }
  }

  Future<void> updateProduct(Product product) async {
    final apiUrl = 'https://shop-62d11.firebaseio.com/products/${product.id}.json';

    final existingProduct = _items.indexWhere((prod) => prod.id == product.id);
    if (existingProduct >= 0) {
      await http.patch(apiUrl, body: json.encode({
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
      }));
      _items[existingProduct] = product;
      notifyListeners();
    }
  }

  Future<void> removeProduct(String productId) async {
    final apiUrl = 'https://shop-62d11.firebaseio.com/products/$productId.json';
    final existingProduct = _items.indexWhere((prod) => prod.id == productId);
    if (existingProduct >= 0) {
      await http.delete(apiUrl);
      _items.removeAt(existingProduct);
      notifyListeners();
    }
  }

  findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }
}
