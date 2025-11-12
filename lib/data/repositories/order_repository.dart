import 'package:flutter/material.dart';
import '../models/order_model.dart';

abstract class OrderRepository {
  Future<List<OrderModel>> getOrders();
  Future<List<OrderModel>> getOrdersByStatus(String status);
}

class OrderRepositoryImpl implements OrderRepository {
  // You can keep mock data for testing or remove it since you're using API
  final List<OrderModel> _mockOrders = [
    OrderModel(
      id: '1',
      trackingNumber: 'B56H894S454',
      status: 'Pending',
      description: 'Returned to sender',
      icon: Icons.local_shipping_outlined,
      orderDate: '11/11/2025',
      serviceName: 'Delivery - Courier',
      customerName: 'Test Customer',
      customerPhone: '+971 544878921',
      pickupLocation: 'Test Pickup Location',
      deliveryLocation: 'Test Delivery Location',
      paymentAmount: 'AED 40.00',
      paymentStatus: 'Paid',
    ),
    OrderModel(
      id: '2',
      trackingNumber: 'B56H895S455',
      status: 'Delivered',
      description: 'Delivered successfully',
      icon: Icons.access_time,
      orderDate: '10/11/2025',
      serviceName: 'Delivery - Courier',
      customerName: 'Test Customer 2',
      customerPhone: '+971 544878922',
      pickupLocation: 'Test Pickup Location 2',
      deliveryLocation: 'Test Delivery Location 2',
      paymentAmount: 'AED 35.00',
      paymentStatus: 'Paid',
    ),
  ];

  @override
  Future<List<OrderModel>> getOrders() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockOrders;
  }

  @override
  Future<List<OrderModel>> getOrdersByStatus(String status) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (status == 'All') {
      return _mockOrders;
    }
    return _mockOrders.where((order) => order.status == status).toList();
  }
}