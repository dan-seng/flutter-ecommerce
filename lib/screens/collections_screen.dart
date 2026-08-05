import 'package:flutter/material.dart';

import '../models/product.dart';
import '../state/catalog_controller.dart';
import '../state/scopes.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/pulse.dart';
import 'category_products_screen.dart';

class CollectionsScreen extends StatelessWidget {
  const CollectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ListenableBuilder(
        listenable: CatalogScope.of(context),
        builder: (context, _) {
          final catalog = CatalogScope.of(context);
          return switch (catalog.status) {
            CatalogStatus.loading => const _CollectionsSkeleton(),
            CatalogStatus.error => _CollectionsError(
                message: catalog.error ?? 'Something went wrong.',
                onRetry: catalog.load,
              ),
            CatalogStatus.ready => _buildContent(context, catalog),
          };
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, CatalogController catalog) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'COLLECTIONS',
                  style: AppTheme.eyebrow(AppColors.ember),
                ),
                const SizedBox(height: 4),
                Text(
                  'Explore the edit.',
                  style: AppTheme.serifStyle(size: 32),
                ),
                const SizedBox(height: 6),
                Text(
                  'Curated shelves for every kind of day.',
                  style: AppTheme.sansStyle(size: 13.5, color: AppColors.stone),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 140),
          sliver: SliverList.separated(
            itemCount: catalog.categories.length,
            separatorBuilder: (_, _) => const SizedBox(height: 14),
            itemBuilder: (context, i) {
              final category = catalog.categories[i];
              final products = catalog.products
                  .where((p) => p.category == category)
                  .toList();
              return _CategoryTile(
                category: category,
                products: products,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CategoryProductsScreen(
                      category: category,
                      products: products,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.category,
    required this.products,
    required this.onTap,
  });

  final String category;
  final List<Product> products;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final sample = products.isNotEmpty ? products.first : null;
    final tint = AppColors.tintFor(category);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: tint,
          borderRadius: BorderRadius.circular(26),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned(
              right: -34,
              bottom: -44,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.35),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 14, 16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('SHOP',
                            style: AppTheme.eyebrow(AppColors.stone)),
                        const Spacer(),
                        Text(
                          AppColors.labelFor(category),
                          style: AppTheme.serifStyle(
                            size: 26,
                            weight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              '${products.length} pieces',
                              style: AppTheme.sansStyle(
                                size: 12,
                                weight: FontWeight.w600,
                                color: AppColors.stone,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 26,
                              height: 26,
                              decoration: const BoxDecoration(
                                color: AppColors.ink,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_outward_rounded,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (sample != null)
                    Container(
                      width: 96,
                      height: 118,
                      margin: const EdgeInsets.only(left: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Image.network(
                        sample.image,
                        fit: BoxFit.contain,
                        errorBuilder: (_, _, _) => const Icon(
                            Icons.image_outlined, color: AppColors.stone),
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

class _CollectionsError extends StatelessWidget {
  const _CollectionsError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.grid_off_rounded, size: 40, color: AppColors.stone),
          const SizedBox(height: 14),
          Text('Collections are away',
              style: AppTheme.serifStyle(size: 22)),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTheme.sansStyle(size: 13.5, color: AppColors.stone),
          ),
          const SizedBox(height: 22),
          FilledButton(
            onPressed: onRetry,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.ember,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 13),
            ),
            child: const Text('Try again'),
          ),
        ],
      ),
    );
  }
}

class _CollectionsSkeleton extends StatelessWidget {
  const _CollectionsSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 40),
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        Pulse(child: SkeletonBox(width: 110, height: 12)),
        SizedBox(height: 6),
        Pulse(child: SkeletonBox(width: 230, height: 36)),
        SizedBox(height: 24),
        Pulse(child: SkeletonBox(width: double.infinity, height: 150, radius: 26)),
        SizedBox(height: 14),
        Pulse(child: SkeletonBox(width: double.infinity, height: 150, radius: 26)),
        SizedBox(height: 14),
        Pulse(child: SkeletonBox(width: double.infinity, height: 150, radius: 26)),
      ],
    );
  }
}
