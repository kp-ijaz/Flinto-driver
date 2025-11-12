import 'package:flinto_driver/core/constants/app_text.dart';
import 'package:flinto_driver/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: Get.width * 0.75,
      child: Column(
        children: [
          // Header Section with Profile
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(24.w, 60.h, 24.w, 30.h),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF7B6B), Color(0xFFFF9B8A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Image
                Container(
                  width: 90.w,
                  height: 90.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                // Name
                Text(
                  'Mr. Rahim',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 12.h),
                // Language Toggle
                Row(
                  children: [
                    Text(
                      'English',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Container(
                      width: 52.w,
                      height: 30.h,
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                              child: Container(
                                width: 24.w,
                                height: 24.w,
                              decoration: const BoxDecoration(
                                color: Color(0xFF4CAF50),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Menu Items
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  SizedBox(height: 8.h),
                  _DrawerMenuItem(
                    icon: Icons.home_outlined,
                    title: AppText.home,
                    onTap: () {
                      Get.back();
                      Get.toNamed(AppRoutes.home);
                    },
                  ),
                  Divider(height: 1.h, indent: 72.w, endIndent: 16.w),
                  _DrawerMenuItem(
                    icon: Icons.calendar_today_outlined,
                    title: AppText.schedule,
                    onTap: () {
                      Get.back();
                      Get.toNamed(AppRoutes.schedule);
                    },
                  ),
                  Divider(height: 1.h, indent: 72.w, endIndent: 16.w),
                  _DrawerMenuItem(
                    icon: Icons.person_outline,
                    title: AppText.accounts,
                    onTap: () {
                      Get.back();
                      Get.toNamed(AppRoutes.profile);
                    },
                  ),
                  Divider(height: 1.h, indent: 72.w, endIndent: 16.w),
                  _DrawerMenuItem(
                    icon: Icons.history,
                    title: AppText.orderHistoryMenu,
                    onTap: () {
                      Get.back();
                      // Navigate to Order History
                    },
                  ),
                  Divider(height: 1.h, indent: 72.w, endIndent: 16.w),
                  _DrawerMenuItem(
                    icon: Icons.settings_outlined,
                    title: AppText.settings,
                    onTap: () {
                      Get.back();
                      // Navigate to Settings
                    },
                  ),
                  Divider(height: 1.h, indent: 16.w, endIndent: 16.w, thickness: 1),
                  _DrawerMenuItem(
                    icon: Icons.logout,
                    title: AppText.logout,
                    isLogout: true,
                    onTap: () {
                      _showLogoutDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ),

          // Footer
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _FooterLink(text: AppText.termsOfService, onTap: () {}),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.w),
                  width: 1.w,
                  height: 12.h,
                  color: Colors.grey[400],
                ),
                _FooterLink(text: AppText.privacyPolicy, onTap: () {}),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.w),
                  width: 1.w,
                  height: 12.h,
                  color: Colors.grey[400],
                ),
                _FooterLink(text: AppText.contactUs, onTap: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text(AppText.logout, style: TextStyle(fontSize: 18.sp)),
        content: Text('Are you sure you want to logout?', style: TextStyle(fontSize: 14.sp)),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(AppText.cancel, style: TextStyle(fontSize: 14.sp)),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.back();
              Get.offAllNamed(AppRoutes.login);
            },
            child: Text(
              AppText.logout,
              style: TextStyle(color: const Color(0xFFFF6B6B), fontSize: 14.sp),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== DRAWER MENU ITEM ====================
class _DrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isLogout;
  final VoidCallback onTap;

  const _DrawerMenuItem({
    required this.icon,
    required this.title,
    this.isLogout = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Row(
          children: [
            Icon(
              icon,
              color: isLogout ? const Color(0xFFFF6B6B) : Colors.black,
              size: 24.sp,
            ),
            SizedBox(width: 24.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                color: isLogout ? const Color(0xFFFF6B6B) : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== FOOTER LINK ====================
class _FooterLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _FooterLink({
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11.sp,
          color: Colors.grey,
        ),
      ),
    );
  }
}
