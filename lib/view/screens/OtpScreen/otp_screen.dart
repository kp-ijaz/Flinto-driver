import 'package:flinto_driver/core/constants/app_colors.dart';
import 'package:flinto_driver/core/utils/responsive.dart';
import 'package:flinto_driver/view/screens/HomeScreen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    final List<TextEditingController> otpControllers = List.generate(
      4,
      (index) => TextEditingController(),
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
                "Please enter the 4-digit code sent to $phoneNumber\n(Test OTP: $receivedOtp)",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Responsive.sp(context, 14),
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: Responsive.h(context, 40)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) {
                  return SizedBox(
                    width: Responsive.w(context, 60),
                    height: Responsive.h(context, 70),
                    child: TextField(
                      controller: otpControllers[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
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
                          borderSide:  BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:  BorderSide(
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
                onPressed: () {},
                child:  Text(
                  "Didn't receive code? Resend",
                  style: TextStyle(
                    color: AppColors.pending,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: Responsive.h(context, 30)),
              SizedBox(
                width: context.screenWidth * 0.7,
                child: ElevatedButton(
                  onPressed: () {
                    // Verify OTP logic here
                    // For now, navigate to HomeScreen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyOrderScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: Responsive.h(context, 15),
                    ),
                  ),
                  child: const Text("Verify OTP"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
