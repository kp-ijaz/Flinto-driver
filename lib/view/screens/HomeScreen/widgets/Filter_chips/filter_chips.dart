import 'package:flutter/material.dart';

// AppColors class (replace with your actual import)
class AppColors {
  static const Color black = Color.fromARGB(255, 0, 0, 0);
  static const Color darkGrey = Color(0xFF9E9E9E);
}

class FilterChips extends StatefulWidget {
  const FilterChips({Key? key}) : super(key: key);

  @override
  State<FilterChips> createState() => _FilterChipsState();
}

class _FilterChipsState extends State<FilterChips> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> filters = ['All', 'Pending', 'On Process', 'Delivered'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: filters.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.black,
          borderRadius: BorderRadius.circular(25),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.black,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelPadding: EdgeInsets.zero, // ✅ Remove default padding
        padding: EdgeInsets.zero, // ✅ Remove TabBar padding
        tabs: filters.map((filter) => Tab(text: filter)).toList(),
      ),
    );
  }
}