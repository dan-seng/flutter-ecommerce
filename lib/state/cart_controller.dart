import 'package:flutter/material.dart';

import '../models/product.dart';

class CartLine {
  final Product product;
  int quantity;
  CartLine(this.product, this.quantity);

  double get subtotal => product.price * quantity;
}

class CartController extends ChangeNotifier {
  final Map<int, CartLine> _items = {};

  List<CartLine> get lines => _items.values.toList(growable: false);

  bool get isEmpty => _items.isEmpty;

  int get count =>
      _items.values.fold(0, (sum, line) => sum + line.quantity);

  double get subtotal =>
      _items.values.fold(0, (sum, line) => sum + line.subtotal);

  int quantityOf(Product product) => _items[product.id]?.quantity ?? 0;

  bool contains(Product product) => _items.containsKey(product.id);

  void add(Product product, {int quantity = 1}) {
    final line = _items[product.id];
    if (line == null) {
      _items[product.id] = CartLine(product, quantity);
    } else {
      line.quantity += quantity;
    }
    notifyListeners();
  }

  void remove(Product product) {
    if (_items.remove(product.id) != null) notifyListeners();
  }

  void increment(Product product) => add(product);

  void decrement(Product product) {
    final line = _items[product.id];
    if (line == null) return;
    if (line.quantity <= 1) {
      _items.remove(product.id);
    } else {
      line.quantity--;
    }
    notifyListeners();
  }

  void clear() {
    if (_items.isEmpty) return;
    _items.clear();
    notifyListeners();
  }
}
