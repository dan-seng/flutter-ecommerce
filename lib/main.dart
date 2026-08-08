import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'services/auth_service.dart';
import 'services/fakestore_api.dart';
import 'state/auth_scope.dart';
import 'state/cart.dart';
import 'state/cart_scope.dart';
import 'state/theme_scope.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PaintingBinding.instance.imageCache.maximumSizeBytes = 100 * 1024 * 1024;
  PaintingBinding.instance.imageCache.maximumSize = 100;
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase init fallback: $e');
  }
  runApp(const GebeyaApp());
}

class GebeyaApp extends StatefulWidget {
  const GebeyaApp({super.key, this.repository, this.initialUser});

  final ProductRepository? repository;
  final AppUser? initialUser;

  @override
  State<GebeyaApp> createState() => _GebeyaAppState();
}

class _GebeyaAppState extends State<GebeyaApp> {
  final Cart _cart = Cart();
  late final AuthService _authService = AuthService(
    initialUser: widget.initialUser,
  );

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
                title: 'Gebeya',
                debugShowCheckedModeBanner: false,
                theme: buildAppTheme(),
                darkTheme: buildAppDarkTheme(),
                themeMode: themeController.themeMode,
                home: AppFlowGate(repository: widget.repository),
              );
            },
          ),
        ),
      ),
    );
  }
}

class AppFlowGate extends StatefulWidget {
  const AppFlowGate({super.key, this.repository});

  final ProductRepository? repository;

  @override
  State<AppFlowGate> createState() => _AppFlowGateState();
}

class _AppFlowGateState extends State<AppFlowGate> {
  bool? _hasSeenOnboarding;

  @override
  void initState() {
    super.initState();
    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_hasSeenOnboarding == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!_hasSeenOnboarding!) {
      return const OnboardingScreen();
    }

    final auth = AuthScope.watch(context);
    if (!auth.isLoggedIn) {
      return const LoginScreen();
    }

    return HomeScreen(repository: widget.repository);
  }
}
