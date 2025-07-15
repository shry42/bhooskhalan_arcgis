import 'package:bhooskhalann/landslide/report_landslide_maps_screen/widgets/build_distribution_section.dart';
import 'package:flutter/material.dart';

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
                  const Text(
                    'Distribution',
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
                        'Distribution of the landslide is divided by seven categories: (source UNESCO-WP/WLI 1993)',
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      buildDistributionSection(
                        number: '1.',
                        title: 'Advancing',
                        description: 'The rupture surface is extending in the direction of the movement.',
                      ),
                      
                      buildDistributionSection(
                        number: '2.',
                        title: 'Retrogressive',
                        description: 'The rupture surface is extending in the direction opposite to the motion of the displaced material.',
                      ),
                      
                      buildDistributionSection(
                        number: '3.',
                        title: 'Enlarging',
                        description: 'The rupture surface of the landslide is extending in two or more directions.',
                      ),
                      
                      buildDistributionSection(
                        number: '4.',
                        title: 'Diminishing',
                        description: 'The volume of the displacing material is decreasing.',
                      ),
                      
                      buildDistributionSection(
                        number: '5.',
                        title: 'Confined',
                        description: 'There is a scarp but no rupture surface is visible at the foot of the displaced mass.',
                      ),
                      
                      buildDistributionSection(
                        number: '6.',
                        title: 'Moving',
                        description: 'The displaced material continues to move without any visible change in the rupture surface and the volume of the displaced material.',
                      ),
                      
                      buildDistributionSection(
                        number: '7.',
                        title: 'Widening',
                        description: 'The rupture surface is extending into one or both flanks of the landslide.',
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
