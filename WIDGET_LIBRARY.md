# Flinto Driver - Reusable Widget Library

This document provides an overview of all reusable widgets created for the Flinto Driver app based on the Figma designs. These widgets are designed to reduce code duplication, improve maintainability, and boost performance.

## 📁 Widget Structure

```
lib/view/widgets/
├── common/              # Common reusable widgets
│   ├── app_header.dart
│   ├── content_card.dart
│   ├── filter_pills.dart
│   ├── info_row.dart
│   ├── pill_button.dart
│   ├── primary_button.dart
│   ├── search_bar.dart
│   ├── status_pill.dart
│   └── widget_exports.dart
├── navigation/          # Navigation widgets
│   ├── bottom_nav_bar.dart
│   ├── side_menu.dart
│   └── navigation_widget_exports.dart
├── order/               # Order-related widgets
│   ├── map_view_widget.dart
│   ├── order_item_card.dart
│   ├── parcel_info_card.dart
│   └── order_widget_exports.dart
├── notification/        # Notification widgets
│   ├── notification_item.dart
│   └── notification_widget_exports.dart
└── profile/             # Profile widgets
    ├── profile_display.dart
    ├── vehicle_card.dart
    └── profile_widget_exports.dart
```

## 🎨 Common Widgets

### AppHeader
A reusable header component with logo, back button, menu button, and notification icon.

**Usage:**
```dart
AppHeader(
  title: 'My Orders',  // Optional
  showBackButton: true,
  showMenuButton: false,
  onBackPressed: () => Navigator.pop(context),
  onNotificationPressed: () => navigateToNotifications(),
)
```

### StatusPill
Colored pill-shaped status indicators for orders.

**Usage:**
```dart
StatusPill(
  label: 'Pending',
  status: OrderStatus.pending,
)
```

**Available Statuses:**
- `OrderStatus.pending` - Orange
- `OrderStatus.onProcess` - Light orange
- `OrderStatus.delivered` - Green
- `OrderStatus.paid` - Green
- `OrderStatus.pickedUp` - Green

### ContentCard
White card container with rounded corners and shadow.

**Usage:**
```dart
ContentCard(
  child: YourWidget(),
  padding: EdgeInsets.all(16),
  borderRadius: 12,
)
```

### PrimaryButton
Full-width primary action button (red by default).

**Usage:**
```dart
PrimaryButton(
  text: 'Scan QR Code',
  onPressed: () => handleAction(),
  isLoading: false,
)
```

### InfoRow
Key-value pair display with optional icon.

**Usage:**
```dart
InfoRow(
  label: 'Delivery Made',
  value: 'Express',
  icon: Icons.local_shipping,
)
```

### SearchBar
Search input field with QR code scanner icon.

**Usage:**
```dart
SearchBar(
  hintText: 'Enter Tracking Number...',
  controller: searchController,
  onChanged: (value) => filterOrders(value),
  onQrScanPressed: () => scanQRCode(),
)
```

### FilterPills
Horizontal scrollable filter chips.

**Usage:**
```dart
FilterPills(
  filters: ['All', 'Pending', 'Delivered'],
  selectedFilter: 'All',
  onFilterSelected: (filter) => setState(() => _filter = filter),
)
```

### PillButton
Small pill-shaped action buttons with different types.

**Usage:**
```dart
PillButton(
  label: 'Express',
  type: PillButtonType.express,
  onPressed: () => handleAction(),
)
```

**Available Types:**
- `PillButtonType.express` - Orange
- `PillButtonType.schedule` - Blue
- `PillButtonType.pickup` - Pink
- `PillButtonType.drop` - Green

## 📦 Order Widgets

### OrderItemCard
Card component for displaying order items in lists.

**Usage:**
```dart
OrderItemCard(
  trackingId: 'B56H894S454',
  statusText: 'Pending',
  status: OrderStatus.pending,
  description: 'Returned to sender',
  onTap: () => navigateToDetails(),
)
```

### ParcelInfoCard
Detailed parcel information card with addresses and status.

**Usage:**
```dart
ParcelInfoCard(
  parcelType: 'Courier | Small Parcel',
  trackingId: '#B56H48',
  fromAddress: 'Marriott Residences, Sheikh Mohammed...',
  toAddress: '02 Residential Tower, Sheikh Zayed Rd...',
  statusText: 'Pending',
  status: OrderStatus.pending,
)
```

### MapViewWidget
Map view with route visualization (placeholder - integrate with Google Maps).

**Usage:**
```dart
MapViewWidget(
  fromLocation: 'Marriott Residences',
  toLocation: '02 Residential Tower',
  height: 200,
)
```

## 🧭 Navigation Widgets

### BottomNavBar
Bottom navigation bar with three tabs: Schedule, Home, Profile.

**Usage:**
```dart
BottomNavBar(
  currentIndex: NavItem.home,
  onTap: (item) {
    switch(item) {
      case NavItem.schedule: navigateToSchedule();
      case NavItem.home: navigateToHome();
      case NavItem.profile: navigateToProfile();
    }
  },
)
```

### SideMenu
Drawer menu with profile, menu items, and footer links.

**Usage:**
```dart
SideMenu(
  userName: 'Mr. Rahim',
  userImageUrl: 'https://...',
  currentLanguage: 'English',
  isLanguageEnabled: true,
  onMenuTap: (item) => handleMenuTap(item),
  onLogout: () => handleLogout(),
)
```

## 🔔 Notification Widgets

### NotificationItem
List item for displaying notifications.

**Usage:**
```dart
NotificationItem(
  message: 'You have new delivery Request.',
  timeAgo: '1 min ago',
  tag: 'Express',
  icon: Icons.access_time,
  onTap: () => openNotification(),
)
```

## 👤 Profile Widgets

### ProfileDisplay
Circular profile picture with name and optional edit button.

**Usage:**
```dart
ProfileDisplay(
  name: 'Mr. Rahim',
  imageUrl: 'https://...',
  onImageTap: () => pickImage(),
)
```

### VehicleCard
Vehicle information card with image and details.

**Usage:**
```dart
VehicleCard(
  vehicleName: 'Toyota | Pickup Bak',
  licenseNumber: 'KA 05695',
  plateNumber: '3WPASS',
  description: 'A reliable and powerful utility vehicle...',
  imageUrl: 'https://...',
  onKnowMorePressed: () => showDetails(),
)
```

## 🎨 Color Constants

All colors are defined in `lib/core/constants/app_colors.dart`:

- **Primary Colors:** `AppColors.primary` (Orange)
- **Background:** `AppColors.backgroundDark` (Dark grey), `AppColors.background` (Light grey)
- **Status Colors:** `AppColors.statusPending`, `AppColors.statusDelivered`, etc.
- **Button Colors:** `AppColors.buttonPrimary`, `AppColors.buttonExpress`, etc.

## 📱 Responsive Design

All widgets use the `Responsive` utility class for consistent sizing across devices:

```dart
Responsive.w(context, 16)  // Width-based sizing
Responsive.h(context, 16)  // Height-based sizing
Responsive.sp(context, 14)  // Font size scaling
```

## 🚀 Performance Tips

1. **Use const constructors** where possible to reduce rebuilds
2. **Extract widgets** for complex UI components
3. **Use ListView.builder** for long lists instead of ListView
4. **Cache images** when using NetworkImage
5. **Use keys** appropriately for stateful widgets in lists

## 📝 Example: Complete Screen

See `lib/view/screens/HomeScreen/home_screen.dart` for a complete example of using multiple widgets together.

## 🔄 Importing Widgets

You can import widgets individually or use the export files:

```dart
// Individual import
import 'package:flinto_driver/view/widgets/common/app_header.dart';

// Or use export file
import 'package:flinto_driver/view/widgets/common/widget_exports.dart';
```

## 🎯 Best Practices

1. **Reuse widgets** - Don't duplicate UI code
2. **Keep widgets focused** - Each widget should have a single responsibility
3. **Use parameters** - Make widgets flexible with optional parameters
4. **Document usage** - Add comments for complex widgets
5. **Test widgets** - Create widget tests for critical components

## 🔧 Customization

All widgets accept customization parameters. Check individual widget files for available options. Common customization includes:
- Colors
- Sizes
- Padding/Margins
- Border radius
- Icons
- Text styles

