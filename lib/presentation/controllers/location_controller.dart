import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../data/repositories/location_repository.dart';
import 'auth_controller.dart';
import '../../data/repositories/auth_repository.dart';

class LocationController extends GetxController {
  LocationController({
    LocationRepository? locationRepository,
    AuthController? authController,
  })  : _locationRepository = locationRepository ?? LocationRepository(),
        _authController = authController ?? Get.find<AuthController>();

  final LocationRepository _locationRepository;
  final AuthController _authController;

  final RxBool isSaving = false.obs;
  bool _dialogVisible = false;
  bool _alreadyPrompted = false;

  @override
  void onInit() {
    super.onInit();
    if (_authController.driver != null) {
      _alreadyPrompted = true;
    }
  }

  Future<void> promptForLocation({bool force = false, VoidCallback? onSuccess}) async {
    final driver = _authController.driver;
    if (driver == null) return;

    if (_alreadyPrompted && !force) return;
    if (_dialogVisible && !force) return;

    final driverId = driver.driverRegistrationId;
    final areaId = driver.cityId;

    if (driverId == null || areaId == null) {
      return;
    }

    _dialogVisible = true;
    await Get.dialog<bool>(
      Obx(
        () => Dialog(
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          backgroundColor: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.96),
                      Colors.white.withOpacity(0.82),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.7),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 30,
                      offset: const Offset(0, 18),
                    ),
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 26, vertical: 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B6B).withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.location_on_rounded,
                        color: Color(0xFFFF6B6B),
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Enable Your Location',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Allow Flinto Driver to access your current position so we can assign the closest pickups and deliveries.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.45,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 26),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isSaving.value
                            ? null
                            : () async {
                                final success = await _captureAndSubmitLocation(
                                  driverId: driverId,
                                  areaId: areaId,
                                );
                                if (success) {
                                  Get.back(result: true);
                                  if (onSuccess != null) {
                                    onSuccess();
                                  }
                                  _alreadyPrompted = true;
                                  Get.snackbar(
                                    'Location',
                                    'Location updated successfully.',
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B6B),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 0,
                        ),
                        child: isSaving.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text(
                                'Use Current Location',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () => Get.back(result: false),
                      child: const Text(
                        'Maybe later',
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.55),
    );
    _dialogVisible = false;
  }

  Future<bool> _captureAndSubmitLocation({
    required int driverId,
    required int areaId,
  }) async {
    try {
      isSaving.value = true;

      final permissionGranted = await _ensureLocationPermission();
      if (!permissionGranted) {
        return false;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      await _locationRepository.saveOrUpdateDriverLocation(
        driverRegistrationId: driverId,
        areaId: areaId,
        latitude: position.latitude,
        longitude: position.longitude,
      );

      return true;
    } on ApiException catch (error) {
      Get.snackbar(
        'Location',
        error.message,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } catch (error) {
      Get.snackbar(
        'Location',
        'Unable to update location. ${error.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  Future<bool> _ensureLocationPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar(
        'Location',
        'Location services are disabled. Please enable them.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      Get.snackbar(
        'Location',
        'Location permissions are denied. Please allow access from Settings.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    return true;
  }

  @override
  void onClose() {
    _locationRepository.dispose();
    super.onClose();
  }
}
