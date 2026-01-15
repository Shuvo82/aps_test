import 'package:get_storage/get_storage.dart';

class StorageHelper {
  static const String _biometricEnabledKey = 'biometric_enabled';
  static const String _userEmailKey = 'user_email';
  static const String _userPasswordKey = 'user_password';

  static GetStorage get _box => GetStorage();

  /// Initialize GetStorage
  static Future<void> init() async {
    await GetStorage.init();
  }

  /// Check if biometric is enabled
  static bool isBiometricEnabled() {
    return _box.read(_biometricEnabledKey) ?? false;
  }

  /// Set biometric enabled status
  static Future<void> setBiometricEnabled(bool enabled) async {
    await _box.write(_biometricEnabledKey, enabled);
  }

  /// Save user email for biometric login
  static Future<void> saveUserEmail(String email) async {
    await _box.write(_userEmailKey, email);
  }

  /// Get stored user email
  static String? getUserEmail() {
    return _box.read(_userEmailKey);
  }

  /// Save user password for biometric login
  static Future<void> saveUserPassword(String password) async {
    await _box.write(_userPasswordKey, password);
  }

  /// Get stored user password
  static String? getUserPassword() {
    return _box.read(_userPasswordKey);
  }

  /// Clear all stored credentials
  static Future<void> clearCredentials() async {
    await _box.remove(_userEmailKey);
    await _box.remove(_userPasswordKey);
    await _box.remove(_biometricEnabledKey);
  }

  /// Check if credentials are stored
  static bool hasStoredCredentials() {
    final email = getUserEmail();
    final password = getUserPassword();
    return email != null &&
        password != null &&
        email.isNotEmpty &&
        password.isNotEmpty;
  }
}
