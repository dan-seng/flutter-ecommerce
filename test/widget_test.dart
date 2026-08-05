import 'package:flutter_test/flutter_test.dart';

import 'package:dan/models/product.dart';
import 'package:dan/state/cart_controller.dart';

void main() {
  final product = Product(
    id: 1,
    title: 'Test Product',
    price: 25.5,
    description: 'A fine product.',
    category: 'electronics',
    image: 'https://example.com/image.png',
    rating: 4.5,
    ratingCount: 10,
  );

  group('CartController', () {
    test('adds and increments quantities', () {
      final cart = CartController();
      cart.add(product);
      cart.add(product, quantity: 2);

      expect(cart.count, 3);
      expect(cart.subtotal, closeTo(76.5, 0.001));
      expect(cart.lines.single.quantity, 3);
    });

    test('decrement removes at one', () {
      final cart = CartController();
      cart.add(product);
      cart.decrement(product);

      expect(cart.isEmpty, isTrue);
    });

    test('remove and clear', () {
      final cart = CartController();
      cart.add(product, quantity: 2);
      cart.remove(product);
      expect(cart.isEmpty, isTrue);

      cart.add(product);
      cart.clear();
      expect(cart.isEmpty, isTrue);
    });
  });

  group('Product.fromJson', () {
    test('parses the fake store shape', () {
      final p = Product.fromJson({
        'id': 1,
        'title': 'T',
        'price': 109.95,
        'description': 'D',
        'category': "men's clothing",
        'image': 'https://i.imgur.com/1.png',
        'rating': {'rate': 3.9, 'count': 120},
      });

      expect(p.id, 1);
      expect(p.price, 109.95);
      expect(p.rating, 3.9);
      expect(p.ratingCount, 120);
    });
  });
}
