import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gebeya/data/mock_products.dart';
import 'package:gebeya/main.dart';
import 'package:gebeya/models/product.dart';
import 'package:gebeya/screens/cart/cart_screen.dart';
import 'package:gebeya/screens/product_detail/product_detail_screen.dart';
import 'package:gebeya/services/fakestore_api.dart';

class _FakeRepository implements ProductRepository {
  _FakeRepository(this.products);

  final List<Product> products;

  @override
  Future<List<Product>> fetchProducts() async => products;

  @override
  Future<Product> fetchProduct(int id) async =>
      products.firstWhere((p) => p.id == id);
}

void main() {
  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(
      GebeyaApp(repository: _FakeRepository(sampleProducts)),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  }

  testWidgets('Home screen renders products from the API', (tester) async {
    await pumpApp(tester);

    expect(find.text('Alex'), findsOneWidget);
    expect(find.text('Summer\nCollection'), findsOneWidget);
    expect(find.text('Featured Products'), findsOneWidget);
    expect(find.text(sampleProducts.first.name), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('New Arrivals'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump();

    expect(find.text('Smart Audio Hub'), findsOneWidget);
    expect(find.text(sampleProducts[2].name), findsOneWidget);
  });

  testWidgets('Category chips filter products', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('electronics'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(
      find.text(sampleProducts.first.name),
      findsNothing,
    );
  });

  testWidgets('Tapping a product opens the detail screen', (tester) async {
    await pumpApp(tester);

    await tester.ensureVisible(find.text(sampleProducts.first.name));
    await tester.pump();
    await tester.tap(find.text(sampleProducts.first.name));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Add to Cart'), findsOneWidget);
    expect(find.text('Buy Now'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Description'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump();
    expect(find.text('Description'), findsOneWidget);
    expect(find.text('\$${sampleProducts.first.price.toStringAsFixed(2)}'),
        findsWidgets);
  });

  testWidgets('Quantity selector increments and decrements', (tester) async {
    await pumpApp(tester);

    await tester.ensureVisible(find.text(sampleProducts.first.name));
    await tester.pump();
    await tester.tap(find.text(sampleProducts.first.name));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    await tester.scrollUntilVisible(
      find.text('Quantity'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump();

    final detail = find.byType(ProductDetailScreen);
    final addIcon = find.descendant(of: detail, matching: find.byIcon(Icons.add));
    final removeIcon =
        find.descendant(of: detail, matching: find.byIcon(Icons.remove));

    await tester.ensureVisible(addIcon);
    await tester.pump();
    expect(find.text('1'), findsWidgets);

    await tester.tap(addIcon);
    await tester.pump();
    expect(find.text('2'), findsOneWidget);

    await tester.tap(removeIcon);
    await tester.pump();
    expect(find.text('1'), findsWidgets);
  });

  Future<void> addFirstProductAndOpenCart(WidgetTester tester) async {
    await pumpApp(tester);

    await tester.ensureVisible(find.text(sampleProducts.first.name));
    await tester.pump();
    await tester.tap(find.text(sampleProducts.first.name));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.text('Add to Cart'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.text('View'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  testWidgets('Adding a product to cart from the detail screen', (tester) async {
    await addFirstProductAndOpenCart(tester);

    expect(find.text('My Cart'), findsOneWidget);
    expect(find.text(sampleProducts.first.name), findsOneWidget);
    expect(find.text('\$${sampleProducts.first.price.toStringAsFixed(2)}'),
        findsWidgets);
    expect(find.text('Checkout'), findsOneWidget);
  });

  testWidgets('Cart quantity controls update totals', (tester) async {
    await addFirstProductAndOpenCart(tester);

    expect(find.text('My Cart'), findsOneWidget);
    expect(find.text(sampleProducts.first.name), findsOneWidget);

    final price = sampleProducts.first.price;
    await tester.tap(find.descendant(
      of: find.byType(CartScreen),
      matching: find.byIcon(Icons.add),
    ));
    await tester.pump();
    expect(find.text('\$${(price * 2).toStringAsFixed(2)}'), findsWidgets);

    await tester.tap(find.descendant(
      of: find.byType(CartScreen),
      matching: find.byIcon(Icons.remove),
    ));
    await tester.pump();
    expect(find.text('\$${price.toStringAsFixed(2)}'), findsWidgets);
  });

  testWidgets('Removing items shows the empty cart state', (tester) async {
    await addFirstProductAndOpenCart(tester);

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pump();

    expect(find.text('Your cart is empty'), findsOneWidget);
    expect(find.text('Browse Products'), findsOneWidget);
  });

  Future<void> openSearch(WidgetTester tester) async {
    await pumpApp(tester);

    await tester.tap(find.byType(TextField));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));
  }

  testWidgets('Tapping the search bar opens the search screen', (tester) async {
    await openSearch(tester);

    expect(find.text('Popular Searches'), findsOneWidget);
  });

  testWidgets('Search filters products by query', (tester) async {
    await openSearch(tester);

    await tester.enterText(find.byType(TextField), 'backpack');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text(sampleProducts.first.name), findsOneWidget);
    expect(find.text(sampleProducts[1].name), findsNothing);
  });

  testWidgets('Search shows a no-results state', (tester) async {
    await openSearch(tester);

    await tester.enterText(find.byType(TextField), 'zzzz');
    await tester.pump();

    expect(find.textContaining('No results'), findsOneWidget);
  });

  testWidgets('Popular search chips filter results', (tester) async {
    await openSearch(tester);

    await tester.tap(find.text('Backpack'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text(sampleProducts.first.name), findsOneWidget);
  });

  testWidgets('Tapping a search result opens the detail screen', (tester) async {
    await openSearch(tester);

    await tester.enterText(find.byType(TextField), 'backpack');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    await tester.tap(find.text(sampleProducts.first.name));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Add to Cart'), findsOneWidget);
  });

  testWidgets('Tapping the Profile tab opens the profile screen', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Profile'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));

    expect(find.text('Alex Johnson'), findsOneWidget);
    expect(find.text('My Orders'), findsOneWidget);
    expect(find.text('Payment Methods'), findsOneWidget);
  });

  testWidgets('Profile menu items and sign out work', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Profile'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));

    await tester.tap(find.text('My Orders'));
    await tester.pump();
    expect(find.text('My Orders is coming soon'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1500));
    await tester.pump(const Duration(milliseconds: 300));

    await tester.scrollUntilVisible(
      find.text('Sign Out'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(find.text('Sign Out'));
    await tester.pump();
    await tester.tap(find.text('Sign Out'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Signed out (demo)'), findsOneWidget);
  });
}
