import 'package:flutter/material.dart';

import 'screens/app_shell.dart';
import 'state/cart_controller.dart';
import 'state/catalog_controller.dart';
import 'state/scopes.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(DanApp(
    cart: CartController(),
    catalog: CatalogController(),
    shell: ShellController(),
  ));
}

class DanApp extends StatelessWidget {
  const DanApp({
    super.key,
    required this.cart,
    required this.catalog,
    required this.shell,
  });

  final CartController cart;
  final CatalogController catalog;
  final ShellController shell;

  @override
  Widget build(BuildContext context) {
    return CartScope(
      controller: cart,
      child: CatalogScope(
        controller: catalog,
        child: ShellScope(
          controller: shell,
          child: MaterialApp(
            title: 'Ember',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            home: const AppShell(),
          ),
        ),
      ),
    );
  }
}
