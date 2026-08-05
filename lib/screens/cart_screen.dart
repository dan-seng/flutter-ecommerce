import 'package:flutter/material.dart';

import '../state/cart_controller.dart';
import '../state/scopes.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../utils/format.dart';
import '../widgets/product_image.dart';
import '../widgets/qty_stepper.dart';

const _freeShippingThreshold = 100.0;
const _shippingRate = 12.0;

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = CartScope.of(context);
    return SafeArea(
      bottom: false,
      child: ListenableBuilder(
        listenable: cart,
        builder: (context, _) {
          return cart.isEmpty
              ? const _EmptyBag()
              : _buildContent(context, cart);
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, CartController cart) {
    final subtotal = cart.subtotal;
    final shipping =
        subtotal >= _freeShippingThreshold ? 0.0 : _shippingRate;
    final total = subtotal + shipping;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('YOUR BAG', style: AppTheme.eyebrow(AppColors.ember)),
                    const SizedBox(height: 4),
                    Text(
                      'Shopping bag',
                      style: AppTheme.serifStyle(size: 30),
                    ),
                  ],
                ),
              ),
              Text(
                '${cart.count} ${cart.count == 1 ? 'item' : 'items'}',
                style: AppTheme.sansStyle(
                    size: 12.5,
                    weight: FontWeight.w600,
                    color: AppColors.stone),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
            itemCount: cart.lines.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, i) => _CartLineTile(line: cart.lines[i]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 140),
          child: Column(
            children: [
              _SummaryCard(
                subtotal: subtotal,
                shipping: shipping,
                total: total,
              ),
              const SizedBox(height: 14),
              GestureDetector(
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Checkout is a demo in this build.'),
                  ),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 17),
                  decoration: BoxDecoration(
                    color: AppColors.ember,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Checkout · ${formatPrice(total)}',
                        style: AppTheme.sansStyle(
                          size: 14.5,
                          weight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded,
                          size: 17, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CartLineTile extends StatelessWidget {
  const _CartLineTile({required this.line});

  final CartLine line;

  @override
  Widget build(BuildContext context) {
    final cart = CartScope.of(context);
    final product = line.product;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.line),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          SizedBox(
            width: 84,
            height: 84,
            child: ProductImage(
              product: product,
              radius: 16,
              padding: const EdgeInsets.all(10),
              enableHero: false,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 84,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product.title,
                          style: AppTheme.sansStyle(
                            size: 13,
                            weight: FontWeight.w600,
                            height: 1.25,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () => cart.remove(product),
                        icon: const Icon(Icons.delete_outline_rounded,
                            size: 18, color: AppColors.stone),
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        constraints:
                            const BoxConstraints(minWidth: 28, minHeight: 28),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      QtyStepper(
                        quantity: line.quantity,
                        onIncrement: () => cart.increment(product),
                        onDecrement: () => cart.decrement(product),
                        dense: true,
                      ),
                      const Spacer(),
                      Text(
                        formatPrice(line.subtotal),
                        style: AppTheme.sansStyle(
                          size: 14,
                          weight: FontWeight.w700,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
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

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.subtotal,
    required this.shipping,
    required this.total,
  });

  final double subtotal;
  final double shipping;
  final double total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        children: [
          _Row(label: 'Subtotal', value: formatPrice(subtotal)),
          const SizedBox(height: 10),
          _Row(
            label: 'Shipping',
            value: shipping == 0
                ? 'Free'
                : formatPrice(shipping),
            valueColor: shipping == 0 ? AppColors.ember : null,
            valueWeight: shipping == 0 ? FontWeight.w700 : null,
          ),
          if (shipping > 0)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Free shipping on orders over ${formatPrice(_freeShippingThreshold)}.',
                  style: AppTheme.sansStyle(
                      size: 11, color: AppColors.stone),
                ),
              ),
            ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: AppColors.line, height: 1),
          ),
          _Row(
            label: 'Total',
            value: formatPrice(total),
            valueIsSerif: true,
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.label,
    required this.value,
    this.valueIsSerif = false,
    this.valueColor,
    this.valueWeight,
  });

  final String label;
  final String value;
  final bool valueIsSerif;
  final Color? valueColor;
  final FontWeight? valueWeight;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTheme.sansStyle(size: 13.5, color: AppColors.stone),
          ),
        ),
        if (valueIsSerif)
          Text(
            value,
            style: AppTheme.serifStyle(
                size: 20,
                weight: FontWeight.w600,
                color: valueColor ?? AppColors.ink),
          )
        else
          Text(
            value,
            style: AppTheme.sansStyle(
              size: 13.5,
              weight: valueWeight ?? FontWeight.w600,
              color: valueColor ?? AppColors.ink,
            ),
          ),
      ],
    );
  }
}

class _EmptyBag extends StatelessWidget {
  const _EmptyBag();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: const BoxDecoration(
                color: AppColors.emberSoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 34,
                color: AppColors.ember,
              ),
            ),
            const SizedBox(height: 20),
            Text('Your bag is empty',
                style: AppTheme.serifStyle(size: 24)),
            const SizedBox(height: 6),
            Text(
              'Beautiful things are waiting.\nGo find something you love.',
              textAlign: TextAlign.center,
              style: AppTheme.sansStyle(size: 13.5, color: AppColors.stone),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () => ShellScope.of(context).setIndex(0),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.ink,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Start shopping',
                  style: AppTheme.sansStyle(
                    size: 13.5,
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
