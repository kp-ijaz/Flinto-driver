import 'package:flinto_driver/core/constants/app_colors.dart';
import 'package:flinto_driver/core/constants/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  
  const StatusBadge({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color;
    Color bgColor;
    
    switch (status.toLowerCase()) {
      case 'delivered':
        color = AppColors.delivered;
        bgColor = AppColors.delivered.withOpacity(0.1);
        break;
      case 'on process':
        color = AppColors.onProcess;
        bgColor = AppColors.onProcess.withOpacity(0.1);
        break;
      case 'pending':
      default:
        color = AppColors.pending;
        bgColor = AppColors.pending.withOpacity(0.1);
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(25.r),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Text(
        status,
        style: AppTextStyles.statusLabel.copyWith(color: color, fontSize: 14.sp),
      ),
    );
  }
}
