String formatMoney(double value) => '\$${value.toStringAsFixed(2)}';

String formatCount(int count) {
  if (count >= 1000) {
    final value = count / 1000;
    return '${value.toStringAsFixed(value >= 10 ? 0 : 1)}k';
  }
  return count.toString();
}
