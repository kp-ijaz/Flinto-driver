import 'dart:convert';
import 'package:http/http.dart' as http;

class OrderStatusApi {
  OrderStatusApi({http.Client? client}) : _client = client ?? http.Client();
  
  final http.Client _client;
  static const String _base = 'https://flinto.r-y-x.net';

  Future<Map<String, dynamic>> updateOrderStatus({
    required int orderMasterId,
    required int driverId,
    required String status,
    String lang = 'en',
  }) async {
    final uri = Uri.parse('$_base/api/v1/Driver/UpdateOrderStatus');
    
    final body = jsonEncode({
      'orderMasterId': orderMasterId,
      'driverId': driverId,
      'status': status,
      'lang': lang,
    });

    try {
      final response = await _client.post(
        uri,
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return json;
      } else {
        throw Exception('Failed to update order status: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error updating order status: $e');
    }
  }

  void dispose() => _client.close();
}