import 'package:bhooskhalann/landslide/report_landslide_maps_screen/widgets/build_activity_section.dart';
import 'package:bhooskhalann/landslide/report_landslide_maps_screen/widgets/build_activity_sub_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showActivityDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'activity'.tr,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Container(
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'activity_description'.tr,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      buildActivitySection(
                        number: '1.',
                        title: 'active'.tr,
                        description: 'active_desc'.tr,
                      ),
                      
                      buildActivitySection(
                        number: '2.',
                        title: 'suspended'.tr,
                        description: 'suspended_desc'.tr,
                      ),
                      
                      buildActivitySection(
                        number: '3.',
                        title: 'reactivated'.tr,
                        description: 'reactivated_desc'.tr,
                      ),
                      
                      buildActivitySection(
                        number: '4.',
                        title: 'inactive'.tr,
                        description: 'inactive_desc'.tr,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Sub-categories
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildActivitySubSection(
                              letter: 'a.',
                              title: 'dormant'.tr,
                              description: 'dormant_desc'.tr,
                            ),
                            
                            buildActivitySubSection(
                              letter: 'b.',
                              title: 'abandoned'.tr,
                              description: 'abandoned_desc'.tr,
                            ),
                            
                            buildActivitySubSection(
                              letter: 'c.',
                              title: 'stabilized'.tr,
                              description: 'stabilized_desc'.tr,
                            ),
                            
                            buildActivitySubSection(
                              letter: 'd.',
                              title: 'relict'.tr,
                              description: 'relict_desc'.tr,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
