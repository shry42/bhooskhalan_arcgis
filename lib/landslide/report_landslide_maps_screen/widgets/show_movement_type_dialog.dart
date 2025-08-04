import 'package:bhooskhalann/landslide/report_landslide_maps_screen/widgets/build_movement_sub_section.dart';
import 'package:bhooskhalann/landslide/report_landslide_maps_screen/widgets/build_movement_type_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showMovementTypeDialog(BuildContext context) {
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
                    'type_of_movement'.tr,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildMovementTypeSection(
                        title: 'slide'.tr,
                        description: 'slide_desc'.tr,
                      ),
                      
                      buildMovementTypeSection(
                        title: 'falls'.tr,
                        description: 'falls_desc'.tr,
                      ),
                      
                      buildMovementTypeSection(
                        title: 'topples'.tr,
                        description: 'topples_desc'.tr,
                      ),
                      
                      buildMovementTypeSection(
                        title: 'subsidence'.tr,
                        description: 'subsidence_desc'.tr,
                      ),
                      
                      buildMovementTypeSection(
                        title: 'creep'.tr,
                        description: 'creep_desc'.tr,
                      ),
                      
                      buildMovementTypeSection(
                        title: 'lateral_spreads'.tr,
                        description: 'lateral_spreads_desc'.tr,
                      ),
                      
                      buildMovementTypeSection(
                        title: 'flows'.tr,
                        description: 'flows_desc'.tr,
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildMovementSubSection(
                              title: 'debris_flow'.tr,
                              description: 'debris_flow_desc'.tr,
                            ),
                            
                            buildMovementSubSection(
                              title: 'debris_avalanche'.tr,
                              description: 'debris_avalanche_desc'.tr,
                            ),
                            
                            buildMovementSubSection(
                              title: 'earthflow'.tr,
                              description: 'earthflow_desc'.tr,
                            ),
                            
                            buildMovementSubSection(
                              title: 'mudflow'.tr,
                              description: 'mudflow_desc'.tr,
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
