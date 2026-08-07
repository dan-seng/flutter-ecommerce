import 'package:flutter/material.dart';

/// Design tokens extracted from the "Obsidian Gold Luxe Market" design system.
abstract class AppColors {
  // Ultra-Luxe Gold & Warm Amber Palette (Replacing Blue)
  static const primary = Color(0xFFD97706);
  static const primaryLight = Color(0xFFF59E0B);
  static const primaryDark = Color(0xFFB45309);
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryContainer = Color(0xFFFEF3C7);
  static const onPrimaryContainer = Color(0xFF78350F);
  static const inversePrimary = Color(0xFFFDE68A);

  static const secondary = Color(0xFF059669);
  static const onSecondary = Color(0xFFFFFFFF);
  static const secondaryContainer = Color(0xFFD1D5DB);
  static const onSecondaryContainer = Color(0xFF065F46);

  static const tertiary = Color(0xFFB45309);
  static const onTertiary = Color(0xFFFFFFFF);
  static const tertiaryContainer = Color(0xFFFFFBEB);
  static const onTertiaryContainer = Color(0xFF78350F);

  static const accent = Color(0xFFF59E0B);

  static const error = Color(0xFFEF4444);
  static const onError = Color(0xFFFFFFFF);
  static const errorContainer = Color(0xFFFEE2E2);
  static const onErrorContainer = Color(0xFF991B1B);

  static const background = Color(0xFFF8FAFC);
  static const onBackground = Color(0xFF0F172A);

  static const surface = Color(0xFFFFFFFF);
  static const onSurface = Color(0xFF0F172A);
  static const surfaceVariant = Color(0xFFF1F5F9);
  static const onSurfaceVariant = Color(0xFF64748B);

  static const outline = Color(0xFF94A3B8);
  static const outlineVariant = Color(0xFFE2E8F0);

  static const surfaceContainerLowest = Color(0xFFFFFFFF);
  static const surfaceContainerLow = Color(0xFFF8FAFC);
  static const surfaceContainer = Color(0xFFF1F5F9);
  static const surfaceContainerHigh = Color(0xFFE2E8F0);
  static const surfaceContainerHighest = Color(0xFFCBD5E1);

  static const inverseSurface = Color(0xFF1E293B);
  static const onInverseSurface = Color(0xFFF8FAFC);

  static const searchField = Color(0xFFF1F5F9);
  static const chipInactive = Color(0xFFF1F5F9);
  static const starRating = Color(0xFFF59E0B);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFD97706), Color(0xFFF59E0B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFB45309)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassBannerGradient = LinearGradient(
    colors: [Color(0xCC0F172A), Color(0x330F172A)],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
  );
}

class AppTypography {
  static const fontFamily = 'Inter';

  static const displayLg = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 40 / 32,
    letterSpacing: -0.02,
  );
  static const headlineLg = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 32 / 24,
    letterSpacing: -0.01,
  );
  static const headlineMd = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 28 / 20,
  );
  static const headlineLgMobile = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 28 / 22,
  );
  static const titleLg = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 24 / 18,
  );
  static const bodyLg = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
  );
  static const bodyMd = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
  );
  static const labelLg = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 20 / 14,
    letterSpacing: 0.01,
  );
  static const labelMd = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 16 / 12,
  );
}

ThemeData buildAppTheme() {
  final colorScheme = ColorScheme.light(
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.onPrimaryContainer,
    inversePrimary: AppColors.inversePrimary,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    secondaryContainer: AppColors.secondaryContainer,
    onSecondaryContainer: AppColors.onSecondaryContainer,
    tertiary: AppColors.tertiary,
    onTertiary: AppColors.onTertiary,
    tertiaryContainer: AppColors.tertiaryContainer,
    onTertiaryContainer: AppColors.onTertiaryContainer,
    error: AppColors.error,
    onError: AppColors.onError,
    errorContainer: AppColors.errorContainer,
    onErrorContainer: AppColors.onErrorContainer,
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    surfaceContainerHighest: AppColors.surfaceVariant,
    onSurfaceVariant: AppColors.onSurfaceVariant,
    surfaceContainerLow: AppColors.surfaceContainerLow,
    surfaceContainer: AppColors.surfaceContainer,
    surfaceContainerHigh: AppColors.surfaceContainerHigh,
    surfaceContainerLowest: AppColors.surfaceContainerLowest,
    outline: AppColors.outline,
    outlineVariant: AppColors.outlineVariant,
    inverseSurface: AppColors.inverseSurface,
    onInverseSurface: AppColors.onInverseSurface,
    surfaceTint: AppColors.primary,
  );

  final base = ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    fontFamily: AppTypography.fontFamily,
  );

  return base.copyWith(
    scaffoldBackgroundColor: AppColors.background,
    textTheme: base.textTheme.copyWith(
      displayLarge: AppTypography.displayLg,
      headlineLarge: AppTypography.headlineLg,
      headlineMedium: AppTypography.headlineMd,
      headlineSmall: AppTypography.headlineLgMobile,
      titleLarge: AppTypography.titleLg,
      bodyLarge: AppTypography.bodyLg,
      bodyMedium: AppTypography.bodyMd,
      labelLarge: AppTypography.labelLg,
      labelMedium: AppTypography.labelMd,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.primary,
      selectionColor: AppColors.inversePrimary,
      selectionHandleColor: AppColors.primary,
    ),
    splashFactory: InkSparkle.splashFactory,
  );
}

ThemeData buildAppDarkTheme() {
  final colorScheme = ColorScheme.dark(
    primary: AppColors.primaryLight,
    onPrimary: Colors.white,
    primaryContainer: const Color(0xFF78350F),
    onPrimaryContainer: const Color(0xFFFDE68A),
    secondary: AppColors.secondary,
    onSecondary: Colors.white,
    surface: const Color(0xFF0F172A),
    onSurface: const Color(0xFFF8FAFC),
    surfaceContainerHighest: const Color(0xFF1E293B),
    onSurfaceVariant: const Color(0xFF94A3B8),
    outline: const Color(0xFF475569),
    outlineVariant: const Color(0xFF334155),
    error: AppColors.error,
    onError: Colors.white,
  );

  final base = ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    fontFamily: AppTypography.fontFamily,
    brightness: Brightness.dark,
  );

  return base.copyWith(
    scaffoldBackgroundColor: const Color(0xFF020617),
    textTheme: base.textTheme.copyWith(
      displayLarge: AppTypography.displayLg.copyWith(color: const Color(0xFFF8FAFC)),
      headlineLarge: AppTypography.headlineLg.copyWith(color: const Color(0xFFF8FAFC)),
      headlineMedium: AppTypography.headlineMd.copyWith(color: const Color(0xFFF8FAFC)),
      headlineSmall: AppTypography.headlineLgMobile.copyWith(color: const Color(0xFFF8FAFC)),
      titleLarge: AppTypography.titleLg.copyWith(color: const Color(0xFFF8FAFC)),
      bodyLarge: AppTypography.bodyLg.copyWith(color: const Color(0xFFE2E8F0)),
      bodyMedium: AppTypography.bodyMd.copyWith(color: const Color(0xFFCBD5E1)),
      labelLarge: AppTypography.labelLg.copyWith(color: const Color(0xFFF8FAFC)),
      labelMedium: AppTypography.labelMd.copyWith(color: const Color(0xFF94A3B8)),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.primaryLight,
      selectionColor: Color(0xFFB45309),
      selectionHandleColor: AppColors.primaryLight,
    ),
    splashFactory: InkSparkle.splashFactory,
  );
}
