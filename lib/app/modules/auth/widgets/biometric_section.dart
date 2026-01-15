import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/biometric_service.dart';
import '../../../core/utils/storage_helper.dart';
import '../controllers/auth_controller.dart';

class BiometricSection extends GetView<AuthController> {
  const BiometricSection({super.key});

  @override
  Widget build(BuildContext context) {
    final biometricService = Get.find<BiometricService>();
    final authService = Get.find<AuthService>();

    return Obx(() {
      // Observe isBiometricReady to trigger rebuild when service is ready
      final _ = controller.isBiometricReady.value;

      // Check if user can use biometric (has stored credentials OR valid session OR stored user info)
      final hasCredentialsOrSession =
          StorageHelper.hasStoredCredentials() ||
          authService.isLoggedIn ||
          StorageHelper.hasStoredUserInfo();

      // Debug logging
      print(
        'BiometricSection - isBiometricReady: ${controller.isBiometricReady.value}',
      );
      print(
        'BiometricSection - isBiometricAvailable: ${biometricService.isBiometricAvailable.value}',
      );
      print(
        'BiometricSection - hasStoredCredentials: ${StorageHelper.hasStoredCredentials()}',
      );
      print(
        'BiometricSection - hasStoredUserInfo: ${StorageHelper.hasStoredUserInfo()}',
      );
      print(
        'BiometricSection - isLoggedIn (Firebase): ${authService.isLoggedIn}',
      );
      print(
        'BiometricSection - hasCredentialsOrSession: $hasCredentialsOrSession',
      );
      print(
        'BiometricSection - isBiometricEnabled: ${StorageHelper.isBiometricEnabled()}',
      );
      print('BiometricSection - isLogin: ${controller.isLogin.value}');

      // Only show biometric option if:
      // 1. Biometric service is ready
      // 2. Biometric is available on device
      // 3. User has stored credentials OR has valid Firebase session OR stored user info
      // 4. Biometric login is enabled
      // 5. We're on the login tab (not sign up)
      final shouldShow =
          controller.isBiometricReady.value &&
          biometricService.isBiometricAvailable.value &&
          hasCredentialsOrSession &&
          StorageHelper.isBiometricEnabled() &&
          controller.isLogin.value;

      if (!shouldShow) {
        return const SizedBox.shrink();
      }

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            const Text(
              'Quick Login',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 16),
            _buildBiometricButton(),
            const SizedBox(height: 12),
            Text(
              'Or use email & password below',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.black.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildBiometricButton() {
    return GestureDetector(
      onTap: controller.authenticateWithBiometric,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.fingerprint,
                size: 32,
                color: AppColors.white,
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Login with Fingerprint',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
                Text(
                  'Touch sensor to authenticate',
                  style: TextStyle(fontSize: 12, color: AppColors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
