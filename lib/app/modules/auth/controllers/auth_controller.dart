import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constant/app_colors.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/biometric_service.dart';
import '../../../core/utils/storage_helper.dart';
import '../../../routes/app_pages.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final BiometricService _biometricService = Get.find<BiometricService>();

  // Form key
  final formKey = GlobalKey<FormState>();

  // Text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Observable variables
  final RxBool isLogin = true.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;
  final Rx<UserRole> selectedRole = UserRole.user.obs;

  @override
  void onInit() {
    super.onInit();
    // Check if biometric login is available
    _checkBiometricLogin();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  /// Check if biometric login should be prompted
  Future<void> _checkBiometricLogin() async {
    // Small delay to ensure UI is ready
    await Future.delayed(const Duration(milliseconds: 500));

    if (StorageHelper.isBiometricEnabled() &&
        StorageHelper.hasStoredCredentials() &&
        _biometricService.isBiometricAvailable.value) {
      // Auto-trigger biometric authentication
      authenticateWithBiometric();
    }
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  /// Toggle confirm password visibility
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  /// Validate email
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  /// Validate password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  /// Validate confirm password
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Submit form
  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;

    bool success;
    if (isLogin.value) {
      success = await _authService.signIn(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
    } else {
      success = await _authService.signUp(
        email: emailController.text.trim(),
        password: passwordController.text,
        role: selectedRole.value,
      );
    }

    if (success) {
      Get.offAllNamed(Routes.HOME);
    }
  }

  /// Authenticate with biometric
  Future<void> authenticateWithBiometric() async {
    if (!_biometricService.isBiometricAvailable.value) {
      Get.snackbar(
        'Error',
        'Biometric authentication is not available',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final authenticated = await _biometricService.authenticate(
      reason: 'Authenticate to login to the app',
    );

    if (authenticated) {
      // Sign in with stored credentials
      final success = await _authService.signInWithStoredCredentials();
      if (success) {
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.snackbar(
          'Error',
          'Failed to login. Please enter your credentials.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  /// Clear form
  void clearForm() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    selectedRole.value = UserRole.user;
  }

  /// Sign in with Google
  Future<void> signInWithGoogle() async {
    // Show role selection dialog first
    final role = await _showRoleSelectionDialog();
    if (role == null) return; // User canceled

    final success = await _authService.signInWithGoogle(role: role);
    if (success) {
      Get.offAllNamed(Routes.HOME);
    }
  }

  /// Show role selection dialog
  Future<UserRole?> _showRoleSelectionDialog() async {
    return await Get.dialog<UserRole>(
      AlertDialog(
        title: const Text('Select Your Role'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please select your role to continue:'),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.person, color: AppColors.primary),
              title: const Text('Normal User'),
              subtitle: const Text('Regular access'),
              tileColor: AppColors.lightGreenBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              onTap: () => Get.back(result: UserRole.user),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(
                Icons.admin_panel_settings,
                color: AppColors.primary,
              ),
              title: const Text('Admin'),
              subtitle: const Text('Full access'),
              tileColor: AppColors.lightGreenBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              onTap: () => Get.back(result: UserRole.admin),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
