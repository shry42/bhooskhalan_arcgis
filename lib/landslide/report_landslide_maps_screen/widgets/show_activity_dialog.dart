import 'package:bhooskhalann/landslide/report_landslide_maps_screen/widgets/build_activity_section.dart';
import 'package:bhooskhalann/landslide/report_landslide_maps_screen/widgets/build_activity_sub_section.dart';
import 'package:flutter/material.dart';

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
                  const Text(
                    'Activity',
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
                      const Text(
                        'Activity can be classified into four categories (source (UNESCO-WP/WLI, 1993))',
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      buildActivitySection(
                        number: '1.',
                        title: 'Active',
                        description: 'A Active landslide is currently moving.',
                      ),
                      
                      buildActivitySection(
                        number: '2.',
                        title: 'Suspended',
                        description: 'A suspended landslide has moved within the last twelve months but is not active at present.',
                      ),
                      
                      buildActivitySection(
                        number: '3.',
                        title: 'Reactivated',
                        description: 'A reactivated landslide is an active landslide that has been inactive.',
                      ),
                      
                      buildActivitySection(
                        number: '4.',
                        title: 'Inactive',
                        description: 'An inactive landslide has not moved within the last twelve months. Inactive landslides can be subdivided further into the following states. Inactive landslide further can be classified into sub categories.',
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
                              title: 'Dormant',
                              description: 'A dormant landslide is an inactive landslide that can be reactivated by its original causes or other causes.',
                            ),
                            
                            buildActivitySubSection(
                              letter: 'b.',
                              title: 'Abandoned',
                              description: 'An abandoned landslide is an inactive landslide that is no longer affected by its original causes.',
                            ),
                            
                            buildActivitySubSection(
                              letter: 'c.',
                              title: 'Stabilized',
                              description: 'A stabilized landslide is an inactive landslide that has been protected from its original causes by artificial remedial measures.',
                            ),
                            
                            buildActivitySubSection(
                              letter: 'd.',
                              title: 'Relict',
                              description: 'A relict landslide is an inactive landslide that developed under geomorphological or climatic conditions considerably different from those at present.',
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
