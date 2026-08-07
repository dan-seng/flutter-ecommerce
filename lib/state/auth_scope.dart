import 'package:flutter/widgets.dart';
import '../services/auth_service.dart';

class AuthScope extends InheritedNotifier<AuthService> {
  const AuthScope({
    super.key,
    required AuthService super.notifier,
    required super.child,
  });

  static AuthService watch(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AuthScope>();
    assert(scope != null, 'No AuthScope found in context');
    return scope!.notifier!;
  }

  static AuthService read(BuildContext context) {
    final element =
        context.getElementForInheritedWidgetOfExactType<AuthScope>();
    final scope = element?.widget as AuthScope?;
    assert(scope != null, 'No AuthScope found in context');
    return scope!.notifier!;
  }
}
