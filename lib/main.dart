import 'package:flutter/material.dart';

import 'screens/home/home_screen.dart';
import 'services/fakestore_api.dart';
import 'state/cart.dart';
import 'state/cart_scope.dart';
import 'state/theme_scope.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const GebeyaApp());
}

class GebeyaApp extends StatefulWidget {
  const GebeyaApp({super.key, this.repository});

  final ProductRepository? repository;

  @override
  State<GebeyaApp> createState() => _GebeyaAppState();
}

class _GebeyaAppState extends State<GebeyaApp> {
  final Cart _cart = Cart();

  @override
  Widget build(BuildContext context) {
    return ThemeScope(
      child: CartScope(
        cart: _cart,
        child: Builder(
          builder: (context) {
            final themeController = ThemeScope.of(context);
            return MaterialApp(
              title: 'Indigo',
              debugShowCheckedModeBanner: false,
              theme: buildAppTheme(),
              darkTheme: buildAppDarkTheme(),
              themeMode: themeController.themeMode,
              home: HomeScreen(repository: widget.repository),
            );
          },
        ),
      ),
    );
  }
}
