import 'package:flinto_driver/core/constants/app_colors.dart';
import 'package:flinto_driver/core/constants/app_text.dart';
import 'package:flinto_driver/view/screens/HomeScreen/widgets/status_badge/status_badge.dart';
import 'package:flinto_driver/presentation/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OrderCard extends StatelessWidget {
  final String trackingNumber;
  final String status;
  final IconData icon;
  final String? orderDate;

  const OrderCard({
    Key? key,
    required this.trackingNumber,
    required this.status,
    required this.icon,
    this.orderDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    
    return InkWell(
      onTap: () {
        // Find the full order from the controller's list
        final order = controller.orders.firstWhere(
          (o) => o.trackingNumber == trackingNumber,
          orElse: () => controller.orders.first,
        );
        controller.navigateToOrderDetails(order);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        padding: EdgeInsets.only(left: 14.w, right: 14.w, bottom: 8.h, top: 8.h),
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          children: [
            Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                color: AppColors.darkGrey,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 30.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trackingNumber,
                    style: AppTextStyles.trackingNumber.copyWith(fontSize: 16.sp),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    orderDate ?? 'No date',
                    style: AppTextStyles.subtitle.copyWith(fontSize: 13.sp),
                  ),
                ],
              ),
            ),
            StatusBadge(status: status),
          ],
        ),
      ),
    );
  }
}