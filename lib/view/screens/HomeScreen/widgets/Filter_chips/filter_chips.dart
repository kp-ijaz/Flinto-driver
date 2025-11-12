import 'package:flinto_driver/core/constants/app_colors.dart';
import 'package:flinto_driver/presentation/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FilterChips extends StatelessWidget {
  final Function(String) onFilterChanged;

  const FilterChips({
    Key? key,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    
    return Container(
      height: 40.h,
      margin: EdgeInsets.symmetric(horizontal: 18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Obx(
        () => Row(
          children: controller.filters.map((filter) {
            final isSelected = controller.selectedFilter.value == filter;
            return Expanded(
              child: GestureDetector(
                onTap: () => onFilterChanged(filter),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.black : Colors.transparent,
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  child: Center(
                    child: Text(
                      filter,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                        color: isSelected ? Colors.white : AppColors.black,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}