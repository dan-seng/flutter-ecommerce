import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Pill-shaped quantity selector.
class QtyStepper extends StatelessWidget {
  const QtyStepper({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    this.dense = false,
    this.inverted = false,
  });

  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final bool dense;
  final bool inverted;

  @override
  Widget build(BuildContext context) {
    final fg = inverted ? Colors.white : AppColors.ink;
    final size = dense ? 26.0 : 32.0;
    final iconSize = dense ? 14.0 : 17.0;

    Widget button(IconData icon, VoidCallback onTap) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            child: Icon(icon, size: iconSize, color: fg),
          ),
        ),
      );
    }

    return Container(
      height: dense ? 34 : 42,
      decoration: BoxDecoration(
        color: inverted ? Colors.white.withValues(alpha: 0.14) : AppColors.paper,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: inverted ? Colors.white.withValues(alpha: 0.35) : AppColors.line,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          button(Icons.remove_rounded, onDecrement),
          Text(
            '$quantity',
            style: AppTheme.sansStyle(
              size: dense ? 13 : 15,
              weight: FontWeight.w700,
              color: fg,
            ),
          ),
          button(Icons.add_rounded, onIncrement),
        ],
      ),
    );
  }
}
