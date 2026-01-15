import 'package:get/get.dart';

import '../services/auth_service.dart';
import '../services/biometric_service.dart';

class DependencyInjection {
  static Future<void> init() async {
    // Initialize services
    Get.put<AuthService>(AuthService(), permanent: true);
    Get.put<BiometricService>(BiometricService(), permanent: true);
  }
}
