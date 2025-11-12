import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/routes/app_routes.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_controller.dart';

class OtpController extends GetxController {
  OtpController({
    required this.phoneNumber,
    required this.expectedOtp,
    AuthRepository? authRepository,
  }) : _authRepository = authRepository ?? AuthRepository();

  final String phoneNumber;
  final String expectedOtp;

  final AuthRepository _authRepository;
  final AuthController _authController = Get.find<AuthController>();

  final RxBool isVerifying = false.obs;
  final List<TextEditingController> otpControllers =
      List.generate(4, (_) => TextEditingController());

  String get enteredOtp =>
      otpControllers.map((controller) => controller.text.trim()).join();

  Future<void> verifyOtp() async {
    final otp = enteredOtp;

    if (otp.length != expectedOtp.length) {
      Get.snackbar(
        'OTP',
        'Please enter the complete OTP.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (otp != expectedOtp) {
      Get.snackbar(
        'OTP',
        'The OTP you entered is incorrect.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isVerifying.value = true;
    try {
      final response =
          await _authRepository.verifyOtp(phoneNumber: phoneNumber, otp: otp);

      if (response.isSuccess) {
        _authController.cacheLoginData(
          driver: response.driver ?? _authController.driver,
          phone: phoneNumber,
          otp: '',
        );
        _authController.clearPendingOtp();

        Get.offAllNamed(AppRoutes.home);
      } else {
        Get.snackbar(
          'OTP',
          response.message ?? 'OTP verification failed. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on ApiException catch (error) {
      Get.snackbar(
        'OTP',
        error.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (error) {
      Get.snackbar(
        'OTP',
        'Unexpected error occurred. ${error.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isVerifying.value = false;
    }
  }

  @override
  void onClose() {
    for (final controller in otpControllers) {
      controller.dispose();
    }
    _authRepository.dispose();
    super.onClose();
  }
}
