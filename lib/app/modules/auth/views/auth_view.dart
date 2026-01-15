import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../core/constant/app_colors.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_form_section.dart';
import '../widgets/biometric_section.dart';
import '../widgets/header_section.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGreenBackground,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Obx(
              () => HeaderSection(
                title: controller.isLogin.value
                    ? 'Welcome Back!'
                    : 'Create Account',
                subtitle: controller.isLogin.value
                    ? 'Sign in to continue'
                    : 'Register to get started',
                icon: controller.isLogin.value
                    ? Icons.lock_open
                    : Icons.person_add,
              ),
            ),
            const SizedBox(height: 20),

            // Authentication Form Section
            const AuthFormSection(),

            // Biometric Login Section (visible only when enabled)
            const BiometricSection(),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
