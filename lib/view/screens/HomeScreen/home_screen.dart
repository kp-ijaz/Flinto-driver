import 'package:flinto_driver/view/screens/HomeScreen/widgets/Common_appbar/app_bar.dart';
import 'package:flinto_driver/view/screens/HomeScreen/widgets/CustomDrawer/custom_drawer_screen.dart';
import 'package:flinto_driver/view/screens/HomeScreen/widgets/Filter_chips/filter_chips.dart';
import 'package:flinto_driver/view/screens/HomeScreen/widgets/bottomnavbar/bottom_nav_bar.dart';
import 'package:flinto_driver/view/screens/HomeScreen/widgets/order_card/custom_order_card.dart';
import 'package:flinto_driver/presentation/controllers/home_controller.dart';
import 'package:flinto_driver/presentation/controllers/navigation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MyOrderScreen extends StatelessWidget {
  const MyOrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize controllers
    final controller = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : Get.put(HomeController());
    final navController = Get.isRegistered<NavigationController>()
        ? Get.find<NavigationController>()
        : Get.put(NavigationController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      navController.setCurrentIndex(1);
    });

    return Scaffold(
      drawer: const CustomDrawer(),
      body: Column(
        children: [
          const CustomAppBar(title: 'My Order'),
          SizedBox(height: ScreenUtil().setHeight(10)),
          FilterChips(
            onFilterChanged: controller.onFilterChanged,
          ),
          SizedBox(height: ScreenUtil().setHeight(10)),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.orders.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (controller.orders.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox_outlined, size: 80, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'No orders found',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Orders will appear here once available',
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                );
              }
              
              return RefreshIndicator(
                onRefresh: () => controller.loadOrders(reset: true),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: controller.orders.length,
                  itemBuilder: (context, index) {
                    final order = controller.orders[index];
                    return OrderCard(
                      trackingNumber: order.trackingNumber,
                      status: order.status,
                      icon: order.icon,
                      orderDate: order.orderDate,
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNav(),
    );
  }
}