import 'package:flinto_driver/core/constants/app_colors.dart';
import 'package:flinto_driver/core/constants/app_text.dart';
import 'package:flinto_driver/view/screens/HomeScreen/widgets/searchbar/custom_searchbar.dart';
import 'package:flinto_driver/presentation/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final bool showBackButton;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.showBackButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFF6453),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 30.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Menu or Back Button
                  if (showBackButton)
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white, size: 28.sp),
                      onPressed: () => Get.back(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    )
                  else
                    IconButton(
                      icon: Icon(Icons.menu, color: Colors.white, size: 28.sp),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  
                  // Logo Images in Center
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/logo white.png',
                          height: 30.h,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(width: 8.w),
                        Image.asset(
                          'assets/images/text main.png',
                          height: 25.h,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                  
                  // Notification Icon
                  IconButton(
                    icon: Icon(Icons.notifications_outlined, color: Colors.white, size: 28.sp),
                    onPressed: () {
                      Get.find<HomeController>().navigateToNotifications();
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Text(
                title,
                style: AppTextStyles.heading.copyWith(fontSize: 28.sp),
              ),
              SizedBox(height: 10.h),
              const SearchBarr(
                hint: AppText.enterTrackingNumber,
                showQRCode: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}