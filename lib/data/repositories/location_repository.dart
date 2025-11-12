import 'dart:convert';

import 'package:http/http.dart' as http;

import 'auth_repository.dart';

class LocationRepository {
  LocationRepository({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const String _baseUrl = 'https://flinto.r-y-x.net';

  Future<void> saveOrUpdateDriverLocation({
    required int driverRegistrationId,
    required int areaId,
    required double latitude,
    required double longitude,
    String title = 'Current Location',
    String address = '',
    int driverVehicleId = 0,
    String note = '',
    bool status = true,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/v1/DriverLocation/SaveOrUpdate');
    final response = await _client.post(
      uri,
      headers: const {
        'Content-Type': 'application/json',
        'accept': '*/*',
      },
      body: jsonEncode({
        'driverLocationId': 0,
        'driverRegistrationId': driverRegistrationId,
        'title': title,
        'areaId': areaId,
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
        'address': address,
        'driverVehicleId': driverVehicleId,
        'note': note,
        'status': status,
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        message:
            'Failed to update location (${response.statusCode}): ${response.body}',
        statusCode: response.statusCode,
      );
    }
  }

  void dispose() {
    _client.close();
  }
}


