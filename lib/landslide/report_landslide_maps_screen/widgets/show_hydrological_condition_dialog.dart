import 'package:bhooskhalann/landslide/report_landslide_maps_screen/widgets/build_hydrological_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showHydrologicalConditionDialog(BuildContext context) {
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
                    'hydrological_condition'.tr,
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
                      buildHydrologicalSection(
                        title: 'dry'.tr,
                        description: 'dry_desc'.tr,
                      ),
                      
                      buildHydrologicalSection(
                        title: 'damp'.tr,
                        description: 'damp_desc'.tr,
                      ),
                      
                      buildHydrologicalSection(
                        title: 'wet'.tr,
                        description: 'wet_desc'.tr,
                      ),
                      
                      buildHydrologicalSection(
                        title: 'dripping'.tr,
                        description: 'dripping_desc'.tr,
                      ),
                      
                      buildHydrologicalSection(
                        title: 'flowing'.tr,
                        description: 'flowing_desc'.tr,
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
