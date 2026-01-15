import 'package:get/get.dart';

import '../../../core/services/auth_service.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  @override
  void onInit() {
    super.onInit();
    _navigateToNextScreen();
  }

  /// Check auth status and navigate to appropriate screen
  Future<void> _navigateToNextScreen() async {
    // Add a small delay for splash screen visibility
    await Future.delayed(const Duration(seconds: 2));

    // Check if user is already logged in
    final isLoggedIn = await _authService.checkAuthStatus();

    if (isLoggedIn) {
      Get.offAllNamed(Routes.HOME);
    } else {
      Get.offAllNamed(Routes.AUTH);
    }
  }
}
