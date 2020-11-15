import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false});

  Future<void> toggleFavoriteStatus() async {
    final apiUrl = 'https://shop-62d11.firebaseio.com/products/$id.json';
    final oldFavorite = isFavorite;
    
    isFavorite = !isFavorite;
    notifyListeners();

    try {
      final response = await http.patch(
        apiUrl,
        body: json.encode({'isFavorite': isFavorite}),
      );
      if (response.statusCode >= 400) {
        isFavorite = oldFavorite;
        notifyListeners();
        throw Error();
      }
      
    } catch (error) {
      throw error;
    }
  }
}
