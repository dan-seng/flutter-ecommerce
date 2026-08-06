import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

abstract class ProductRepository {
  Future<List<Product>> fetchProducts();

  Future<Product> fetchProduct(int id);
}

class FakeStoreApi implements ProductRepository {
  FakeStoreApi({http.Client? client}) : _client = client ?? http.Client();

  static const baseUrl = 'https://fakestoreapi.com';

  final http.Client _client;

  @override
  Future<List<Product>> fetchProducts() async {
    final response = await _client.get(Uri.parse('$baseUrl/products'));
    if (response.statusCode != 200) {
      throw Exception('Failed to load products (${response.statusCode})');
    }
    final decoded = jsonDecode(response.body) as List<dynamic>;
    return decoded
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Product> fetchProduct(int id) async {
    final response = await _client.get(Uri.parse('$baseUrl/products/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to load product (${response.statusCode})');
    }
    return Product.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }
}
