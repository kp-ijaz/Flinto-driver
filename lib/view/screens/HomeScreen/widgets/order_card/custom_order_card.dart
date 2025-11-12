import 'package:flinto_driver/core/constants/app_colors.dart';
import 'package:flinto_driver/core/constants/app_text.dart';
import 'package:flinto_driver/view/screens/HomeScreen/widgets/status_badge/status_badge.dart';
import 'package:flinto_driver/view/screens/OrderDetailsScreen/order_detail_screen.dart';
import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final String trackingNumber;
  final String status;
  final IconData icon;
  
  const OrderCard({
    Key? key,
    required this.trackingNumber,
    required this.status,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailsScreen(
              trackingNumber: trackingNumber,
              status: status,
            ),
          ),
        );
    },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        padding: const EdgeInsets.only(left: 14,right: 14,bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: AppColors.darkGrey,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(trackingNumber, style: AppTextStyles.trackingNumber),
                   SizedBox(height: 4),
                   Text('Returned to sender', style: AppTextStyles.subtitle),
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
