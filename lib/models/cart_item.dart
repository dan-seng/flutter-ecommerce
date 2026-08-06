import 'product.dart';

class CartItem {
  const CartItem({
    required this.product,
    this.quantity = 1,
    this.size,
    this.color,
  });

  final Product product;
  final int quantity;
  final String? size;
  final String? color;

  double get lineTotal => product.price * quantity;

  CartItem copyWith({int? quantity, String? size, String? color}) {
    return CartItem(
      product: product,
      quantity: quantity ?? this.quantity,
      size: size ?? this.size,
      color: color ?? this.color,
    );
  }

  /// Two items form the same line when they share a product and options.
  bool sameLineAs(CartItem other) =>
      product.id == other.product.id &&
      size == other.size &&
      color == other.color;
}
