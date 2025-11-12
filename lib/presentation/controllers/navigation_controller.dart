import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';

class NavigationController extends GetxController {
  final RxInt currentIndex = 1.obs; // 0: Schedule, 1: Home, 2: Profile

  @override
  void onInit() {
    super.onInit();
    // Initialize with home screen
    currentIndex.value = 1;
  }

  void changeIndex(int index) {
    if (currentIndex.value == index) return;
    
    // Update index first for immediate UI feedback
    currentIndex.value = index;
    
    // Get current route name
    final currentRoute = Get.currentRoute;
    
    // Check if we're already on a bottom nav screen
    final isBottomNavScreen = currentRoute == AppRoutes.home ||
        currentRoute == AppRoutes.schedule ||
        currentRoute == AppRoutes.profile;
    
    // Navigate to the selected screen
    // Use offNamedUntil to pop to the first bottom nav screen if we're navigating from a detail screen
    // Otherwise, use offNamed to replace the current bottom nav screen
    switch (index) {
      case 0:
        if (isBottomNavScreen) {
          Get.offNamed(AppRoutes.schedule, arguments: {'fromBottomNav': true});
        } else {
          Get.offNamedUntil(
            AppRoutes.schedule,
            (route) => route.settings.name == AppRoutes.home ||
                route.settings.name == AppRoutes.schedule ||
                route.settings.name == AppRoutes.profile ||
                route.isFirst,
            arguments: {'fromBottomNav': true},
          );
        }
        break;
      case 1:
        if (isBottomNavScreen) {
          Get.offNamed(AppRoutes.home, arguments: {'fromBottomNav': true});
        } else {
          Get.offNamedUntil(
            AppRoutes.home,
            (route) => route.settings.name == AppRoutes.home ||
                route.settings.name == AppRoutes.schedule ||
                route.settings.name == AppRoutes.profile ||
                route.isFirst,
            arguments: {'fromBottomNav': true},
          );
        }
        break;
      case 2:
        if (isBottomNavScreen) {
          Get.offNamed(AppRoutes.profile, arguments: {'fromBottomNav': true});
        } else {
          Get.offNamedUntil(
            AppRoutes.profile,
            (route) => route.settings.name == AppRoutes.home ||
                route.settings.name == AppRoutes.schedule ||
                route.settings.name == AppRoutes.profile ||
                route.isFirst,
            arguments: {'fromBottomNav': true},
          );
        }
        break;
    }
  }

  void setCurrentIndex(int index) {
    if (currentIndex.value != index) {
      currentIndex.value = index;
    }
  }
}

