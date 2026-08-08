import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../state/auth_scope.dart';
import '../../theme/app_theme.dart';
import 'register_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final auth = AuthScope.read(context);
      await auth.sendPasswordReset(_emailController.text.trim());

      if (mounted) {
        setState(() {
          _emailSent = true;
        });
      }
    } catch (e) {
      if (mounted) {
        final message = _cleanResetErrorMessage(e);
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

  String _cleanResetErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No account found matching this email address.';
        case 'invalid-email':
          return 'Please enter a valid email address.';
        default:
          return error.message ?? 'Failed to send password reset email.';
      }
    }
    return 'Failed to send reset link. Please check your email and try again.';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.back,
            color: theme.colorScheme.onSurface,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: _emailSent
                ? _buildSuccessView(theme, isDark)
                : _buildResetFormView(theme, isDark),
          ),
        ),
      ),
    );
  }

  Widget _buildResetFormView(ThemeData theme, bool isDark) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Security Header Card
          Center(
            child: Container(
              width: 180,
              height: 140,
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
                              AppColors.primary.withValues(alpha: 0.2),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Icon(
                      CupertinoIcons.lock_shield_fill,
                      size: 64,
                      color: AppColors.primary,
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary
                                  .withValues(alpha: 0.85),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'SECURITY',
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
            'Reset Password',
            textAlign: TextAlign.center,
            style: AppTypography.headlineLg.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w900,
              fontSize: 26,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter your registered email address below. We will send you an official password reset link.',
            textAlign: TextAlign.center,
            style: AppTypography.bodyMd.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 32),

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

          const SizedBox(height: 24),

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
                onPressed: _isLoading ? null : _handleResetPassword,
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
                        'Send Reset Link',
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

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Remembered your password? ',
                style: AppTypography.bodyMd.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
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
    );
  }

  Widget _buildSuccessView(ThemeData theme, bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF10B981).withValues(alpha: 0.4),
                width: 2,
              ),
            ),
            child: const Icon(
              CupertinoIcons.checkmark_seal_fill,
              size: 56,
              color: Color(0xFF10B981),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Check Your Email',
          textAlign: TextAlign.center,
          style: AppTypography.headlineLg.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w900,
            fontSize: 26,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'We have sent a password reset link to:',
          textAlign: TextAlign.center,
          style: AppTypography.bodyMd.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          _emailController.text.trim(),
          textAlign: TextAlign.center,
          style: AppTypography.titleLg.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Click the link in the email to set up your new password.',
          textAlign: TextAlign.center,
          style: AppTypography.bodyMd.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark
                ? theme.colorScheme.surfaceContainerHigh
                : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
            ),
          ),
          child: Row(
            children: [
              const Icon(CupertinoIcons.info_circle,
                  color: AppColors.primary, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Didn't see it? Please check your Spam / Junk folder. (Note: Email must be registered in Firebase Auth Console to receive reset links).",
                  style: AppTypography.bodyMd.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 52,
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'Back to Sign In',
              style: AppTypography.titleLg.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              CupertinoPageRoute<void>(
                builder: (_) => const RegisterScreen(),
              ),
            );
          },
          style: OutlinedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            side: BorderSide(
              color: theme.colorScheme.outlineVariant,
            ),
          ),
          child: Text(
            'New here? Create Account',
            style: AppTypography.labelLg.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
