import 'package:flutter/material.dart';

import '../models/product.dart';
import '../state/catalog_controller.dart';
import '../state/scopes.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../widgets/product_card.dart';
import '../widgets/pulse.dart';
import 'product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String? _category;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CatalogScope.of(context).load();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ListenableBuilder(
        listenable: CatalogScope.of(context),
        builder: (context, _) {
          final catalog = CatalogScope.of(context);
          return switch (catalog.status) {
            CatalogStatus.loading => const _HomeSkeleton(),
            CatalogStatus.error => _ErrorView(
                message: catalog.error ?? 'Something went wrong.',
                onRetry: catalog.load,
              ),
            CatalogStatus.ready => _buildContent(catalog),
          };
        },
      ),
    );
  }

  Widget _buildContent(CatalogController catalog) {
    final visible = _visible(catalog.products);
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _BrandRow(),
                const SizedBox(height: 22),
                _Greeting(),
                const SizedBox(height: 20),
                _SearchField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _query = v.trim()),
                ),
                const SizedBox(height: 18),
                _CategoryChips(
                  categories: catalog.categories,
                  selected: _category,
                  onSelected: (c) => setState(() => _category = c),
                ),
                const SizedBox(height: 20),
                _FeaturedHero(product: _featured(catalog.products)),
                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _SectionHeader(
              eyebrow: 'CATALOG',
              title: 'Just landed',
              count: '${visible.length} pieces',
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 140),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 14,
              childAspectRatio: 0.60,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, i) {
                final product = visible[i];
                return ProductCard(
                  product: product,
                  onTap: () => _openDetail(product),
                );
              },
              childCount: visible.length,
            ),
          ),
        ),
      ],
    );
  }

  List<Product> _visible(List<Product> all) {
    var list = all;
    if (_category != null) {
      list = list.where((p) => p.category == _category).toList();
    }
    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      list = list.where((p) => p.title.toLowerCase().contains(q)).toList();
    }
    return list;
  }

  Product _featured(List<Product> products) {
    if (products.isEmpty) return products.first;
    return products.firstWhere(
      (p) => p.category == "men's clothing",
      orElse: () => products.first,
    );
  }

  void _openDetail(Product product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProductDetailScreen(product: product),
      ),
    );
  }
}

class _BrandRow extends StatelessWidget {
  const _BrandRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'EMBER',
                style: AppTheme.serifStyle(
                  size: 22,
                  weight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              TextSpan(
                text: '.',
                style: AppTheme.serifStyle(
                  size: 22,
                  weight: FontWeight.w700,
                  color: AppColors.ember,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        _RoundIcon(
          icon: Icons.person_outline_rounded,
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Accounts are a demo, for now.')),
          ),
        ),
      ],
    );
  }
}

class _Greeting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good morning'
        : hour < 18
            ? 'Good afternoon'
            : 'Good evening';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: AppTheme.sansStyle(size: 13.5, color: AppColors.stone),
        ),
        const SizedBox(height: 2),
        Text(
          'Shop the edit.',
          style: AppTheme.serifStyle(size: 36, weight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Search the store',
        hintStyle: AppTheme.sansStyle(size: 14, color: AppColors.stone),
        prefixIcon: const Padding(
          padding: EdgeInsets.only(left: 16, right: 8),
          child: Icon(Icons.search_rounded, size: 21, color: AppColors.stone),
        ),
        suffixIcon: ListenableBuilder(
          listenable: controller,
          builder: (context, _) => controller.text.isEmpty
              ? const SizedBox.shrink()
              : IconButton(
                  icon: const Icon(Icons.close_rounded,
                      size: 19, color: AppColors.stone),
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                ),
        ),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
        isDense: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.ink, width: 1.4),
        ),
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  const _CategoryChips({
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  final List<String> categories;
  final String? selected;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final items = <String?>[null, ...categories];
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final category = items[i];
          final active = selected == category;
          return GestureDetector(
            onTap: () => onSelected(category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: active ? AppColors.ink : AppColors.surface,
                borderRadius: BorderRadius.circular(19),
                border: Border.all(
                  color: active ? AppColors.ink : AppColors.line,
                ),
              ),
              child: Text(
                category == null ? 'All' : AppColors.labelFor(category),
                style: AppTheme.sansStyle(
                  size: 12.5,
                  weight: FontWeight.w600,
                  color: active ? Colors.white : AppColors.ink,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FeaturedHero extends StatelessWidget {
  const _FeaturedHero({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ProductDetailScreen(product: product),
        ),
      ),
      child: Container(
        height: 190,
        decoration: BoxDecoration(
          color: AppColors.ink,
          borderRadius: BorderRadius.circular(28),
        ),
        padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FEATURED · DROP 04',
                    style: AppTheme.eyebrow(const Color(0xFFE8A78F)),
                  ),
                  const Spacer(),
                  Text(
                    'The\neveryday\ncarry.',
                    style: AppTheme.serifStyle(
                      size: 27,
                      weight: FontWeight.w600,
                      height: 1.02,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        formatPrice(product.price),
                        style: AppTheme.sansStyle(
                          size: 13.5,
                          weight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.ember,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Shop now',
                              style: AppTheme.sansStyle(
                                size: 12,
                                weight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.arrow_forward_rounded,
                                size: 13, color: Colors.white),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(14),
                child: Hero(
                  tag: 'featured-${product.id}',
                  child: CachedProductImage(product: product),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CachedProductImage extends StatelessWidget {
  const CachedProductImage({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      product.image,
      fit: BoxFit.contain,
      errorBuilder: (_, _, _) => const Icon(Icons.image_outlined,
          color: AppColors.stone),
      loadingBuilder: (context, child, progress) =>
          progress == null ? child : const SizedBox.shrink(),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.eyebrow,
    required this.title,
    this.count,
  });

  final String eyebrow;
  final String title;
  final String? count;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(eyebrow, style: AppTheme.eyebrow(AppColors.ember)),
              const SizedBox(height: 4),
              Text(title, style: AppTheme.serifStyle(size: 26)),
            ],
          ),
        ),
        if (count != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              count!,
              style: AppTheme.sansStyle(size: 12, color: AppColors.stone),
            ),
          ),
      ],
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, size: 21, color: AppColors.ink),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 40, color: AppColors.stone),
            const SizedBox(height: 14),
            Text('The store is taking a nap',
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
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
              ),
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeSkeleton extends StatelessWidget {
  const _HomeSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 40),
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        Pulse(child: SkeletonBox(width: 90, height: 24)),
        SizedBox(height: 24),
        Pulse(child: SkeletonBox(width: 190, height: 40)),
        SizedBox(height: 24),
        Pulse(child: SkeletonBox(width: double.infinity, height: 54, radius: 18)),
        SizedBox(height: 18),
        Pulse(child: SkeletonBox(width: double.infinity, height: 38, radius: 19)),
        SizedBox(height: 20),
        Pulse(child: SkeletonBox(width: double.infinity, height: 190, radius: 28)),
        SizedBox(height: 28),
        Pulse(child: SkeletonBox(width: 160, height: 34)),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: SkeletonBox(height: 220, radius: 22)),
            SizedBox(width: 14),
            Expanded(child: SkeletonBox(height: 220, radius: 22)),
          ],
        ),
      ],
    );
  }
}
