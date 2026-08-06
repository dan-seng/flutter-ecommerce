import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class IndigoBottomNavBar extends StatelessWidget {
  const IndigoBottomNavBar({
    super.key,
    required this.currentIndex,
    this.onSelect,
    this.cartCount = 0,
  });

  final int currentIndex;
  final ValueChanged<int>? onSelect;
  final int cartCount;

  static const _cartTabIndex = 3;

  static const _items = [
    (
      icon: CupertinoIcons.house,
      activeIcon: CupertinoIcons.house_fill,
      label: 'Home'
    ),
    (
      icon: CupertinoIcons.compass,
      activeIcon: CupertinoIcons.compass_fill,
      label: 'Explore'
    ),
    (
      icon: CupertinoIcons.heart,
      activeIcon: CupertinoIcons.heart_fill,
      label: 'Wishlist'
    ),
    (
      icon: CupertinoIcons.bag,
      activeIcon: CupertinoIcons.bag_fill,
      label: 'Cart'
    ),
    (
      icon: CupertinoIcons.person,
      activeIcon: CupertinoIcons.person_fill,
      label: 'Profile'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: 70,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 24,
              spreadRadius: 0,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.72),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.8),
                  width: 1.2,
                ),
              ),
              child: Row(
                children: List.generate(_items.length, (index) {
                  final item = _items[index];
                  final active = index == currentIndex;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => onSelect?.call(index),
                      behavior: HitTestBehavior.opaque,
                      child: Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOutCubic,
                          padding: EdgeInsets.symmetric(
                            horizontal: active ? 14 : 8,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: active
                                ? AppColors.primary.withValues(alpha: 0.12)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(18),
                            border: active
                                ? Border.all(
                                    color: AppColors.primary.withValues(alpha: 0.2),
                                    width: 1,
                                  )
                                : null,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 24,
                                width: 28,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  alignment: Alignment.center,
                                  children: [
                                    AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 200),
                                      child: Icon(
                                        active ? item.activeIcon : item.icon,
                                        key: ValueKey<bool>(active),
                                        size: 22,
                                        color: active
                                            ? AppColors.primary
                                            : AppColors.onSurfaceVariant
                                                .withValues(alpha: 0.7),
                                      ),
                                    ),
                                    if (index == _cartTabIndex && cartCount > 0)
                                      Positioned(
                                        top: -6,
                                        right: -8,
                                        child: _CartBadge(count: cartCount),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 3),
                              AnimatedDefaultTextStyle(
                                duration: const Duration(milliseconds: 200),
                                style: AppTypography.labelMd.copyWith(
                                  fontSize: 10,
                                  fontWeight:
                                      active ? FontWeight.w700 : FontWeight.w500,
                                  color: active
                                      ? AppColors.primary
                                      : AppColors.onSurfaceVariant
                                          .withValues(alpha: 0.7),
                                ),
                                child: Text(item.label),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CartBadge extends StatelessWidget {
  const _CartBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: AppColors.accentGradient,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.4),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: Text(
        '$count',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w800,
          height: 1.1,
        ),
      ),
    );
  }
}
