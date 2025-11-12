import 'dart:developer';
import 'package:flinto_driver/core/constants/app_colors.dart';
// import 'package:flinto_driver/core/constants/app_text.dart';
import 'package:flinto_driver/data/repositories/order_status_api.dart';
import 'package:flinto_driver/view/screens/DeliveryOtpScreen/delivery_otp_screen.dart';
import 'package:flinto_driver/view/screens/OrderDetailsScreen/widgets/simple_appbar.dart';
import 'package:flinto_driver/presentation/controllers/auth_controller.dart';
// import 'package:flinto_driver/view/screens/delivery_otp_screen.dart'; // Import the new OTP screen
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDeliveryScreen extends StatefulWidget {
  final Map<String, dynamic>? orderData;

  const ProductDeliveryScreen({
    Key? key,
    this.orderData,
  }) : super(key: key);

  @override
  State<ProductDeliveryScreen> createState() => _ProductDeliveryScreenState();
}

class _ProductDeliveryScreenState extends State<ProductDeliveryScreen> {
  bool isProcessing = false;
  final OrderStatusApi _statusApi = OrderStatusApi();
  
  late final Map<String, dynamic> args;
  
  @override
  void initState() {
    super.initState();
    args = widget.orderData ?? Get.arguments as Map<String, dynamic>? ?? {};
    
    log('\n📥 PRODUCT DELIVERY SCREEN - RECEIVED ARGUMENTS:');
    log('═══════════════════════════════════════════════════');
    log('Order ID: ${_getArg('id')}');
    log('Tracking Number: ${_getArg('trackingNumber')}');
    log('Invoice Status ID: ${_getIntArg('invoiceStatusId')} (Type: ${args['invoiceStatusId']?.runtimeType})');
    log('Category ID: ${_getIntArg('categoryId')} (Type: ${args['categoryId']?.runtimeType})');
    log('Status: ${_getArg('status')}');
    log('Category Name: ${_getArg('categoryName')}');
    log('Delivery Landmark: ${_getArg('deliveryLandmark')}');
    log('═══════════════════════════════════════════════════\n');
  }

  String _getArg(String key, {String fallback = 'N/A'}) {
    return args[key]?.toString() ?? fallback;
  }

  int _getIntArg(String key, {int fallback = 0}) {
    final value = args[key];
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? fallback;
    return fallback;
  }

  bool _hasDeliveryLocation() {
    final deliveryLocation = _getArg('deliveryLocation', fallback: '');
    return deliveryLocation.isNotEmpty && 
           deliveryLocation != 'N/A' && 
           deliveryLocation != 'Location not available' &&
           deliveryLocation != 'Delivery location not available';
  }

  Future<void> _handleDeliveryOrEnd() async {
    final categoryId = _getIntArg('categoryId');
    
    // If it's a delivery (categoryId == 1), navigate to OTP screen
    if (categoryId == 1) {
      log('🔐 Navigating to OTP screen for delivery verification');
      
      // Navigate to OTP screen and pass order data
      final result = await Get.to(
        () => DeliveryOtpScreen(
          orderData: args,
          trackingNumber: _getArg('trackingNumber'),
        ),
      );
      
      // If OTP verification was successful, the DeliveryOtpScreen will handle navigation
      // No need to do anything here
      return;
    }
    
    // For End Service (categoryId != 1), complete directly without OTP
    setState(() => isProcessing = true);

    try {
      final authController = Get.find<AuthController>();
      final driverId = authController.driver?.driverRegistrationId;
      
      if (driverId == null) {
        throw Exception('Driver ID not found');
      }

      final orderMasterId = _getIntArg('id');
      
      log('🔄 Ending Service:');
      log('  Order Master ID: $orderMasterId');
      log('  Driver ID: $driverId');
      log('  Status: Delivered');
      
      await _statusApi.updateOrderStatus(
        orderMasterId: orderMasterId,
        driverId: driverId,
        status: 'Delivered',
        lang: 'en',
      );

      log('✅ Service ended successfully!');

      if (!mounted) return;

      setState(() => isProcessing = false);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Service completed successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Get.offAllNamed('/home');
        }
      });
    } catch (e) {
      log('❌ Error ending service: $e');
      if (!mounted) return;
      
      setState(() => isProcessing = false);
      Get.snackbar('Error', 'Failed to complete service: $e',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    final trackingNumber = _getArg('trackingNumber', fallback: 'B56H48');
    final pickupLocation = _getArg('pickupLocation', fallback: 'Marriott Residences, Sheikh Mohammed...');
    final deliveryLocation = _getArg('deliveryLocation', fallback: 'O2 Residential Tower, Sheikh Zayed Rd...');
    final deliveryLandmark = _getArg('deliveryLandmark', fallback: 'Delivery Location');
    final orderDate = _getArg('orderDate', fallback: '26 Aug, 2025');
    final time = _getArg('time', fallback: '08:00 PM');
    final deliveryType = _getArg('deliveryType', fallback: 'Express');
    final categoryName = _getArg('categoryName', fallback: 'Courier');
    final status = _getArg('status', fallback: 'Picked Up');
    final paymentAmount = _getArg('paymentAmount', fallback: 'AED 1,220');
    final paymentStatus = _getArg('paymentStatus', fallback: 'Paid');
    final categoryId = _getIntArg('categoryId');
    final invoiceStatusId = _getIntArg('invoiceStatusId');

    final buttonText = categoryId == 1 ? 'Delivered' : 'End Service';
    final buttonIcon = categoryId == 1 ? Icons.check_circle : Icons.stop_circle;

    log('\n🔘 BUTTON RENDERING (Product Delivery):');
    log('  Invoice Status ID: $invoiceStatusId');
    log('  Category ID: $categoryId');
    log('  Button Text: $buttonText');
    log('  Is Processing: $isProcessing');

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SimpleAppBar(title: 'Flinto'),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.arrow_back, color: AppColors.primary, size: 28),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Product Delivery',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkGrey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Map Section with Route
                  Container(
                    height: 250,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: CustomPaint(
                      painter: _hasDeliveryLocation() 
                        ? RoutePainter()
                        : null,
                      child: Stack(
                        children: [
                          if (_hasDeliveryLocation()) ...[
                            Positioned(
                              top: 40,
                              right: 50,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.location_on, color: Colors.white, size: 24),
                              ),
                            ),
                            Positioned(
                              bottom: 80,
                              left: 60,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.location_on, color: Colors.white, size: 24),
                              ),
                            ),
                          ] else
                            Positioned(
                              top: 100,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.location_on, color: Colors.white, size: 24),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Main Order Card
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: AppColors.darkGrey,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Icon(Icons.access_time, color: Colors.white, size: 30),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$categoryName | ${_getArg('deliveryType', fallback: 'Small Parcel')}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.darkGrey,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.inventory_2_outlined, size: 14, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          'Tracking ID: #$trackingNumber',
                                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 4),
                            IconButton(
                              icon: const Icon(Icons.more_horiz, color: AppColors.darkGrey),
                              onPressed: () {},
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // From/To Locations
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Container(
                                  width: 2,
                                  height: 50,
                                  color: Colors.grey[400],
                                ),
                              ],
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'From:',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.darkGrey,
                                    ),
                                  ),
                                  Text(
                                    pickupLocation,
                                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey, width: 2),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Shipping To:',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.darkGrey,
                                    ),
                                  ),
                                  Text(
                                    deliveryLocation,
                                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),
                        Divider(color: Colors.grey[300], height: 1),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            const Text(
                              'Status: ',
                              style: TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                            Text(
                              status,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.darkGrey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Delivery Details
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.speed, color: AppColors.darkGrey, size: 24),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Delivery Made',
                                    style: TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    deliveryType,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.darkGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Divider(color: Colors.grey[300], height: 28),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.calendar_today_outlined, color: AppColors.darkGrey, size: 24),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Date',
                                    style: TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    orderDate,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.darkGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Divider(color: Colors.grey[300], height: 28),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.access_time, color: AppColors.darkGrey, size: 24),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Placed at time',
                                    style: TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    time,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.darkGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Delivery Address Highlight - NOW USING LANDMARK
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE5E5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, color: Color(0xFFFF6B4A), size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                deliveryLandmark,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFF6B4A),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                deliveryLocation,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFFFF6B4A),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF6B4A),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check, color: Colors.white, size: 20),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Payment Status
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Payment Status:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkGrey,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFF4CAF50)),
                          ),
                          child: Text(
                            paymentStatus,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4CAF50),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Action Button
                  if (invoiceStatusId == 5)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: isProcessing
                          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                          : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _handleDeliveryOrEnd,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFF6B4A),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                  elevation: 2,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(buttonIcon, color: Colors.white, size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      buttonText,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _statusApi.dispose();
    super.dispose();
  }
}

// Custom painter for drawing the dotted route line on the map
class RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    
    final startX = size.width * 0.25;
    final startY = size.height * 0.65;
    
    final endX = size.width * 0.7;
    final endY = size.height * 0.25;
    
    path.moveTo(startX, startY);
    path.quadraticBezierTo(
      size.width * 0.4, 
      size.height * 0.5,
      size.width * 0.55, 
      size.height * 0.4
    );
    path.quadraticBezierTo(
      size.width * 0.65, 
      size.height * 0.3,
      endX, 
      endY
    );

    _drawDashedPath(canvas, path, paint);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    const dashWidth = 8.0;
    const dashSpace = 5.0;
    
    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final nextDistance = distance + dashWidth;
        final extractPath = metric.extractPath(
          distance,
          nextDistance > metric.length ? metric.length : nextDistance,
        );
        canvas.drawPath(extractPath, paint);
        distance = nextDistance + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}