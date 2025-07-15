import 'package:bhooskhalann/landslide/report_landslide_maps_screen/widgets/build_table_row.dart';
import 'package:flutter/material.dart';

void showAlertCategoryDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.95,
          height: MediaQuery.of(context).size.height * 0.85,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Alert Category',
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
                        'Ministry of Home affairs has categorized alert for landslide disaster into three categories',
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      const Text(
                        'I-Red,high alert',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      const Text(
                        'II-Orange,medium alert',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      const Text(
                        'III-Yellow,low alert',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Table
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[400]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            // Table Header
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                ),
                              ),
                              child: const Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Text(
                                        'Category',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Text(
                                        'Description',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Text(
                                        'Stage',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            // Table Rows
                            buildTableRow(
                              category: 'III',
                              description: 'Landslide and subsidence that occur in the vicinity of the in habituated areas and/ or any infrastructure that can adversely affect either human or property or infrastructure Landslides and subsidence that blocks smaller natural drainages and posing insignificant to limited risk it lives and properties It may pose some amount of threat for future damage.',
                              stage: 'Yellow',
                              isLast: false,
                            ),
                            
                            buildTableRow(
                              category: 'II',
                              description: 'Landslide and subsidence that occur and/or have damaging effects on inhabited areas, important and strategic infrastructure such as highways/roads, pilgrimage routes, rail routes and other civil installations like any hydroelectric/irrigation/ multipurpose projects and that result either loss of lives or damage to any property.',
                              stage: 'Orange',
                              isLast: false,
                            ),
                            
                            buildTableRow(
                              category: 'I',
                              description: 'Landslide and subsidence that occur nad /or have effect on inhabited areas, important and strategic infrastructure such as highways/roads, pilgrimage routes, rail routes and other civil installations like any appurtenant structures which result in significant losses of lives and properties This category also includes large landslide that causes damming and blocking of major rivers leading to the possibility of breaching of dam and flooding of downstream low-lying areas (outcome of Landslide Lake Outburst-LLOF).',
                              stage: 'Red',
                              isLast: true,
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
