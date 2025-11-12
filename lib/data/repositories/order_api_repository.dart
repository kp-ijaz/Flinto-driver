import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/order_model.dart';
import 'auth_repository.dart';

class OrderApiRepository {
  OrderApiRepository({http.Client? client}) : _client = client ?? http.Client();
  
  final http.Client _client;
  static const String _base = 'https://flinto.r-y-x.net';

  Future<List<OrderModel>> fetchDriverOrders({
    required int driverId,
    required int page,
    required int size,
    String? type,
    String? keyword,
    String lang = 'en',
  }) async {
    final uri = Uri.parse('$_base/api/OrderRequest/GetDriverOrders').replace(
      queryParameters: {
        'driverId': '$driverId',
        'page': '$page',
        'size': '$size',
        if (type != null && type.isNotEmpty) 'type': type,
        if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
        'lang': lang,
      },
    );

    final response = await _client.post(
      uri,
      headers: const {'accept': '*/*'},
      body: '',
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        message: 'Orders API failed (${response.statusCode}). ${response.body.isNotEmpty ? response.body : ''}',
        statusCode: response.statusCode,
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    
    // Navigate through nested structure: result.result
    final result = json['result'] as Map<String, dynamic>?;
    final list = result?['result'] as List<dynamic>? ?? [];

    // Map each order using OrderModel.fromJson with proper icon
    return list.map<OrderModel>((item) {
      final map = item as Map<String, dynamic>;
      final status = map['orderStatus']?.toString() ?? 'Unknown';
      final icon = _iconForStatus(status);
      
      // Use the existing fromJson method which handles all fields properly
      return OrderModel.fromJson(map, icon);
    }).toList();
  }

  void dispose() => _client.close();

  // Updated to match actual API status values
  IconData _iconForStatus(String status) {
    final statusLower = status.toLowerCase();
    
    if (statusLower.contains('placed') || statusLower.contains('pending')) {
      return Icons.access_time;
    } else if (statusLower.contains('process') || statusLower.contains('transit')) {
      return Icons.local_shipping_outlined;
    } else if (statusLower.contains('delivered') || statusLower.contains('completed')) {
      return Icons.check_circle_outline;
    } else if (statusLower.contains('cancelled') || statusLower.contains('rejected')) {
      return Icons.cancel_outlined;
    } else {
      return Icons.inventory_2_outlined;
    }
  }
}