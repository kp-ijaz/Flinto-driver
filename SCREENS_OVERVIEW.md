# Flinto Driver - Screens Overview

This document provides an overview of all screens created based on the Figma designs.

## 📱 Created Screens

### 1. HomeScreen (`lib/view/screens/HomeScreen/`)
- **Purpose**: Main screen displaying list of orders
- **Features**:
  - Search bar with QR scanner
  - Filter pills (All, Pending, On Process, Delivered)
  - Order list with status indicators
  - Bottom navigation bar

### 2. JobDetailsScreen (`lib/view/screens/JobDetailsScreen/`)
- **Purpose**: Detailed view of a specific job/order
- **Features**:
  - Map view with route visualization
  - Parcel information card
  - Delivery details (Express, Date, Payment)
  - Customer information
  - Product details
  - "Scan QR Code to Pick up" button

### 3. ScanQRCodeScreen (`lib/view/screens/ScanQRCodeScreen/`)
- **Purpose**: Display QR code for scanning
- **Features**:
  - QR code display
  - Booking ID
  - Share options (WhatsApp, Messenger)

### 4. ProductDeliveryScreen (`lib/view/screens/ProductDeliveryScreen/`)
- **Purpose**: Product delivery confirmation screen
- **Features**:
  - Map view
  - Parcel information with "Picked Up" status
  - Delivery details (Express, Date, Time)
  - Location confirmation
  - Payment status
  - "Send QR Code to Delivery" button

### 5. ScheduleScreen (`lib/view/screens/ScheduleScreen/`)
- **Purpose**: Schedule view with date picker and task list
- **Features**:
  - Date navigation (previous/next day)
  - Task list with from/to locations
  - Delivery type pills (Express, Schedule)
  - Action buttons (Pick Up, Drop)
  - Bottom navigation bar

### 6. ProfileScreen (`lib/view/screens/ProfileScreen/`)
- **Purpose**: Driver profile and account information
- **Features**:
  - Profile picture with edit option
  - Profile information (Email, Phone, ID, Joined Date)
  - Vehicle details card
  - Bottom navigation bar

### 7. OrderHistoryScreen (`lib/view/screens/OrderHistoryScreen/`)
- **Purpose**: Order history with sales reports and statistics
- **Features**:
  - Sales report with bar chart
  - Period selector (Weekly, Monthly, Yearly)
  - Summary statistics:
    - Total Orders Completed
    - Orders Within Emirate
    - Orders Outside Emirate
    - Income Earned

### 8. NotificationsScreen (`lib/view/screens/NotificationsScreen/`)
- **Purpose**: List of notifications
- **Features**:
  - Notification list items
  - Express tag indicators
  - Timestamps
  - "Mark All Read" button

### 9. PickupRequestScreen (`lib/view/screens/PickupRequestScreen/`)
- **Purpose**: New pickup request details
- **Features**:
  - Map view
  - Request details card
  - Delivery type (Express)
  - Date and time information
  - Accept/Reject buttons

### 10. ThankYouScreen (`lib/view/screens/ThankYouScreen/`)
- **Purpose**: Delivery completion confirmation
- **Features**:
  - Success icon (green checkmark)
  - Thank you message
  - "Back to Schedule" button

## 🎨 Design Consistency

All screens follow the same design principles:
- **Header**: Dark grey background with Flinto logo
- **Colors**: Consistent use of orange (primary), green (success), red (actions)
- **Cards**: White cards with rounded corners and shadows
- **Typography**: Consistent font sizes and weights
- **Spacing**: Responsive spacing using the Responsive utility

## 🔄 Navigation Flow

```
HomeScreen
  ├── JobDetailsScreen
  │     └── ScanQRCodeScreen
  ├── NotificationsScreen
  ├── ScheduleScreen
  ├── ProfileScreen
  │     └── OrderHistoryScreen
  └── PickupRequestScreen
        └── ProductDeliveryScreen
              └── ThankYouScreen
```

## 📦 Reusable Widgets Used

All screens use the reusable widget library:
- `AppHeader` - Consistent header across all screens
- `ContentCard` - White card containers
- `StatusPill` - Status indicators
- `PrimaryButton` - Action buttons
- `InfoRow` - Key-value information display
- `OrderItemCard` - Order list items
- `ParcelInfoCard` - Parcel information
- `MapViewWidget` - Map visualization
- `BottomNavBar` - Bottom navigation
- `NotificationItem` - Notification list items
- `ProfileDisplay` - Profile picture and name
- `VehicleCard` - Vehicle information

## 🚀 Usage Example

```dart
// Navigate to Job Details
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => JobDetailsScreen(
      trackingId: '#B56H48',
      fromAddress: 'Marriott Residences...',
      toAddress: '02 Residential Tower...',
    ),
  ),
);

// Navigate to Notifications
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const NotificationsScreen(),
  ),
);
```

## 🔧 Customization

Each screen accepts parameters for customization:
- Tracking IDs
- Addresses
- Status values
- Dates and times
- User information

## 📝 Notes

- All screens are responsive and work on different screen sizes
- Map views are placeholders - integrate with Google Maps or similar
- QR codes are placeholder patterns - integrate with QR code generation library
- Date formatting uses simple string formatting (can be replaced with intl package)
- All screens follow Flutter best practices for performance

