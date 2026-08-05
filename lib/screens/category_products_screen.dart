import 'package:flutter/material.dart';

import '../models/product.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

class CategoryProductsScreen extends StatelessWidget {
  const CategoryProductsScreen({
    super.key,
    required this.category,
    required this.products,
  });

  final String category;
  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    final label = AppColors.labelFor(category);
    return Scaffold(
      backgroundColor: AppColors.paper,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.paper,
            surfaceTintColor: Colors.transparent,
            leading: _BackButton(onTap: () => Navigator.of(context).pop()),
            title: Text(
              label,
              style: AppTheme.serifStyle(size: 20, weight: FontWeight.w600),
            ),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Text(
                    '${products.length}',
                    style: AppTheme.sansStyle(
                        size: 12.5,
                        weight: FontWeight.w600,
                        color: AppColors.stone),
                  ),
                ),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 14,
                childAspectRatio: 0.60,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, i) {
                  final product = products[i];
                  return ProductCard(
                    product: product,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ProductDetailScreen(product: product),
                      ),
                    ),
                  );
                },
                childCount: products.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        color: AppColors.surface,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: const SizedBox(
            width: 40,
            height: 40,
            child: Icon(Icons.arrow_back_rounded, size: 21, color: AppColors.ink),
          ),
        ),
      ),
    );
  }
}
