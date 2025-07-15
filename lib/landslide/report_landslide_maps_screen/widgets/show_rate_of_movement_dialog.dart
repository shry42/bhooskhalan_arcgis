import 'package:bhooskhalann/landslide/report_landslide_maps_screen/widgets/build_rate_section.dart';
import 'package:flutter/material.dart';

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
                  const Text(
                    'Rate of Movement',
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
                        title: 'Extremely Rapid',
                        description: 'Typical velocity more than 5m/sec',
                      ),
                      
                      buildRateSection(
                        title: 'Very Rapid',
                        description: 'Typical velocity more than 3 m/min',
                      ),
                      
                      buildRateSection(
                        title: 'Rapid',
                        description: 'Typical velocity more than 1.8 m/hour',
                      ),
                      
                      buildRateSection(
                        title: 'Moderate',
                        description: 'Typical velocity more than 13m/month',
                      ),
                      
                      buildRateSection(
                        title: 'Slow',
                        description: 'Typical velocity more than 1.6m/year',
                      ),
                      
                      buildRateSection(
                        title: 'Very Slow',
                        description: 'Typical velocity more than 16mm/year',
                      ),
                      
                      buildRateSection(
                        title: 'Extremely slow',
                        description: 'Typical velocity less than 16mm/year',
                      ),
                      
                      const SizedBox(height: 20),
                      
                      const Text(
                        '(source: Cruden & Varnes 1996)',
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
