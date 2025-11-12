import 'package:flinto_driver/core/constants/app_colors.dart';
// import 'package:flinto_driver/core/constants/app_text.dart';
import 'package:flinto_driver/view/screens/OrderDetailsScreen/widgets/simple_appbar.dart';
import 'package:flinto_driver/view/screens/Thankyouscreen/thankyou_screen.dart';
import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart'; // Add this to pubspec.yaml

class ProductDeliveryScreen extends StatefulWidget {
  final String trackingNumber;
  final String pickupLocation;
  final String deliveryLocation;
  final String deliveryType;
  final String date;
  final String time;

  const ProductDeliveryScreen({
    Key? key,
    required this.trackingNumber,
    required this.pickupLocation,
    required this.deliveryLocation,
    required this.deliveryType,
    required this.date,
    required this.time,
  }) : super(key: key);

  @override
  State<ProductDeliveryScreen> createState() => _ProductDeliveryScreenState();
}

class _ProductDeliveryScreenState extends State<ProductDeliveryScreen> {
  // GoogleMapController? _mapController;
  // bool isDestinationReached = false;

  // final LatLng _pickupLocation = const LatLng(25.0961, 55.1562); // Marriott example
  // final LatLng _deliveryLocation = const LatLng(25.1079, 55.1713); // O2 Tower example

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SimpleAppBar(title: 'Flinto'),
          Expanded(
            child: Stack(
              children: [
                // // Map Section
                // Positioned.fill(
                //   child: GoogleMap(
                //     initialCameraPosition: CameraPosition(
                //       target: _pickupLocation,
                //       zoom: 13,
                //     ),
                //     markers: {
                //       Marker(
                //         markerId: const MarkerId('pickup'),
                //         position: _pickupLocation,
                //         icon: BitmapDescriptor.defaultMarkerWithHue(
                //           BitmapDescriptor.hueRed,
                //         ),
                //       ),
                //       Marker(
                //         markerId: const MarkerId('delivery'),
                //         position: _deliveryLocation,
                //         icon: BitmapDescriptor.defaultMarkerWithHue(
                //           BitmapDescriptor.hueGreen,
                //         ),
                //       ),
                //     },
                //     polylines: {
                //       Polyline(
                //         polylineId: const PolylineId('route'),
                //         points: [_pickupLocation, _deliveryLocation],
                //         color: AppColors.darkGrey,
                //         width: 3,
                //         patterns: [
                //           PatternItem.dash(20),
                //           PatternItem.gap(10),
                //         ],
                //       ),
                //     },
                //     onMapCreated: (controller) {
                //       _mapController = controller;
                //     },
                //     myLocationButtonEnabled: false,
                //     zoomControlsEnabled: false,
                //   ),
                // ),

                // Top Title
                Positioned(
                  top: 20,
                  left: 20,
                  right: 20,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: AppColors.primary,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Product Delivery',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGrey,
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom Sheet
                DraggableScrollableSheet(
                  initialChildSize: 0.6,
                  minChildSize: 0.6,
                  maxChildSize: 0.9,
                  builder: (context, scrollController) {
                    return Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Drag Handle
                            Center(
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 12),
                                width: 40,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),

                            // Order Info Card
                            Container(
                              margin: const EdgeInsets.all(16),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppColors.lightGrey,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 70,
                                        height: 70,
                                        decoration: const BoxDecoration(
                                          color: AppColors.darkGrey,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.home_work_outlined,
                                          color: Colors.white,
                                          size: 35,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      const Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Home Moving | Loading &',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.darkGrey,
                                              ),
                                            ),
                                            Text(
                                              'Unloading',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.darkGrey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(
                                        Icons.more_vert,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.inventory_2_outlined,
                                        size: 18,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Tracking ID: #${widget.trackingNumber}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
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
                                            width: 14,
                                            height: 14,
                                            decoration: const BoxDecoration(
                                              color: AppColors.primary,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          Container(
                                            width: 2,
                                            height: 50,
                                            color: Colors.grey[300],
                                          ),
                                          Container(
                                            width: 14,
                                            height: 14,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.grey,
                                                width: 2,
                                              ),
                                            ),
                                          ),
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
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.darkGrey,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              widget.pickupLocation,
                                              style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            const Text(
                                              'Shipping To:',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.darkGrey,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              widget.deliveryLocation,
                                              style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 16),

                                  // Status
                                  const Row(
                                    children: [
                                      Text(
                                        'Status: ',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.darkGrey,
                                        ),
                                      ),
                                      Text(
                                        'Picked Up',
                                        style: TextStyle(
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

                            // Delivery Details
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppColors.lightGrey,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                children: [
                                  _buildDetailRow(
                                    Icons.speed,
                                    'Delivery Made',
                                    widget.deliveryType,
                                  ),
                                  const Divider(height: 32),
                                  _buildDetailRow(
                                    Icons.calendar_today_outlined,
                                    'Date',
                                    widget.date,
                                  ),
                                  const Divider(height: 32),
                                  _buildDetailRow(
                                    Icons.access_time,
                                    'Placed at time',
                                    widget.time,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Destination Card
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 16),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFE5E5),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: AppColors.primary,
                                    size: 30,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'O2 Residential Tower',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          widget.deliveryLocation,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: AppColors.primary.withOpacity(0.8),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: AppColors.primary,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Payment Status
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
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
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                        color: AppColors.delivered,
                                        width: 2,
                                      ),
                                    ),
                                    child: const Text(
                                      'Paid',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.delivered,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Action Button
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const ThankYouDeliveryScreen(),
      ),
    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    padding: const EdgeInsets.symmetric(vertical: 18),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: const Text(
                                    'Finished Service',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.darkGrey, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGrey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // void _showQRCodeDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //       title: const Text(
  //         'QR Code Sent',
  //         style: TextStyle(fontWeight: FontWeight.bold),
  //       ),
  //       content: const Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Icon(
  //             Icons.qr_code_2,
  //             size: 100,
  //             color: AppColors.primary,
  //           ),
  //           SizedBox(height: 16),
  //           Text(
  //             'QR Code has been sent to the delivery location',
  //             textAlign: TextAlign.center,
  //             style: TextStyle(fontSize: 14),
  //           ),
  //         ],
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text('OK'),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}