import 'package:get/get.dart';
import '../../view/screens/HomeScreen/home_screen.dart';
import '../../view/screens/ScheduleScreen/schedule_screen.dart';
import '../../view/screens/ProfileScreen/profilescreen.dart';
import '../../view/screens/OrderDetailsScreen/order_detail_screen.dart';
import '../../view/screens/loginScreen/login_screen.dart';
import '../../view/screens/OtpScreen/otp_screen.dart';
import '../../view/screens/ProductDeliveryScreen/product_delivery_screen.dart';
import '../../view/screens/Thankyouscreen/thankyou_screen.dart' show ThankYouDeliveryScreen;

class AppRoutes {
  static const String login = '/login';
  static const String otp = '/otp';
  static const String home = '/home';
  static const String schedule = '/schedule';
  static const String profile = '/profile';
  static const String orderDetails = '/order-details';
  static const String productDelivery = '/product-delivery';
  static const String thankYou = '/thank-you';

  static List<GetPage> getPages = [
    GetPage(
      name: login,
      page: () => LoginScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: otp,
      page: () {
        final args = Get.arguments as Map<String, dynamic>?;
        final phoneNumber = args?['phoneNumber'] as String? ?? '';
        final otpValue = args?['otp'] as String? ?? '';
        return OtpScreen(
          phoneNumber: phoneNumber,
          receivedOtp: otpValue,
        );
      },
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: home,
      page: () => const MyOrderScreen(),
      transition: Transition.noTransition,
      transitionDuration: const Duration(milliseconds: 0),
    ),
    GetPage(
      name: schedule,
      page: () => const ScheduleScreen(),
      transition: Transition.noTransition,
      transitionDuration: const Duration(milliseconds: 0),
    ),
    GetPage(
      name: profile,
      page: () => const ProfileScreen(),
      transition: Transition.noTransition,
      transitionDuration: const Duration(milliseconds: 0),
    ),
    GetPage(
      name: orderDetails,
      page: () => const OrderDetailsScreen(), // Remove the args handling here
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: productDelivery,
      page: () {
        final args = Get.arguments as Map<String, dynamic>?; // Changed to dynamic
        return ProductDeliveryScreen(
          trackingNumber: args?['trackingNumber']?.toString() ?? '',
          pickupLocation: args?['pickupLocation']?.toString() ?? '',
          deliveryLocation: args?['deliveryLocation']?.toString() ?? '',
          deliveryType: args?['deliveryType']?.toString() ?? '',
          date: args?['date']?.toString() ?? '',
          time: args?['time']?.toString() ?? '',
        );
      },
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: thankYou,
      page: () => const ThankYouDeliveryScreen(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}