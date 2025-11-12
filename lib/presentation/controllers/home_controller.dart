import 'dart:developer';

import 'package:flinto_driver/data/repositories/auth_repository.dart';
import 'package:get/get.dart';
import '../../../data/models/order_model.dart';
import '../../../data/repositories/order_repository.dart';
import '../../../data/repositories/order_api_repository.dart';
import 'location_controller.dart';
import 'auth_controller.dart';

class HomeController extends GetxController {
  final OrderRepository _orderRepository = OrderRepositoryImpl();
  final OrderApiRepository _orderApi = OrderApiRepository();
  final AuthController _auth = Get.find<AuthController>();
  final LocationController _locationController = Get.find<LocationController>();

  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxString selectedFilter = 'All'.obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;

  int _page = 0;
  final int _size = 10;
  bool _hasMore = true;

  final List<String> filters = ['All', 'Pending', 'On Process', 'Delivered'];

  @override
  void onInit() {
    super.onInit();
    loadOrders(reset: true);
  }

  @override
  void onReady() {
    super.onReady();
    _locationController.promptForLocation(
      force: true,
      onSuccess: () {
        loadOrders(reset: true);
      },
    );
  }

  Future<void> loadOrders({bool reset = false}) async {
    if (_auth.driver?.driverRegistrationId == null) {
      orders.clear();
      return;
    }

    if (reset) {
      _page = 0;
      _hasMore = true;
      orders.clear();
    }

    if (!_hasMore) return;

    try {
    isLoading.value = true;
    final type = _mapFilterToType(selectedFilter.value);
    final list = await _orderApi.fetchDriverOrders(
      driverId: _auth.driver!.driverRegistrationId!,
      page: _page,
      size: _size,
      type: type,
      lang: 'en',
    );

    // 🔍 DEBUG: log all orders in a compact format
    log('\n🔍 Loaded ${list.length} orders:');
    list.logAllOrders(); // Uses extension method
    
    // 🔍 DEBUG: log first order in detail
    if (list.isNotEmpty) {
      log('\n📋 First order details:');
      list.first.logDebugInfo();
    }

    if (list.length < _size) _hasMore = false;
    orders.addAll(list);
    _page += 1;
  } catch (e) {
      Get.snackbar('Orders', 'Failed to load orders: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void onFilterChanged(String filter) {
    selectedFilter.value = filter;
    loadOrders(reset: true);
  }

  void navigateToOrderDetails(OrderModel order) {
    Get.toNamed(
      '/order-details',
      arguments: {
        'trackingNumber': order.trackingNumber,
        'status': order.status,
        'orderDate': order.orderDate,
        'pickupLocation': order.pickupLocation,
        'deliveryLocation': order.deliveryLocation,
        'deliveryType': order.deliveryType,
        'customerName': order.customerName,
        'customerPhone': order.customerPhone,
        'customerAddress': order.customerAddress,
        'receiverName': order.receiverName,
        'receiverPhone': order.receiverPhone,
        'receiverAddress': order.receiverAddress,
        'paymentAmount': order.paymentAmount,
        'paymentStatus': order.paymentStatus,
        'paymentMethod': order.paymentMethod,
        'productDetails': order.productDetails,
        'time': order.time,
        'serviceName': order.serviceName,
        'categoryName': order.categoryName,
        'totalAmount': order.totalAmount,
        'orderImages': order.orderImages,
      },
    );
  }

  void navigateToNotifications() {
    Get.snackbar('Info', 'Notifications screen coming soon');
  }

  Future<void> searchOrders(String query) async {
    if (_auth.driver?.driverRegistrationId == null) {
      orders.clear();
      return;
    }

    if (query.isEmpty) {
      loadOrders(reset: true);
      return;
    }

    try {
      isLoading.value = true;
      _page = 0;
      _hasMore = true;
      final list = await _orderApi.fetchDriverOrders(
        driverId: _auth.driver!.driverRegistrationId!,
        page: _page,
        size: _size,
        keyword: query,
        lang: 'en',
      );

      orders
        ..clear()
        ..addAll(list);
      _page = 1;
    } on ApiException catch (e) {
      Get.snackbar('Search', e.message, snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Search', 'Search failed: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  String? _mapFilterToType(String filter) {
    switch (filter) {
      case 'Pending':
        return 'Pending';
      case 'On Process':
        return 'Onprocess';
      case 'Delivered':
        return 'Completed';
      default:
        return null;
    }
  }
}