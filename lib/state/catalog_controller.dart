import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/api_service.dart';

enum CatalogStatus { loading, ready, error }

/// Loads the full catalog (products + categories) once and shares it.
class CatalogController extends ChangeNotifier {
  CatalogController({ApiService? api}) : _api = api ?? ApiService();

  final ApiService _api;

  CatalogStatus status = CatalogStatus.loading;
  List<Product> products = const [];
  List<String> categories = const [];
  String? error;

  Future<void> load() async {
    status = CatalogStatus.loading;
    notifyListeners();
    try {
      final results = await Future.wait([
        _api.fetchProducts(),
        _api.fetchCategories(),
      ]);
      products = results[0] as List<Product>;
      categories = results[1] as List<String>;
      status = CatalogStatus.ready;
    } on ApiException catch (e) {
      error = e.message;
      status = CatalogStatus.error;
    } catch (_) {
      error = 'Something went wrong while loading the store.';
      status = CatalogStatus.error;
    }
    notifyListeners();
  }
}
