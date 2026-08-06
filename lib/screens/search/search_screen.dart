import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/cart_item.dart';
import '../../models/product.dart';
import '../../services/fakestore_api.dart';
import '../../state/cart_scope.dart';
import '../../theme/app_theme.dart';
import '../../utils/formatters.dart';
import '../product_detail/product_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, this.repository, this.initialQuery = ''});

  final ProductRepository? repository;
  final String initialQuery;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static const _popularSearches = [
    'Backpack',
    'Watch',
    'Sneakers',
    'Electronics',
    "Men's",
    'Jewelery',
    'Laptop',
  ];

  late final ProductRepository _repository;
  late final TextEditingController _controller;
  late Future<List<Product>> _productsFuture;
  late String _query;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? FakeStoreApi();
    _controller = TextEditingController(text: widget.initialQuery);
    _query = widget.initialQuery.trim();
    _productsFuture = _repository.fetchProducts();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    setState(() => _query = value.trim());
  }

  void _setQuery(String query) {
    _controller.text = query;
    _onQueryChanged(query);
  }

  void _retry() {
    setState(() {
      _productsFuture = _repository.fetchProducts();
    });
  }

  void _openProduct(Product product) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProductDetailScreen(
          product: product,
          repository: _repository,
        ),
      ),
    );
  }

  void _addToCart(Product product) {
    CartScope.read(context).add(CartItem(product: product));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Added "${product.name}" to cart'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(milliseconds: 1500),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _SearchField(
              controller: _controller,
              onChanged: _onQueryChanged,
              onClear: () => _setQuery(''),
              onBack: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: FutureBuilder<List<Product>>(
                future: _productsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return _SearchErrorView(onRetry: _retry);
                  }
                  final products = snapshot.data ?? const <Product>[];
                  return _SearchBody(
                    query: _query,
                    products: products,
                    popularSearches: _popularSearches,
                    onSuggestionTap: _setQuery,
                    onProductTap: _openProduct,
                    onAddProduct: _addToCart,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.onChanged,
    required this.onClear,
    required this.onBack,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        border: Border(
          bottom: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        children: [
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
          Expanded(
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: AppColors.searchField,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: AppColors.outlineVariant.withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    CupertinoIcons.search,
                    size: 18,
                    color: AppColors.onSurfaceVariant,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      onChanged: onChanged,
                      autofocus: true,
                      cursorColor: AppColors.primary,
                      textInputAction: TextInputAction.search,
                      style: AppTypography.bodyMd.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Search products, categories...',
                        hintStyle: AppTypography.bodyMd.copyWith(
                          color: AppColors.onSurfaceVariant
                              .withValues(alpha: 0.6),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  if (controller.text.isNotEmpty)
                    GestureDetector(
                      onTap: onClear,
                      child: const Icon(
                        CupertinoIcons.xmark_circle_fill,
                        size: 18,
                        color: AppColors.onSurfaceVariant,
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

class _SearchBody extends StatelessWidget {
  const _SearchBody({
    required this.query,
    required this.products,
    required this.popularSearches,
    required this.onSuggestionTap,
    required this.onProductTap,
    required this.onAddProduct,
  });

  final String query;
  final List<Product> products;
  final List<String> popularSearches;
  final ValueChanged<String> onSuggestionTap;
  final ValueChanged<Product> onProductTap;
  final ValueChanged<Product> onAddProduct;

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) {
      return _SearchSuggestions(
        popularSearches: popularSearches,
        onSuggestionTap: onSuggestionTap,
      );
    }

    final q = query.toLowerCase();
    final results = products
        .where((p) =>
            p.name.toLowerCase().contains(q) ||
            p.category.toLowerCase().contains(q))
        .toList();

    if (results.isEmpty) {
      return _NoResults(query: query);
    }

    return ListView.separated(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: results.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final product = results[index];
        return _SearchResultTile(
          product: product,
          onTap: () => onProductTap(product),
          onAdd: () => onAddProduct(product),
        );
      },
    );
  }
}

class _SearchSuggestions extends StatelessWidget {
  const _SearchSuggestions({
    required this.popularSearches,
    required this.onSuggestionTap,
  });

  final List<String> popularSearches;
  final ValueChanged<String> onSuggestionTap;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        Text(
          'Popular Searches',
          style: AppTypography.headlineMd.copyWith(
            color: AppColors.onBackground,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: popularSearches.map((term) {
            return GestureDetector(
              onTap: () => onSuggestionTap(term),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.outlineVariant.withValues(alpha: 0.5),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      CupertinoIcons.search,
                      size: 14,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      term,
                      style: AppTypography.labelLg.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  const _SearchResultTile({
    required this.product,
    required this.onTap,
    required this.onAdd,
  });

  final Product product;
  final VoidCallback onTap;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: SizedBox(
                    width: 68,
                    height: 68,
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const ColoredBox(
                          color: AppColors.surfaceContainerHigh,
                        );
                      },
                      errorBuilder: (context, error, stackTrace) =>
                          const ColoredBox(
                        color: AppColors.surfaceContainerHigh,
                        child: Center(
                          child: Icon(
                            CupertinoIcons.photo,
                            size: 20,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.category.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.labelMd.copyWith(
                          color: AppColors.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.labelLg.copyWith(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        formatMoney(product.price),
                        style: AppTypography.titleLg.copyWith(
                          color: AppColors.onBackground,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: onAdd,
                      borderRadius: BorderRadius.circular(12),
                      child: const Center(
                        child: Icon(Icons.add, size: 20, color: Colors.white),
                      ),
                    ),
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

class _NoResults extends StatelessWidget {
  const _NoResults({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                CupertinoIcons.search,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No results for "$query"',
              textAlign: TextAlign.center,
              style: AppTypography.headlineMd.copyWith(
                color: AppColors.onBackground,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try a different keyword or category.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMd.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchErrorView extends StatelessWidget {
  const _SearchErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              CupertinoIcons.wifi_exclamationmark,
              size: 48,
              color: AppColors.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              "Couldn't load products",
              style: AppTypography.headlineMd.copyWith(
                color: AppColors.onBackground,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 48,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ElevatedButton.icon(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(CupertinoIcons.refresh, size: 18),
                label: const Text('Retry'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
