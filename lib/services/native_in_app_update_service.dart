import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/app_config.dart';

class NativeInAppUpdateService {
  static const MethodChannel _channel = MethodChannel('in_app_update');
  
  /// Check for app updates and show update dialog if available
  static Future<void> checkForUpdates({bool showDialog = true}) async {
    try {
      if (Platform.isAndroid) {
        await _checkAndroidUpdates(showDialog);
      } else if (Platform.isIOS) {
        await _checkIOSUpdates(showDialog);
      }
    } catch (e) {
      print('❌ Error checking for updates: $e');
    }
  }

  /// Check for Android updates
  static Future<void> _checkAndroidUpdates(bool showDialog) async {
    final Map<dynamic, dynamic>? result = await _channel.invokeMethod('checkForUpdate');
    
    if (result != null && result['updateAvailable'] == true) {
      if (showDialog) {
        _showAndroidUpdateDialog(result);
      } else {
        print('📱 Android Update available: ${result['immediateAllowed'] ? 'Immediate' : 'Flexible'}');
      }
    } else {
      print('📱 Android App is up to date');
    }
  }

  /// Check for iOS updates via App Store API
  static Future<void> _checkIOSUpdates(bool showDialog) async {
    try {
      final bool updateAvailable = await _checkIOSUpdateAvailable();
      
      if (updateAvailable) {
        if (showDialog) {
          _showIOSUpdateDialog();
        } else {
          print('📱 iOS Update available on App Store');
        }
      } else {
        print('📱 iOS App is up to date');
      }
    } catch (e) {
      print('❌ Error checking iOS updates: $e');
    }
  }

  /// Check if iOS update is available on App Store
  static Future<bool> _checkIOSUpdateAvailable() async {
    try {
      // Get current app version
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final String currentVersion = packageInfo.version;
      
      // Query App Store API for latest version
      final String appStoreUrl = 'https://itunes.apple.com/lookup?bundleId=${packageInfo.packageName}';
      final response = await http.get(Uri.parse(appStoreUrl));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        
        if (results.isNotEmpty) {
          final Map<String, dynamic> appInfo = results[0];
          final String latestVersion = appInfo['version'];
          
          print('📱 Current version: $currentVersion, Latest version: $latestVersion');
          
          // Compare versions
          return _compareVersions(currentVersion, latestVersion) < 0;
        }
      }
      
      return false;
    } catch (e) {
      print('❌ Error checking App Store version: $e');
      return false;
    }
  }

  /// Compare version strings (e.g., "1.2.3" vs "1.2.4")
  static int _compareVersions(String version1, String version2) {
    final List<int> v1Parts = version1.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final List<int> v2Parts = version2.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    
    // Pad with zeros if needed
    while (v1Parts.length < v2Parts.length) v1Parts.add(0);
    while (v2Parts.length < v1Parts.length) v2Parts.add(0);
    
    for (int i = 0; i < v1Parts.length; i++) {
      if (v1Parts[i] < v2Parts[i]) return -1;
      if (v1Parts[i] > v2Parts[i]) return 1;
    }
    
    return 0;
  }

  /// Show iOS update dialog
  static void _showIOSUpdateDialog() {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(Icons.system_update, color: Colors.blue),
            SizedBox(width: 8),
            Text('App Update Available'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'A new version of Bhooskhalan is available on the App Store!',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Update now to get the latest features and improvements.',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info, color: Colors.blue, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'You\'ll be redirected to the App Store to update',
                      style: TextStyle(fontSize: 12, color: Colors.blue[800]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text('Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _openAppStore();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: Text('Update Now'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  /// Open App Store for iOS update
  static Future<void> _openAppStore() async {
    try {
      final Uri url = Uri.parse(AppConfig.appStoreUrl);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Error',
          'Unable to open App Store. Please update manually.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
      }
    } catch (e) {
      print('❌ Error opening App Store: $e');
      Get.snackbar(
        'Error',
        'Unable to open App Store. Please update manually.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    }
  }

  /// Show Android update dialog
  static void _showAndroidUpdateDialog(Map<dynamic, dynamic> updateInfo) {
    final bool immediateAllowed = updateInfo['immediateAllowed'] ?? false;
    final bool flexibleAllowed = updateInfo['flexibleAllowed'] ?? false;
    
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(Icons.system_update, color: Colors.blue),
            SizedBox(width: 8),
            Text('App Update Available'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'A new version of Bhooskhalan is available!',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Update now to get the latest features and improvements.',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            SizedBox(height: 12),
            if (immediateAllowed)
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'This update requires a restart',
                        style: TextStyle(fontSize: 12, color: Colors.orange[800]),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text('Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _performAndroidUpdate(updateInfo);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: Text('Update Now'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  /// Perform Android update
  static Future<void> _performAndroidUpdate(Map<dynamic, dynamic> updateInfo) async {
    try {
      final bool immediateAllowed = updateInfo['immediateAllowed'] ?? false;
      final bool flexibleAllowed = updateInfo['flexibleAllowed'] ?? false;
      
      if (immediateAllowed) {
        await _channel.invokeMethod('performImmediateUpdate');
      } else if (flexibleAllowed) {
        await _channel.invokeMethod('startFlexibleUpdate');
        _showProgressDialog();
        
        _channel.setMethodCallHandler((call) async {
          switch (call.method) {
            case 'onUpdateCompleted':
              Get.back();
              Get.snackbar(
                'Update Complete',
                'Please restart the app to apply the update',
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.green,
                colorText: Colors.white,
                duration: Duration(seconds: 5),
              );
              break;
            case 'onUpdateCancelled':
              Get.back();
              Get.snackbar(
                'Update Cancelled',
                'Update was cancelled by user',
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.orange,
                colorText: Colors.white,
                duration: Duration(seconds: 3),
              );
              break;
            case 'onUpdateFailed':
              Get.back();
              Get.snackbar(
                'Update Failed',
                'Unable to update the app. Please try again later.',
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.red,
                colorText: Colors.white,
                duration: Duration(seconds: 3),
              );
              break;
          }
        });
      } else {
        Get.snackbar(
          'Update Not Available',
          'No update method available for this device.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
      }
    } catch (e) {
      print('❌ Error performing Android update: $e');
      Get.snackbar(
        'Update Failed',
        'Unable to update the app. Please try again later.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    }
  }

  /// Show progress dialog for flexible updates
  static void _showProgressDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('Downloading Update'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Please wait while the update downloads...'),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  /// Check for updates silently (called on app start)
  static Future<void> checkForUpdatesSilently() async {
    await checkForUpdates(showDialog: false);
  }

  /// Check for updates with user dialog (called from settings or menu)
  static Future<void> checkForUpdatesWithDialog() async {
    await checkForUpdates(showDialog: true);
  }
} 