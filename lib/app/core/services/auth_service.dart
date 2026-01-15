import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../utils/storage_helper.dart';

enum UserRole { admin, user }

class UserModel {
  final String uid;
  final String email;
  final UserRole role;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.role,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] == 'admin' ? UserRole.admin : UserRole.user,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'role': role == UserRole.admin ? 'admin' : 'user',
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  String get roleDisplayName =>
      role == UserRole.admin ? 'Admin' : 'Normal User';
}

class AuthService extends GetxService {
  late final FirebaseAuth _auth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Rx<User?> firebaseUser = Rx<User?>(null);
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;

  User? get user => firebaseUser.value;
  bool get isLoggedIn => user != null;

  AuthService() {
    _auth = FirebaseAuth.instance;
    // CRITICAL: Disable app verification BEFORE any auth operations
    // This fixes the "empty reCAPTCHA token" error in development
    _auth.setSettings(appVerificationDisabledForTesting: true);
  }

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());
  }

  /// Sign up with email and password
  Future<bool> signUp({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    try {
      isLoading.value = true;

      // Create user with Firebase Auth
      final UserCredential credential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      if (credential.user != null) {
        // Create user document in Firestore
        final userModel = UserModel(
          uid: credential.user!.uid,
          email: email,
          role: role,
          createdAt: DateTime.now(),
        );

        await _firestore
            .collection('users')
            .doc(credential.user!.uid)
            .set(userModel.toMap());

        currentUser.value = userModel;

        // Store user info for biometric login
        await StorageHelper.saveUserInfo(
          uid: credential.user!.uid,
          email: email,
          role: role == UserRole.admin ? 'admin' : 'user',
          password: password,
        );

        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Sign Up Error',
        e.message ?? 'An error occurred during sign up',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } catch (e) {
      Get.snackbar(
        'Sign Up Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Sign in with email and password
  Future<bool> signIn({required String email, required String password}) async {
    try {
      isLoading.value = true;

      final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        await fetchUserData(credential.user!.uid);

        // Store user info for biometric login
        final user = currentUser.value;
        await StorageHelper.saveUserInfo(
          uid: credential.user!.uid,
          email: email,
          role: user?.role == UserRole.admin ? 'admin' : 'user',
          password: password,
        );

        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Sign In Error',
        e.message ?? 'An error occurred during sign in',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } catch (e) {
      Get.snackbar(
        'Sign In Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch user data from Firestore
  Future<void> fetchUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        final user = UserModel.fromMap(doc.data()!);
        currentUser.value = user;

        // Save user info locally for biometric login
        await StorageHelper.saveUserInfo(
          uid: user.uid,
          email: user.email,
          role: user.role == UserRole.admin ? 'admin' : 'user',
        );
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  /// Restore user from local storage (for biometric auth)
  void restoreUserFromStorage() {
    final uid = StorageHelper.getUserUid();
    final email = StorageHelper.getUserEmail();
    final roleStr = StorageHelper.getUserRole();

    if (uid != null && email != null) {
      currentUser.value = UserModel(
        uid: uid,
        email: email,
        role: roleStr == 'admin' ? UserRole.admin : UserRole.user,
        createdAt: DateTime.now(),
      );
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      currentUser.value = null;
      await StorageHelper.setBiometricEnabled(false);
    } catch (e) {
      Get.snackbar(
        'Sign Out Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Check if user is authenticated and fetch user data
  Future<bool> checkAuthStatus() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await fetchUserData(user.uid).timeout(
          const Duration(seconds: 8),
          onTimeout: () {
            print('Firestore fetch timeout');
          },
        );
        return true;
      }
      return false;
    } catch (e) {
      print('Error in checkAuthStatus: $e');
      return false;
    }
  }

  /// Sign in with stored credentials (for biometric auth)
  Future<bool> signInWithStoredCredentials() async {
    try {
      final email = StorageHelper.getUserEmail();
      final password = StorageHelper.getUserPassword();

      if (email != null && password != null) {
        return await signIn(email: email, password: password);
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Sign in with Google (Android only)
  Future<bool> signInWithGoogle({required UserRole role}) async {
    // Only support Android
    if (!Platform.isAndroid) {
      Get.snackbar(
        'Not Supported',
        'Google Sign In is only supported on Android',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    try {
      isLoading.value = true;

      final googleSignIn = GoogleSignIn.instance;

      // Sign out first to ensure fresh authentication (fixes reauth issues)
      await googleSignIn.signOut();

      // Initialize with serverClientId for Android (from google-services.json -> oauth_client -> client_id with type 3)
      googleSignIn.initialize(
        serverClientId:
            '21462327165-dpsc4q1ese4jq5nt7tmgmvo7avnecri4.apps.googleusercontent.com',
      );

      // Trigger the authentication flow
      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Create a new credential - use idToken for both on Android with v7
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.idToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      if (userCredential.user != null) {
        // Check if user already exists in Firestore
        final doc = await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .get();

        if (!doc.exists) {
          // Create new user document with the selected role
          final userModel = UserModel(
            uid: userCredential.user!.uid,
            email: userCredential.user!.email ?? '',
            role: role,
            createdAt: DateTime.now(),
          );

          await _firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .set(userModel.toMap());

          currentUser.value = userModel;

          // Save user info locally for biometric login
          await StorageHelper.saveUserInfo(
            uid: userCredential.user!.uid,
            email: userCredential.user!.email ?? '',
            role: role == UserRole.admin ? 'admin' : 'user',
          );
        } else {
          // Fetch existing user data (this also saves to local storage)
          await fetchUserData(userCredential.user!.uid);
        }

        return true;
      }
      return false;
    } on GoogleSignInException catch (e) {
      // Handle cancelled or failed sign-in gracefully
      if (e.code == GoogleSignInExceptionCode.canceled) {
        Get.log('Google Sign In cancelled by user');
        return false;
      }
      Get.snackbar(
        'Google Sign In Error',
        e.description ?? 'An error occurred during Google sign in',
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.log('GoogleSignInException: ${e.code} - ${e.description}');
      return false;
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Google Sign In Error',
        e.message ?? 'An error occurred during Google sign in',
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.log('FirebaseAuthException: ${e.code} - ${e.message}');
      return false;
    } catch (e) {
      Get.snackbar(
        'Google Sign In Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.log('Exception during Google Sign In: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Sign out (including Google - Android only)
  Future<void> signOutGoogle() async {
    try {
      if (Platform.isAndroid) {
        await GoogleSignIn.instance.signOut();
      }
      await _auth.signOut();
      currentUser.value = null;
      await StorageHelper.setBiometricEnabled(false);
    } catch (e) {
      Get.snackbar(
        'Sign Out Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
