import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Typographic + theming helpers for the Ember storefront.
abstract final class AppTheme {
  static const String serif = 'Fraunces';
  static const String sans = 'Inter';

  static TextStyle serifStyle({
    double size = 20,
    FontWeight weight = FontWeight.w600,
    Color color = AppColors.ink,
    double height = 1.12,
    double? letterSpacing,
    FontStyle style = FontStyle.normal,
  }) =>
      TextStyle(
        fontFamily: serif,
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
        fontStyle: style,
      );

  static TextStyle sansStyle({
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.ink,
    double height = 1.4,
    double? letterSpacing,
  }) =>
      TextStyle(
        fontFamily: sans,
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
      );

  /// Small-caps eyebrow label used above section titles.
  static TextStyle eyebrow(Color color) => sansStyle(
        size: 10.5,
        weight: FontWeight.w600,
        color: color,
        letterSpacing: 2.2,
      );

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.ember,
      brightness: Brightness.light,
      surface: AppColors.surface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: sans,
      scaffoldBackgroundColor: AppColors.paper,
      colorScheme: scheme.copyWith(
        surface: AppColors.surface,
        onSurface: AppColors.ink,
        primary: AppColors.ember,
        onPrimary: Colors.white,
        outline: AppColors.line,
      ),
      splashFactory: InkSparkle.splashFactory,
      textTheme: Typography.material2021(platform: TargetPlatform.android)
          .black
          .apply(fontFamily: sans, bodyColor: AppColors.ink)
          .copyWith(
            displayLarge: serifStyle(size: 44, weight: FontWeight.w600, height: 1.04),
            headlineLarge: serifStyle(size: 34, weight: FontWeight.w600, height: 1.08),
            headlineMedium: serifStyle(size: 26, weight: FontWeight.w600, height: 1.12),
            headlineSmall: serifStyle(size: 20, weight: FontWeight.w600, height: 1.15),
            titleLarge: serifStyle(size: 18, weight: FontWeight.w600, height: 1.2),
            titleMedium: sansStyle(size: 16, weight: FontWeight.w600),
            bodyLarge: sansStyle(size: 15),
            bodyMedium: sansStyle(size: 14),
            bodySmall: sansStyle(size: 12.5),
            labelLarge: sansStyle(size: 14.5, weight: FontWeight.w600, letterSpacing: 0.2),
            labelMedium: sansStyle(size: 12, weight: FontWeight.w600, letterSpacing: 0.4),
          ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.ink,
        contentTextStyle: sansStyle(size: 14, weight: FontWeight.w500, color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
