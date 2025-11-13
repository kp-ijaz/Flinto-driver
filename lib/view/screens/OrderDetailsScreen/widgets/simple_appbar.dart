import 'package:flinto_driver/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class SimpleAppBar extends StatelessWidget {
  final bool showNotification;
  final VoidCallback? onNotificationTap;

  const SimpleAppBar({
    Key? key,
    this.showNotification = true,
    this.onNotificationTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            children: [
              // Flinto Logo Image
              Image.asset(
                'assets/images/Group 113.png',
                height: 35,
                fit: BoxFit.contain,
              ),
              const Spacer(),
              
              // Notification Icon (Optional)
              if (showNotification)
                GestureDetector(
                  onTap: onNotificationTap,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.notifications_outlined,
                      color: AppColors.darkGrey,
                      size: 24,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}