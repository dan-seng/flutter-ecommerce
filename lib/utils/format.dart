String formatPrice(double value) =>
    '\$${value.toStringAsFixed(value == value.roundToDouble() ? 0 : 2)}';
