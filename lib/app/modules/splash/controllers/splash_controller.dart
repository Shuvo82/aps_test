import 'package:get/get.dart';

import '../../../core/services/auth_service.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  @override
  void onInit() {
    super.onInit();
    print('SplashController onInit called');
    _navigateToNextScreen();
  }

  /// Check auth status and navigate to appropriate screen
  Future<void> _navigateToNextScreen() async {
    try {
      // Add a small delay for splash screen visibility
      await Future.delayed(const Duration(seconds: 2));

      // Check if user is already logged in with timeout
      bool isLoggedIn = false;
      try {
        isLoggedIn = await _authService.checkAuthStatus().timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            print('Auth check timeout, navigating to auth');
            return false;
          },
        );
      } catch (e) {
        print('Error checking auth status: $e');
        isLoggedIn = false;
      }

      if (isLoggedIn) {
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.offAllNamed(Routes.AUTH);
      }
    } catch (e) {
      print('Navigation error: $e');
      Get.offAllNamed(Routes.AUTH);
    }
  }
}
