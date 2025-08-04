import 'package:bhooskhalann/landslide/forecast/bulletin_date_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForecastBulletinPage extends StatelessWidget {
  const ForecastBulletinPage({super.key});

  @override
  Widget build(BuildContext context) {
    final districts = [
      {
        'key': 'district_tamil_nadu_nilgiris',
        'original': 'TAMIL NADU - THE NILGIRIS',
      },
      {
        'key': 'district_west_bengal_darjeeling',
        'original': 'WEST BENGAL - DARJEELING',
      },
      {
        'key': 'district_west_bengal_kalimpong',
        'original': 'WEST BENGAL - KALIMPONG',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'forecast_bulletin'.tr,
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'select_district_instruction'.tr,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ...districts.map(
              (districtInfo) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.blue.shade600,
                    elevation: 3,
                  ),
                  onPressed: () {
                    // Parse the original district string to extract state and district
                    final parts = districtInfo['original']!.split(' - ');
                    final state = parts[0].trim();
                    final districtName = parts[1].trim();
                    
                    // Navigate to BulletinDateScreen with state and district
                    Get.to(() => BulletinDateScreen(
                      state: state,
                      district: districtName,
                    ));
                  },
                  child: Text(
                    districtInfo['key']!.tr,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}