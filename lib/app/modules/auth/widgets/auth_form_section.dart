import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/services/auth_service.dart';
import '../controllers/auth_controller.dart';

class AuthFormSection extends GetView<AuthController> {
  const AuthFormSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Toggle between Login and Sign Up
              _buildAuthToggle(),
              const SizedBox(height: 30),

              // Email Field
              _buildTextField(
                controller: controller.emailController,
                label: 'Email',
                hint: 'Enter your email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: controller.validateEmail,
              ),
              const SizedBox(height: 16),

              // Password Field
              _buildPasswordField(),
              const SizedBox(height: 16),

              // Confirm Password (Sign Up only)
              if (!controller.isLogin.value) ...[
                _buildConfirmPasswordField(),
                const SizedBox(height: 16),

                // Role Dropdown (Sign Up only)
                _buildRoleDropdown(),
                const SizedBox(height: 24),
              ] else
                const SizedBox(height: 24),

              // Submit Button
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAuthToggle() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightGreenBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildToggleButton(
              title: 'Login',
              isSelected: controller.isLogin.value,
              onTap: () => controller.isLogin.value = true,
            ),
          ),
          Expanded(
            child: _buildToggleButton(
              title: 'Sign Up',
              isSelected: !controller.isLogin.value,
              onTap: () => controller.isLogin.value = false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.white : AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        filled: true,
        fillColor: AppColors.white,
      ),
    );
  }

  Widget _buildPasswordField() {
    return Obx(
      () => TextFormField(
        controller: controller.passwordController,
        obscureText: !controller.isPasswordVisible.value,
        validator: controller.validatePassword,
        decoration: InputDecoration(
          labelText: 'Password',
          hintText: 'Enter your password',
          prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary),
          suffixIcon: IconButton(
            icon: Icon(
              controller.isPasswordVisible.value
                  ? Icons.visibility_off
                  : Icons.visibility,
              color: AppColors.primary,
            ),
            onPressed: controller.togglePasswordVisibility,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primary.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          filled: true,
          fillColor: AppColors.white,
        ),
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return Obx(
      () => TextFormField(
        controller: controller.confirmPasswordController,
        obscureText: !controller.isConfirmPasswordVisible.value,
        validator: controller.validateConfirmPassword,
        decoration: InputDecoration(
          labelText: 'Confirm Password',
          hintText: 'Re-enter your password',
          prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary),
          suffixIcon: IconButton(
            icon: Icon(
              controller.isConfirmPasswordVisible.value
                  ? Icons.visibility_off
                  : Icons.visibility,
              color: AppColors.primary,
            ),
            onPressed: controller.toggleConfirmPasswordVisibility,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primary.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          filled: true,
          fillColor: AppColors.white,
        ),
      ),
    );
  }

  Widget _buildRoleDropdown() {
    return Obx(
      () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(12),
          color: AppColors.white,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<UserRole>(
            value: controller.selectedRole.value,
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down, color: AppColors.primary),
            items: UserRole.values.map((role) {
              return DropdownMenuItem(
                value: role,
                child: Row(
                  children: [
                    Icon(
                      role == UserRole.admin
                          ? Icons.admin_panel_settings
                          : Icons.person,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      role == UserRole.admin ? 'Admin' : 'Normal User',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                controller.selectedRole.value = value;
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    final authService = Get.find<AuthService>();
    return Obx(
      () => ElevatedButton(
        onPressed: authService.isLoading.value ? null : controller.submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: authService.isLoading.value
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                ),
              )
            : Text(
                controller.isLogin.value ? 'Login' : 'Sign Up',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
