import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../core/constant/app_colors.dart';
import '../controllers/home_controller.dart';
import '../widgets/biometric_toggle_section.dart';
import '../widgets/dashboard_header_section.dart';
import '../widgets/user_info_section.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGreenBackground,
      body: const SingleChildScrollView(
        child: Column(
          children: [
            // Dashboard Header Section
            DashboardHeaderSection(),
            SizedBox(height: 20),

            // User Info Section
            UserInfoSection(),
            SizedBox(height: 16),

            // Biometric Toggle Section
            BiometricToggleSection(),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
