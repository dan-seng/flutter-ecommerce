import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/product.dart';

abstract class ProductRepository {
  Future<List<Product>> fetchProducts({bool forceRefresh = false});

  Future<Product> fetchProduct(int id);
}

class FakeStoreApi implements ProductRepository {
  FakeStoreApi({http.Client? client}) : _client = client ?? http.Client();

  static const baseUrl = 'https://fakestoreapi.com';
  static const String _offlineCacheKey = 'cached_products_json_v1';
  static List<Product>? _cachedProducts;

  final http.Client _client;

  @override
  Future<List<Product>> fetchProducts({bool forceRefresh = false}) async {
    if (!forceRefresh && _cachedProducts != null && _cachedProducts!.isNotEmpty) {
      return _cachedProducts!;
    }

    try {
      final response = await _client
          .get(Uri.parse('$baseUrl/products'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body) as List<dynamic>;
        _cachedProducts = decoded
            .map((item) => Product.fromJson(item as Map<String, dynamic>))
            .toList();

        // Save to persistent disk cache for offline browsing
        _saveToDiskCache(response.body);
        return _cachedProducts!;
      }
    } catch (e) {
      debugPrint('Network fetch failed ($e). Attempting offline disk cache...');
    }

    // Try reading persistent disk cache
    final diskCached = await _loadFromDiskCache();
    if (diskCached != null && diskCached.isNotEmpty) {
      _cachedProducts = diskCached;
      return _cachedProducts!;
    }

    if (_cachedProducts != null && _cachedProducts!.isNotEmpty) {
      return _cachedProducts!;
    }

    throw Exception('Offline: No cached products available');
  }

  @override
  Future<Product> fetchProduct(int id) async {
    try {
      final response = await _client
          .get(Uri.parse('$baseUrl/products/$id'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        return Product.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );
      }
    } catch (e) {
      debugPrint('Network fetchProduct failed ($e). Searching offline cache...');
    }

    // Offline fallback from cached list
    final allProducts = await fetchProducts();
    return allProducts.firstWhere(
      (p) => p.id == id,
      orElse: () => allProducts.first,
    );
  }

  static Future<void> _saveToDiskCache(String jsonString) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_offlineCacheKey, jsonString);
    } catch (e) {
      debugPrint('Error saving offline cache: $e');
    }
  }

  static Future<List<Product>?> _loadFromDiskCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_offlineCacheKey);
      if (raw != null && raw.isNotEmpty) {
        final decoded = jsonDecode(raw) as List<dynamic>;
        return decoded
            .map((item) => Product.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('Error loading offline cache: $e');
    }
    return null;
  }
}
