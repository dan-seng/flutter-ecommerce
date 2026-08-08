import 'dart:convert';
import 'package:http/http.dart' as http;

class StripePaymentResult {
  const StripePaymentResult({
    required this.success,
    this.transactionId,
    this.status,
    this.errorMessage,
  });

  final bool success;
  final String? transactionId;
  final String? status;
  final String? errorMessage;
}

class StripeCheckoutSessionResult {
  const StripeCheckoutSessionResult({
    required this.success,
    this.checkoutUrl,
    this.sessionId,
    this.errorMessage,
  });

  final bool success;
  final String? checkoutUrl;
  final String? sessionId;
  final String? errorMessage;
}

class StripeService {
  StripeService({
    String? publishableKey,
    String? secretKey,
  })  : _publishableKey = publishableKey ?? _defaultPublishableKey,
        _secretKey = secretKey ?? _defaultSecretKey;

  static const _defaultPublishableKey = String.fromEnvironment(
    'STRIPE_PUBLISHABLE_KEY',
    defaultValue:
        'pk_test_51SQWZDBiBHtTmUyaRA1luP1edsYJDUO3WwdyBxkeow4SaEKqFyHDYruDM7z7Er8sCq9aH0FDEs5WV0UWahBR3Z23007ERPSjkg',
  );
  static const _defaultSecretKey = String.fromEnvironment(
    'STRIPE_SECRET_KEY',
    defaultValue: 'sk_test_YOUR_STRIPE_SECRET_KEY',
  );

  final String _publishableKey;
  final String _secretKey;

  String get publishableKey => _publishableKey;
  String get secretKey => _secretKey;

  /// Creates an official Stripe Hosted Checkout Session (checkout.stripe.com).
  Future<StripeCheckoutSessionResult> createCheckoutSession({
    required double amount,
    required String currency,
    required String userEmail,
    required List<String> itemNames,
  }) async {
    try {
      if (_secretKey.contains('YOUR_STRIPE_SECRET_KEY') || _secretKey.isEmpty) {
        await Future<void>.delayed(const Duration(milliseconds: 600));
        return StripeCheckoutSessionResult(
          success: true,
          checkoutUrl: 'https://gebeya.com/checkout_demo',
          sessionId: 'cs_demo_${DateTime.now().millisecondsSinceEpoch}',
        );
      }

      final amountInCents = (amount * 100).round();
      final url = Uri.parse('https://api.stripe.com/v1/checkout/sessions');

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $_secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'payment_method_types[0]': 'card',
          'mode': 'payment',
          'customer_email': userEmail,
          'line_items[0][price_data][currency]': currency.toLowerCase(),
          'line_items[0][price_data][product_data][name]':
              itemNames.isNotEmpty ? itemNames.take(3).join(', ') : 'Gebeya Luxe Order',
          'line_items[0][price_data][unit_amount]': amountInCents.toString(),
          'line_items[0][quantity]': '1',
          'success_url': 'https://gebeya.com/success?session_id={CHECKOUT_SESSION_ID}',
          'cancel_url': 'https://gebeya.com/cancel',
        },
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        final checkoutUrl = data['url'] as String?;
        final sessionId = data['id'] as String?;
        return StripeCheckoutSessionResult(
          success: true,
          checkoutUrl: checkoutUrl,
          sessionId: sessionId,
        );
      } else {
        final error = data['error'] as Map<String, dynamic>?;
        final message = error?['message'] as String? ?? 'Failed to create Stripe checkout session';
        return StripeCheckoutSessionResult(
          success: false,
          errorMessage: message,
        );
      }
    } catch (e) {
      return StripeCheckoutSessionResult(
        success: false,
        errorMessage: 'Network error: ${e.toString()}',
      );
    }
  }

  /// Creates and confirms a live Stripe PaymentIntent for the specified order total.
  Future<StripePaymentResult> processPayment({
    required double amount,
    required String currency,
    required String userEmail,
    String cardToken = 'tok_visa',
  }) async {
    try {
      // Handle placeholder demo key safely for local testing
      if (_secretKey.contains('YOUR_STRIPE_SECRET_KEY') || _secretKey.isEmpty) {
        await Future<void>.delayed(const Duration(milliseconds: 600));
        final demoTxId = 'pi_stripe_demo_${DateTime.now().millisecondsSinceEpoch}';
        return StripePaymentResult(
          success: true,
          transactionId: demoTxId,
          status: 'succeeded',
        );
      }

      final amountInCents = (amount * 100).round();
      final url = Uri.parse('https://api.stripe.com/v1/payment_intents');

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $_secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'amount': amountInCents.toString(),
          'currency': currency.toLowerCase(),
          'confirm': 'true',
          'payment_method_data[type]': 'card',
          'payment_method_data[card][token]': cardToken,
          'automatic_payment_methods[enabled]': 'true',
          'automatic_payment_methods[allow_redirects]': 'never',
          'return_url': 'https://gebeya.com/return',
          'receipt_email': userEmail,
          'description': 'Gebeya Luxe Order Payment ($userEmail)',
        },
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        final intentId = data['id'] as String?;
        final status = data['status'] as String?;
        return StripePaymentResult(
          success: true,
          transactionId: intentId,
          status: status ?? 'succeeded',
        );
      } else {
        final error = data['error'] as Map<String, dynamic>?;
        final message = error?['message'] as String? ?? 'Stripe payment failed';
        return StripePaymentResult(
          success: false,
          errorMessage: message,
        );
      }
    } catch (e) {
      return StripePaymentResult(
        success: false,
        errorMessage: 'Network error: ${e.toString()}',
      );
    }
  }
}
