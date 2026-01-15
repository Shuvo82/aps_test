import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/services/biometric_service.dart';
import '../controllers/home_controller.dart';

class BiometricToggleSection extends GetView<HomeController> {
  const BiometricToggleSection({super.key});

  @override
  Widget build(BuildContext context) {
    final biometricService = Get.find<BiometricService>();

    return Obx(() {
      // Only show if biometric is available on device
      if (!biometricService.isBiometricAvailable.value) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.lightOrangeBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.warning.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: AppColors.warning),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Fingerprint authentication is not available on this device.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.black.withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),
        );
      }

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.fingerprint, color: AppColors.primary, size: 24),
                SizedBox(width: 12),
                Text(
                  'Fingerprint Authentication',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Enable Quick Login',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Use fingerprint to unlock the app without entering your credentials',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.black.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Switch(
                  value: controller.isBiometricEnabled.value,
                  onChanged: controller.toggleBiometric,
                  activeColor: AppColors.primary,
                ),
              ],
            ),
            if (controller.isBiometricEnabled.value) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.lightGreenBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Fingerprint login is enabled. Next time you open the app, you can use your fingerprint to login.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.success,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      );
    });
  }
}
