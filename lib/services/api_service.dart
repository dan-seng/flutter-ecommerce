import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class ApiException implements Exception {
  final String message;
  const ApiException(this.message);
  @override
  String toString() => message;
}

/// Thin, cached client over the Fake Store API.
class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  static const _base = 'https://fakestoreapi.com';
  static const _timeout = Duration(seconds: 20);

  final http.Client _client;
  List<Product>? _all;
  List<String>? _categories;
  final Map<String, List<Product>> _byCategory = {};

  Future<List<Product>> fetchProducts({bool force = false}) async {
    if (_all != null && !force) return _all!;
    final json = await _getJson('/products');
    final products =
        (json as List).map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
    _all = products;
    return products;
  }

  Future<List<String>> fetchCategories({bool force = false}) async {
    if (_categories != null && !force) return _categories!;
    final json = await _getJson('/products/categories');
    final categories = (json as List).map((e) => e as String).toList();
    _categories = categories;
    return categories;
  }

  Future<List<Product>> fetchByCategory(String category,
      {bool force = false}) async {
    final cached = _byCategory[category];
    if (cached != null && !force) return cached;
    final json =
        await _getJson('/products/category/${Uri.encodeComponent(category)}');
    final products =
        (json as List).map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
    _byCategory[category] = products;
    return products;
  }

  Future<dynamic> _getJson(String path) async {
    final uri = Uri.parse('$_base$path');
    try {
      final res = await _client.get(uri).timeout(_timeout);
      if (res.statusCode != 200) {
        throw ApiException('The store replied with ${res.statusCode}.');
      }
      return jsonDecode(res.body);
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const ApiException(
        'Could not reach the store. Check your connection and try again.',
      );
    }
  }

  void clearCache() {
    _all = null;
    _categories = null;
    _byCategory.clear();
  }
}
