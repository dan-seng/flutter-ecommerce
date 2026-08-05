import 'package:flutter/material.dart';

import '../models/product.dart';
import '../state/scopes.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import 'product_image.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cart = CartScope.of(context);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: ProductImage(product: product),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: _QuickAddButton(
                    onTap: () {
                      cart.add(product);
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            content: Text('Added to bag · ${product.title}'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            AppColors.labelFor(product.category).toUpperCase(),
            style: AppTheme.sansStyle(
              size: 9.5,
              weight: FontWeight.w600,
              color: AppColors.stone,
              letterSpacing: 1.8,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 3),
          Text(
            product.title,
            style: AppTheme.sansStyle(
              size: 13,
              weight: FontWeight.w600,
              height: 1.25,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Text(
                formatPrice(product.price),
                style: AppTheme.sansStyle(
                  size: 14,
                  weight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
              const Spacer(),
              const Icon(Icons.star_rounded, size: 13, color: Color(0xFFD9A33A)),
              const SizedBox(width: 2),
              Text(
                product.rating.toStringAsFixed(1),
                style: AppTheme.sansStyle(
                  size: 11,
                  weight: FontWeight.w600,
                  color: AppColors.stone,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickAddButton extends StatelessWidget {
  const _QuickAddButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.ink.withValues(alpha: 0.10),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.add_rounded,
            size: 20,
            color: AppColors.ink,
          ),
        ),
      ),
    );
  }
}
