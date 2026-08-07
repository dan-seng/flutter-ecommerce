import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screens/home/home_screen.dart';
import 'services/auth_service.dart';
import 'services/fakestore_api.dart';
import 'state/auth_scope.dart';
import 'state/cart.dart';
import 'state/cart_scope.dart';
import 'state/theme_scope.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase init fallback: $e');
  }
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
  late final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return ThemeScope(
      child: AuthScope(
        notifier: _authService,
        child: CartScope(
          cart: _cart,
          child: Builder(
            builder: (context) {
              final themeController = ThemeScope.of(context);
              return MaterialApp(
                title: 'Gebeya Luxe',
                debugShowCheckedModeBanner: false,
                theme: buildAppTheme(),
                darkTheme: buildAppDarkTheme(),
                themeMode: themeController.themeMode,
                home: HomeScreen(repository: widget.repository),
              );
            },
          ),
        ),
      ),
    );
  }
}
