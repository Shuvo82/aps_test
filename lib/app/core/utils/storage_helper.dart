import 'package:get_storage/get_storage.dart';

class StorageHelper {
  static const String _biometricEnabledKey = 'biometric_enabled';
  static const String _userEmailKey = 'user_email';
  static const String _userPasswordKey = 'user_password';
  static const String _userUidKey = 'user_uid';
  static const String _userRoleKey = 'user_role';

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

  /// Save user UID
  static Future<void> saveUserUid(String uid) async {
    await _box.write(_userUidKey, uid);
  }

  /// Get stored user UID
  static String? getUserUid() {
    return _box.read(_userUidKey);
  }

  /// Save user role
  static Future<void> saveUserRole(String role) async {
    await _box.write(_userRoleKey, role);
  }

  /// Get stored user role
  static String? getUserRole() {
    return _box.read(_userRoleKey);
  }

  /// Save all user info
  static Future<void> saveUserInfo({
    required String uid,
    required String email,
    required String role,
    String? password,
  }) async {
    await saveUserUid(uid);
    await saveUserEmail(email);
    await saveUserRole(role);
    if (password != null) {
      await saveUserPassword(password);
    }
  }

  /// Clear all stored credentials
  static Future<void> clearCredentials() async {
    await _box.remove(_userEmailKey);
    await _box.remove(_userPasswordKey);
    await _box.remove(_biometricEnabledKey);
    await _box.remove(_userUidKey);
    await _box.remove(_userRoleKey);
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

  /// Check if user info is stored (for biometric without password)
  static bool hasStoredUserInfo() {
    final uid = getUserUid();
    final email = getUserEmail();
    return uid != null && email != null && uid.isNotEmpty && email.isNotEmpty;
  }
}
