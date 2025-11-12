import 'package:flinto_driver/core/constants/app_colors.dart';
import 'package:flinto_driver/presentation/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SearchBarr extends StatelessWidget {
  final String hint;
  final bool showQRCode;
  
  const SearchBarr({
    Key? key,
    required this.hint,
    this.showQRCode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final searchController = TextEditingController();
    
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: TextField(
              controller: searchController,
              onChanged: (value) => controller.searchOrders(value),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14.sp),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              ),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        if (showQRCode)
          Container(
            margin: EdgeInsets.only(right: 8.w),
            decoration: BoxDecoration(
              color: AppColors.darkGrey,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.qr_code_scanner, color: Colors.white, size: 22.sp),
              onPressed: () {},
            ),
          ),
      ],
    );
  }
}
