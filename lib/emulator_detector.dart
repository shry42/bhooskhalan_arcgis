// // emulator_detector.dart
// import 'dart:io';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:flutter/services.dart';

// class EmulatorDetector {
//   static const MethodChannel _channel = MethodChannel('emulator_detector');

//   /// Checks if the app is running on an emulator
//   static Future<bool> isEmulator() async {
//     if (Platform.isAndroid) {
//       return await _isAndroidEmulator();
//     } else if (Platform.isIOS) {
//       return await _isIOSSimulator();
//     }
//     return false;
//   }

//   /// Android emulator detection
//   static Future<bool> _isAndroidEmulator() async {
//     try {
//       final deviceInfo = DeviceInfoPlugin();
//       final androidInfo = await deviceInfo.androidInfo;

//       // Check multiple indicators of emulator
//       final checks = [
//         _checkBuildProperties(androidInfo),
//         _checkHardwareProperties(androidInfo),
//         await _checkSystemProperties(),
//       ];

//       // If any check indicates emulator, return true
//       return checks.any((check) => check);
//     } catch (e) {
//       // If device info fails, assume it might be an emulator
//       return true;
//     }
//   }

//   /// iOS simulator detection
//   static Future<bool> _isIOSSimulator() async {
//     try {
//       final deviceInfo = DeviceInfoPlugin();
//       final iosInfo = await deviceInfo.iosInfo;
      
//       // iOS simulator will have "Simulator" in the model
//       return iosInfo.model.toLowerCase().contains('simulator') ||
//              !iosInfo.isPhysicalDevice;
//     } catch (e) {
//       return true;
//     }
//   }

//   /// Check Android build properties
//   static bool _checkBuildProperties(AndroidDeviceInfo androidInfo) {
//     final suspiciousValues = [
//       'google_sdk',
//       'emulator',
//       'android sdk built for x86',
//       'generic',
//       'unknown',
//       'goldfish',
//       'ranchu',
//     ];

//     final properties = [
//       androidInfo.model.toLowerCase(),
//       androidInfo.brand.toLowerCase(),
//       androidInfo.manufacturer.toLowerCase(),
//       androidInfo.product.toLowerCase(),
//       androidInfo.device.toLowerCase(),
//       androidInfo.hardware.toLowerCase(),
//     ];

//     return properties.any((property) =>
//         suspiciousValues.any((suspicious) => property.contains(suspicious)));
//   }

//   /// Check hardware properties
//   static bool _checkHardwareProperties(AndroidDeviceInfo androidInfo) {
//     // Emulators often have specific fingerprints
//     final fingerprint = androidInfo.fingerprint.toLowerCase();
    
//     return fingerprint.contains('generic') ||
//            fingerprint.contains('unknown') ||
//            fingerprint.contains('emulator') ||
//            fingerprint.contains('sdk') ||
//            fingerprint.contains('genymotion');
//   }

//   /// Check system properties via platform channel
//   static Future<bool> _checkSystemProperties() async {
//     try {
//       final result = await _channel.invokeMethod('checkSystemProperties');
//       return result ?? false;
//     } catch (e) {
//       return false;
//     }
//   }

//   /// Main method to call before app initialization
//   static Future<void> validateDevice() async {
//     final isEmulator = await EmulatorDetector.isEmulator();
    
//     if (isEmulator) {
//       // Handle emulator detection - you can customize this behavior
//       throw EmulatorDetectedException('App cannot run on emulator devices');
//     }
//   }
// }

// /// Custom exception for emulator detection
// class EmulatorDetectedException implements Exception {
//   final String message;
  
//   EmulatorDetectedException(this.message);
  
//   @override
//   String toString() => 'EmulatorDetectedException: $message';
// }