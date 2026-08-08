import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../state/auth_scope.dart';
import '../../theme/app_theme.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final auth = AuthScope.read(context);
      await auth.registerWithEmail(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Account created! Welcome, ${_nameController.text.trim()}!'),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        } else {
          Navigator.of(context).pushReplacement(
            CupertinoPageRoute<void>(
              builder: (_) => const LoginScreen(),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        final message = _cleanRegisterErrorMessage(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _cleanRegisterErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'email-already-in-use':
          return 'An account already exists with this email address. Please sign in.';
        case 'weak-password':
          return 'Password is too weak. Please use at least 6 characters.';
        case 'invalid-email':
          return 'Please enter a valid email address.';
        default:
          return error.message ?? 'Registration failed. Please try again.';
      }
    }
    final str = error.toString();
    if (str.contains('email-already-in-use')) {
      return 'An account already exists with this email address. Please sign in.';
    }
    return 'Registration failed. Please check your details and try again.';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // iOS Showcase Card Header
                  Center(
                    child: Container(
                      width: 220,
                      height: 160,
                      decoration: BoxDecoration(
                        color: isDark
                            ? theme.colorScheme.surfaceContainerHigh
                            : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(
                          color: theme.colorScheme.outlineVariant
                              .withValues(alpha: 0.4),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withValues(alpha: isDark ? 0.4 : 0.08),
                            blurRadius: 24,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: RadialGradient(
                                    center: Alignment.center,
                                    radius: 0.75,
                                    colors: [
                                      AppColors.primary.withValues(alpha: 0.15),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Image.network(
                                'https://fakestoreapi.com/img/71pWzhdJNwL._AC_UL640_QL65_ML3_.jpg',
                                fit: BoxFit.cover,
                                cacheWidth: 500,
                                cacheHeight: 500,
                                errorBuilder: (ctx, err, stack) => Image.asset(
                                  'assets/images/app_logo_icon.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 8, sigmaY: 8),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary
                                          .withValues(alpha: 0.85),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Text(
                                      'GEBEYA JOIN',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'Create Account',
                    textAlign: TextAlign.center,
                    style: AppTypography.headlineLg.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w900,
                      fontSize: 26,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Join Gebeya Luxe Marketplace to sync your cart, wishlist, and shipping across devices.',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyMd.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Full Name
                  TextFormField(
                    controller: _nameController,
                    style: AppTypography.bodyMd.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      hintText: 'Alex Johnson',
                      prefixIcon: const Icon(CupertinoIcons.person, size: 20),
                      filled: true,
                      fillColor: isDark
                          ? theme.colorScheme.surfaceContainerHigh
                          : theme.colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: theme.colorScheme.outlineVariant
                              .withValues(alpha: 0.5),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: theme.colorScheme.outlineVariant
                              .withValues(alpha: 0.4),
                        ),
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Enter your full name';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 14),

                  // Email Address
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: AppTypography.bodyMd.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      hintText: 'alex.johnson@example.com',
                      prefixIcon: const Icon(CupertinoIcons.mail, size: 20),
                      filled: true,
                      fillColor: isDark
                          ? theme.colorScheme.surfaceContainerHigh
                          : theme.colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: theme.colorScheme.outlineVariant
                              .withValues(alpha: 0.5),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: theme.colorScheme.outlineVariant
                              .withValues(alpha: 0.4),
                        ),
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) return 'Enter your email';
                      if (!val.contains('@')) return 'Enter a valid email address';
                      return null;
                    },
                  ),

                  const SizedBox(height: 14),

                  // Password
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: AppTypography.bodyMd.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(CupertinoIcons.lock, size: 20),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? CupertinoIcons.eye_slash
                              : CupertinoIcons.eye,
                          size: 20,
                        ),
                        onPressed: () =>
                            setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      filled: true,
                      fillColor: isDark
                          ? theme.colorScheme.surfaceContainerHigh
                          : theme.colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: theme.colorScheme.outlineVariant
                              .withValues(alpha: 0.5),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: theme.colorScheme.outlineVariant
                              .withValues(alpha: 0.4),
                        ),
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'Enter your password';
                      if (val.length < 6) return 'Password must be at least 6 characters';
                      return null;
                    },
                  ),

                  const SizedBox(height: 14),

                  // Confirm Password Field
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    style: AppTypography.bodyMd.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon:
                          const Icon(CupertinoIcons.lock_shield, size: 20),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? CupertinoIcons.eye_slash
                              : CupertinoIcons.eye,
                          size: 20,
                        ),
                        onPressed: () => setState(() =>
                            _obscureConfirmPassword = !_obscureConfirmPassword),
                      ),
                      filled: true,
                      fillColor: isDark
                          ? theme.colorScheme.surfaceContainerHigh
                          : theme.colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: theme.colorScheme.outlineVariant
                              .withValues(alpha: 0.5),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: theme.colorScheme.outlineVariant
                              .withValues(alpha: 0.4),
                        ),
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (val != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // Register Button
                  SizedBox(
                    height: 54,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.35),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Text(
                                'Register Account',
                                style: AppTypography.titleLg.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Sign In Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: AppTypography.bodyMd.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();
                          } else {
                            Navigator.of(context).pushReplacement(
                              CupertinoPageRoute<void>(
                                builder: (_) => const LoginScreen(),
                              ),
                            );
                          }
                        },
                        child: Text(
                          'Sign In',
                          style: AppTypography.labelLg.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
