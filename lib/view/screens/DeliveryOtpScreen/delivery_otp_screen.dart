import 'dart:developer';
import 'package:flinto_driver/core/constants/app_colors.dart';
import 'package:flinto_driver/core/utils/responsive.dart';
import 'package:flinto_driver/data/repositories/order_status_api.dart';
import 'package:flinto_driver/presentation/controllers/auth_controller.dart';
// import 'package:flinto_driver/view/screens/ThankYouDeliveryScreen.dart';
import 'package:flinto_driver/view/screens/Thankyouscreen/thankyou_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class DeliveryOtpScreen extends StatefulWidget {
  final Map<String, dynamic> orderData;
  final String trackingNumber;

  const DeliveryOtpScreen({
    Key? key,
    required this.orderData,
    required this.trackingNumber,
  }) : super(key: key);

  @override
  State<DeliveryOtpScreen> createState() => _DeliveryOtpScreenState();
}

class _DeliveryOtpScreenState extends State<DeliveryOtpScreen> {
  final List<TextEditingController> otpControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(4, (index) => FocusNode());
  
  bool isVerifying = false;
  final String correctOtp = '1111'; // Fixed OTP
  final OrderStatusApi _statusApi = OrderStatusApi();

  @override
  void dispose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    _statusApi.dispose();
    super.dispose();
  }

  String _getEnteredOtp() {
    return otpControllers.map((controller) => controller.text).join();
  }

  Future<void> _verifyOtpAndCompleteDelivery() async {
    final enteredOtp = _getEnteredOtp();

    if (enteredOtp.length != 4) {
      Get.snackbar(
        'Invalid OTP',
        'Please enter all 4 digits',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (enteredOtp != correctOtp) {
      Get.snackbar(
        'Invalid OTP',
        'The OTP you entered is incorrect. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      
      // Clear all OTP fields
      for (var controller in otpControllers) {
        controller.clear();
      }
      
      // Focus on first field
      FocusScope.of(context).requestFocus(focusNodes[0]);
      return;
    }

    // OTP is correct, proceed with delivery completion
    setState(() => isVerifying = true);

    try {
      final authController = Get.find<AuthController>();
      final driverId = authController.driver?.driverRegistrationId;

      if (driverId == null) {
        throw Exception('Driver ID not found');
      }

      final orderMasterId = widget.orderData['id'] is int
          ? widget.orderData['id']
          : int.tryParse(widget.orderData['id']?.toString() ?? '0') ?? 0;

      log('🔄 Completing Delivery after OTP verification:');
      log('  Order Master ID: $orderMasterId');
      log('  Driver ID: $driverId');
      log('  Status: Delivered');

      await _statusApi.updateOrderStatus(
        orderMasterId: orderMasterId,
        driverId: driverId,
        status: 'Delivered',
        lang: 'en',
      );

      log('✅ Delivery completed successfully!');

      if (!mounted) return;

      setState(() => isVerifying = false);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Delivery completed successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // Navigate to Thank You screen
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          Get.off(() => const ThankYouDeliveryScreen());
        }
      });
    } catch (e) {
      log('❌ Error completing delivery: $e');
      if (!mounted) return;

      setState(() => isVerifying = false);
      
      Get.snackbar(
        'Error',
        'Failed to complete delivery: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.darkGrey),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Verify Delivery',
          style: TextStyle(
            color: AppColors.darkGrey,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: AppResponsive.horizontalPaddingForWidth(
            MediaQuery.of(context).size.width,
          ),
          child: Column(
            children: [
              SizedBox(height: Responsive.h(context, 40)),
              
              // Delivery Icon
              Container(
                height: Responsive.h(context, 120),
                width: Responsive.h(context, 120),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE5E5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.local_shipping_outlined,
                  size: Responsive.h(context, 60),
                  color: const Color(0xFFFF6B4A),
                ),
              ),
              
              SizedBox(height: Responsive.h(context, 30)),
              
              Text(
                "Enter Delivery OTP",
                style: TextStyle(
                  fontSize: Responsive.sp(context, 24),
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkGrey,
                ),
              ),
              
              SizedBox(height: Responsive.h(context, 12)),
              
              Text(
                "Tracking #${widget.trackingNumber}",
                style: TextStyle(
                  fontSize: Responsive.sp(context, 14),
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              
              SizedBox(height: Responsive.h(context, 8)),
              
              Text(
                "Please enter the 4-digit OTP to confirm delivery",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Responsive.sp(context, 14),
                  color: Colors.grey[600],
                ),
              ),
              
              SizedBox(height: Responsive.h(context, 8)),
              
              // Show test OTP in development
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Test OTP: $correctOtp",
                  style: TextStyle(
                    fontSize: Responsive.sp(context, 13),
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              
              SizedBox(height: Responsive.h(context, 40)),
              
              // OTP Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  return SizedBox(
                    width: Responsive.w(context, 60),
                    height: Responsive.h(context, 70),
                    child: TextField(
                      controller: otpControllers[index],
                      focusNode: focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      onChanged: (value) {
                        if (value.length == 1 && index < 3) {
                          FocusScope.of(context).requestFocus(focusNodes[index + 1]);
                        } else if (value.isEmpty && index > 0) {
                          FocusScope.of(context).requestFocus(focusNodes[index - 1]);
                        } else if (value.length == 1 && index == 3) {
                          // Auto-verify when last digit is entered
                          FocusScope.of(context).unfocus();
                        }
                      },
                      style: TextStyle(
                        fontSize: Responsive.sp(context, 32),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: Responsive.h(context, 18),
                        ),
                        counterText: "",
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFFF6B4A),
                            width: 2,
                          ),
                        ),
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  );
                }),
              ),
              
              SizedBox(height: Responsive.h(context, 30)),
              
              // Resend OTP (for future implementation)
              TextButton(
                onPressed: () {
                  Get.snackbar(
                    'OTP Info',
                    'For delivery verification, please use OTP: $correctOtp',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.blue[100],
                    colorText: Colors.blue[900],
                  );
                },
                child: const Text(
                  "Need help with OTP?",
                  style: TextStyle(
                    color: Color(0xFFFF6B4A),
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              
              SizedBox(height: Responsive.h(context, 30)),
              
              // Verify Button
              SizedBox(
                width: context.screenWidth * 0.7,
                child: ElevatedButton(
                  onPressed: isVerifying ? null : _verifyOtpAndCompleteDelivery,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B4A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: Responsive.h(context, 16),
                    ),
                    elevation: 2,
                  ),
                  child: isVerifying
                      ? SizedBox(
                          height: Responsive.h(context, 20),
                          width: Responsive.h(context, 20),
                          child: const CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          "Verify & Complete Delivery",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              
              SizedBox(height: Responsive.h(context, 40)),
            ],
          ),
        ),
      ),
    );
  }
}