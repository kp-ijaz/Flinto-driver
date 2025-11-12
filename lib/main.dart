import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'core/routes/app_routes.dart';
import 'presentation/controllers/auth_controller.dart';
import 'presentation/controllers/location_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(AuthController(), permanent: true);
  Get.put(LocationController(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        final authController = Get.find<AuthController>();
        return GetMaterialApp(
          title: 'Flinto Driver',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          initialRoute:
              authController.isLoggedIn ? AppRoutes.home : AppRoutes.login,
          getPages: AppRoutes.getPages,
          defaultTransition: Transition.rightToLeft,
          transitionDuration: const Duration(milliseconds: 300),
        );
      },
    );
  }
}

// ============================================
// NEW ARCHITECTURE (GetX) - Available but not active
// Uncomment below and comment above to use new architecture
// ============================================
/*
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'core/routes/app_routes.dart';

void main() {
  runApp(const MyAppNew());
}

class MyAppNew extends StatelessWidget {
  const MyAppNew({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Flinto Driver',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.orange,
            useMaterial3: true,
          ),
          initialRoute: AppRoutes.splash,
          getPages: AppRoutes.getPages,
          defaultTransition: Transition.rightToLeft,
          transitionDuration: const Duration(milliseconds: 300),
        );
      },
    );
  }
}
*/
