import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class NativeInAppUpdateService {
  static const MethodChannel _channel = MethodChannel('in_app_update');
  
  /// Check for app updates and show update dialog if available
  static Future<void> checkForUpdates({bool showDialog = true}) async {
    try {
      // Only check for updates on Android
      if (!Platform.isAndroid) return;

      final Map<dynamic, dynamic>? result = await _channel.invokeMethod('checkForUpdate');
      
      if (result != null && result['updateAvailable'] == true) {
        if (showDialog) {
          _showUpdateDialog(result);
        } else {
          // Silent update check - just log
          print('📱 Update available: ${result['immediateAllowed'] ? 'Immediate' : 'Flexible'}');
        }
      } else {
        print('📱 App is up to date');
      }
    } catch (e) {
      print('❌ Error checking for updates: $e');
    }
  }

  /// Show update dialog to user
  static void _showUpdateDialog(Map<dynamic, dynamic> updateInfo) {
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
              _performUpdate(updateInfo);
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

  /// Perform the actual update
  static Future<void> _performUpdate(Map<dynamic, dynamic> updateInfo) async {
    try {
      final bool immediateAllowed = updateInfo['immediateAllowed'] ?? false;
      final bool flexibleAllowed = updateInfo['flexibleAllowed'] ?? false;
      
      if (immediateAllowed) {
        // Immediate update - app will restart
        await _channel.invokeMethod('performImmediateUpdate');
      } else if (flexibleAllowed) {
        // Flexible update - download in background
        await _channel.invokeMethod('startFlexibleUpdate');
        
        // Show progress dialog
        _showProgressDialog();
        
        // Listen for update completion
        _channel.setMethodCallHandler((call) async {
          switch (call.method) {
            case 'onUpdateCompleted':
              Get.back(); // Close progress dialog
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
              Get.back(); // Close progress dialog
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
              Get.back(); // Close progress dialog
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
        // No update type available
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
      print('❌ Error performing update: $e');
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