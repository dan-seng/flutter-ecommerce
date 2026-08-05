import 'package:flutter/material.dart';

import 'cart_controller.dart';
import 'catalog_controller.dart';

class CartScope extends InheritedNotifier<CartController> {
  const CartScope({
    super.key,
    required CartController controller,
    required super.child,
  }) : super(notifier: controller);

  static CartController of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<CartScope>()!
      .notifier!;
}

class CatalogScope extends InheritedNotifier<CatalogController> {
  const CatalogScope({
    super.key,
    required CatalogController controller,
    required super.child,
  }) : super(notifier: controller);

  static CatalogController of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<CatalogScope>()!
      .notifier!;
}

class ShellScope extends InheritedNotifier<ShellController> {
  const ShellScope({
    super.key,
    required ShellController controller,
    required super.child,
  }) : super(notifier: controller);

  static ShellController of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<ShellScope>()!
      .notifier!;
}

/// Controls which tab the root shell shows.
class ShellController extends ChangeNotifier {
  int _index = 0;
  int get index => _index;

  void setIndex(int value) {
    if (value == _index) return;
    _index = value;
    notifyListeners();
  }
}
