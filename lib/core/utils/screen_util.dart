import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenUtilHelper {
  static void init(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
    );
  }
}

extension ScreenUtilExtension on num {
  double get w => ScreenUtil().setWidth(this);
  double get h => ScreenUtil().setHeight(this);
  double get r => ScreenUtil().radius(this);
  double get sp => ScreenUtil().setSp(this);
  double get sw => ScreenUtil().screenWidth * this;
  double get sh => ScreenUtil().screenHeight * this;
}

