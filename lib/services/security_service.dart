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
        // ✅ Enhanced emulator detection for VAPT compliance
        checks.add(await isEmulatorDetected());
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
  
  /// Check if running on Android emulator (existing method)
  static Future<bool> checkEmulator() async {
    if (!Platform.isAndroid) return false;
    try {
      return await _channel.invokeMethod('checkEmulator') ?? false;
    } catch (e) {
      return false;
    }
  }

  /// ✅ Enhanced emulator detection for VAPT compliance
  static Future<bool> isEmulatorDetected() async {
    if (!Platform.isAndroid) return false;
    try {
      return await _channel.invokeMethod('isEmulatorDetected') ?? false;
    } catch (e) {
      // Fail secure - assume emulator if check fails
      return true;
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
      status['enhancedEmulator'] = await isEmulatorDetected(); // ✅ Added for VAPT
    } else if (Platform.isIOS) {
      status['jailbreak'] = await checkJailbreak();
      status['simulator'] = await checkSimulator();
    }
    
    return status;
  }

  /// ✅ Separate method to check only emulator (both basic and enhanced)
  static Future<bool> isRunningOnEmulator() async {
    try {
      if (Platform.isAndroid) {
        bool basicEmulator = await checkEmulator();
        bool enhancedEmulator = await isEmulatorDetected();
        return basicEmulator || enhancedEmulator;
      } else if (Platform.isIOS) {
        return await checkSimulator();
      }
      return false;
    } catch (e) {
      return true; // Fail secure
    }
  }

  /// ✅ Check only for root/jailbreak (excluding emulator/simulator)
  static Future<bool> isDeviceRooted() async {
    try {
      if (Platform.isAndroid) {
        List<bool> rootChecks = [];
        rootChecks.add(await isDeveloperModeEnabled());
        rootChecks.add(await isDebuggingEnabled());
        rootChecks.add(await checkRootFiles());
        rootChecks.add(await checkRootApps());
        rootChecks.add(await checkSystemProperties());
        return rootChecks.any((check) => check);
      } else if (Platform.isIOS) {
        return await checkJailbreak();
      }
      return false;
    } catch (e) {
      return true; // Fail secure
    }
  }

  /// ✅ Comprehensive security check with detailed results
  static Future<SecurityCheckResult> performComprehensiveSecurityCheck() async {
    try {
      bool isRooted = await isDeviceRooted();
      bool isEmulator = await isRunningOnEmulator();
      bool isCompromised = isRooted || isEmulator;
      
      Map<String, bool> detailedStatus = await getDetailedSecurityStatus();
      
      return SecurityCheckResult(
        isSecure: !isCompromised,
        isRooted: isRooted,
        isEmulator: isEmulator,
        detailedChecks: detailedStatus,
      );
    } catch (e) {
      return SecurityCheckResult(
        isSecure: false,
        isRooted: true, // Fail secure
        isEmulator: true, // Fail secure
        detailedChecks: {},
        error: e.toString(),
      );
    }
  }
}

/// ✅ Result class for comprehensive security checks
class SecurityCheckResult {
  final bool isSecure;
  final bool isRooted;
  final bool isEmulator;
  final Map<String, bool> detailedChecks;
  final String? error;

  SecurityCheckResult({
    required this.isSecure,
    required this.isRooted,
    required this.isEmulator,
    required this.detailedChecks,
    this.error,
  });

  @override
  String toString() {
    return 'SecurityCheckResult('
        'isSecure: $isSecure, '
        'isRooted: $isRooted, '
        'isEmulator: $isEmulator, '
        'detailedChecks: $detailedChecks'
        '${error != null ? ', error: $error' : ''}'
        ')';
  }

  /// Get human-readable security issues
  List<String> getSecurityIssues() {
    List<String> issues = [];
    
    if (isRooted) {
      issues.add('Device appears to be rooted/jailbroken');
    }
    
    if (isEmulator) {
      issues.add('Running on emulator/simulator');
    }
    
    detailedChecks.forEach((check, result) {
      if (result) {
        switch (check) {
          case 'developerMode':
            issues.add('Developer options enabled');
            break;
          case 'debugging':
            issues.add('ADB debugging enabled');
            break;
          case 'rootFiles':
            issues.add('Root files detected');
            break;
          case 'rootApps':
            issues.add('Root management apps found');
            break;
          case 'systemProperties':
            issues.add('Suspicious system properties');
            break;
          case 'emulator':
          case 'enhancedEmulator':
            issues.add('Emulator environment detected');
            break;
          case 'jailbreak':
            issues.add('Jailbreak detected');
            break;
          case 'simulator':
            issues.add('iOS Simulator detected');
            break;
        }
      }
    });
    
    return issues;
  }
}