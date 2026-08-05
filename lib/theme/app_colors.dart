import 'package:flutter/material.dart';

/// "Ember & Ivory" — an editorial, warm-minimal palette.
abstract final class AppColors {
  static const Color paper = Color(0xFFF5F1EA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color ink = Color(0xFF1C1914);
  static const Color stone = Color(0xFF8A8275);
  static const Color line = Color(0xFFE7E0D4);

  static const Color ember = Color(0xFFE2502B);
  static const Color emberDark = Color(0xFFB63A1D);
  static const Color emberSoft = Color(0xFFF7E3DC);

  static const Color cream = Color(0xFFF0E6D4);
  static const Color sage = Color(0xFFDDE7DF);
  static const Color blush = Color(0xFFF3E0E0);
  static const Color lavender = Color(0xFFE6E4F0);
  static const Color mist = Color(0xFFE4E9ED);

  /// Soft tint used behind each product photograph.
  static const Map<String, Color> categoryTints = {
    'electronics': sage,
    'jewelery': cream,
    "men's clothing": lavender,
    "women's clothing": blush,
  };

  static Color tintFor(String? category) =>
      categoryTints[category] ?? mist;

  static String labelFor(String category) => switch (category) {
        'electronics' => 'Electronics',
        'jewelery' => 'Jewelery',
        "men's clothing" => "Men's Edit",
        "women's clothing" => "Women's Edit",
        _ => category,
      };
}
