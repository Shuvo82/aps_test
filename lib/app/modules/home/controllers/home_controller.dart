import 'package:get/get.dart';

import '../../../core/services/auth_service.dart';
import '../../../core/services/biometric_service.dart';
import '../../../core/utils/storage_helper.dart';
import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final BiometricService _biometricService = Get.find<BiometricService>();

  // Observable variables
  final RxBool isBiometricEnabled = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadBiometricStatus();
  }

  /// Load biometric enabled status from storage
  void _loadBiometricStatus() {
    isBiometricEnabled.value = StorageHelper.isBiometricEnabled();
  }

  /// Toggle biometric authentication
  Future<void> toggleBiometric(bool value) async {
    if (value) {
      // First authenticate to enable biometric
      final authenticated = await _biometricService.authenticate(
        reason: 'Authenticate to enable fingerprint login',
      );

      if (authenticated) {
        await StorageHelper.setBiometricEnabled(true);
        isBiometricEnabled.value = true;
        Get.snackbar(
          'Success',
          'Fingerprint login enabled successfully!',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Failed',
          'Could not verify your fingerprint. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      await StorageHelper.setBiometricEnabled(false);
      isBiometricEnabled.value = false;
      Get.snackbar(
        'Disabled',
        'Fingerprint login has been disabled.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Logout user
  Future<void> logout() async {
    await _authService.signOut();
    Get.offAllNamed(Routes.AUTH);
  }
}
