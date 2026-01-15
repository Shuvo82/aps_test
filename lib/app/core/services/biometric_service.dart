import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

class BiometricService extends GetxService {
  final LocalAuthentication _localAuth = LocalAuthentication();

  final RxBool canCheckBiometrics = false.obs;
  final RxBool isBiometricAvailable = false.obs;
  final RxList<BiometricType> availableBiometrics = <BiometricType>[].obs;

  @override
  void onInit() {
    super.onInit();
    _checkBiometricAvailability();
  }

  /// Check if device supports biometrics
  Future<void> _checkBiometricAvailability() async {
    try {
      canCheckBiometrics.value = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      isBiometricAvailable.value =
          canCheckBiometrics.value && isDeviceSupported;

      if (isBiometricAvailable.value) {
        availableBiometrics.value = await _localAuth.getAvailableBiometrics();
      }
    } on PlatformException catch (e) {
      print('Error checking biometric availability: $e');
      isBiometricAvailable.value = false;
    }
  }

  /// Check if fingerprint is available
  bool get hasFingerprintSupport {
    return availableBiometrics.contains(BiometricType.fingerprint) ||
        availableBiometrics.contains(BiometricType.strong) ||
        availableBiometrics.contains(BiometricType.weak);
  }

  /// Authenticate with biometrics
  Future<bool> authenticate({
    String reason = 'Please authenticate to continue',
  }) async {
    try {
      if (!isBiometricAvailable.value) {
        return false;
      }

      final authenticated = await _localAuth.authenticate(
        localizedReason: reason,
      );

      return authenticated;
    } on PlatformException catch (e) {
      print('Biometric authentication error: $e');
      return false;
    }
  }

  /// Cancel authentication
  Future<void> cancelAuthentication() async {
    await _localAuth.stopAuthentication();
  }
}
