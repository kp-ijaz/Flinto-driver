// import 'package:flinto_driver/core/constants/app_colors.dart';
import 'package:flinto_driver/core/constants/app_text.dart';
// import 'package:flinto_driver/view/screens/HomeScreen/widgets/CustomDrawer/custom_drawer_screen.dart';
import 'package:flinto_driver/view/screens/HomeScreen/widgets/searchbar/custom_searchbar.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final bool showBackButton;
  
  const CustomAppBar({
    Key? key,
    required this.title,
    this.showBackButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: const Color.fromARGB(208, 224, 94, 14),
        // gradient: LinearGradient(
        //   colors: [const Color.fromARGB(255, 237, 134, 61), const Color.fromARGB(255, 210, 123, 60),],
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        // ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (showBackButton)
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    )
                  else
                      IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                      onPressed: () {
                        // ✅ THIS IS THE KEY CHANGE - Opens drawer instead of pushing new route
                        Scaffold.of(context).openDrawer();
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  const Spacer(),
                  const Icon(Icons.notifications_outlined, color: Colors.white, size: 28),
                ],
              ),
              const SizedBox(height: 20),
              Text(title, style: AppTextStyles.heading),
              const SizedBox(height: 10),
              SearchBarr(
              hint: 'Enter Tracking Number...',
              showQRCode: true,
                          ),
            ],
          ),
        ),
      ),
    );
  }
}
