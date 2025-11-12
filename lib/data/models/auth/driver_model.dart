class DriverModel {
  final int? driverRegistrationId;
  final String? driverRegistrationKey;
  final int? assignedDriverId;
  final String? name;
  final String? email;
  final int? cityId;
  final String? otp;
  final String? countryCode;
  final String? phoneNumber;
  final String? driverLicensePicture;
  final String? registrationPaperPicture;
  final String? carType;
  final String? policeClearanceCertificateImage;
  final String? emiratePicture;
  final String? status;
  final int? shipPerDay;
  final bool? acceptedByAdmin;
  final DateTime? createdAt;
  final int? assignedBy;
  final DateTime? updatedAt;
  final String? passportPicture;
  final String? termsAndCondition;
  final String? driverPhoto;

  const DriverModel({
    this.driverRegistrationId,
    this.driverRegistrationKey,
    this.assignedDriverId,
    this.name,
    this.email,
    this.cityId,
    this.otp,
    this.countryCode,
    this.phoneNumber,
    this.driverLicensePicture,
    this.registrationPaperPicture,
    this.carType,
    this.policeClearanceCertificateImage,
    this.emiratePicture,
    this.status,
    this.shipPerDay,
    this.acceptedByAdmin,
    this.createdAt,
    this.assignedBy,
    this.updatedAt,
    this.passportPicture,
    this.termsAndCondition,
    this.driverPhoto,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      driverRegistrationId: json['driverRegistrationId'] as int?,
      driverRegistrationKey: json['driverRegistrationKey'] as String?,
      assignedDriverId: json['assignedDriverId'] as int?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      cityId: json['cityId'] as int?,
      otp: json['otp'] as String?,
      countryCode: json['countryCode'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      driverLicensePicture: json['driverLicensePicture'] as String?,
      registrationPaperPicture: json['registrationPaperPicture'] as String?,
      carType: json['carType'] as String?,
      policeClearanceCertificateImage:
          json['policeClearanceCertificateImage'] as String?,
      emiratePicture: json['emiratePicture'] as String?,
      status: json['status'] as String?,
      shipPerDay: json['shipPerDay'] as int?,
      acceptedByAdmin: json['acceptedByAdmin'] as bool?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      assignedBy: json['assignedBy'] as int?,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
      passportPicture: json['passportPicture'] as String?,
      termsAndCondition: json['termsAndCondition'] as String?,
      driverPhoto: json['driverPhoto'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driverRegistrationId': driverRegistrationId,
      'driverRegistrationKey': driverRegistrationKey,
      'assignedDriverId': assignedDriverId,
      'name': name,
      'email': email,
      'cityId': cityId,
      'otp': otp,
      'countryCode': countryCode,
      'phoneNumber': phoneNumber,
      'driverLicensePicture': driverLicensePicture,
      'registrationPaperPicture': registrationPaperPicture,
      'carType': carType,
      'policeClearanceCertificateImage': policeClearanceCertificateImage,
      'emiratePicture': emiratePicture,
      'status': status,
      'shipPerDay': shipPerDay,
      'acceptedByAdmin': acceptedByAdmin,
      'createdAt': createdAt?.toIso8601String(),
      'assignedBy': assignedBy,
      'updatedAt': updatedAt?.toIso8601String(),
      'passportPicture': passportPicture,
      'termsAndCondition': termsAndCondition,
      'driverPhoto': driverPhoto,
    };
  }
}


