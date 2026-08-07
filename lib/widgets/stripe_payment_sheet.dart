import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/stripe_service.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';

class StripePaymentSheetModal extends StatefulWidget {
  const StripePaymentSheetModal({
    super.key,
    required this.amount,
    required this.userEmail,
  });

  final double amount;
  final String userEmail;

  static Future<StripePaymentResult?> show({
    required BuildContext context,
    required double amount,
    required String userEmail,
  }) {
    return showModalBottomSheet<StripePaymentResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StripePaymentSheetModal(
        amount: amount,
        userEmail: userEmail,
      ),
    );
  }

  @override
  State<StripePaymentSheetModal> createState() =>
      _StripePaymentSheetModalState();
}

class _StripePaymentSheetModalState extends State<StripePaymentSheetModal> {
  final _cardNumberController =
      TextEditingController(text: '4242  4242  4242  4242');
  final _expiryController = TextEditingController(text: '12 / 28');
  final _cvcController = TextEditingController(text: '123');
  final _zipController = TextEditingController(text: '90210');

  bool _isProcessing = false;
  String? _errorMessage;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvcController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  Future<void> _handleStripePay() async {
    final cardNumber = _cardNumberController.text.replaceAll(' ', '');
    final expiry = _expiryController.text.trim();
    final cvc = _cvcController.text.trim();

    if (cardNumber.length < 16) {
      setState(() => _errorMessage = 'Please enter a valid 16-digit card number');
      return;
    }
    if (expiry.length < 4) {
      setState(() => _errorMessage = 'Please enter a valid expiry date (MM/YY)');
      return;
    }
    if (cvc.length < 3) {
      setState(() => _errorMessage = 'Please enter a valid 3-digit CVC');
      return;
    }

    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    final stripeService = StripeService();
    final result = await stripeService.processPayment(
      amount: widget.amount,
      currency: 'USD',
      userEmail: widget.userEmail,
    );

    if (!mounted) return;
    setState(() => _isProcessing = false);

    if (result.success) {
      Navigator.of(context).pop(result);
    } else {
      setState(() {
        _errorMessage = result.errorMessage ?? 'Payment failed';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return AnimatedPadding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      duration: const Duration(milliseconds: 150),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.15),
              blurRadius: 30,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Grab Handle
                Center(
                  child: Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Stripe Header & Badge
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF635BFF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            CupertinoIcons.creditcard_fill,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'stripe',
                            style: AppTypography.titleLg.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: const Color(0xFFF59E0B).withValues(alpha: 0.4),
                        ),
                      ),
                      child: Text(
                        'TEST MODE',
                        style: AppTypography.labelMd.copyWith(
                          color: const Color(0xFFD97706),
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(CupertinoIcons.xmark_circle_fill),
                      onPressed: () => Navigator.of(context).pop(),
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                Text(
                  'Payment Details',
                  style: AppTypography.headlineMd.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                  ),
                ),
                Text(
                  'Amount to charge: ${formatMoney(widget.amount)} USD',
                  style: AppTypography.bodyMd.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 20),

                // Error alert box
                if (_errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.accent.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          CupertinoIcons.exclamationmark_triangle_fill,
                          color: AppColors.accent,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: AppTypography.bodyMd.copyWith(
                              color: AppColors.accent,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                ],

                // Card Number Field
                Text(
                  'CARD NUMBER',
                  style: AppTypography.labelMd.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _cardNumberController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(16),
                  ],
                  style: AppTypography.titleLg.copyWith(
                    letterSpacing: 2,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(CupertinoIcons.creditcard, size: 20),
                    suffixIcon: const Icon(
                      CupertinoIcons.checkmark_seal_fill,
                      color: Color(0xFF635BFF),
                      size: 18,
                    ),
                    hintText: '4242 4242 4242 4242',
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHigh,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Expiry, CVC & ZIP
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'EXPIRY',
                            style: AppTypography.labelMd.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _expiryController,
                            keyboardType: TextInputType.datetime,
                            style: AppTypography.titleLg.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              hintText: 'MM/YY',
                              filled: true,
                              fillColor: theme.colorScheme.surfaceContainerHigh,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CVC',
                            style: AppTypography.labelMd.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _cvcController,
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(4),
                            ],
                            style: AppTypography.titleLg.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              hintText: 'CVC',
                              filled: true,
                              fillColor: theme.colorScheme.surfaceContainerHigh,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'POSTAL CODE',
                            style: AppTypography.labelMd.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _zipController,
                            keyboardType: TextInputType.number,
                            style: AppTypography.titleLg.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            decoration: InputDecoration(
                              hintText: 'ZIP',
                              filled: true,
                              fillColor: theme.colorScheme.surfaceContainerHigh,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 14),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Pay Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isProcessing ? null : _handleStripePay,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF635BFF),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isProcessing
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                CupertinoIcons.lock_fill,
                                size: 16,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Pay ${formatMoney(widget.amount)} with Stripe Card',
                                style: AppTypography.titleLg.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14,
                                ),
                              ),
                            ],
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
