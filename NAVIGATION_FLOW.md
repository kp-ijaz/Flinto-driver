# Flinto Driver - Navigation Flow

This document describes the complete navigation flow implemented in the app.

## 🔄 Complete Navigation Flow

### 1. **Login Flow**
```
LoginScreen → OtpScreen → HomeScreen
```

**LoginScreen** (`lib/view/screens/loginScreen/login_screen.dart`)
- User enters phone number
- Clicks "Sign In" button
- Navigates to `OtpScreen`

**OtpScreen** (`lib/view/screens/OtpScreen/otp_screen.dart`)
- User enters 4-digit OTP
- Clicks "Verify OTP" button
- Navigates to `HomeScreen` (replaces current screen)

### 2. **Order Flow**
```
HomeScreen → OrderItemCard (tap) → JobDetailsScreen → ScanQRCodeScreen → ProductDeliveryScreen → QRScannerScreen → ThankYouScreen
```

**HomeScreen** (`lib/view/screens/HomeScreen/home_screen.dart`)
- Displays list of orders
- User taps on any `OrderItemCard`
- Navigates to `JobDetailsScreen` with order details

**JobDetailsScreen** (`lib/view/screens/JobDetailsScreen/job_details_screen.dart`)
- Shows job/order details
- Displays map, parcel info, customer info
- User clicks "Scan QR Code to Pick up" button
- Navigates to `ScanQRCodeScreen`

**ScanQRCodeScreen** (`lib/view/screens/ScanQRCodeScreen/scan_qr_code_screen.dart`)
- Displays QR code for pickup
- Shows booking ID
- User clicks "Continue to Delivery" button
- Navigates to `ProductDeliveryScreen`

**ProductDeliveryScreen** (`lib/view/screens/ProductDeliveryScreen/product_delivery_screen.dart`)
- Shows delivery details
- Displays map and location confirmation
- User clicks "Send QR Code to Delivery" button
- Navigates to `QRScannerScreen`

**QRScannerScreen** (`lib/view/screens/QRScannerScreen/qr_scanner_screen.dart`)
- Scanner interface to scan receiver's QR code
- Simulates scanning (2 seconds)
- Automatically navigates to `ThankYouScreen` after successful scan

**ThankYouScreen** (`lib/view/screens/ThankYouScreen/thank_you_screen.dart`)
- Success confirmation screen
- Shows thank you message
- "Back to Schedule" button (currently pops to first route)

## 📱 Screen Details

### LoginScreen
- **File**: `lib/view/screens/loginScreen/login_screen.dart`
- **Navigation**: `Navigator.push()` to `OtpScreen`
- **Action**: "Sign In" button

### OtpScreen
- **File**: `lib/view/screens/OtpScreen/otp_screen.dart`
- **Navigation**: `Navigator.pushReplacement()` to `HomeScreen`
- **Action**: "Verify OTP" button

### HomeScreen
- **File**: `lib/view/screens/HomeScreen/home_screen.dart`
- **Navigation**: `Navigator.push()` to `JobDetailsScreen`
- **Action**: Tap on `OrderItemCard`

### JobDetailsScreen
- **File**: `lib/view/screens/JobDetailsScreen/job_details_screen.dart`
- **Navigation**: `Navigator.push()` to `ScanQRCodeScreen`
- **Action**: "Scan QR Code to Pick up" button
- **Parameters**: `trackingId`, `fromAddress`, `toAddress`

### ScanQRCodeScreen
- **File**: `lib/view/screens/ScanQRCodeScreen/scan_qr_code_screen.dart`
- **Navigation**: `Navigator.push()` to `ProductDeliveryScreen`
- **Action**: "Continue to Delivery" button
- **Parameters**: `bookingId`

### ProductDeliveryScreen
- **File**: `lib/view/screens/ProductDeliveryScreen/product_delivery_screen.dart`
- **Navigation**: `Navigator.push()` to `QRScannerScreen`
- **Action**: "Send QR Code to Delivery" button
- **Parameters**: `trackingId`, `fromAddress`, `toAddress`

### QRScannerScreen
- **File**: `lib/view/screens/QRScannerScreen/qr_scanner_screen.dart`
- **Navigation**: `Navigator.pushReplacement()` to `ThankYouScreen`
- **Action**: Automatic after 2 seconds (simulated scan)
- **Note**: Currently uses placeholder scanner UI

### ThankYouScreen
- **File**: `lib/view/screens/ThankYouScreen/thank_you_screen.dart`
- **Navigation**: `Navigator.popUntil()` to first route
- **Action**: "Back to Schedule" button

## 🔧 Implementation Notes

### Navigation Methods Used

1. **`Navigator.push()`**: Used for forward navigation (adds to stack)
   - HomeScreen → JobDetailsScreen
   - JobDetailsScreen → ScanQRCodeScreen
   - ScanQRCodeScreen → ProductDeliveryScreen
   - ProductDeliveryScreen → QRScannerScreen

2. **`Navigator.pushReplacement()`**: Used to replace current screen
   - OtpScreen → HomeScreen (replaces login flow)
   - QRScannerScreen → ThankYouScreen (replaces scanner)

3. **`Navigator.popUntil()`**: Used to go back to first route
   - ThankYouScreen → First route (HomeScreen)

### Data Passing

Order data is passed between screens using constructor parameters:
- `trackingId`: Order tracking ID
- `fromAddress`: Pickup address
- `toAddress`: Delivery address
- `bookingId`: Booking reference

### Current Limitations

1. **QR Scanner**: Currently uses a placeholder UI. For production, integrate with:
   - `qr_code_scanner` package
   - `mobile_scanner` package
   - Camera permissions handling

2. **OTP Verification**: Currently navigates immediately. In production:
   - Add actual OTP verification logic
   - Validate OTP before navigation
   - Handle error cases

3. **Order Data**: Currently uses hardcoded sample data. In production:
   - Fetch from API
   - Use state management (Provider, Riverpod, Bloc)
   - Handle loading and error states

## 🚀 Testing the Flow

To test the complete flow:

1. Run the app
2. Enter phone number on LoginScreen
3. Click "Sign In"
4. Enter OTP (any 4 digits)
5. Click "Verify OTP"
6. On HomeScreen, tap any order card
7. On JobDetailsScreen, click "Scan QR Code to Pick up"
8. On ScanQRCodeScreen, click "Continue to Delivery"
9. On ProductDeliveryScreen, click "Send QR Code to Delivery"
10. Wait 2 seconds on QRScannerScreen (auto-navigates)
11. See ThankYouScreen

## 📝 Future Enhancements

1. Add proper QR code scanning with camera
2. Implement actual OTP verification
3. Add loading states during navigation
4. Handle back button navigation properly
5. Add route guards for authentication
6. Implement deep linking
7. Add navigation animations

