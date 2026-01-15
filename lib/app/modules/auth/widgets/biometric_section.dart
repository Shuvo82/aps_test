import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/services/biometric_service.dart';
import '../../../core/utils/storage_helper.dart';
import '../controllers/auth_controller.dart';

class BiometricSection extends GetView<AuthController> {
  const BiometricSection({super.key});

  @override
  Widget build(BuildContext context) {
    final biometricService = Get.find<BiometricService>();

    return Obx(() {
      // Only show biometric option if it's available and user has stored credentials
      if (!biometricService.isBiometricAvailable.value ||
          !StorageHelper.hasStoredCredentials() ||
          !StorageHelper.isBiometricEnabled()) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const Divider(height: 40),
            const Text(
              'OR',
              style: TextStyle(
                color: AppColors.disabled,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            _buildBiometricButton(),
          ],
        ),
      );
    });
  }

  Widget _buildBiometricButton() {
    return GestureDetector(
      onTap: controller.authenticateWithBiometric,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        decoration: BoxDecoration(
          color: AppColors.lightGreenBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.fingerprint,
                size: 50,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Login with Fingerprint',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Touch the fingerprint sensor',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.black.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
