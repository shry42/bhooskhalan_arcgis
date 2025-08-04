import 'package:bhooskhalann/landslide/forecast/bulletin_webview_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BulletinDateScreen extends StatelessWidget {
  final String state;
  final String district;

  const BulletinDateScreen({
    Key? key,
    required this.state,
    required this.district,
  }) : super(key: key);

  // Generate dates directly in the widget - no controller needed
  List<Map<String, String>> _generateDates() {
    DateTime currentDate = DateTime.now().subtract(const Duration(days: 1));
    
    List<Map<String, String>> dates = [];
    for (int i = 0; i < 7; i++) {
      DateTime date = currentDate.subtract(Duration(days: i));
      
      String displayDate = DateFormat('yyyy-MM-dd').format(date);
      String apiDate = DateFormat('yyyyMMdd').format(date);
      String dayName = DateFormat('EEEE').format(date);
      
      dates.add({
        'displayDate': displayDate,
        'apiDate': apiDate,
        'dayName': dayName,
      });
    }
    
    return dates;
  }

  void _openBulletin(String bulletinDate) async {
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

      // Construct the API endpoint
      final endpoint = '/Landslide/getbulletin?state=$state&district=$district&bulletindate=$bulletinDate';
      
      // Close loading dialog
      Get.back();
      
      // Navigate to webview
      Get.to(() => BulletinWebViewScreen(
        bulletinDate: bulletinDate,
        endpoint: endpoint,
        state: state,
        district: district,
      ));
      
    } catch (e) {
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

  @override
  Widget build(BuildContext context) {
    // Generate dates immediately - no async, no loading, no controller
    final dateList = _generateDates();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'bulletin_date'.tr,
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        backgroundColor: const Color(0xFF2196F3),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Show selected state and district
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'selected_location'.tr,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$state - $district',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'select_any_date'.tr,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.normal,
                color: Colors.black87,
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          Expanded(
            child: ListView.builder(
              itemCount: dateList.length,
              itemBuilder: (context, index) {
                final dateInfo = dateList[index];
                
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: InkWell(
                    onTap: () => _openBulletin(dateInfo['apiDate']!),
                    borderRadius: BorderRadius.circular(4.0),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F8DC),
                        borderRadius: BorderRadius.circular(4.0),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today, 
                            color: Color(0xFF2196F3),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dateInfo['displayDate']!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  dateInfo['dayName']!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}