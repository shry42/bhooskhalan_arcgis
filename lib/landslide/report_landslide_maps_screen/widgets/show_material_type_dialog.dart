  import 'package:bhooskhalann/landslide/report_landslide_maps_screen/widgets/build_material_type_section_screen.dart';
import 'package:flutter/material.dart';

void showMaterialTypeDialog(BuildContext context) {
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
                      'Material Types',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
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
                        // Rock Section
                        buildMaterialTypeSection(
                          title: 'Rock',
                          imagePath: 'assets/rock_slide.png',
                          description: 'Rock slide',
                        ),
                        const SizedBox(height: 20),
                        
                        // Soil Section
                        buildMaterialTypeSection(
                          title: 'Soil',
                          imagePath: 'assets/soil_slide.png',
                          description: 'Soil slide',
                        ),
                        const SizedBox(height: 20),
                        
                        // Debris Section
                        buildMaterialTypeSection(
                          title: 'Debris (mixture of Rock and Soil)',
                          imagePath: 'assets/debris_slide.png',
                          description: 'Debris slide',
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


