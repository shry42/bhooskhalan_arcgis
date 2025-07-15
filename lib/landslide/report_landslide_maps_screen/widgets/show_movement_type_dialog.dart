import 'package:bhooskhalann/landslide/report_landslide_maps_screen/widgets/build_movement_sub_section.dart';
import 'package:bhooskhalann/landslide/report_landslide_maps_screen/widgets/build_movement_type_section.dart';
import 'package:flutter/material.dart';

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
                  const Text(
                    'Type of Movement',
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
                        title: 'Slide',
                        description: 'A slide-type landslide is a downslope movement of material that occurs along a distinctive rupture or slip surface.',
                      ),
                      
                      buildMovementTypeSection(
                        title: 'Falls',
                        description: 'Falls are abrupt movements of masses of geologic materials, such as rocks and boulders, which become detached from steep slopes or cliffs. Separation occurs along discontinuities such as fractures, joints, and bedding planes and movement occurs by free-fall, bouncing, and rolling.',
                      ),
                      
                      buildMovementTypeSection(
                        title: 'Topples',
                        description: 'Toppling failures are distinguished by the forward rotation of a unit or units about some pivotal point, below or low in the unit, under the actions of gravity and forces exerted by adjacent units or by fluids in cracks.',
                      ),
                      
                      buildMovementTypeSection(
                        title: 'Subsidence',
                        description: 'Surface subsidence is the gradual or sometimes abrupt collapse of rock and soil layers. Subsidence can be caused by mining, pumping of groundwater, underground coal fires, piping etc.',
                      ),
                      
                      buildMovementTypeSection(
                        title: 'Creep',
                        description: 'Creep is the imperceptibly slow, steady downward movement of slope-forming soil or rock.',
                      ),
                      
                      buildMovementTypeSection(
                        title: 'Lateral Spreads',
                        description: 'Lateral spreads are distinctive because they usually occur on very gentle slopes or flat terrain. The dominant mode of movement is lateral extension accompanied by shear or tensile fractures. The failure is caused by liquefaction, the process whereby saturated, loose, cohesionless sediments (usually sands and silts) are transformed from a solid into a liquefied state. Failure is usually triggered by rapid ground motion, such as that experienced during an earthquake, but can also be artificially induced. When coherent material, either bedrock or soil, rests on materials that liquefy, the upper units may undergo fracturing and extension and may then subside, translate, rotate, disintegrate, or liquefy and flow. Lateral spreading in fine-grained materials on shallow slopes is usually progressive.',
                      ),
                      
                      buildMovementTypeSection(
                        title: 'Flows',
                        description: 'There are five basic categories of flows that differ from one another in fundamental ways:',
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildMovementSubSection(
                              title: 'a. Debris flow',
                              description: 'A debris flow is a form of rapid mass movement in which a combination of loose soil, rock, organic matter, air, and water mobilize as slurry that flows down slope.',
                            ),
                            
                            buildMovementSubSection(
                              title: 'b. Debris avalanche',
                              description: 'This is a variety of very rapid to extremely rapid debris flow.',
                            ),
                            
                            buildMovementSubSection(
                              title: 'c. Earthflow',
                              description: 'Earthflows have a characteristic \'hourglass\' shape. The slope material liquefies and runs out, forming a bowl or depression at the head. The flow itself is elongate and usually occurs in fine-grained materials or clay-bearing rocks on moderate slopes and under saturated conditions. However, dry flows of granular material are also possible.',
                            ),
                            
                            buildMovementSubSection(
                              title: 'd. Mudflow',
                              description: 'A mudflow is an earthflow consisting of material that is wet enough to flow rapidly and that contains at least 50 percent sand, silt, and clay-sized particles.',
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
