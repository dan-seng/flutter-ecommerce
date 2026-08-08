import 'package:flutter_test/flutter_test.dart';
import 'package:gebeya/models/product.dart';
import 'package:gebeya/services/fakestore_api.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FakeStoreApi Unit Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('fetchProducts parses mock JSON correctly', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          '[{"id":1,"title":"Test Product","price":99.99,"description":"Mock desc","category":"electronics","image":"https://example.com/img.jpg","rating":{"rate":4.5,"count":10}}]',
          200,
        );
      });

      final api = FakeStoreApi(client: mockClient);
      final products = await api.fetchProducts(forceRefresh: true);

      expect(products.length, 1);
      expect(products.first.id, 1);
      expect(products.first.name, 'Test Product');
      expect(products.first.price, 99.99);
    });

    test('fetchProduct fetches single product by ID', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          '{"id":42,"title":"Bag","price":49.0,"description":"Backpack","category":"bags","image":"https://example.com/bag.jpg","rating":{"rate":4.8,"count":120}}',
          200,
        );
      });

      final api = FakeStoreApi(client: mockClient);
      final product = await api.fetchProduct(42);

      expect(product.id, 42);
      expect(product.name, 'Bag');
      expect(product.price, 49.0);
    });
  });
}
