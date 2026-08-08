import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gebeya/services/biometric_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BiometricService Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('isEnabled defaults to true', () async {
      final enabled = await BiometricService.isEnabled();
      expect(enabled, isTrue);
    });

    test('setEnabled updates preferences correctly', () async {
      await BiometricService.setEnabled(false);
      final enabled = await BiometricService.isEnabled();
      expect(enabled, isFalse);

      await BiometricService.setEnabled(true);
      final reEnabled = await BiometricService.isEnabled();
      expect(reEnabled, isTrue);
    });

    test('authenticate succeeds when biometrics disabled in preferences', () async {
      await BiometricService.setEnabled(false);
      final result = await BiometricService.authenticate(reason: 'Test Auth');
      expect(result, isTrue);
    });
  });
}
