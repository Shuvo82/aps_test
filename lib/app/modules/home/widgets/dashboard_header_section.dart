import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/services/auth_service.dart';
import '../controllers/home_controller.dart';

class DashboardHeaderSection extends GetView<HomeController> {
  const DashboardHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Get.find<AuthService>();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Obx(() {
          final user = authService.currentUser.value;
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Dashboard',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: controller.logout,
                    icon: const Icon(Icons.logout, color: AppColors.white),
                    tooltip: 'Logout',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildRoleBadge(user?.role),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildRoleBadge(UserRole? role) {
    final isAdmin = role == UserRole.admin;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: AppColors.white.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isAdmin ? Icons.admin_panel_settings : Icons.person,
            color: AppColors.white,
            size: 24,
          ),
          const SizedBox(width: 10),
          Text(
            isAdmin ? 'Admin User' : 'Normal User',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
