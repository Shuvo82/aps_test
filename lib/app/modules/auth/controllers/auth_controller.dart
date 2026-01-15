import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
}
