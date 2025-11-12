import 'package:flutter/material.dart';
import '../models/order_model.dart';

abstract class OrderRepository {
  Future<List<OrderModel>> getOrders();
  Future<List<OrderModel>> getOrdersByStatus(String status);
}

class OrderRepositoryImpl implements OrderRepository {
  final List<OrderModel> _mockOrders = [
    OrderModel(
      id: '1',
      trackingNumber: 'B56H894S454',
      status: 'Pending',
      description: 'Returned to sender',
      icon: Icons.local_shipping_outlined,
    ),
    OrderModel(
      id: '2',
      trackingNumber: 'B56H895S455',
      status: 'Delivered',
      description: 'Delivered successfully',
      icon: Icons.access_time,
    ),
    OrderModel(
      id: '3',
      trackingNumber: 'B56H896S456',
      status: 'On Process',
      description: 'In transit',
      icon: Icons.local_shipping_outlined,
    ),
    OrderModel(
      id: '4',
      trackingNumber: 'B56H897S457',
      status: 'Pending',
      description: 'Awaiting pickup',
      icon: Icons.access_time,
    ),
    OrderModel(
      id: '5',
      trackingNumber: 'B56H898S458',
      status: 'On Process',
      description: 'In transit',
      icon: Icons.local_shipping_outlined,
    ),
    OrderModel(
      id: '6',
      trackingNumber: 'B56H899S459',
      status: 'Delivered',
      description: 'Delivered successfully',
      icon: Icons.access_time,
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

