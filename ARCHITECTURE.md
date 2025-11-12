# Flinto Driver - Clean Architecture with GetX

## 📁 Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart      # All app colors
│   │   └── app_text.dart         # All static texts
│   ├── routes/
│   │   └── app_routes.dart      # Route definitions with transitions
│   └── utils/
│       ├── responsive.dart       # Legacy responsive helper
│       └── screen_util.dart      # ScreenUtil helper and extensions
│
├── data/
│   ├── models/                   # Data models
│   │   └── order_model.dart
│   └── repositories/            # Data repositories
│       └── order_repository.dart
│
└── presentation/
    ├── controllers/               # GetX controllers
    │   ├── home_controller.dart
    │   └── navigation_controller.dart
    ├── views/                    # Screen views
    │   ├── home/
    │   ├── schedule/
    │   ├── profile/
    │   ├── login/
    │   ├── otp/
    │   └── ...
    └── widgets/                  # Reusable widgets
        ├── common/
        │   ├── app_app_bar.dart
        │   ├── app_search_bar.dart
        │   ├── app_bottom_nav_bar.dart
        │   ├── app_filter_chips.dart
        │   ├── app_status_badge.dart
        │   └── phone_input_field.dart
        └── order/
            └── order_card.dart
```

## 🏗️ Architecture Layers

### 1. **Data Layer** (`lib/data/`)
- **Models**: Data transfer objects (DTOs)
- **Repositories**: Data source implementations (API, Local DB, etc.)

### 2. **Presentation Layer** (`lib/presentation/`)
- **Controllers**: GetX controllers for state management
- **Views**: UI screens
- **Widgets**: Reusable UI components

### 3. **Core Layer** (`lib/core/`)
- **Constants**: Colors, texts, and other constants
- **Routes**: Navigation configuration
- **Utils**: Helper functions and extensions

## 🎯 Key Features

### State Management with GetX
- Reactive state management using `Rx` variables
- `GetBuilder` for performance optimization
- `Obx` for reactive UI updates
- Dependency injection with `Get.put()` and `Get.find()`

### Responsive Design
- Uses `flutter_screenutil` for responsive sizing
- Extension methods: `.w`, `.h`, `.sp`, `.r` for easy sizing
- Design size: 375x812 (iPhone X)

### Navigation
- Named routes with `Get.toNamed()`
- Smooth transitions (rightToLeft, fadeIn, etc.)
- 300ms transition duration
- Bottom navigation with state management

### Performance Optimizations
- `const` constructors where possible
- `GetBuilder` instead of `Obx` for non-reactive updates
- Cached widgets
- Lazy loading for lists

## 📝 Usage Examples

### Creating a Controller
```dart
class HomeController extends GetxController {
  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxBool isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }
  
  Future<void> loadOrders() async {
    isLoading.value = true;
    update(); // Notify GetBuilder widgets
    // ... load data
    isLoading.value = false;
    update();
  }
}
```

### Using in View
```dart
class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(HomeController()); // Initialize controller
    
    return GetBuilder<HomeController>(
      builder: (controller) {
        // Rebuild only when update() is called
        return Text('Orders: ${controller.orders.length}');
      },
    );
  }
}
```

### Responsive Sizing
```dart
Container(
  width: 100.w,  // Responsive width
  height: 50.h,  // Responsive height
  padding: EdgeInsets.all(16.w),
  child: Text(
    'Hello',
    style: TextStyle(fontSize: 16.sp), // Responsive font
  ),
)
```

### Navigation
```dart
// Navigate to route
Get.toNamed('/order-details', arguments: order);

// Navigate with replacement
Get.offNamed('/home');

// Navigate and clear stack
Get.offAllNamed('/login');
```

## 🎨 Best Practices

1. **Always use `const` constructors** for static widgets
2. **Use `GetBuilder`** for performance-critical updates
3. **Use `Obx`** only for reactive UI that needs frequent updates
4. **Initialize controllers** in views using `Get.put()`
5. **Use extensions** for responsive sizing (`.w`, `.h`, `.sp`)
6. **Extract reusable widgets** to reduce code duplication
7. **Use `AppText`** for all static texts
8. **Use `AppColors`** for all colors

## 🔄 State Management Flow

```
User Action → Controller Method → Repository → Model → Update State → UI Rebuild
```

## 📦 Dependencies

- **get**: ^4.6.6 - State management and navigation
- **flutter_screenutil**: ^5.9.0 - Responsive design
- **intl**: ^0.19.0 - Internationalization
- **cached_network_image**: ^3.3.1 - Image caching

## 🚀 Next Steps

1. Add more controllers for other screens
2. Implement API integration in repositories
3. Add error handling and loading states
4. Implement caching strategies
5. Add unit tests for controllers
6. Add widget tests for reusable components

