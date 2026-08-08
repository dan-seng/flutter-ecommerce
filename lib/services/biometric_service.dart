import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BiometricService {
  BiometricService._();

  static final LocalAuthentication _auth = LocalAuthentication();
  static const String _prefKey = 'is_biometric_enabled';

  /// Get user's biometric toggle setting (defaults to true)
  static Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_prefKey) ?? true;
  }

  /// Update user's biometric toggle setting
  static Future<void> setEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, enabled);
  }

  /// Check if biometric hardware (fingerprint / Face ID) is supported on device
  static Future<bool> isBiometricAvailable() async {
    try {
      final bool canCheck = await _auth.canCheckBiometrics;
      final bool isSupported = await _auth.isDeviceSupported();
      return canCheck || isSupported;
    } on PlatformException catch (e) {
      debugPrint('Biometric check error: $e');
      return false;
    }
  }

  /// Trigger 1-tap Fingerprint / Face ID / PIN / Pattern authentication modal
  static Future<bool> authenticate({
    required String reason,
  }) async {
    final bool enabled = await isEnabled();
    if (!enabled) return true; // Bypassed if disabled in Profile Settings

    try {
      final bool isAvailable = await isBiometricAvailable();
      if (!isAvailable) {
        // Fallback for emulator / desktop demo mode
        await Future<void>.delayed(const Duration(milliseconds: 500));
        return true;
      }

      return await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
    } on PlatformException catch (e) {
      debugPrint('Biometric auth error: $e');
      return false;
    }
  }
}
