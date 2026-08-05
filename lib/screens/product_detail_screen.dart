import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/product.dart';
import '../state/scopes.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../widgets/qty_stepper.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _qty = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final catalog = CatalogScope.of(context);
    final related = catalog.products
        .where((p) => p.category == product.category && p.id != product.id)
        .take(10)
        .toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 400,
            backgroundColor: AppColors.paper,
            surfaceTintColor: Colors.transparent,
            leading: _CircleButton(
              icon: Icons.arrow_back_rounded,
              onTap: () => Navigator.of(context).pop(),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _CircleButton(
                  icon: Icons.favorite_border_rounded,
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Saved to your wishlist.')),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  color: AppColors.tintFor(product.category),
                ),
                padding: const EdgeInsets.all(44),
                child: Hero(
                  tag: 'product-${product.id}',
                  child: CachedNetworkImage(
                    imageUrl: product.image,
                    fit: BoxFit.contain,
                    fadeInDuration: const Duration(milliseconds: 300),
                    placeholder: (_, _) => Icon(
                      Icons.image_outlined,
                      size: 40,
                      color: AppColors.ink.withValues(alpha: 0.18),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        AppColors.labelFor(product.category).toUpperCase(),
                        style: AppTheme.eyebrow(AppColors.ember),
                      ),
                      const Spacer(),
                      _RatingChip(product: product),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    product.title,
                    style: AppTheme.serifStyle(size: 30, height: 1.08),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    formatPrice(product.price),
                    style: AppTheme.serifStyle(
                      size: 26,
                      weight: FontWeight.w600,
                      color: AppColors.ember,
                    ),
                  ),
                  const SizedBox(height: 26),
                  Text('DESCRIPTION', style: AppTheme.eyebrow(AppColors.stone)),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: AppTheme.sansStyle(
                      size: 14.5,
                      color: AppColors.ink,
                      height: 1.65,
                    ),
                  ),
                  if (related.isNotEmpty) ...[
                    const SizedBox(height: 32),
                    Text('COMPLETE THE SET',
                        style: AppTheme.eyebrow(AppColors.ember)),
                    const SizedBox(height: 10),
                    Text(
                      'You may also like',
                      style: AppTheme.serifStyle(size: 24),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 218,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: related.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 14),
                        itemBuilder: (context, i) {
                          final item = related[i];
                          return _RelatedCard(
                            product: item,
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProductDetailScreen(product: item),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _AddToBagBar(
        product: product,
        quantity: _qty,
        onIncrement: () => setState(() => _qty++),
        onDecrement: () =>
            setState(() => _qty = _qty > 1 ? _qty - 1 : _qty),
      ),
    );
  }
}

class _RatingChip extends StatelessWidget {
  const _RatingChip({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 15, color: Color(0xFFD9A33A)),
          const SizedBox(width: 4),
          Text(
            product.rating.toStringAsFixed(1),
            style: AppTheme.sansStyle(size: 12.5, weight: FontWeight.w700),
          ),
          const SizedBox(width: 6),
          Text(
            '(${product.ratingCount})',
            style: AppTheme.sansStyle(size: 11.5, color: AppColors.stone),
          ),
        ],
      ),
    );
  }
}

class _RelatedCard extends StatelessWidget {
  const _RelatedCard({required this.product, required this.onTap});

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 148,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.tintFor(product.category),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(16),
              child: CachedNetworkImage(
                imageUrl: product.image,
                fit: BoxFit.contain,
                errorWidget: (_, _, _) => const Icon(Icons.image_outlined,
                    color: AppColors.stone),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.title,
              style: AppTheme.sansStyle(
                size: 12.5,
                weight: FontWeight.w600,
                height: 1.25,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 3),
            Text(
              formatPrice(product.price),
              style: AppTheme.sansStyle(
                size: 12.5,
                weight: FontWeight.w700,
                color: AppColors.ember,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddToBagBar extends StatelessWidget {
  const _AddToBagBar({
    required this.product,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  final Product product;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    final cart = CartScope.of(context);
    final inBag = cart.quantityOf(product);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(top: BorderSide(color: AppColors.line)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        16 + MediaQuery.of(context).viewPadding.bottom,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('TOTAL', style: AppTheme.eyebrow(AppColors.stone)),
                Text(
                  formatPrice(product.price * quantity),
                  style: AppTheme.serifStyle(
                    size: 21,
                    weight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          QtyStepper(
            quantity: quantity,
            onIncrement: onIncrement,
            onDecrement: onDecrement,
            dense: true,
          ),
          const SizedBox(width: 12),
          _AddButton(
            product: product,
            quantity: quantity,
            inBag: inBag,
          ),
        ],
      ),
    );
  }
}

class _AddButton extends StatefulWidget {
  const _AddButton({
    required this.product,
    required this.quantity,
    required this.inBag,
  });

  final Product product;
  final int quantity;
  final int inBag;

  @override
  State<_AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<_AddButton> {
  bool _justAdded = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _handleAdd() {
    CartScope.of(context).add(widget.product, quantity: widget.quantity);
    setState(() => _justAdded = true);
    _timer?.cancel();
    _timer = Timer(const Duration(milliseconds: 1300), () {
      if (mounted) setState(() => _justAdded = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final label = _justAdded
        ? 'Added ✓'
        : widget.inBag > 0
            ? 'Add another · ${widget.inBag + widget.quantity}'
            : 'Add to bag';
    return GestureDetector(
      onTap: _handleAdd,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
        decoration: BoxDecoration(
          color: _justAdded ? AppColors.ink : AppColors.ember,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: AppTheme.sansStyle(
            size: 13.5,
            weight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: AppColors.surface,
        shape: const CircleBorder(),
        elevation: 1,
        shadowColor: AppColors.ink.withValues(alpha: 0.2),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: SizedBox(
            width: 40,
            height: 40,
            child: Icon(icon, size: 21, color: AppColors.ink),
          ),
        ),
      ),
    );
  }
}
