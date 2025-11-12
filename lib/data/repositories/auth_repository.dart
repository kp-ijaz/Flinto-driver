import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

import '../models/auth/login_response.dart';

class AuthRepository {
  AuthRepository({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const String _baseUrl = 'https://flinto.r-y-x.net';

  Future<LoginResponse> requestOtp({required String phoneNumber}) async {
    final response = await _sendRequest(
      queryParameters: {'phoneNumber': phoneNumber},
    );
    return _parseResponse(response);
    
  }

  Future<LoginResponse> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    final response = await _sendRequest(
      queryParameters: {
        'phoneNumber': phoneNumber,
        'otp': otp,
      },
    );
    return _parseResponse(response);
  }

  Future<http.Response> _sendRequest({
    required Map<String, String> queryParameters,
  }) async {
    final uri = Uri.parse('$_baseUrl/driver-Login')
        .replace(queryParameters: queryParameters);

    http.Response response = await _client.post(
      uri,
      headers: const {'accept': '*/*'},
      body: '',
    );

    if (response.statusCode == 405) {
      response = await _client.get(
        uri,
        headers: const {'accept': '*/*'},
      );
    }

    return response;
  }

  LoginResponse _parseResponse(http.Response response) {
    if (response.body.isEmpty) {
      throw ApiException(
        message: 'Empty response from server (${response.statusCode}).',
        statusCode: response.statusCode,
      );
    }

    Map<String, dynamic> json;
    try {
      json = jsonDecode(response.body) as Map<String, dynamic>;
    } on FormatException catch (error) {
      throw ApiException(
        message:
            'Invalid response format: ${error.message}. Body: ${response.body}',
        statusCode: response.statusCode,
      );
    }

    final loginResponse = LoginResponse.fromJson(json);

    if (response.statusCode >= 200 &&
        response.statusCode < 300 &&
        loginResponse.isSuccess) {
      return loginResponse;
    } else {
      final message = loginResponse.message?.isNotEmpty == true
          ? loginResponse.message!
          : 'Something went wrong (${response.statusCode}).';
      throw ApiException(
        message: message,
        statusCode: response.statusCode,
      );
    }
  }

  void dispose() {
    _client.close();
  }
}

class ApiException implements Exception {
  ApiException({required this.message, this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'ApiException($statusCode): $message';
}


