import 'package:flutter/material.dart';

extension MediaQueryX on BuildContext {
  Size get mediaSize => MediaQuery.of(this).size;
  double get screenWidth => mediaSize.width;
  double get screenHeight => mediaSize.height;
}

class AppResponsive {
  static bool isPhone(double width) => width < 600;
  static bool isTablet(double width) => width >= 600 && width < 1024;
  static bool isDesktop(double width) => width >= 1024;

  static EdgeInsets horizontalPaddingForWidth(double width) {
    if (isDesktop(width)) return const EdgeInsets.symmetric(horizontal: 48);
    if (isTablet(width)) return const EdgeInsets.symmetric(horizontal: 24);
    return const EdgeInsets.symmetric(horizontal: 16);
  }

  static int gridCountForWidth(
    double width, {
    int phone = 2,
    int tablet = 3,
    int desktop = 4,
  }) {
    if (isDesktop(width)) return desktop;
    if (isTablet(width)) return tablet;
    return phone;
  }
}

// import 'package:flutter/widgets.dart';

class Responsive {
  static const double _baseWidth = 375.0; // iPhone X width baseline
  static const double _baseHeight = 812.0; // iPhone X height baseline

  static double w(BuildContext context, double size) {
    final width = MediaQuery.of(context).size.width;
    return size * (width / _baseWidth);
  }

  static double h(BuildContext context, double size) {
    final height = MediaQuery.of(context).size.height;
    return size * (height / _baseHeight);
  }

  static double sp(BuildContext context, double fontSize) {
    final shortest = MediaQuery.of(context).size.shortestSide;
    final scale = shortest / _baseWidth;
    final value = fontSize * scale;
    return value.clamp(fontSize * 0.85, fontSize * 1.25);
  }
}
