import 'dart:io';
import 'package:flutter/services.dart';

class SecurityService {
  static const MethodChannel _channel = MethodChannel('security_channel');
  
  /// Main security check - returns true if device is compromised
  static Future<bool> isDeviceCompromised() async {
    try {
      List<bool> checks = [];
      
      if (Platform.isAndroid) {
        // Android security checks
        checks.add(await isDeveloperModeEnabled());
        checks.add(await isDebuggingEnabled());
        checks.add(await checkRootFiles());
        checks.add(await checkRootApps());
        checks.add(await checkSystemProperties());
        checks.add(await checkEmulator());
      } else if (Platform.isIOS) {
        // iOS security checks
        checks.add(await checkJailbreak());
        checks.add(await checkSimulator());
      }
      
      // Return true if ANY check indicates compromise
      return checks.any((check) => check);
    } catch (e) {
      // If detection fails, assume device is compromised for security
      print('Security check error: $e');
      return true;
    }
  }
  
  // ============ ANDROID CHECKS ============
  
  /// Check if Android developer options are enabled
  static Future<bool> isDeveloperModeEnabled() async {
    if (!Platform.isAndroid) return false;
    try {
      return await _channel.invokeMethod('isDeveloperModeEnabled') ?? false;
    } catch (e) {
      return false;
    }
  }
  
  /// Check if ADB debugging is enabled
  static Future<bool> isDebuggingEnabled() async {
    if (!Platform.isAndroid) return false;
    try {
      return await _channel.invokeMethod('isDebuggingEnabled') ?? false;
    } catch (e) {
      return false;
    }
  }
  
  /// Check for common root files
  static Future<bool> checkRootFiles() async {
    if (!Platform.isAndroid) return false;
    try {
      return await _channel.invokeMethod('checkRootFiles') ?? false;
    } catch (e) {
      return false;
    }
  }
  
  /// Check for root management apps
  static Future<bool> checkRootApps() async {
    if (!Platform.isAndroid) return false;
    try {
      return await _channel.invokeMethod('checkRootApps') ?? false;
    } catch (e) {
      return false;
    }
  }
  
  /// Check system build properties
  static Future<bool> checkSystemProperties() async {
    if (!Platform.isAndroid) return false;
    try {
      return await _channel.invokeMethod('checkSystemProperties') ?? false;
    } catch (e) {
      return false;
    }
  }
  
  /// Check if running on Android emulator
  static Future<bool> checkEmulator() async {
    if (!Platform.isAndroid) return false;
    try {
      return await _channel.invokeMethod('checkEmulator') ?? false;
    } catch (e) {
      return false;
    }
  }
  
  // ============ iOS CHECKS ============
  
  /// Check for iOS jailbreak
  static Future<bool> checkJailbreak() async {
    if (!Platform.isIOS) return false;
    try {
      return await _channel.invokeMethod('checkJailbreak') ?? false;
    } catch (e) {
      return false;
    }
  }
  
  /// Check if running on iOS simulator
  static Future<bool> checkSimulator() async {
    if (!Platform.isIOS) return false;
    try {
      return await _channel.invokeMethod('checkSimulator') ?? false;
    } catch (e) {
      return false;
    }
  }
  
  // ============ UTILITY METHODS ============
  
  /// Get detailed security status for debugging
  static Future<Map<String, bool>> getDetailedSecurityStatus() async {
    Map<String, bool> status = {};
    
    if (Platform.isAndroid) {
      status['developerMode'] = await isDeveloperModeEnabled();
      status['debugging'] = await isDebuggingEnabled();
      status['rootFiles'] = await checkRootFiles();
      status['rootApps'] = await checkRootApps();
      status['systemProperties'] = await checkSystemProperties();
      status['emulator'] = await checkEmulator();
    } else if (Platform.isIOS) {
      status['jailbreak'] = await checkJailbreak();
      status['simulator'] = await checkSimulator();
    }
    
    return status;
  }
}