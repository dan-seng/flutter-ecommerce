import 'package:flutter/material.dart';

import '../state/scopes.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import 'cart_screen.dart';
import 'home_screen.dart';
import 'collections_screen.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    final shell = ShellScope.of(context);
    return ListenableBuilder(
      listenable: shell,
      builder: (context, _) {
        return Scaffold(
          extendBody: true,
          body: IndexedStack(
            index: shell.index,
            children: const [
              HomeScreen(),
              CollectionsScreen(),
              CartScreen(),
            ],
          ),
          bottomNavigationBar: _ShellBar(
            index: shell.index,
            onChanged: shell.setIndex,
          ),
        );
      },
    );
  }
}

class _ShellBar extends StatelessWidget {
  const _ShellBar({required this.index, required this.onChanged});

  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final cart = CartScope.of(context);
    final count = cart.count;

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 0, 24, 18 + MediaQuery.of(context).viewPadding.bottom),
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.ink.withValues(alpha: 0.10),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            _BarItem(
              icon: Icons.home_outlined,
              activeIcon: Icons.home_rounded,
              label: 'Home',
              active: index == 0,
              onTap: () => onChanged(0),
            ),
            _BarItem(
              icon: Icons.grid_view_outlined,
              activeIcon: Icons.grid_view_rounded,
              label: 'Explore',
              active: index == 1,
              onTap: () => onChanged(1),
            ),
            Expanded(
              child: _BarItem(
                icon: Icons.shopping_bag_outlined,
                activeIcon: Icons.shopping_bag_rounded,
                label: 'Bag',
                badge: count,
                active: index == 2,
                onTap: () => onChanged(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BarItem extends StatelessWidget {
  const _BarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.active,
    required this.onTap,
    this.badge = 0,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  final int badge;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.ink : AppColors.stone;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: Icon(
                    active ? activeIcon : icon,
                    key: ValueKey(active),
                    size: 23,
                    color: color,
                  ),
                ),
                const SizedBox(height: 3),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 180),
                  style: AppTheme.sansStyle(
                    size: 10.5,
                    weight: active ? FontWeight.w700 : FontWeight.w500,
                    color: color,
                    letterSpacing: 0.4,
                  ),
                  child: Text(label),
                ),
              ],
            ),
            if (badge > 0)
              Positioned(
                right: 20,
                top: 8,
                child: Container(
                  constraints: const BoxConstraints(minWidth: 17, minHeight: 17),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.ember,
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(color: AppColors.surface, width: 1.6),
                  ),
                  child: Text(
                    '$badge',
                    style: AppTheme.sansStyle(
                      size: 10,
                      weight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
