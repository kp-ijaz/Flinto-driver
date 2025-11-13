import 'package:flinto_driver/view/screens/HomeScreen/widgets/bottomnavbar/bottom_nav_bar.dart';
import 'package:flinto_driver/presentation/controllers/navigation_controller.dart';
import 'package:flinto_driver/view/screens/OrderDetailsScreen/widgets/simple_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime selectedDate = DateTime(2023, 8, 27);
  late NavigationController navController;

  @override
  void initState() {
    super.initState();
    // Initialize navigation controller with schedule index
    navController = Get.isRegistered<NavigationController>()
        ? Get.find<NavigationController>()
        : Get.put(NavigationController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navController.setCurrentIndex(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            const SimpleAppBar(showNotification: true,),
            // Schedule Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(12, 12, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.arrow_back,
                        color: Color(0xFFFF6B6B),
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Schedule',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Date Selector
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(decoration: BoxDecoration(border: Border.all()),
                          child: const Icon(Icons.chevron_left, size: 24, color: Colors.black)),
                        const SizedBox(width: 20),
                        const Text(
                          'Aug 27, 2023',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Container(decoration: BoxDecoration(border: Border.all()),
                          child: const Icon(Icons.chevron_right, size: 24, color: Colors.black)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Delivery Cards List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: const [
                  DeliveryCard(
                    packageType: 'Small Parcel',
                    trackingId: '#B56H48',
                    from: 'Marriott Residences...',
                    to: 'O2 Residential Towe...',
                    isExpress: true,
                    isPickUp: true,
                  ),
                  SizedBox(height: 12),
                  DeliveryCard(
                    packageType: 'Documents',
                    trackingId: '#B56H48',
                    from: 'Marriott Residences...',
                    to: 'O2 Residential Towe...',
                    isExpress: false,
                    isPickUp: true,
                  ),
                  SizedBox(height: 12),
                  DeliveryCard(
                    packageType: 'Small Parcel',
                    trackingId: '#B56H48',
                    from: 'Marriott Residences...',
                    to: 'O2 Residential Towe...',
                    isExpress: false,
                    isPickUp: false,
                  ),
                  SizedBox(height: 12),
                  DeliveryCard(
                    packageType: 'Documents',
                    trackingId: '#B56H48',
                    from: 'Marriott Residences...',
                    to: 'O2 Residential Towe...',
                    isExpress: true,
                    isPickUp: true,
                  ),
                  SizedBox(height: 12),
                  DeliveryCard(
                    packageType: 'Documents',
                    trackingId: '#B56H48',
                    from: 'Marriott Residences...',
                    to: 'O2 Residential Towe...',
                    isExpress: false,
                    isPickUp: true,
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 0),
    );
  }
}

class DeliveryCard extends StatelessWidget {
  final String packageType;
  final String trackingId;
  final String from;
  final String to;
  final bool isExpress;
  final bool isPickUp;

  const DeliveryCard({
    Key? key,
    required this.packageType,
    required this.trackingId,
    required this.from,
    required this.to,
    required this.isExpress,
    required this.isPickUp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline
          Column(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF6B6B),
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 2,
                height: 48,
                color: const Color(0xFFE0E0E0),
                margin: const EdgeInsets.symmetric(vertical: 2),
              ),
              Container(
                width: 14,
                height: 14,
                decoration: const BoxDecoration(
                  color: Color(0xFFE0E0E0),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          // Addresses
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'From:',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  from,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF757575),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Shipping To:',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  to,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF757575),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
                width: 1,
                height: 100,
                color: const Color(0xFFE0E0E0),
                margin: const EdgeInsets.symmetric(vertical: 2),
              ),const SizedBox(width: 10),
          // Package Info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                packageType,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Tracking ID: $trackingId',
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 11,
                  color: Color(0xFF9E9E9E),
                ),
              ),
              const SizedBox(height: 10),
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: isExpress 
                      ? const Color(0xFFFFF0F0) 
                      : const Color(0xFFE8F4FD),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isExpress 
                        ? const Color(0xFFFF6B6B) 
                        : const Color(0xFF64B5F6),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isExpress ? Icons.bolt : Icons.access_time,
                      size: 13,
                      color: isExpress 
                          ? const Color(0xFFFF6B6B) 
                          : const Color(0xFF64B5F6),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isExpress ? 'Express' : 'Schedule',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isExpress 
                            ? const Color(0xFFFF6B6B) 
                            : const Color(0xFF64B5F6),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              // Action Button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isPickUp 
                        ? const Color(0xFFFF6B6B) 
                        : const Color(0xFF66BB6A),
                    width: 1,
                  ),
                ),
                child: Text(
                  isPickUp ? 'Pick Up' : 'Drop',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isPickUp 
                        ? const Color(0xFFFF6B6B) 
                        : const Color(0xFF66BB6A),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
