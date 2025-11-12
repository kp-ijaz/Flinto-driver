import 'package:flinto_driver/core/constants/app_colors.dart';
import 'package:flinto_driver/core/utils/responsive.dart';
import 'package:flinto_driver/presentation/controllers/otp_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class OtpScreen extends StatelessWidget {
  final String phoneNumber;
  final String receivedOtp;

  const OtpScreen({
    super.key,
    required this.phoneNumber,
    required this.receivedOtp,
  });

  @override
  Widget build(BuildContext context) {
    final OtpController controller = Get.put(
      OtpController(phoneNumber: phoneNumber, expectedOtp: receivedOtp),
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: AppResponsive.horizontalPaddingForWidth(
            MediaQuery.of(context).size.width,
          ),
          child: Column(
            children: [
              SizedBox(height: Responsive.h(context, 160)),
              Container(
                height: Responsive.h(context, 150),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/Group 113.png"),
                  ),
                ),
              ),
              SizedBox(height: Responsive.h(context, 60)),
              Text(
                "Enter OTP",
                style: TextStyle(
                  fontSize: Responsive.sp(context, 24),
                  fontWeight: FontWeight.bold,
                  color: AppColors.pending,
                ),
              ),
              SizedBox(height: Responsive.h(context, 10)),
              Text(
                "Please enter the 4-digit code sent to $phoneNumber",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Responsive.sp(context, 14),
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: Responsive.h(context, 8)),
              Text(
                "Test OTP: ${controller.expectedOtp}",
                style: TextStyle(
                  fontSize: Responsive.sp(context, 13),
                  color: Colors.grey[500],
                ),
              ),
              SizedBox(height: Responsive.h(context, 32)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  return SizedBox(
                    width: Responsive.w(context, 60),
                    height: Responsive.h(context, 70),
                    child: TextField(
                      controller: controller.otpControllers[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      onChanged: (value) {
                        if (value.length == 1 && index < 3) {
                          FocusScope.of(context).nextFocus();
                        } else if (value.isEmpty && index > 0) {
                          FocusScope.of(context).previousFocus();
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
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.pending,
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
              TextButton(
                onPressed: () {
                  Get.snackbar(
                    'OTP',
                    'Please contact support to resend OTP.',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                child: Text(
                  "Didn't receive code? Resend",
                  style: TextStyle(
                    color: AppColors.pending,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: Responsive.h(context, 30)),
              Obx(
                () => SizedBox(
                  width: context.screenWidth * 0.7,
                  child: ElevatedButton(
                    onPressed: controller.isVerifying.value
                        ? null
                        : controller.verifyOtp,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: Responsive.h(context, 15),
                      ),
                    ),
                    child: controller.isVerifying.value
                        ? SizedBox(
                            height: Responsive.h(context, 18),
                            width: Responsive.h(context, 18),
                            child: const CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text("Verify OTP"),
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
