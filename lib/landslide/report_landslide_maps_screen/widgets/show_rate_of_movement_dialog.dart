import 'package:bhooskhalann/landslide/report_landslide_maps_screen/widgets/build_rate_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showRateOfMovementDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'rate_of_movement'.tr,
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
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildRateSection(
                        title: 'extremely_rapid'.tr,
                        description: 'extremely_rapid_desc'.tr,
                      ),
                      
                      buildRateSection(
                        title: 'very_rapid'.tr,
                        description: 'very_rapid_desc'.tr,
                      ),
                      
                      buildRateSection(
                        title: 'rapid'.tr,
                        description: 'rapid_desc'.tr,
                      ),
                      
                      buildRateSection(
                        title: 'moderate'.tr,
                        description: 'moderate_desc'.tr,
                      ),
                      
                      buildRateSection(
                        title: 'slow'.tr,
                        description: 'slow_desc'.tr,
                      ),
                      
                      buildRateSection(
                        title: 'very_slow'.tr,
                        description: 'very_slow_desc'.tr,
                      ),
                      
                      buildRateSection(
                        title: 'extremely_slow'.tr,
                        description: 'extremely_slow_desc'.tr,
                      ),
                      
                      const SizedBox(height: 20),
                      
                      Text(
                        'rate_of_movement_source'.tr,
                        style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
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
