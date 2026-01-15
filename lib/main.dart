import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/core/di/dependency_injection.dart';
import 'app/core/utils/storage_helper.dart';
import 'app/routes/app_pages.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize GetStorage
  await StorageHelper.init();

  // Initialize dependency injection
  await DependencyInjection.init();

  runApp(
    GetMaterialApp(
      title: "Aps Test",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal, useMaterial3: true),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
