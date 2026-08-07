import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

class FirestoreService {
  FirestoreService({FirebaseFirestore? firestore})
      : _db = firestore ?? (_isFirebaseInitialized() ? FirebaseFirestore.instance : null);

  final FirebaseFirestore? _db;

  static bool _isFirebaseInitialized() {
    try {
      return FirebaseFirestore.instance.app.name.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// Sync user cart to Firestore
  Future<void> saveUserCart(String uid, List<CartItem> items) async {
    if (_db == null) return;
    try {
      final cartRef = _db.collection('users').doc(uid).collection('cart');
      final batch = _db.batch();

      final existing = await cartRef.get();
      for (final doc in existing.docs) {
        batch.delete(doc.reference);
      }

      for (final item in items) {
        final docRef = cartRef.doc('${item.product.id}_${item.size}_${item.color}');
        batch.set(docRef, {
          'productId': item.product.id,
          'productName': item.product.name,
          'price': item.product.price,
          'imageUrl': item.product.imageUrl,
          'category': item.product.category,
          'quantity': item.quantity,
          'size': item.size,
          'color': item.color,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
      await batch.commit();
    } catch (e) {
      debugPrint('Firestore cart sync error: $e');
    }
  }

  /// Sync user wishlist to Firestore
  Future<void> saveUserWishlist(String uid, List<Product> wishlist) async {
    if (_db == null) return;
    try {
      final wishlistRef = _db.collection('users').doc(uid).collection('wishlist');
      final batch = _db.batch();

      final existing = await wishlistRef.get();
      for (final doc in existing.docs) {
        batch.delete(doc.reference);
      }

      for (final product in wishlist) {
        final docRef = wishlistRef.doc('${product.id}');
        batch.set(docRef, {
          'productId': product.id,
          'name': product.name,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'category': product.category,
          'rating': product.rating,
          'addedAt': FieldValue.serverTimestamp(),
        });
      }
      await batch.commit();
    } catch (e) {
      debugPrint('Firestore wishlist sync error: $e');
    }
  }
}
