import 'package:bhooskhalann/landslide/forecast/bulletin_webview_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BulletinDateController extends GetxController {
  final String state;
  final String district;
  
  RxList<Map<String, String>> dateList = <Map<String, String>>[].obs;

  BulletinDateController({
    required this.state,
    required this.district,
  }) {
    // Generate dates immediately in constructor - no loading needed
    _generateDatesSync();
  }

  void _generateDatesSync() {
    // Get current date and subtract 1 day to start from yesterday
    DateTime currentDate = DateTime.now().subtract(const Duration(days: 1));
    
    // Generate last 7 days
    List<Map<String, String>> dates = [];
    for (int i = 0; i < 7; i++) {
      DateTime date = currentDate.subtract(Duration(days: i));
      
      // Format for display (YYYY-MM-DD)
      String displayDate = DateFormat('yyyy-MM-dd').format(date);
      
      // Format for API (YYYYMMDD)
      String apiDate = DateFormat('yyyyMMdd').format(date);
      
      // Get day name
      String dayName = DateFormat('EEEE').format(date);
      
      dates.add({
        'displayDate': displayDate,
        'apiDate': apiDate,
        'dayName': dayName,
      });
    }
    
    // Set the dates immediately
    dateList.assignAll(dates);
  }

  void openBulletin(String bulletinDate) async {
    try {
      // Show loading indicator
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF2196F3),
          ),
        ),
        barrierDismissible: false,
      );

      // Construct the API endpoint using dynamic state and district
      final endpoint = '/Landslide/getbulletin?state=$state&district=$district&bulletindate=$bulletinDate';
      
      // Close loading dialog immediately since we're going to webview
      Get.back();
      
      // Navigate directly to webview screen to display the bulletin
      // The webview will handle the PDF content directly
      Get.to(() => BulletinWebViewScreen(
        bulletinDate: bulletinDate,
        endpoint: endpoint,
        state: state,
        district: district,
      ));
      
    } catch (e) {
      // Close loading dialog if it's open
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      
      Get.snackbar(
        'error'.tr,
        '${'something_went_wrong'.tr}$e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void refreshDates() {
    _generateDatesSync();
  }
}