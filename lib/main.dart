import 'package:flutter/material.dart';
import 'view/screens/loginScreen/login_screen.dart';
// import 'view/screens/splashScreen/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flinto Driver',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: LoginScreen(),
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
