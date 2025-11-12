import 'driver_model.dart';

class LoginResponse {
  final DriverModel? driver;
  final String? otp;
  final int? code;
  final String? message;
  final bool isSuccess;

  const LoginResponse({
    this.driver,
    this.otp,
    this.code,
    this.message,
    this.isSuccess = false,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    final driverJson = data != null ? data['driver'] as Map<String, dynamic>? : null;

    return LoginResponse(
      driver: driverJson != null ? DriverModel.fromJson(driverJson) : null,
      otp: json['otp'] as String? ?? (driverJson?['otp'] as String?),
      code: json['code'] as int?,
      message: json['message'] as String?,
      isSuccess: json['isSuccess'] as bool? ?? false,
    );
  }

  LoginResponse copyWith({
    DriverModel? driver,
    String? otp,
    int? code,
    String? message,
    bool? isSuccess,
  }) {
    return LoginResponse(
      driver: driver ?? this.driver,
      otp: otp ?? this.otp,
      code: code ?? this.code,
      message: message ?? this.message,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}


