import 'package:flinto_driver/core/utils/responsive.dart';
import 'package:flinto_driver/view/screens/OtpScreen/otp_screen.dart';
import 'package:flinto_driver/view/widgets/phone_input_field.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController phoneController = TextEditingController(
    text: "544878929",
  ); // static test number

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
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
                SizedBox(height: Responsive.h(context, 100)),
                Padding(
                  padding: AppResponsive.horizontalPaddingForWidth(
                    MediaQuery.of(context).size.width,
                  ),
                  child: Column(
                    children: [
                      PhoneInputField(
                        label: '',
                        hint: "Phone Number",
                        controller: phoneController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter phone number';
                          }
                          if (value.length < 7) {
                            return 'Phone number is too short';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Responsive.h(context, 40)),
                SizedBox(
                  width: context.screenWidth * 0.7,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OtpScreen(
                            phoneNumber: "544878929",
                            receivedOtp: "1111",
                          ),
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
                    child: const Text("Sign In"),
                  ),
                ),
                SizedBox(height: Responsive.h(context, 50)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
