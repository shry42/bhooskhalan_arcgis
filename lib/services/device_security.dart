// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:safe_device/safe_device.dart';
// import 'package:geolocator/geolocator.dart';

// class DeviceSecurityService {
//   static bool _initialized = false;
  
//   // Security flags
//   static bool isJailBroken = false;
//   static bool isMockLocation = false;
//   static bool isRealDevice = true;
//   static bool isOnExternalStorage = false;
//   static bool isDevelopmentModeEnable = false;
//   static bool isSafeDevice = true;

//   /// Initialize and perform all security checks
//   static Future<bool> initialize() async {
//     if (_initialized) return isSafeDevice;

//     try {
//       // Request location permission for mock location detection
//       await _requestLocationPermission();
      
//       // Perform all security checks
//       await _performSecurityChecks();
      
//       // Determine if device is safe
//       isSafeDevice = _evaluateDeviceSafety();
      
//       _initialized = true;
      
//       if (!isSafeDevice) {
//         _handleInsecureDevice();
//         return false;
//       }
      
//       print('✅ Device security checks passed');
//       return true;
      
//     } catch (e) {
//       print('❌ Device security check failed: $e');
//       return false;
//     }
//   }

//   /// Perform all security checks
//   static Future<void> _performSecurityChecks() async {
//     // Check if device is jailbroken/rooted
//     isJailBroken = await SafeDevice.isJailBroken;
    
//     // Check if it's a real device (not emulator)
//     isRealDevice = await SafeDevice.isRealDevice;
    
//     // Check for mock location (Android only)
//     if (Platform.isAndroid) {
//       try {
//         isMockLocation = await SafeDevice.isMockLocation;
//         isOnExternalStorage = await SafeDevice.isOnExternalStorage;
//         isDevelopmentModeEnable = await SafeDevice.isDevelopmentModeEnable;
//       } catch (e) {
//         print('Android-specific checks failed: $e');
//       }
//     }
    
//     print('🔍 Security Check Results:');
//     print('  📱 Is Real Device: $isRealDevice');
//     print('  🔓 Is Jailbroken/Rooted: $isJailBroken');
//     print('  📍 Mock Location: $isMockLocation');
//     if (Platform.isAndroid) {
//       print('  💾 External Storage: $isOnExternalStorage');
//       print('  🛠️ Developer Mode: $isDevelopmentModeEnable');
//     }
//   }

//   /// Request location permission for mock location detection
//   static Future<void> _requestLocationPermission() async {
//     try {
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//       }
//     } catch (e) {
//       print('Location permission request failed: $e');
//     }
//   }

//   /// Evaluate if device is safe based on security checks
//   static bool _evaluateDeviceSafety() {
//     // Device is unsafe if:
//     // 1. It's jailbroken/rooted
//     // 2. It's not a real device (emulator)
//     // 3. Mock location is enabled (for sensitive apps)
//     // 4. Running on external storage (Android)
    
//     if (isJailBroken) {
//       print('❌ Device is jailbroken/rooted');
//       return false;
//     }
    
//     if (!isRealDevice) {
//       print('❌ Device is an emulator/simulator');
//       return false;
//     }
    
//     // For government apps, you might want to block mock locations
//     if (isMockLocation) {
//       print('⚠️ Mock location detected');
//       // Uncomment to block mock locations:
//       // return false;
//     }
    
//     if (Platform.isAndroid && isOnExternalStorage) {
//       print('⚠️ App running on external storage');
//       // Uncomment to block external storage:
//       // return false;
//     }
    
//     return true;
//   }

//   /// Handle insecure device detection
//   static void _handleInsecureDevice() {
//     String message = _getSecurityMessage();
    
//     // Show security alert
//     Get.dialog(
//       AlertDialog(
//         title: Row(
//           children: [
//             Icon(Icons.security, color: Colors.red),
//             SizedBox(width: 8),
//             Text('Security Alert'),
//           ],
//         ),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => _exitApp(),
//             child: Text('Exit App', style: TextStyle(color: Colors.red)),
//           ),
//           if (!isJailBroken && !isRealDevice) // Allow bypass for emulator in development
//             TextButton(
//               onPressed: () {
//                 Get.back();
//                 _showDeveloperWarning();
//               },
//               child: Text('Continue (Dev Only)'),
//             ),
//         ],
//       ),
//       barrierDismissible: false,
//     );
//   }

//   /// Get appropriate security message
//   static String _getSecurityMessage() {
//     if (isJailBroken) {
//       return 'This app cannot run on jailbroken or rooted devices for security reasons. '
//              'Please use a standard device to access this application.';
//     }
    
//     if (!isRealDevice) {
//       return 'This app cannot run on emulators or simulators for security reasons. '
//              'Please use a real device to access this application.';
//     }
    
//     if (isMockLocation) {
//       return 'Mock location is detected. Please disable fake GPS applications '
//              'and restart the app.';
//     }
    
//     if (isOnExternalStorage) {
//       return 'This app cannot run from external storage for security reasons. '
//              'Please move the app to internal storage.';
//     }
    
//     return 'Device security check failed. This app requires a secure device environment.';
//   }

//   /// Show developer warning for non-production environments
//   static void _showDeveloperWarning() {
//     Get.snackbar(
//       'Developer Mode',
//       'Running on insecure device - FOR DEVELOPMENT ONLY',
//       snackPosition: SnackPosition.TOP,
//       backgroundColor: Colors.orange,
//       colorText: Colors.white,
//       duration: Duration(seconds: 5),
//       icon: Icon(Icons.warning, color: Colors.white),
//     );
//   }

//   /// Exit the application
//   static void _exitApp() {
//     exit(0);
//   }

//   /// Get detailed security report (for debugging)
//   static Map<String, dynamic> getSecurityReport() {
//     return {
//       'deviceSafety': {
//         'isJailBroken': isJailBroken,
//         'isRealDevice': isRealDevice,
//         'isMockLocation': isMockLocation,
//         'isOnExternalStorage': isOnExternalStorage,
//         'isDevelopmentModeEnable': isDevelopmentModeEnable,
//         'isSafeDevice': isSafeDevice,
//       },
//       'platform': Platform.operatingSystem,
//       'timestamp': DateTime.now().toIso8601String(),
//     };
//   }

//   /// Check if device is safe (call this before sensitive operations)
//   static bool get isDeviceSafe => _initialized && isSafeDevice;

//   /// Force re-check device security
//   static Future<bool> recheckSecurity() async {
//     _initialized = false;
//     return await initialize();
//   }
// }