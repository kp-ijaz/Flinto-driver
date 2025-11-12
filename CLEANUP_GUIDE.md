# Cleanup Guide - Remove Unwanted Code

## ✅ Fixed Issues

1. **Added `AppTextStyles` class** to `lib/core/constants/app_text.dart` for backward compatibility
2. **Cleaned up `main.dart`** - Removed commented imports

## 🗑️ Files to Remove (Old Architecture)

Since we've refactored to **Clean Architecture** with GetX, the following old files in `lib/view/` can be **DELETED** as they're replaced by new files in `lib/presentation/`:

### Old Screens (Can be deleted):
```
lib/view/screens/HomeScreen/                    → Replaced by lib/presentation/views/home/
lib/view/screens/loginScreen/                    → Replaced by lib/presentation/views/login/
lib/view/screens/OtpScreen/                     → Replaced by lib/presentation/views/otp/
lib/view/screens/OrderDetailsScreen/             → Replaced by lib/presentation/views/order_details/
lib/view/screens/ProductDeliveryScreen/          → Replaced by lib/presentation/views/product_delivery/
lib/view/screens/ProfileScreen/                  → Replaced by lib/presentation/views/profile/
lib/view/screens/ScheduleScreen/                 → Replaced by lib/presentation/views/schedule/
lib/view/screens/splashScreen/                   → Replaced by lib/presentation/views/splash/
lib/view/screens/Thankyouscreen/                 → Replaced by lib/presentation/views/thank_you/
```

### Old Widgets (Can be deleted):
```
lib/view/screens/HomeScreen/widgets/             → Replaced by lib/presentation/widgets/
lib/view/widgets/phone_input_field.dart         → Replaced by lib/presentation/widgets/common/phone_input_field.dart
```

## 📝 Migration Status

### ✅ New Clean Architecture Files (Keep these):
- `lib/presentation/views/` - All new screen views
- `lib/presentation/controllers/` - GetX controllers
- `lib/presentation/widgets/` - Reusable widgets
- `lib/data/models/` - Data models
- `lib/data/repositories/` - Repositories
- `lib/core/` - Constants, routes, utils

### ⚠️ Old Files (Can be deleted):
- `lib/view/screens/` - Entire directory
- `lib/view/widgets/` - Entire directory

## 🚀 How to Clean Up

### Option 1: Delete Entire Old Structure
```bash
# Delete old view directory
rm -rf lib/view/
```

### Option 2: Keep for Reference (Recommended)
1. Create a backup: `mv lib/view lib/view_old_backup`
2. Test the app with new architecture
3. If everything works, delete the backup: `rm -rf lib/view_old_backup`

## ⚠️ Important Notes

1. **Don't delete** `lib/core/` - This is used by both old and new code
2. **Check imports** - Make sure no files are importing from `lib/view/`
3. **Test thoroughly** - After cleanup, test all screens

## 🔍 Files Still Using Old Structure

If you see errors about missing files, check if any code is still importing from:
- `lib/view/screens/`
- `lib/view/widgets/`

These should be updated to use:
- `lib/presentation/views/`
- `lib/presentation/widgets/`

## ✅ Current Status

- ✅ `AppTextStyles` added to `app_text.dart`
- ✅ `main.dart` cleaned up
- ✅ New architecture files created
- ⏳ Old files can be removed when ready

