import 'dart:developer';
import 'package:flinto_driver/core/constants/app_colors.dart';
import 'package:flinto_driver/core/constants/app_text.dart';
import 'package:flinto_driver/data/repositories/order_status_api.dart';
import 'package:flinto_driver/view/screens/OrderDetailsScreen/widgets/info_row.dart';
import 'package:flinto_driver/view/screens/OrderDetailsScreen/widgets/simple_appbar.dart';
import 'package:flinto_driver/view/screens/ProductDeliveryScreen/product_delivery_screen.dart';
import 'package:flinto_driver/presentation/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({Key? key}) : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  bool isProcessing = false;
  final OrderStatusApi _statusApi = OrderStatusApi();
  
  late final Map<String, dynamic> args;
  
  @override
  void initState() {
    super.initState();
    args = Get.arguments as Map<String, dynamic>? ?? {};
    
    log('\n📥 ORDER DETAILS SCREEN - RECEIVED ARGUMENTS:');
    log('═══════════════════════════════════════════════════');
    log('Order ID: ${_getArg('id')}');
    log('Tracking Number: ${_getArg('trackingNumber')}');
    log('Invoice Status ID: ${_getIntArg('invoiceStatusId')} (Type: ${args['invoiceStatusId']?.runtimeType})');
    log('Category ID: ${_getIntArg('categoryId')} (Type: ${args['categoryId']?.runtimeType})');
    log('Status: ${_getArg('status')}');
    log('Category Name: ${_getArg('categoryName')}');
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

  Future<void> _handleAccept() async {
    setState(() => isProcessing = true);

    try {
      final authController = Get.find<AuthController>();
      final driverId = authController.driver?.driverRegistrationId;
      
      if (driverId == null) {
        throw Exception('Driver ID not found');
      }

      final orderMasterId = _getIntArg('id');
      
      log('🔄 Accepting Order:');
      log('  Order Master ID: $orderMasterId');
      log('  Driver ID: $driverId');
      log('  Status: Accepted');
      
      await _statusApi.updateOrderStatus(
        orderMasterId: orderMasterId,
        driverId: driverId,
        status: 'Accepted',
        lang: 'en',
      );

      args['invoiceStatusId'] = 4;
      
      log('✅ Order accepted successfully! New invoiceStatusId: 4');
      
      if (!mounted) return;
      
      setState(() => isProcessing = false);
      showTopSnackBar(context, 'Order accepted successfully!');
    } catch (e) {
      log('❌ Error accepting order: $e');
      if (!mounted) return;
      
      setState(() => isProcessing = false);
      Get.snackbar('Error', 'Failed to accept order: $e',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
    }
  }

  Future<void> _handleReject() async {
    final BuildContext dialogContext = context;
    
    showDialog(
      context: dialogContext,
      builder: (BuildContext alertContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Reject Order'),
        content: const Text('Are you sure you want to reject this order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(alertContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(alertContext);
              
              if (!mounted) return;
              
              setState(() => isProcessing = true);

              try {
                final authController = Get.find<AuthController>();
                final driverId = authController.driver?.driverRegistrationId;
                
                if (driverId == null) {
                  throw Exception('Driver ID not found');
                }

                final orderMasterId = _getIntArg('id');
                
                log('🔄 Rejecting Order:');
                log('  Order Master ID: $orderMasterId');
                log('  Driver ID: $driverId');
                log('  Status: Rejected');
                
                await _statusApi.updateOrderStatus(
                  orderMasterId: orderMasterId,
                  driverId: driverId,
                  status: 'Rejected',
                  lang: 'en',
                );

                log('✅ Order rejected successfully!');

                if (!mounted) return;

                setState(() => isProcessing = false);

                Get.snackbar(
                  'Success',
                  'Order rejected successfully',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 2),
                );

                await Future.delayed(const Duration(milliseconds: 800));
                
                if (mounted) {
                  Get.back();
                }
              } catch (e) {
                log('❌ Error rejecting order: $e');
                if (!mounted) return;
                
                setState(() => isProcessing = false);
                Get.snackbar(
                  'Error',
                  'Failed to reject order: $e',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            child: const Text('Reject', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _handlePickupOrStart() async {
    setState(() => isProcessing = true);

    try {
      final authController = Get.find<AuthController>();
      final driverId = authController.driver?.driverRegistrationId;
      
      if (driverId == null) {
        throw Exception('Driver ID not found');
      }

      final orderMasterId = _getIntArg('id');
      
      log('🔄 Picking Up/Starting Service:');
      log('  Order Master ID: $orderMasterId');
      log('  Driver ID: $driverId');
      log('  Status: PickedUp');
      
      await _statusApi.updateOrderStatus(
        orderMasterId: orderMasterId,
        driverId: driverId,
        status: 'PickedUp',
        lang: 'en',
      );

      args['invoiceStatusId'] = 5;
      
      log('✅ Status updated to PickedUp! New invoiceStatusId: 5');
      
      if (!mounted) return;
      
      setState(() => isProcessing = false);
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDeliveryScreen(
            orderData: args,
          ),
        ),
      );
    } catch (e) {
      log('❌ Error updating status: $e');
      if (!mounted) return;
      
      setState(() => isProcessing = false);
      Get.snackbar('Error', 'Failed to update status: $e',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
    }
  }

  void showTopSnackBar(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 20,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 2), () => overlayEntry.remove());
  }

  Widget _buildProductDetails() {
    final productDetails = args['productDetails'] as Map<String, List<String>>?;
    
    if (productDetails == null || productDetails.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Product Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGrey,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: productDetails.entries.map((entry) {
              final title = entry.key.replaceAll('_', ' ');
              final items = entry.value;
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${title.toUpperCase()} :',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      items.join(', '),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderImages() {
    final orderImages = args['orderImages'] as List<dynamic>?;
    
    if (orderImages == null || orderImages.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Order Images',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGrey,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: orderImages.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      backgroundColor: Colors.transparent,
                      child: Stack(
                        children: [
                          Center(
                            child: Image.network(
                              orderImages[index].toString(),
                              fit: BoxFit.contain,
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: IconButton(
                              icon: const Icon(Icons.close, color: Colors.white, size: 30),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 120,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[200],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      orderImages[index].toString(),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.image_not_supported,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerInfo() {
    final customerName = _getArg('customerName', fallback: 'Mr. Rahim');
    final customerPhone = _getArg('customerPhone', fallback: '+0123456789');
    final customerAddress = _getArg('customerAddress', fallback: 'Sheikh Zayed Rd, Al Barsha...');
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Customer information',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.darkGrey,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customerName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkGrey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      customerPhone,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 60,
                width: 2,
                color: Colors.grey[400],
                margin: const EdgeInsets.symmetric(horizontal: 16),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Address:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkGrey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      customerAddress,
                      style: const TextStyle(
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
        ),
      ],
    );
  }

  bool _hasDeliveryLocation() {
    final deliveryLocation = _getArg('deliveryLocation', fallback: '');
    return deliveryLocation.isNotEmpty && 
           deliveryLocation != 'N/A' && 
           deliveryLocation != 'Location not available' &&
           deliveryLocation != 'Delivery location not available';
  }

  Widget _buildActionButtons() {
    final invoiceStatusId = _getIntArg('invoiceStatusId');
    final categoryId = _getIntArg('categoryId');

    log('\n🔘 BUTTON RENDERING:');
    log('  Invoice Status ID: $invoiceStatusId');
    log('  Category ID: $categoryId');
    log('  Is Processing: $isProcessing');

    if (isProcessing) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    if (invoiceStatusId == 3) {
      log('  ✅ Showing Accept/Reject buttons (Status 3)');
      return Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: _handleReject,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: const BorderSide(color: Colors.red, width: 2),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Reject',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.red),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _handleAccept,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B4A),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                elevation: 2,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Accept Order',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    if (invoiceStatusId == 4) {
      final buttonText = categoryId == 1 ? 'Pick Up' : 'Start Service';
      log('  ✅ Showing $buttonText button (Status 4, Category $categoryId)');
      
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _handlePickupOrStart,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF6B4A),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            elevation: 2,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                categoryId == 1 ? Icons.local_shipping : Icons.play_arrow,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                buttonText,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ],
          ),
        ),
      );
    }

    log('  ⚠️ No buttons to show (Status $invoiceStatusId not handled)');
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final categoryName = _getArg('categoryName', fallback: 'Courier');
    final deliveryType = _getArg('deliveryType', fallback: 'Small Parcel');
    final trackingNumber = _getArg('trackingNumber', fallback: 'B56H48');
    final status = _getArg('status', fallback: 'Pending');
    final pickupLocation = _getArg('pickupLocation', fallback: 'Marriott Residences, Sheikh Mohammed...');
    final deliveryLocation = _getArg('deliveryLocation', fallback: 'O2 Residential Tower, Sheikh Zayed Rd...');
    final orderDate = _getArg('orderDate', fallback: '26 Aug, 2025');
    final time = _getArg('time', fallback: '');
    final paymentAmount = _getArg('paymentAmount', fallback: 'AED 1,220');
    final paymentStatus = _getArg('paymentStatus', fallback: 'Paid');

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
                          'Details of a Job',
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
                    height: 200,
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
                              top: 30,
                              right: 40,
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
                              bottom: 40,
                              left: 50,
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
                              top: 75,
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

                  // Main Order Card with Three Dots Menu
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: AppColors.darkGrey,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: const Icon(Icons.local_shipping_outlined, color: Colors.white, size: 26),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$categoryName | $deliveryType',
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

                        const SizedBox(height: 16),
                        
                        // Location Section
                        if (_hasDeliveryLocation()) ...[
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
                          const SizedBox(height: 8),
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
                        ] else
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.location_on, color: AppColors.primary, size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Location:',
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

                        const SizedBox(height: 6),
                        Divider(color: Colors.grey[400], height: 24),
                        
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

                  // Delivery Info with Icons
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.speed, color: AppColors.darkGrey, size: 22),
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
                        Divider(color: Colors.grey[300], height: 24),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.calendar_today_outlined, color: AppColors.darkGrey, size: 22),
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
                        Divider(color: Colors.grey[300], height: 24),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.credit_card, color: AppColors.darkGrey, size: 22),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Payment',
                                    style: TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    paymentAmount,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.darkGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F5E9),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppColors.delivered),
                              ),
                              child: Text(
                                paymentStatus,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF4CAF50),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Customer Information Section
                  _buildCustomerInfo(),
                  
                  const SizedBox(height: 20),

                  // Product Details Section
                  _buildProductDetails(),
                  
                  const SizedBox(height: 20),

                  // Order Images Section
                  _buildOrderImages(),
                  
                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildActionButtons(),
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
    
    // Start point (bottom left - pickup)
    final startX = size.width * 0.2;
    final startY = size.height * 0.75;
    
    // End point (top right - delivery)
    final endX = size.width * 0.75;
    final endY = size.height * 0.25;
    
    // Create a curved path
    path.moveTo(startX, startY);
    path.quadraticBezierTo(
      size.width * 0.4, 
      size.height * 0.6,
      size.width * 0.55, 
      size.height * 0.45
    );
    path.quadraticBezierTo(
      size.width * 0.65, 
      size.height * 0.35,
      endX, 
      endY
    );

    // Draw dashed line
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