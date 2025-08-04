import 'package:bhooskhalann/landslide/report_landslide_maps_screen/widgets/build_distribution_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showDistributionDialog(BuildContext context) {
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
                    'distribution'.tr,
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
                        'distribution_description'.tr,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      buildDistributionSection(
                        number: '1.',
                        title: 'advancing'.tr,
                        description: 'advancing_desc'.tr,
                      ),
                      
                      buildDistributionSection(
                        number: '2.',
                        title: 'retrogressive'.tr,
                        description: 'retrogressive_desc'.tr,
                      ),
                      
                      buildDistributionSection(
                        number: '3.',
                        title: 'enlarging'.tr,
                        description: 'enlarging_desc'.tr,
                      ),
                      
                      buildDistributionSection(
                        number: '4.',
                        title: 'diminishing'.tr,
                        description: 'diminishing_desc'.tr,
                      ),
                      
                      buildDistributionSection(
                        number: '5.',
                        title: 'confined'.tr,
                        description: 'confined_desc'.tr,
                      ),
                      
                      buildDistributionSection(
                        number: '6.',
                        title: 'moving'.tr,
                        description: 'moving_desc'.tr,
                      ),
                      
                      buildDistributionSection(
                        number: '7.',
                        title: 'widening'.tr,
                        description: 'widening_desc'.tr,
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
