# In-App Update Setup Guide

## Overview
This app now supports in-app updates for both Android and iOS platforms.

## Android Updates
- Uses Google Play's built-in in-app update API
- Can download and install updates directly in the app
- Supports both immediate and flexible updates

## iOS Updates
- Checks App Store for available updates
- Shows update dialog when newer version is available
- Redirects users to App Store for manual update
- Cannot install updates directly due to Apple's security restrictions

## Setup Instructions

### 1. Get Your App Store ID
1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Select your app
3. Note the App ID (e.g., `1234567890`)
4. Or find it in your app's App Store URL: `https://apps.apple.com/app/idYOUR_APP_ID`

### 2. Update Configuration
1. Open `lib/config/app_config.dart`
2. Replace `YOUR_APP_STORE_ID` with your actual App Store ID:

```dart
static const String appStoreId = '1234567890'; // Your actual App Store ID
```

### 3. Test the Implementation
- The app will check for updates on startup (silently)
- If an update is available, it will show a dialog
- Users can tap "Update Now" to go to App Store
- Users can tap "Later" to dismiss the dialog

## How It Works

### iOS Flow:
1. App queries App Store API on startup
2. Compares current version with App Store version
3. If update available, shows dialog
4. User taps "Update Now" → Opens App Store
5. User updates manually in App Store

### Android Flow:
1. App checks Google Play for updates
2. If update available, shows dialog
3. User can choose immediate or flexible update
4. Update downloads and installs automatically

## Configuration Options

In `lib/config/app_config.dart`, you can adjust:

- `updateCheckIntervalDays`: How often to check for updates
- `showUpdateDialogOnStart`: Whether to show dialog on app start
- `checkUpdatesSilentlyOnStart`: Whether to check silently on startup

## Testing

### For Development:
- Set a higher version number in `pubspec.yaml`
- The app will think an update is available
- Test the dialog and App Store redirect

### For Production:
- Publish your app to App Store
- Update the version in App Store Connect
- Test with the published version

## Notes

- iOS updates always redirect to App Store (Apple requirement)
- Android can install updates directly in the app
- The service handles both platforms automatically
- No additional setup needed for Android (uses existing Google Play integration)
