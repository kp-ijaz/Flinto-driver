import 'package:flinto_driver/view/screens/HomeScreen/widgets/Common_appbar/app_bar.dart';
import 'package:flinto_driver/view/screens/HomeScreen/widgets/CustomDrawer/custom_drawer_screen.dart';
import 'package:flinto_driver/view/screens/HomeScreen/widgets/Filter_chips/filter_chips.dart';
import 'package:flinto_driver/view/screens/HomeScreen/widgets/bottomnavbar/bottom_nav_bar.dart';
import 'package:flinto_driver/view/screens/HomeScreen/widgets/order_card/custom_order_card.dart';
import 'package:flutter/material.dart';

class MyOrderScreen extends StatelessWidget {
  const MyOrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      body: Column(
        children: [
          const CustomAppBar(title: 'My Order'),
          const SizedBox(height: 10),
          const FilterChips(),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero, // Remove default padding
              children: const [
                OrderCard(
                  trackingNumber: 'B56H894S454',
                  status: 'Pending',
                  icon: Icons.local_shipping_outlined,
                ),
                OrderCard(
                  trackingNumber: 'B56H894S454',
                  status: 'Delivered',
                  icon: Icons.access_time,
                ),
                OrderCard(
                  trackingNumber: 'B56H894S454',
                  status: 'On Process',
                  icon: Icons.local_shipping_outlined,
                ),
                OrderCard(
                  trackingNumber: 'B56H894S454',
                  status: 'Pending',
                  icon: Icons.access_time,
                ),
                OrderCard(
                  trackingNumber: 'B56H894S454',
                  status: 'On Process',
                  icon: Icons.local_shipping_outlined,
                ),
                OrderCard(
                  trackingNumber: 'B56H894S454',
                  status: 'Delivered',
                  icon: Icons.access_time,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNav(),
    );
  }
}