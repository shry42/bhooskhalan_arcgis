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
    print('🔄 Starting update check...');
    try {
      if (Platform.isAndroid) {
        print('📱 Checking Android updates...');
        await _checkAndroidUpdates(showDialog);
      } else if (Platform.isIOS) {
        print('🍎 Checking iOS updates...');
        await _checkIOSUpdates(showDialog);
      }
    } catch (e) {
      print('❌ Error checking for updates: $e');
      if (showDialog) {
        Get.snackbar(
          'Update Check Failed',
          'Unable to check for updates. Please try again later.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
      }
    }
  }

  /// Check for Android updates
  static Future<void> _checkAndroidUpdates(bool showDialog) async {
    try {
      print('🔍 Invoking Android update check...');
      final Map<dynamic, dynamic>? result = await _channel.invokeMethod('checkForUpdate');
      
      print('📊 Android update check result: $result');
      
      if (result != null && result['updateAvailable'] == true) {
        print('✅ Android update available!');
        if (showDialog) {
          _showAndroidUpdateDialog(result);
        } else {
          print('📱 Android Update available: ${result['immediateAllowed'] ? 'Immediate' : 'Flexible'}');
        }
      } else {
        print('📱 Android App is up to date');
        if (showDialog) {
          // Show manual check option for debug
          _showNoUpdateDialog('Android');
        }
      }
    } catch (e) {
      print('❌ Android update check failed: $e');
      if (showDialog) {
        Get.snackbar(
          'Android Update Check Failed',
          'Error: $e',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 5),
        );
      }
    }
  }

  /// Check for iOS updates via App Store API
  static Future<void> _checkIOSUpdates(bool showDialog) async {
    try {
      print('🔍 Checking iOS App Store for updates...');
      final bool updateAvailable = await _checkIOSUpdateAvailable();
      
      if (updateAvailable) {
        print('✅ iOS update available!');
        if (showDialog) {
          _showIOSUpdateDialog();
        } else {
          print('📱 iOS Update available on App Store');
        }
      } else {
        print('📱 iOS App is up to date');
        if (showDialog) {
          // Show manual check option for debug
          _showNoUpdateDialog('iOS');
        }
      }
    } catch (e) {
      print('❌ Error checking iOS updates: $e');
      if (showDialog) {
        Get.snackbar(
          'iOS Update Check Failed',
          'Error: $e',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 5),
        );
      }
    }
  }

  /// Check if iOS update is available on App Store
  static Future<bool> _checkIOSUpdateAvailable() async {
    try {
      // Get current app version
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final String currentVersion = packageInfo.version;
      final String bundleId = packageInfo.packageName;
      
      print('📱 Current app version: $currentVersion');
      print('📱 Bundle ID: $bundleId');
      print('📱 App Store ID configured: ${AppConfig.appStoreId}');
      
      // Query App Store API for latest version using bundle ID
      final String appStoreUrl = 'https://itunes.apple.com/lookup?bundleId=$bundleId';
      print('🔍 Querying App Store API: $appStoreUrl');
      
      final response = await http.get(Uri.parse(appStoreUrl));
      print('📊 App Store API response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        
        print('📊 App Store API results count: ${results.length}');
        
        if (results.isNotEmpty) {
          final Map<String, dynamic> appInfo = results[0];
          final String latestVersion = appInfo['version'];
          final String appStoreUrl = appInfo['trackViewUrl'];
          
          print('📱 Current version: $currentVersion');
          print('📱 Latest version: $latestVersion');
          print('📱 App Store URL: $appStoreUrl');
          
          // Compare versions
          final comparison = _compareVersions(currentVersion, latestVersion);
          print('📊 Version comparison result: $comparison (< 0 means update available)');
          
          return comparison < 0;
        } else {
          print('❌ No results found in App Store API response');
        }
      } else {
        print('❌ App Store API request failed with status: ${response.statusCode}');
        print('❌ Response body: ${response.body}');
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

  /// Show debug dialog when no updates are found
  static void _showNoUpdateDialog(String platform) {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('No Updates Available'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your app is up to date!',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Debug Info ($platform):',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• Current version: 2.2.2',
                    style: TextStyle(fontSize: 12),
                  ),
                  Text(
                    '• Check console logs for details',
                    style: TextStyle(fontSize: 12),
                  ),
                  if (platform == 'Android') ...[
                    Text(
                      '• Requires Google Play Store distribution',
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      '• Debug builds don\'t receive updates',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                  if (platform == 'iOS') ...[
                    Text(
                      '• Requires App Store distribution',
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      '• TestFlight builds may not show updates',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('OK'),
          ),
          if (platform == 'iOS')
            ElevatedButton(
              onPressed: () {
                Get.back();
                _openAppStore();
              },
              child: Text('Open App Store'),
            ),
        ],
      ),
      barrierDismissible: true,
    );
  }

  /// Open App Store manually
  static Future<void> _openAppStore() async {
    try {
      final String url = AppConfig.appStoreUrl;
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Error',
          'Cannot open App Store',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('❌ Error opening App Store: $e');
    }
  }
} 