import 'package:flinto_driver/core/utils/responsive.dart';
import 'package:flinto_driver/presentation/controllers/login_controller.dart';
import 'package:flinto_driver/view/widgets/phone_input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              key: controller.formKey,
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
                          controller: controller.phoneController,
                          validator: controller.validatePhone,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Responsive.h(context, 40)),
                  Obx(
                    () => SizedBox(
                      width: context.screenWidth * 0.7,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.requestOtp,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: Responsive.h(context, 15),
                          ),
                        ),
                        child: controller.isLoading.value
                            ? SizedBox(
                                height: Responsive.h(context, 18),
                                width: Responsive.h(context, 18),
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text("Sign In"),
                      ),
                    ),
                  ),
                  SizedBox(height: Responsive.h(context, 50)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
