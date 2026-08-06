import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  static const _stats = [
    (value: '12', label: 'Orders', icon: CupertinoIcons.cube_box_fill),
    (value: '8', label: 'Wishlist', icon: CupertinoIcons.heart_fill),
    (value: '4', label: 'Reviews', icon: CupertinoIcons.star_fill),
  ];

  static const _accountItems = [
    (icon: CupertinoIcons.tickets, label: 'My Orders', badge: '12'),
    (icon: CupertinoIcons.heart, label: 'My Wishlist', badge: '8'),
    (icon: CupertinoIcons.location, label: 'Shipping Address', badge: '2 saved'),
    (icon: CupertinoIcons.creditcard, label: 'Payment Methods', badge: 'Visa ••• 4242'),
  ];

  static const _generalItems = [
    (icon: CupertinoIcons.gear, label: 'Settings', badge: null),
    (icon: CupertinoIcons.bell, label: 'Notifications', badge: 'On'),
    (icon: CupertinoIcons.question_circle, label: 'Help & Support', badge: '24/7'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _ProfileHeader(onBack: () => Navigator.of(context).pop()),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                children: [
                  const _ProfileCard(),
                  const SizedBox(height: 16),
                  const _StatsRow(stats: _stats),
                  const SizedBox(height: 20),
                  const _QuickShortcutsGrid(),
                  const SizedBox(height: 24),
                  _MenuSection(title: 'Account', items: _accountItems),
                  const SizedBox(height: 20),
                  _MenuSection(
                    title: 'Preferences',
                    items: _generalItems,
                    extraTiles: [
                      _SwitchTile(
                        icon: CupertinoIcons.bell_fill,
                        label: 'Push Notifications',
                        value: _notificationsEnabled,
                        onChanged: (val) =>
                            setState(() => _notificationsEnabled = val),
                      ),
                      _SwitchTile(
                        icon: CupertinoIcons.moon_fill,
                        label: 'Dark Mode',
                        value: _darkModeEnabled,
                        onChanged: (val) =>
                            setState(() => _darkModeEnabled = val),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  const _SignOutButton(),
                  const SizedBox(height: 24),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'GEBEYA LUXE MARKETPLACE',
                          style: AppTypography.labelMd.copyWith(
                            color: AppColors.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Version 2.4.0 (Build 892) • iOS Frosted Glass Edition',
                          style: AppTypography.bodyMd.copyWith(
                            color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        border: Border(
          bottom: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        children: [
          if (Navigator.of(context).canPop()) ...[
            Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: onBack,
                customBorder: const CircleBorder(),
                child: const SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(
                    CupertinoIcons.chevron_back,
                    color: AppColors.onSurface,
                    size: 22,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 4),
          ],
          Expanded(
            child: Text(
              'Profile',
              style: AppTypography.headlineMd.copyWith(
                color: AppColors.onBackground,
                fontWeight: FontWeight.w800,
                fontSize: 22,
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: () => _showComingSoon(context, 'Notifications Settings'),
              customBorder: const CircleBorder(),
              child: Stack(
                children: [
                  const SizedBox(
                    width: 40,
                    height: 40,
                    child: Icon(
                      CupertinoIcons.bell,
                      color: AppColors.onSurface,
                      size: 22,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 3.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'A',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 2,
                bottom: 2,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        'Alex Johnson',
                        style: AppTypography.headlineMd.copyWith(
                          color: AppColors.onBackground,
                          fontWeight: FontWeight.w800,
                          fontSize: 19,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      CupertinoIcons.checkmark_seal_fill,
                      size: 16,
                      color: AppColors.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'alex.johnson@example.com',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.bodyMd.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFF59E0B).withValues(alpha: 0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        CupertinoIcons.star_fill,
                        size: 11,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'VIP GOLD MEMBER',
                        style: AppTypography.labelMd.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: () => _showComingSoon(context, 'Edit Profile'),
              customBorder: const CircleBorder(),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
                child: const Center(
                  child: Icon(
                    CupertinoIcons.pencil,
                    size: 17,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.stats});

  final List<({String value, String label, IconData icon})> stats;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: List.generate(stats.length * 2 - 1, (i) {
          if (i.isOdd) {
            return Container(
              width: 1,
              height: 32,
              color: AppColors.outlineVariant.withValues(alpha: 0.3),
            );
          }
          final stat = stats[i ~/ 2];
          return Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(stat.icon, size: 14, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      stat.value,
                      style: AppTypography.headlineMd.copyWith(
                        color: AppColors.onBackground,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  stat.label,
                  style: AppTypography.bodyMd.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _QuickShortcutsGrid extends StatelessWidget {
  const _QuickShortcutsGrid();

  static const _items = [
    (icon: CupertinoIcons.cube_box, label: 'Track Order', color: AppColors.primary),
    (icon: CupertinoIcons.tag, label: 'Vouchers', color: Color(0xFF10B981)),
    (icon: CupertinoIcons.creditcard, label: 'Gebeya Pay', color: Color(0xFFF59E0B)),
    (icon: CupertinoIcons.chat_bubble_2, label: 'Support', color: AppColors.accent),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_items.length, (index) {
        final item = _items[index];
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: index == _items.length - 1 ? 0 : 10),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => _showComingSoon(context, item.label),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: AppColors.outlineVariant.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: item.color.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(item.icon, size: 20, color: item.color),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.labelMd.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _MenuSection extends StatelessWidget {
  const _MenuSection({
    required this.title,
    required this.items,
    this.extraTiles,
  });

  final String title;
  final List<({IconData icon, String label, String? badge})> items;
  final List<Widget>? extraTiles;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 6, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: AppTypography.labelLg.copyWith(
              color: AppColors.outline,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: AppColors.outlineVariant.withValues(alpha: 0.4),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              ...List.generate(items.length, (index) {
                final item = items[index];
                final isLast = index == items.length - 1 && (extraTiles == null || extraTiles!.isEmpty);
                return Column(
                  children: [
                    _MenuTile(
                      icon: item.icon,
                      label: item.label,
                      badge: item.badge,
                    ),
                    if (!isLast)
                      Container(
                        height: 1,
                        margin: const EdgeInsets.only(left: 58),
                        color: AppColors.outlineVariant.withValues(alpha: 0.25),
                      ),
                  ],
                );
              }),
              if (extraTiles != null)
                ...List.generate(extraTiles!.length, (index) {
                  final tile = extraTiles![index];
                  final isLast = index == extraTiles!.length - 1;
                  return Column(
                    children: [
                      tile,
                      if (!isLast)
                        Container(
                          height: 1,
                          margin: const EdgeInsets.only(left: 58),
                          color: AppColors.outlineVariant.withValues(alpha: 0.25),
                        ),
                    ],
                  );
                }),
            ],
          ),
        ),
      ],
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.label,
    this.badge,
  });

  final IconData icon;
  final String label;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showComingSoon(context, label),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 18, color: AppColors.primary),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: AppTypography.bodyLg.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
            if (badge != null) ...[
              Text(
                badge!,
                style: AppTypography.bodyMd.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
            ],
            const Icon(
              CupertinoIcons.chevron_right,
              size: 16,
              color: AppColors.outline,
            ),
          ],
        ),
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: AppTypography.bodyLg.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
          CupertinoSwitch(
            value: value,
            activeTrackColor: AppColors.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _SignOutButton extends StatelessWidget {
  const _SignOutButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.errorContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.25),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text('Signed out (demo)'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
          },
          child: SizedBox(
            height: 52,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  CupertinoIcons.square_arrow_right,
                  size: 20,
                  color: AppColors.onErrorContainer,
                ),
                const SizedBox(width: 8),
                Text(
                  'Sign Out',
                  style: AppTypography.titleLg.copyWith(
                    color: AppColors.onErrorContainer,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _showComingSoon(BuildContext context, String feature) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text('$feature is coming soon'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1200),
      ),
    );
}
