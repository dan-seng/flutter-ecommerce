import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/product.dart';
import '../theme/app_colors.dart';

/// Rounded, tinted stage behind a product photograph.
class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    required this.product,
    this.radius = 22,
    this.padding = const EdgeInsets.all(16),
    this.enableHero = true,
  });

  final Product product;
  final double radius;
  final EdgeInsets padding;
  final bool enableHero;

  @override
  Widget build(BuildContext context) {
    final image = CachedNetworkImage(
      imageUrl: product.image,
      fit: BoxFit.contain,
      fadeInDuration: const Duration(milliseconds: 250),
      placeholder: (_, _) => Container(
        color: AppColors.tintFor(product.category),
        child: Center(
          child: Icon(
            Icons.image_outlined,
            size: 26,
            color: AppColors.ink.withValues(alpha: 0.22),
          ),
        ),
      ),
      errorWidget: (_, _, _) => Container(
        color: AppColors.tintFor(product.category),
        child: Center(
          child: Icon(
            Icons.broken_image_outlined,
            size: 26,
            color: AppColors.ink.withValues(alpha: 0.22),
          ),
        ),
      ),
    );

    final stage = Container(
      decoration: BoxDecoration(
        color: AppColors.tintFor(product.category),
        borderRadius: BorderRadius.circular(radius),
      ),
      padding: padding,
      clipBehavior: Clip.antiAlias,
      child: image,
    );

    return enableHero
        ? Hero(tag: 'product-${product.id}', child: stage)
        : stage;
  }
}
