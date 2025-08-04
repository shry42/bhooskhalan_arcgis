import 'package:bhooskhalann/landslide/report_landslide_maps_screen/widgets/build_style_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showStyleDialog(BuildContext context) {
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
                    'style'.tr,
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
                      buildStyleSection(
                        title: 'complex'.tr,
                        description: 'complex_desc'.tr,
                      ),
                      
                      buildStyleSection(
                        title: 'composite'.tr,
                        description: 'composite_desc'.tr,
                      ),
                      
                      buildStyleSection(
                        title: 'successive'.tr,
                        description: 'successive_desc'.tr,
                      ),
                      
                      buildStyleSection(
                        title: 'multiple'.tr,
                        description: 'multiple_desc'.tr,
                      ),
                      
                      buildStyleSection(
                        title: 'single'.tr,
                        description: 'single_desc'.tr,
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
