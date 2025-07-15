import 'package:bhooskhalann/landslide/report_landslide_maps_screen/widgets/build_hydrological_section.dart';
import 'package:flutter/material.dart';

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
                  const Text(
                    'Hydrological Condition',
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
                        title: 'Dry',
                        description: 'No moisture visible (source: cruden & varnes 1996) or none inflow per 10 m tunnel length (l/m) (source bieniawski (1989))',
                      ),
                      
                      buildHydrologicalSection(
                        title: 'Damp',
                        description: 'With visible moisture or < 10 inflow per 10 m tunnel length (l/m) (source bieniawski (1989))',
                      ),
                      
                      buildHydrologicalSection(
                        title: 'Wet',
                        description: 'Contains some water but no free water or 10-25 inflow per 10 m tunnel length (l/m) (source bieniawski (1989))',
                      ),
                      
                      buildHydrologicalSection(
                        title: 'Dripping',
                        description: 'Water flowing slowly in tiny drops or 25-125 inflow per 10 m tunnel length (l/m) (source bieniawski (1989))',
                      ),
                      
                      buildHydrologicalSection(
                        title: 'Flowing',
                        description: 'Water is moving smoothly and continuously or >125 inflow per 10 m tunnel length (l/m) (source bieniawski (1989))',
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
