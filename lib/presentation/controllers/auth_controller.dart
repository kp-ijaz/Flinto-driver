import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../data/models/auth/driver_model.dart';

class AuthController extends GetxController {
  static const _driverKey = 'auth_driver';
  static const _pendingOtpKey = 'auth_pending_otp';
  static const _phoneKey = 'auth_phone_number';

  final GetStorage _storage = GetStorage();

  final Rxn<DriverModel> _driver = Rxn<DriverModel>();
  final RxString _pendingOtp = ''.obs;
  final RxString _phoneNumber = ''.obs;

  DriverModel? get driver => _driver.value;
  String get pendingOtp => _pendingOtp.value;
  String get phoneNumber => _phoneNumber.value;
  bool get isLoggedIn => _driver.value != null;

  bool get hasPendingOtp => _pendingOtp.value.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    _loadFromStorage();
  }

  void cacheLoginData({
    DriverModel? driver,
    required String phone,
    required String otp,
  }) {
    if (driver != null) {
      _driver.value = driver;
      _storage.write(_driverKey, driver.toJson());
    }

    _phoneNumber.value = phone;
    _storage.write(_phoneKey, phone);

    _pendingOtp.value = otp;
    _storage.write(_pendingOtpKey, otp);
  }

  void updateDriver(DriverModel? driver) {
    _driver.value = driver;
    if (driver != null) {
      _storage.write(_driverKey, driver.toJson());
    } else {
      _storage.remove(_driverKey);
    }
  }

  void clearPendingOtp() {
    _pendingOtp.value = '';
    _storage.remove(_pendingOtpKey);
  }

  void clearSession() {
    _driver.value = null;
    _pendingOtp.value = '';
    _phoneNumber.value = '';

    _storage
      ..remove(_driverKey)
      ..remove(_pendingOtpKey)
      ..remove(_phoneKey);
  }

  void _loadFromStorage() {
    final storedDriver = _storage.read(_driverKey);
    if (storedDriver is Map) {
      _driver.value =
          DriverModel.fromJson(Map<String, dynamic>.from(storedDriver));
    }

    final storedPhone = _storage.read(_phoneKey);
    if (storedPhone is String) {
      _phoneNumber.value = storedPhone;
    }

    final storedOtp = _storage.read(_pendingOtpKey);
    if (storedOtp is String) {
      _pendingOtp.value = storedOtp;
    }
  }
}

