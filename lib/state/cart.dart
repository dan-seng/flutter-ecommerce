import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../models/product.dart';
import '../services/firestore_service.dart';

class Cart extends ChangeNotifier {
  Cart({FirestoreService? firestoreService}) : _firestore = firestoreService ?? FirestoreService();

  final FirestoreService _firestore;
  final List<CartItem> _items = [];
  final List<Product> _wishlist = [];
  String? _userId;

  List<CartItem> get items => List.unmodifiable(_items);
  List<Product> get wishlist => List.unmodifiable(_wishlist);

  bool get isEmpty => _items.isEmpty;

  int get totalQuantity => _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice => _items.fold(0, (sum, item) => sum + item.lineTotal);

  void setUser(String? uid) {
    _userId = uid;
    if (_userId != null && (_items.isNotEmpty || _wishlist.isNotEmpty)) {
      _syncToFirestore();
    }
  }

  bool isFavorite(Product product) {
    return _wishlist.any((p) => p.id == product.id);
  }

  void toggleFavorite(Product product) {
    final index = _wishlist.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      _wishlist.removeAt(index);
    } else {
      _wishlist.add(product);
    }
    notifyListeners();
    _syncToFirestore();
  }

  void removeFavorite(Product product) {
    _wishlist.removeWhere((p) => p.id == product.id);
    notifyListeners();
    _syncToFirestore();
  }

  void add(CartItem item) {
    final index = _items.indexWhere((existing) => existing.sameLineAs(item));
    if (index >= 0) {
      _items[index] = _items[index].copyWith(
        quantity: _items[index].quantity + item.quantity,
      );
    } else {
      _items.add(item);
    }
    notifyListeners();
    _syncToFirestore();
  }

  void setQuantity(CartItem item, int quantity) {
    final index = _items.indexWhere((existing) => existing.sameLineAs(item));
    if (index < 0) return;
    if (quantity <= 0) {
      _items.removeAt(index);
    } else {
      _items[index] = _items[index].copyWith(quantity: quantity);
    }
    notifyListeners();
    _syncToFirestore();
  }

  void remove(CartItem item) {
    _items.removeWhere((existing) => existing.sameLineAs(item));
    notifyListeners();
    _syncToFirestore();
  }

  void clear() {
    if (_items.isEmpty) return;
    _items.clear();
    notifyListeners();
    _syncToFirestore();
  }

  void _syncToFirestore() {
    if (_userId != null) {
      _firestore.saveUserCart(_userId!, _items);
      _firestore.saveUserWishlist(_userId!, _wishlist);
    }
  }
}
