import 'package:flinto_driver/core/constants/app_colors.dart';
import 'package:flinto_driver/core/constants/app_text.dart';
import 'package:flinto_driver/view/screens/OrderDetailsScreen/widgets/info_row.dart';
import 'package:flinto_driver/view/screens/OrderDetailsScreen/widgets/simple_appbar.dart';
import 'package:flinto_driver/view/screens/ProductDeliveryScreen/product_delivery_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({Key? key}) : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  bool isAccepted = false;
  bool isRejected = false;
  bool isProcessing = false;

  late final Map<String, dynamic> args;
  
  @override
  void initState() {
    super.initState();
    args = Get.arguments as Map<String, dynamic>? ?? {};
  }

  String _getArg(String key, {String fallback = 'N/A'}) {
    return args[key]?.toString() ?? fallback;
  }

  void _handleAccept() {
    setState(() => isProcessing = true);

    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        isAccepted = true;
        isProcessing = false;
      });
      showTopSnackBar(context, 'Order accepted successfully!');
    });
  }

  void _handleReject() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Reject Order'),
        content: const Text('Are you sure you want to reject this order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => isProcessing = true);

              Future.delayed(const Duration(milliseconds: 800), () {
                setState(() {
                  isRejected = true;
                  isProcessing = false;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Order rejected'),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 2),
                  ),
                );

                Future.delayed(const Duration(seconds: 1), () {
                  Navigator.pop(context);
                });
              });
            },
            child: const Text('Reject', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _handleScanQR() {
    showTopSnackBar(context, 'Opening QR Scanner...');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDeliveryScreen(
          trackingNumber: _getArg('trackingNumber'),
          pickupLocation: _getArg('pickupLocation'),
          date: _getArg('orderDate'),
          deliveryLocation: _getArg('deliveryLocation'),
          deliveryType: _getArg('deliveryType'),
          time: _getArg('time'),
        ),
      ),
    );
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
      return Text(
        'No product details available',
        style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.5),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: productDetails.entries.map((entry) {
        final title = entry.key.replaceAll('_', ' ').toUpperCase();
        final items = entry.value;
        
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGrey,
                ),
              ),
              const SizedBox(height: 4),
              ...items.map((item) => Padding(
                padding: const EdgeInsets.only(left: 8, top: 2),
                child: Text(
                  '• $item',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              )),
            ],
          ),
        );
      }).toList(),
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
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text('Order Images', style: AppTextStyles.subtitle),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: orderImages.length,
            itemBuilder: (context, index) {
              return Container(
                width: 100,
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
              );
            },
          ),
        ),
      ],
    );
  }

  // Helper method to check if delivery location is available
  bool _hasDeliveryLocation() {
    final deliveryLocation = _getArg('deliveryLocation', fallback: '');
    return deliveryLocation.isNotEmpty && 
           deliveryLocation != 'N/A' && 
           deliveryLocation != 'Location not available' &&
           deliveryLocation != 'Delivery location not available';
  }

  // Build location section based on whether delivery location exists
  Widget _buildLocationSection(String pickupLocation, String deliveryLocation) {
    final hasDelivery = _hasDeliveryLocation();

    if (!hasDelivery) {
      // Single location display
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.location_on),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Location:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGrey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  pickupLocation,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      );
    }

    // From and To display
    return Column(
      children: [
        // From Location
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                Container(width: 2, height: 40, color: Colors.grey[300]),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'From:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGrey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pickupLocation,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
        // To Location
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey, width: 2),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Shipping To:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGrey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    deliveryLocation,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoryName = _getArg('categoryName', fallback: 'Service');
    final deliveryType = _getArg('deliveryType', fallback: 'Standard');
    final trackingNumber = _getArg('trackingNumber');
    final status = _getArg('status', fallback: 'Unknown');
    final pickupLocation = _getArg('pickupLocation', fallback: 'Location not available');
    final deliveryLocation = _getArg('deliveryLocation', fallback: 'Location not available');
    final orderDate = _getArg('orderDate', fallback: 'No date');
    final time = _getArg('time', fallback: 'No time');
    final paymentAmount = _getArg('paymentAmount', fallback: 'AED 0.00');
    final paymentStatus = _getArg('paymentStatus', fallback: 'Pending');
    final customerName = _getArg('customerName', fallback: 'Customer');
    final customerPhone = _getArg('customerPhone', fallback: 'Not available');
    final customerAddress = _getArg('customerAddress', fallback: 'Address not available');

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
                  // Page Title with Back Button
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.arrow_back, color: AppColors.primary, size: 28),
                        ),
                        const SizedBox(width: 12),
                        Text('Details of a Job', style: AppTextStyles.subtitle),
                      ],
                    ),
                  ),

                  // Status Banner
                  if (isAccepted || isRejected)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isAccepted ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isAccepted ? Colors.green : Colors.red,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isAccepted ? Icons.check_circle : Icons.cancel,
                            color: isAccepted ? Colors.green : Colors.red,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            isAccepted ? 'Order Accepted - Ready for Pickup' : 'Order Rejected',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: isAccepted ? Colors.green[800] : Colors.red[800],
                            ),
                          ),
                        ],
                      ),
                    ),

                  if (isAccepted || isRejected) const SizedBox(height: 16),

                  // Map Section
                  Container(
                    height: 250,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          Container(
                            color: Colors.grey[300],
                            child: Center(
                              child: Icon(Icons.map, size: 80, color: Colors.grey[400]),
                            ),
                          ),
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
                                child: const Icon(Icons.location_on, color: Colors.white, size: 30),
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
                                child: const Icon(Icons.location_on, color: Colors.white, size: 30),
                              ),
                            ),
                          ] else
                            Positioned(
                              top: 85,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: AppColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.location_on, color: Colors.white, size: 30),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Order Info Card
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: const BoxDecoration(
                                color: AppColors.darkGrey,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.local_shipping_outlined, color: Colors.white, size: 30),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$categoryName | $deliveryType',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.darkGrey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.inventory_2_outlined, size: 16, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          'Tracking ID: #$trackingNumber',
                                          style: const TextStyle(fontSize: 13, color: Colors.grey),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Dynamic Location Section
                        _buildLocationSection(pickupLocation, deliveryLocation),

                        const SizedBox(height: 20),

                        Row(
                          children: [
                            const Text('Status: ', style: TextStyle(fontSize: 15, color: AppColors.darkGrey)),
                            Text(
                              status,
                              style: const TextStyle(
                                fontSize: 15,
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

                  // Delivery Info
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        InfoRow(
                          icon: Icons.speed,
                          label: 'Delivery Type',
                          value: deliveryType,
                        ),
                        Divider(color: Colors.grey[200]),
                        InfoRow(
                          icon: Icons.calendar_today_outlined,
                          label: 'Date',
                          value: '$orderDate ${time.isNotEmpty && time != 'No time' ? "at $time" : ""}',
                        ),
                        Divider(color: Colors.grey[200]),
                        InfoRow(
                          icon: Icons.credit_card,
                          label: 'Payment',
                          value: paymentAmount,
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: paymentStatus.toLowerCase() == 'paid' 
                                  ? AppColors.delivered.withOpacity(0.1)
                                  : Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: paymentStatus.toLowerCase() == 'paid' 
                                    ? AppColors.delivered
                                    : Colors.orange,
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              paymentStatus,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: paymentStatus.toLowerCase() == 'paid' 
                                    ? AppColors.delivered
                                    : Colors.orange,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Customer Information
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text('Customer information', style: AppTextStyles.subtitle),
                  ),

                  const SizedBox(height: 12),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                customerName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkGrey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Phone: $customerPhone',
                                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 50,
                          color: Colors.grey[300],
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Address:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkGrey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                customerAddress,
                                style: const TextStyle(fontSize: 13, color: Colors.grey),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text('Product Details', style: AppTextStyles.subtitle),
                  ),
                  const SizedBox(height: 12),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildProductDetails(),
                  ),

                  // Order Images Section
                  _buildOrderImages(),

                  const SizedBox(height: 24),

                  // Action Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: isProcessing
                          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                          : isAccepted
                              ? _buildQRButton()
                              : isRejected
                                  ? const SizedBox.shrink()
                                  : _buildAcceptRejectButtons(),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcceptRejectButtons() {
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

  Widget _buildQRButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _handleScanQR,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF6B4A),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 2,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 12),
            Text(
              'Start Service',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}