import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routes/app_routes.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_controller.dart';

class LoginController extends GetxController {
  LoginController({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository();

  final AuthRepository _authRepository;
  final AuthController _authController = Get.find<AuthController>();

  final TextEditingController phoneController = TextEditingController();
  final RxBool isLoading = false.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String get _trimmedPhone => phoneController.text.trim();

  String? validatePhone(String? value) {
    final phone = value?.trim() ?? '';
    if (phone.isEmpty) {
      return 'Please enter phone number';
    }
    if (phone.length < 7) {
      return 'Phone number is too short';
    }
    return null;
  }

  @override
  void onInit() {
    super.onInit();
    if (_authController.phoneNumber.isNotEmpty) {
      phoneController.text = _authController.phoneNumber;
    }
  }

  Future<void> requestOtp() async {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    final phone = _trimmedPhone;

    isLoading.value = true;
    try {
      final response = await _authRepository.requestOtp(phoneNumber: phone);

      final otp = response.otp ?? '';
      developer.log(
        'OTP received for $phone: $otp',
        name: 'LoginController',
      );
      if (otp.isEmpty) {
        Get.snackbar(
          'Login',
          'Unable to retrieve OTP. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      _authController.cacheLoginData(
        driver: response.driver,
        phone: phone,
        otp: otp,
      );

      Get.toNamed(
        AppRoutes.otp,
        arguments: {
          'phoneNumber': phone,
          'otp': otp,
        },
      );
    } on ApiException catch (error) {
      Get.snackbar(
        'Login failed',
        error.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (error) {
      Get.snackbar(
        'Login failed',
        'Unexpected error occurred. ${error.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
  @override
  void onClose() {
    phoneController.dispose();
    _authRepository.dispose();
    super.onClose();
  }
}


