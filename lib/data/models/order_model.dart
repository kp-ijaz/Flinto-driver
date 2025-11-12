import 'dart:developer';
import 'package:flutter/material.dart';

class OrderModel {
  final String id;
  final String trackingNumber;
  final String status;
  final String? description;
  final IconData icon;
  final String? orderDate;
  
  // Location fields
  final String? pickupLocation;
  final String? deliveryLocation;
  final String? deliveryType;
  
  // NEW: Landmark fields
  final String? pickupLandmark;
  final String? deliveryLandmark;
  
  // Customer (Pickup Member) fields
  final String? customerName;
  final String? customerPhone;
  final String? customerAddress;
  
  // Receiver fields
  final String? receiverName;
  final String? receiverPhone;
  final String? receiverAddress;
  
  // Payment fields
  final String? paymentAmount;
  final String? paymentStatus;
  final String? paymentMethod;
  
  // Order details
  final Map<String, List<String>>? productDetails;
  final String? time;
  final String? serviceName;
  final String? categoryName;
  final double? totalAmount;
  
  // Images
  final List<String>? orderImages;
  
  // Status tracking fields
  final int? invoiceStatusId;
  final int? categoryId;

  OrderModel({
    required this.id,
    required this.trackingNumber,
    required this.status,
    this.description,
    required this.icon,
    this.orderDate,
    this.pickupLocation,
    this.deliveryLocation,
    this.deliveryType,
    this.pickupLandmark,
    this.deliveryLandmark,
    this.customerName,
    this.customerPhone,
    this.customerAddress,
    this.receiverName,
    this.receiverPhone,
    this.receiverAddress,
    this.paymentAmount,
    this.paymentStatus,
    this.paymentMethod,
    this.productDetails,
    this.time,
    this.serviceName,
    this.categoryName,
    this.totalAmount,
    this.orderImages,
    this.invoiceStatusId,
    this.categoryId,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json, IconData icon) {
    // Extract pickup location
    final pickupLoc = json['picUpLocation'] as Map<String, dynamic>?;
    final pickupAddress = pickupLoc?['formattedAddress']?.toString() ?? 
                          pickupLoc?['landmark']?.toString() ?? 
                          'Pickup location not available';
    final pickupLandmark = pickupLoc?['landmark']?.toString() ?? 'Pickup Location';
    
    // Extract receiver location
    final receiverLoc = json['reciverLocation'] as Map<String, dynamic>?;
    final deliveryAddress = receiverLoc?['formattedAddress']?.toString() ?? 
                            receiverLoc?['landmark']?.toString() ?? 
                            'Delivery location not available';
    final deliveryLandmark = receiverLoc?['landmark']?.toString() ?? 'Delivery Location';
    
    // Extract pickup member
    final pickupMember = json['pickUpMember'] as Map<String, dynamic>?;
    final customerName = pickupMember?['name']?.toString().isEmpty ?? true
        ? 'Customer'
        : pickupMember!['name'].toString();
    final customerCountryCode = pickupMember?['countryCode']?.toString() ?? '';
    final customerPhoneNumber = pickupMember?['phoneNumber']?.toString() ?? '';
    final customerPhone = customerCountryCode.isNotEmpty && customerPhoneNumber.isNotEmpty
        ? '$customerCountryCode $customerPhoneNumber'
        : 'Not available';
    
    // Extract receiver member
    final receiverMember = json['reciverMember'] as Map<String, dynamic>?;
    final receiverName = receiverMember?['name']?.toString().isEmpty ?? true
        ? 'Receiver'
        : receiverMember!['name'].toString();
    final receiverCountryCode = receiverMember?['countryCode']?.toString() ?? '';
    final receiverPhoneNumber = receiverMember?['phoneNumber']?.toString() ?? '';
    final receiverPhone = receiverCountryCode.isNotEmpty && receiverPhoneNumber.isNotEmpty
        ? '$receiverCountryCode $receiverPhoneNumber'
        : 'Not available';
    
    // Extract category details
    final category = json['category'] as Map<String, dynamic>?;
    final categoryName = category?['categoryName']?.toString() ?? 'Service';
    final categoryId = category?['categoryId'] as int? ?? 0;
    
    // Extract product details
    Map<String, List<String>> productDetailsMap = {};
    final details = json['details'] as List<dynamic>?;
    if (details != null && details.isNotEmpty) {
      for (var detail in details) {
        if (detail is Map<String, dynamic>) {
          final type = detail['type']?.toString() ?? '';
          final detailsList = detail['details'] as List<dynamic>?;
          if (detailsList != null && detailsList.isNotEmpty) {
            productDetailsMap[type] = detailsList
                .map((e) => e.toString())
                .where((s) => s.isNotEmpty)
                .toList();
          }
        }
      }
    }
    
    // Extract order images
    final orderImagesList = json['orderImage'] as List<dynamic>?;
    final orderImages = orderImagesList
        ?.map((e) => e.toString())
        .where((s) => s.isNotEmpty)
        .toList();
    
    // Parse amounts
    final totalAmount = double.tryParse(json['totalAmount']?.toString() ?? '0') ?? 0.0;
    final paymentAmount = 'AED ${totalAmount.toStringAsFixed(2)}';
    
    // Extract invoice status ID
    final invoiceStatusId = json['invoiceStatusId'] as int? ?? 0;
    
    return OrderModel(
      id: json['orderMasterId']?.toString() ?? '',
      trackingNumber: json['orderId']?.toString() ?? '',
      status: json['orderStatus']?.toString() ?? '',
      description: json['requirements']?.toString(),
      icon: icon,
      orderDate: json['orderDate']?.toString() ?? json['startDate']?.toString(),
      pickupLocation: pickupAddress,
      deliveryLocation: deliveryAddress,
      deliveryType: json['serviceTypeName']?.toString() ?? 'Standard',
      pickupLandmark: pickupLandmark,
      deliveryLandmark: deliveryLandmark,
      customerName: customerName,
      customerPhone: customerPhone,
      customerAddress: pickupAddress,
      receiverName: receiverName,
      receiverPhone: receiverPhone,
      receiverAddress: deliveryAddress,
      paymentAmount: paymentAmount,
      paymentStatus: json['paymentStatus']?.toString() ?? 'Pending',
      paymentMethod: json['paymentMethod']?.toString(),
      productDetails: productDetailsMap.isNotEmpty ? productDetailsMap : null,
      time: json['startTime']?.toString() ?? '',
      serviceName: json['serviceTypeName']?.toString() ?? 'Service',
      categoryName: categoryName,
      totalAmount: totalAmount,
      orderImages: orderImages,
      invoiceStatusId: invoiceStatusId,
      categoryId: categoryId,
    );
  }

  void logDebugInfo() {
    log('\n========================================');
    log('ORDER MODEL DEBUG INFO');
    log('========================================\n');
    
    log('📦 BASIC INFO:');
    log('  ├─ ID: $id');
    log('  ├─ Tracking Number: $trackingNumber');
    log('  ├─ Status: $status');
    log('  ├─ Invoice Status ID: ${invoiceStatusId ?? "null"}');
    log('  ├─ Category ID: ${categoryId ?? "null"}');
    log('  ├─ Description: ${description ?? "null"}');
    log('  ├─ Order Date: ${orderDate ?? "null"}');
    log('  └─ Time: ${time ?? "null"}\n');
    
    log('📍 LOCATION INFO:');
    log('  ├─ Pickup Location: ${pickupLocation ?? "null"}');
    log('  ├─ Pickup Landmark: ${pickupLandmark ?? "null"}');
    log('  ├─ Delivery Location: ${deliveryLocation ?? "null"}');
    log('  ├─ Delivery Landmark: ${deliveryLandmark ?? "null"}');
    log('  └─ Delivery Type: ${deliveryType ?? "null"}\n');
    
    log('👤 CUSTOMER INFO (Pickup Member):');
    log('  ├─ Name: ${customerName ?? "null"}');
    log('  ├─ Phone: ${customerPhone ?? "null"}');
    log('  └─ Address: ${customerAddress ?? "null"}\n');
    
    log('👥 RECEIVER INFO:');
    log('  ├─ Name: ${receiverName ?? "null"}');
    log('  ├─ Phone: ${receiverPhone ?? "null"}');
    log('  └─ Address: ${receiverAddress ?? "null"}\n');
    
    log('💰 PAYMENT INFO:');
    log('  ├─ Amount: ${paymentAmount ?? "null"}');
    log('  ├─ Status: ${paymentStatus ?? "null"}');
    log('  ├─ Method: ${paymentMethod ?? "null"}');
    log('  └─ Total Amount: ${totalAmount ?? "null"}\n');
    
    log('🏷️ SERVICE INFO:');
    log('  ├─ Service Name: ${serviceName ?? "null"}');
    log('  └─ Category Name: ${categoryName ?? "null"}\n');
    
    log('📋 PRODUCT DETAILS:');
    if (productDetails != null && productDetails!.isNotEmpty) {
      productDetails!.forEach((key, value) {
        log('  ├─ $key:');
        for (var item in value) {
          log('  │  └─ $item');
        }
      });
    } else {
      log('  └─ No product details');
    }
    log('');
    
    log('🖼️ ORDER IMAGES:');
    if (orderImages != null && orderImages!.isNotEmpty) {
      for (var i = 0; i < orderImages!.length; i++) {
        log('  ├─ Image ${i + 1}: ${orderImages![i]}');
      }
    } else {
      log('  └─ No images');
    }
    
    log('\n========================================\n');
  }

  void logCompact() {
    log('Order #$trackingNumber | Status: $status | InvoiceStatus: ${invoiceStatusId ?? "N/A"} | Category: ${categoryId ?? "N/A"} | Customer: $customerName | Landmark: $deliveryLandmark | Amount: $paymentAmount');
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'trackingNumber': trackingNumber,
      'status': status,
      'description': description,
      'orderDate': orderDate,
      'pickupLocation': pickupLocation,
      'deliveryLocation': deliveryLocation,
      'deliveryType': deliveryType,
      'pickupLandmark': pickupLandmark,
      'deliveryLandmark': deliveryLandmark,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerAddress': customerAddress,
      'receiverName': receiverName,
      'receiverPhone': receiverPhone,
      'receiverAddress': receiverAddress,
      'paymentAmount': paymentAmount,
      'paymentStatus': paymentStatus,
      'paymentMethod': paymentMethod,
      'productDetails': productDetails,
      'time': time,
      'serviceName': serviceName,
      'categoryName': categoryName,
      'totalAmount': totalAmount,
      'orderImages': orderImages,
      'invoiceStatusId': invoiceStatusId,
      'categoryId': categoryId,
    };
  }
}

extension OrderListDebug on List<OrderModel> {
  void logAllOrders() {
    log('\n========================================');
    log('LOGGING ${length} ORDERS');
    log('========================================\n');
    
    for (var i = 0; i < length; i++) {
      log('Order ${i + 1}/${length}:');
      this[i].logCompact();
    }
    
    log('\n========================================\n');
  }
  
  void logDetailedOrders() {
    for (var i = 0; i < length; i++) {
      log('Order ${i + 1}/${length}:');
      this[i].logDebugInfo();
    }
  }
}