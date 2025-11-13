import 'package:flinto_driver/view/screens/HomeScreen/widgets/bottomnavbar/bottom_nav_bar.dart';
import 'package:flinto_driver/presentation/controllers/navigation_controller.dart';
import 'package:flinto_driver/presentation/controllers/auth_controller.dart';
import 'package:flinto_driver/view/screens/OrderDetailsScreen/widgets/simple_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('MMM dd, yyyy').format(date);
  }

  String _formatPhoneNumber(String? countryCode, String? phone) {
    if (countryCode == null || phone == null) return 'N/A';
    return '$countryCode $phone';
  }

  @override
  Widget build(BuildContext context) {
    // Initialize controllers
    final navController = Get.isRegistered<NavigationController>()
        ? Get.find<NavigationController>()
        : Get.put(NavigationController());
    
    final authController = Get.find<AuthController>();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navController.setCurrentIndex(2);
    });
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SimpleAppBar(showNotification: true),
            
            // Accounts Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(12, 12, 20, 20),
              child: Row(
                children: [
                  const Icon(
                    Icons.arrow_back,
                    color: Color(0xFFFF6B6B),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Accounts',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF0F0),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit_outlined,
                      color: Color(0xFFFF6B6B),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Scrollable Content
            Expanded(
              child: Obx(() {
                final driver = authController.driver;
                
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      // Profile Image
                      Stack(
                        children: [
                          Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[200],
                              image: driver?.driverPhoto != null
                                  ? DecorationImage(
                                      image: NetworkImage(driver!.driverPhoto!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: driver?.driverPhoto == null
                                ? Icon(
                                    Icons.person,
                                    size: 50,
                                    color: Colors.grey[400],
                                  )
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFF6B6B),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      
                      // Name
                      Text(
                        driver?.name ?? 'Driver Name',
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      
                      // Profile Information Section
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            _InfoItem(
                              label: 'Email:',
                              value: driver?.email ?? 'N/A',
                            ),
                            const Divider(height: 20, color: Color(0xFFE0E0E0)),
                            _InfoItem(
                              label: 'Phone Number:',
                              value: _formatPhoneNumber(
                                driver?.countryCode,
                                driver?.phoneNumber,
                              ),
                            ),
                            const Divider(height: 20, color: Color(0xFFE0E0E0)),
                            _InfoItem(
                              label: 'Driver ID:',
                              value: driver?.driverRegistrationId != null
                                  ? '#DR${driver!.driverRegistrationId}'
                                  : 'N/A',
                            ),
                            const Divider(height: 20, color: Color(0xFFE0E0E0)),
                            _InfoItem(
                              label: 'Joined Date:',
                              value: _formatDate(driver?.updatedAt),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Vehicle Details Section
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Vehicle Details',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Vehicle Image
                                Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey[200],
                                    image: const DecorationImage(
                                      image: NetworkImage(
                                        'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?w=400',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                
                                // Vehicle Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        driver?.carType ?? 'Vehicle Type',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'License Number:',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                const Text(
                                                  'KA 05695',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Plate Number:',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                const Text(
                                                  '3WPASS',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Vehicle Detail:',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'A reliable and powerful utility vehicle designed for heavy loads and long hauls.',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.black87,
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            
                            // Know More Button
                            Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF6B6B),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: const Text(
                                  'Know More',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(currentIndex: 2),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const _InfoItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}