import 'package:bhooskhalann/landslide/all_reports/all_reports_screen.dart' show AllReportsScreen, AllReportsScreenArcGIS;
import 'package:bhooskhalann/landslide/forecast/forecast_bulletin_screen.dart';
import 'package:bhooskhalann/landslide/landslide_information_screen.dart/landslide_info_screen.dart';
import 'package:bhooskhalann/landslide/report_landslide_maps_screen/maps/arcgis_map_screen.dart';
import 'package:bhooskhalann/landslide/report_landslide_maps_screen/report_form_getx/draft_report_section/recent_report_screen/recent_reports_screen.dart';
import 'package:bhooskhalann/screens/news/recent_news_screen.dart';
import 'package:bhooskhalann/screens/report_landslide_dialog.dart';
import 'package:bhooskhalann/user_profile/expert_user_profile.dart';
import 'package:bhooskhalann/user_profile/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
   HomeScreen({super.key});

ProfileController  profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    final List<_HomeCardItem> items = [
      _HomeCardItem('report_landslide'.tr, "assets/report.png"),
      _HomeCardItem('view_my_reports'.tr, "assets/view_reports.png"),
      _HomeCardItem('all_reports'.tr, "assets/all_reports.png"),
      _HomeCardItem('basic_information_landslides'.tr, "assets/basic_info.png"),
      _HomeCardItem('forecast_bulletin'.tr, "assets/forecast_bulletin.png"),
      _HomeCardItem('recent_news'.tr, "assets/recent_news.png"),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('home'.tr),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions:  [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap:(){
                Get.to(ExpertProfileScreen());
              },
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Colors.blue),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                itemCount: items.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 40,
                  childAspectRatio: 0.85,
                ),
                itemBuilder: (context, index) {
                  return _buildCard(items[index]);
                },
              ),
            ),
            // const SizedBox(height: 16),
            // SizedBox(
            //   width: 200,
            //   height: 48,
            //   child: ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.blue,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(12),
            //       ),
            //     ),
            //     onPressed: () {
            //       // Logout logic
            //       profileController.logout();
            //     },
            //     child: Text('logout'.tr.toUpperCase(), style: const TextStyle(color: Colors.white)),
            //   ),
            // ),
         
          ],
        ),
      ),
    );
  }

Widget _buildCard(_HomeCardItem item) {
  // Check if this is forecast bulletin or recent news card
  bool needsImageFix = item.title == 'forecast_bulletin'.tr || item.title == 'recent_news'.tr;
  
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: InkWell(
      onTap: () async{
if (item.title == 'report_landslide'.tr) {
  // Check user type from SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final userType = prefs.getString('userType') ?? 'Public';
  
  if (userType == 'Public') {
    // Navigate to ArcGisLocationMapScreen for public users
    Get.to(() => ArcGisLocationMapScreen());
  } else {
    // Show safety dialog for other user types
    showSafetyDialog(Get.context!);
  }
}
         else if(item.title == 'view_my_reports'.tr){
          Get.to(()=>RecentReportsPage());
        } else if(item.title == 'forecast_bulletin'.tr){
          Get.to(()=>ForecastBulletinPage());
        }else if(item.title == 'recent_news'.tr){
          Get.to(()=>RecentNewsScreen());
        }else if(item.title == 'basic_information_landslides'.tr){
          Get.to(()=>LandslideInfoScreen());
        }
        else if(item.title == 'all_reports'.tr){
          Get.to(()=>AllReportsScreenArcGIS());
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: needsImageFix ? 3 : 1,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: needsImageFix 
                ? Container(
                    width: double.infinity,
                    child: Image.asset(
                      item.imagePath,
                      fit: BoxFit.contain,
                    ),
                  )
                : Image.asset(
                    item.imagePath,
                    fit: BoxFit.cover,
                  ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: needsImageFix ? 8 : 12,
              horizontal: needsImageFix ? 4 : 0,
            ),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            child: Text(
              item.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              maxLines: needsImageFix ? 2 : null,
              overflow: needsImageFix ? TextOverflow.ellipsis : null,
            ),
          ),
        ],
      ),
    ),
  );
}
}

class _HomeCardItem {
  final String title;
  final String imagePath;

  _HomeCardItem(this.title, this.imagePath);
}

void showSafetyDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const SafetyDialog(),
  );
}