import 'package:get/get.dart';

import '../../../core/services/auth_service.dart';
import '../../../core/services/biometric_service.dart';
import '../../../core/utils/storage_helper.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final BiometricService _biometricService = Get.find<BiometricService>();

  @override
  void onInit() {
    super.onInit();
    print('SplashController onInit called');
    _navigateToNextScreen();
  }

  /// Check auth status and navigate to appropriate screen
  Future<void> _navigateToNextScreen() async {
    try {
      // Add a small delay for splash screen visibility
      await Future.delayed(const Duration(seconds: 2));

      // Wait for biometric service to be ready
      await _biometricService.isReady;

      // Check if biometric login is enabled
      if (StorageHelper.isBiometricEnabled() &&
          _biometricService.isBiometricAvailable.value) {
        // Check if user has stored credentials OR valid Firebase session OR stored user info
        final hasCredentials = StorageHelper.hasStoredCredentials();
        final hasValidSession = _authService.isLoggedIn;
        final hasStoredUserInfo = StorageHelper.hasStoredUserInfo();

        if (hasCredentials || hasValidSession || hasStoredUserInfo) {
          // Trigger biometric authentication
          final authenticated = await _biometricService.authenticate(
            reason: 'Authenticate to login to the app',
          );

          if (authenticated) {
            if (hasCredentials) {
              // Sign in with stored credentials
              final success = await _authService.signInWithStoredCredentials();
              if (success) {
                Get.offAllNamed(Routes.HOME);
                return;
              }
            } else {
              // User has valid Firebase session or stored user info
              // Restore user data from local storage if needed
              if (_authService.currentUser.value == null) {
                _authService.restoreUserFromStorage();
              }
              Get.offAllNamed(Routes.HOME);
              return;
            }
          }
          // If biometric failed or login failed, go to auth screen
          Get.offAllNamed(Routes.AUTH);
          return;
        }
      }

      // Always go to auth screen for login
      // User must authenticate (biometric, email/password, or Google)
      Get.offAllNamed(Routes.AUTH);
    } catch (e) {
      print('Navigation error: $e');
      Get.offAllNamed(Routes.AUTH);
    }
  }
}
