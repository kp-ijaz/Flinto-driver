import 'package:flinto_driver/core/constants/app_colors.dart';
import 'package:flinto_driver/presentation/controllers/navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  
  const CustomBottomNav({Key? key, this.currentIndex = 1}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get or create navigation controller
    NavigationController navController;
    try {
      navController = Get.find<NavigationController>();
    } catch (e) {
      navController = Get.put(NavigationController());
    }
    
    // Update current index after build to avoid triggering setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (currentIndex != navController.currentIndex.value) {
        navController.setCurrentIndex(currentIndex);
      }
    });
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.calendar_today_outlined,
                  label: 'Schedule',
                  isSelected: navController.currentIndex.value == 0,
                  onTap: () => navController.changeIndex(0),
                ),
                _NavItem(
                  icon: Icons.home,
                  label: 'Home',
                  isSelected: navController.currentIndex.value == 1,
                  onTap: () => navController.changeIndex(1),
                ),
                _NavItem(
                  icon: Icons.person_outline,
                  label: 'Profile',
                  isSelected: navController.currentIndex.value == 2,
                  onTap: () => navController.changeIndex(2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Add haptic feedback for better UX
        // HapticFeedback.lightImpact();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  icon,
                  key: ValueKey('$icon-$isSelected'),
                  color: isSelected ? Colors.white : AppColors.darkGrey,
                  size: 24.sp,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              style: TextStyle(
                fontSize: 12.sp,
                color: isSelected ? AppColors.primary : AppColors.darkGrey,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
