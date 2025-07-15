// import 'package:bhooskhalann/landslide/report_landslide_maps_screen/report_form_getx/report_form_controller.dart';
// import 'package:bhooskhalann/landslide/report_landslide_maps_screen/widgets/show_activity_dialog.dart';
// import 'package:bhooskhalann/landslide/report_landslide_maps_screen/widgets/show_alert_category_dialog.dart';
// import 'package:bhooskhalann/landslide/report_landslide_maps_screen/widgets/show_distribution_dialog.dart';
// import 'package:bhooskhalann/landslide/report_landslide_maps_screen/widgets/show_hydrological_condition_dialog.dart';
// import 'package:bhooskhalann/landslide/report_landslide_maps_screen/widgets/show_material_type_dialog.dart';
// import 'package:bhooskhalann/landslide/report_landslide_maps_screen/widgets/show_movement_type_dialog.dart';
// import 'package:bhooskhalann/landslide/report_landslide_maps_screen/widgets/show_rate_of_movement_dialog.dart';
// import 'package:bhooskhalann/landslide/report_landslide_maps_screen/widgets/show_style_dialog.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class LandslideReportingScreen extends StatelessWidget {
//   const LandslideReportingScreen({Key? key, required this.latitude, required this.longitude}) : super(key: key);
  
//   final double latitude;
//   final double longitude;

//   @override
//   Widget build(BuildContext context) {
//     // Initialize controller with coordinates
//     final controller = Get.put(LandslideReportController());
//     controller.setCoordinates(latitude, longitude);
    
//     // Colors for professional appearance
//     final Color primaryColor = const Color(0xFF1976D2);
//     final Color secondaryColor = const Color(0xFF64B5F6);
//     final Color backgroundColor = const Color(0xFFF5F7FA);
//     final Color cardColor = Colors.white;
//     final Color textColor = const Color(0xFF2C3E50);
//     final Color hintColor = const Color(0xFF7F8C8D);

//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: primaryColor,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Get.back(),
//         ),
//         title: const Text(
//           'Report Landslide',
//           style: TextStyle(fontWeight: FontWeight.w600),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Get.snackbar(
//                 'Success',
//                 'Form saved as draft',
//                 backgroundColor: primaryColor,
//                 colorText: Colors.white,
//               );
//             },
//             child: const Text(
//               'SAVE',
//               style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//       body: Obx(() => controller.isLoading.value
//           ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(color: primaryColor),
//                   const SizedBox(height: 16),
//                   Text(
//                     'Submitting report...',
//                     style: TextStyle(
//                       color: textColor,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           : Form(
//               key: controller.formKey,
//               child: ListView(
//                 padding: const EdgeInsets.all(16.0),
//                 children: [
//                   // Location Information Section
//                   _buildSectionCard(
//                     title: 'Location Information',
//                     primaryColor: primaryColor,
//                     cardColor: cardColor,
//                     textColor: textColor,
//                     children: [
//                       _buildTextField(
//                         label: 'Latitude *',
//                         controller: controller.latitudeController,
//                         readOnly: true,
//                         validator: (value) => controller.validateRequired(value, 'Latitude'),
//                       ),
//                       const SizedBox(height: 16),
//                       _buildTextField(
//                         label: 'Longitude *',
//                         controller: controller.longitudeController,
//                         readOnly: true,
//                         validator: (value) => controller.validateRequired(value, 'Longitude'),
//                       ),
//                       const SizedBox(height: 16),
//                       _buildTextField(
//                         label: 'State *',
//                         controller: controller.stateController,
//                         validator: (value) => controller.validateRequired(value, 'State'),
//                       ),
//                       const SizedBox(height: 16),
//                       _buildTextField(
//                         label: 'District *',
//                         controller: controller.districtController,
//                         validator: (value) => controller.validateRequired(value, 'District'),
//                       ),
//                       const SizedBox(height: 16),
//                       _buildTextField(
//                         label: 'Subdivision/Taluk',
//                         controller: controller.subdivisionController,
//                       ),
//                       const SizedBox(height: 16),
//                       _buildTextField(
//                         label: 'Village',
//                         controller: controller.villageController,
//                       ),
//                       const SizedBox(height: 16),
//                       _buildTextField(
//                         label: 'Other relevant location details \nif any such as landmark etc',
//                         controller: controller.locationDetailsController,
//                         maxLines: 3,
//                       ),
//                     ],
//                   ),
                  
//                   const SizedBox(height: 16),
                  
//                   // Occurrence Information Section
//                   _buildSectionCard(
//                     title: 'Occurrence of Landslide \n(Date & Time) *',
//                     primaryColor: primaryColor,
//                     cardColor: cardColor,
//                     textColor: textColor,
//                     children: [
//                       Obx(() => _buildDropdown(
//                         hint: '---Select---',
//                         value: controller.landslideOccurrenceValue.value,
//                         items: [
//                           'I know the EXACT occurrence date',
//                           'I know the APPROXIMATE occurrence date', 
//                           'I DO NOT know the occurrence date'
//                         ],
//                         onChanged: (value) {
//                           controller.landslideOccurrenceValue.value = value;
//                           controller.dateController.clear();
//                           controller.timeController.clear();
//                           controller.howDoYouKnowValue.value = null;
//                           controller.occurrenceDateRangeController.clear();
//                         },
//                         icon: Icons.event,
//                       )),
                      
//                       // Conditional fields based on selection
//                // Replace the existing conditional fields section with this fixed version
// Obx(() {
//   if (controller.landslideOccurrenceValue.value == 'I know the EXACT occurrence date') {
//     return Column(
//       children: [
//         const SizedBox(height: 16),
//         Row(
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _labelText('Date *', textColor),
//                   GestureDetector(
//                     onTap: () => controller.selectDate(),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                       decoration: BoxDecoration(
//                         color: Colors.grey[200],
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(color: Colors.grey[300]!),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                          Text(
//   controller.selectedDateText.value.isEmpty ? 'Select Date' : controller.selectedDateText.value,
//   style: TextStyle(
//     color: controller.selectedDateText.value.isEmpty ? Colors.grey[600] : Colors.black,
//   ),
// ),
//                           Icon(Icons.calendar_today, color: Colors.grey[600]),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _labelText('Time', textColor),
//                   GestureDetector(
//                     onTap: () => controller.selectTime(),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                       decoration: BoxDecoration(
//                         color: Colors.grey[200],
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(color: Colors.grey[300]!),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//   controller.selectedTimeText.value.isEmpty ? 'Select Time' : controller.selectedTimeText.value,
//   style: TextStyle(
//     color: controller.selectedTimeText.value.isEmpty ? Colors.grey[600] : Colors.black,
//   ),
// ),
//                           Icon(Icons.access_time, color: Colors.grey[600]),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 16),
//         _labelText('How do you know this Information? *', textColor),
//         _buildDropdown(
//           hint: 'Select source',
//           value: controller.howDoYouKnowValue.value,
//           items: [
//             'I observed it',
//             'Through a local',
//             'Social media',
//             'News',
//             'I don\'t know',
//           ],
//           onChanged: (value) => controller.howDoYouKnowValue.value = value,
//           icon: Icons.info,
//         ),
//       ],
//     );
//   } else if (controller.landslideOccurrenceValue.value == 'I know the APPROXIMATE occurrence date') {
//     return Column(
//       children: [
//         const SizedBox(height: 16),
//         _labelText('Occurrence Date Range *', textColor),
//         _buildDropdown(
//           hint: '---Select---',
//           value: controller.occurrenceDateRangeController.text.isEmpty ? null : controller.occurrenceDateRangeController.text,
//           items: [
//             'In the last 3 days',
//             'In the last week', 
//             'In the last month',
//             'In the last 3 months',
//             'In the last year',
//             'Older than a year',                        
//           ],
//           onChanged: (value) => controller.occurrenceDateRangeController.text = value ?? '',
//           icon: Icons.date_range,
//         ),
//       ],
//     );
//   }
  
//   return const SizedBox.shrink();
// }),           
//                     ],
//                   ),
                  
//                   const SizedBox(height: 16),
                  
//                   // Landslide Location Type
//                   _buildSectionCard(
//                     title: 'Where did the landslide take place\n(Landuse/Landcover) *',
//                     primaryColor: primaryColor,
//                     cardColor: cardColor,
//                     textColor: textColor,
//                     children: [
//                       Obx(() => _buildDropdown(
//                         hint: 'Select location type',
//                         value: controller.whereDidLandslideOccurValue.value,
//                         items: ['Near/onroad', 'Next to river', 'Settlement', 'Plantation (tea,rubber .... etc.)', 'Forest Area', 'Cultivation','Barren Land','Other (Specify)'],
//                         onChanged: (value) => controller.whereDidLandslideOccurValue.value = value,
//                         icon: Icons.landscape,
//                       )),
//                     ],
//                   ),
                  
//                   const SizedBox(height: 16),
                  
//                   // Type of Material
//                   _buildSectionCard(
//                     title: 'Type of Material *',
//                     primaryColor: primaryColor,
//                     cardColor: cardColor,
//                     textColor: textColor,
//                     children: [
//                       Obx(() => _buildDropdown(
//                         hint: 'Select material type',
//                         value: controller.typeOfMaterialValue.value,
//                         items: ['Rock', 'Soil', 'Debris (mixture of Rock and Soil)'],
//                         onChanged: (value) => controller.typeOfMaterialValue.value = value,
//                         icon: Icons.move_down,
//                         hasInfoIcon: true,
//                         onInfoTap: () => showMaterialTypeDialog(context),
//                       )),
//                     ],
//                   ),
                  
//                   const SizedBox(height: 16),
                  
//                   // Type of Movement
//                   _buildSectionCard(
//                     title: 'Type of Movement *',
//                     primaryColor: primaryColor,
//                     cardColor: cardColor,
//                     textColor: textColor,
//                     children: [
//                       Obx(() => _buildDropdown(
//                         hint: 'Select movement type',
//                         value: controller.typeOfMovementValue.value,
//                         items: ['Slide','Fall', 'Topple','Subsidence','Creep','Lateral spread', 'Flow','Complex'],
//                         onChanged: (value) => controller.typeOfMovementValue.value = value,
//                         icon: Icons.move_down,
//                         hasInfoIcon: true,
//                         onInfoTap: () => showMovementTypeDialog(context),
//                       )),
//                     ],
//                   ),
                  
//                   const SizedBox(height: 16),
                  
//                   // Dimensions Section
//                   _buildSectionCard(
//                     title: 'Dimensions',
//                     primaryColor: primaryColor,
//                     cardColor: cardColor,
//                     textColor: textColor,
//                     children: [
//                       _buildTextField(
//                         label: 'Length (in meters) *',
//                         controller: controller.lengthController,
//                         keyboardType: TextInputType.number,
//                         hasInfoIcon: true,
//                         onInfoTap: () => _showDimensionsDialog(context),
//                         validator: (value) => controller.validateNumber(value, 'Length'),
//                       ),
//                       const SizedBox(height: 16),
//                       _buildTextField(
//                         label: 'Width (in meters) *',
//                         controller: controller.widthController,
//                         keyboardType: TextInputType.number,
//                         hasInfoIcon: true,
//                         onInfoTap: () => _showDimensionsDialog(context),
//                         validator: (value) => controller.validateNumber(value, 'Width'),
//                       ),
//                       const SizedBox(height: 16),
//                       _buildTextField(
//                         label: 'Height (in meters) *',
//                         controller: controller.heightController,
//                         keyboardType: TextInputType.number,
//                         hasInfoIcon: true,
//                         onInfoTap: () => _showDimensionsDialog(context),
//                         validator: (value) => controller.validateNumber(value, 'Height'),
//                       ),
//                       const SizedBox(height: 16),
//                       _buildTextField(
//                         label: 'Area (in sq.meters) *',
//                         controller: controller.areaController,
//                         keyboardType: TextInputType.number,
//                         validator: (value) => controller.validateNumber(value, 'Area'),
//                       ),
//                       const SizedBox(height: 16),
//                       _buildTextField(
//                         label: 'Depth (in meters)*',
//                         controller: controller.depthController,
//                         keyboardType: TextInputType.number,
//                         validator: (value) => controller.validateNumber(value, 'Depth'),
//                       ),
//                       const SizedBox(height: 16),
//                       _buildTextField(
//                         label: 'Volume (in cu.meters) *',
//                         controller: controller.volumeController,
//                         keyboardType: TextInputType.number,
//                         validator: (value) => controller.validateNumber(value, 'Volume'),
//                       ),
//                       const SizedBox(height: 16),
//                       _buildTextField(
//                         label: 'Run-out distance (in meters)',
//                         controller: controller.runoutDistanceController,
//                         keyboardType: TextInputType.number,
//                       ),
//                     ],
//                   ),
                  
//                   const SizedBox(height: 16),
                  
//                   // Rate of Movement
//                   _buildSectionCard(
//                     title: 'Rate of Movement',
//                     primaryColor: primaryColor,
//                     cardColor: cardColor,
//                     textColor: textColor,
//                     children: [
//                       Obx(() => _buildDropdown(
//                         hint: 'Select rate of movement',
//                         value: controller.rateOfMovementValue.value,
//                         items: ['Extremely Rapid', 'Very Rapid', 'Rapid', 'Moderate', 'Slow', 'Very Slow', 'Extremely Slow'],
//                         onChanged: (value) => controller.rateOfMovementValue.value = value,
//                         icon: Icons.speed,
//                         hasInfoIcon: true,
//                         onInfoTap: () => showRateOfMovementDialog(context),
//                       )),
//                     ],
//                   ),
                  
//                   const SizedBox(height: 16),
                  
//                   // Activity
//                   _buildSectionCard(
//                     title: 'Activity *',
//                     primaryColor: primaryColor,
//                     cardColor: cardColor,
//                     textColor: textColor,
//                     children: [
//                       Obx(() => _buildDropdown(
//                         hint: 'Select activity status',
//                         value: controller.activityValue.value,
//                         items: ['Active', 'Reactivated','Suspended','Dormant','Abandoned','Stabilised', 'Relict'],
//                         onChanged: (value) => controller.activityValue.value = value,
//                         icon: Icons.monitor_heart,
//                         hasInfoIcon: true,
//                         onInfoTap: () => showActivityDialog(context),
//                       )),
//                     ],
//                   ),
                  
//                   const SizedBox(height: 16),
                  
//                   // Distribution
//                   _buildSectionCard(
//                     title: 'Distribution',
//                     primaryColor: primaryColor,
//                     cardColor: cardColor,
//                     textColor: textColor,
//                     children: [
//                       Obx(() => _buildDropdown(
//                         hint: 'Select distribution pattern',
//                         value: controller.distributionValue.value,
//                         items: ['Advancing', 'Retrogressive', 'Widening','Enlarging','Confined', 'Diminishing','Moving', ],
//                         onChanged: (value) => controller.distributionValue.value = value,
//                         icon: Icons.scatter_plot,
//                         hasInfoIcon: true,
//                         onInfoTap: () => showDistributionDialog(context),
//                       )),
//                     ],
//                   ),
                  
//                   const SizedBox(height: 16),
                  
//                   // Style
//                   _buildSectionCard(
//                     title: 'Style *',
//                     primaryColor: primaryColor,
//                     cardColor: cardColor,
//                     textColor: textColor,
//                     children: [
//                       Obx(() => _buildDropdown(
//                         hint: 'Select style',
//                         value: controller.styleValue.value,
//                         items: ['Complex','Successive', 'Multiple','Single','Composite'],
//                         onChanged: (value) => controller.styleValue.value = value,
//                         icon: Icons.style,
//                         hasInfoIcon: true,
//                         onInfoTap: () => showStyleDialog(context),
//                       )),
//                     ],
//                   ),
                  
//                   const SizedBox(height: 16),
                  
//                   // Failure Mechanism
//                   _buildSectionCard(
//                     title: 'Failure Mechanism *',
//                     primaryColor: primaryColor,
//                     cardColor: cardColor,
//                     textColor: textColor,
//                     children: [
//                       Obx(() => _buildDropdown(
//                         hint: 'Select failure mechanism',
//                         value: controller.failureMechanismValue.value,
//                         items: ['Translational', 'Rotational', 'Planar', 'Wedge', 'Topple'],
//                         onChanged: (value) => controller.failureMechanismValue.value = value,
//                         icon: Icons.broken_image,
//                       )),
//                     ],
//                   ),
                  
//                   const SizedBox(height: 16),
                  
//                   // History
//                   _buildSectionCard(
//                     title: 'History',
//                     primaryColor: primaryColor,
//                     cardColor: cardColor,
//                     textColor: textColor,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Dates of past movement, if any reactivation date and time',
//                             style: TextStyle(
//                               color: hintColor,
//                               fontSize: 14,
//                               height: 1.4,
//                             ),
//                           ),
//                           const SizedBox(height: 16),
                          
//                           // Display selected dates
//                           Obx(() {
//                             if (controller.historyDates.isNotEmpty) {
//                               return Column(
//                                 children: [
//                                   ...List.generate(controller.historyDates.length, (index) {
//                                     return Padding(
//                                       padding: const EdgeInsets.only(bottom: 12.0),
//                                       child: Row(
//                                         children: [
//                                           Expanded(
//                                             child: Container(
//                                               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                                               decoration: BoxDecoration(
//                                                 color: Colors.grey[100],
//                                                 borderRadius: BorderRadius.circular(8),
//                                                 border: Border.all(color: Colors.grey[300]!),
//                                               ),
//                                               child: Text(
//                                                 controller.historyDates[index],
//                                                 style: const TextStyle(
//                                                   fontSize: 16,
//                                                   fontWeight: FontWeight.w500,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           const SizedBox(width: 12),
//                                           GestureDetector(
//                                             onTap: () => controller.removeHistoryDate(index),
//                                             child: Container(
//                                               padding: const EdgeInsets.all(8),
//                                               decoration: BoxDecoration(
//                                                 color: Colors.grey[400],
//                                                 shape: BoxShape.circle,
//                                               ),
//                                               child: const Icon(
//                                                 Icons.close,
//                                                 color: Colors.white,
//                                                 size: 16,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     );
//                                   }),
//                                   const SizedBox(height: 12),
//                                 ],
//                               );
//                             }
//                             return const SizedBox.shrink();
//                           }),
                          
//                           // Add date button
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: primaryColor,
//                                   foregroundColor: Colors.white,
//                                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                   elevation: 2,
//                                 ),
//                                 onPressed: () => controller.selectHistoryDate(),
//                                 child: const Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Icon(Icons.add, size: 20),
//                                     SizedBox(width: 8),
//                                     Text(
//                                       'Add Date',
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
                          
//                           // Show placeholder text when no dates are added
//                           Obx(() {
//                             if (controller.historyDates.isEmpty) {
//                               return Container(
//                                 padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
//                                 decoration: BoxDecoration(
//                                   color: backgroundColor,
//                                   borderRadius: BorderRadius.circular(8),
//                                   border: Border.all(color: primaryColor.withOpacity(0.3)),
//                                 ),
//                                 child: Row(
//                                   children: [
//                                     Icon(Icons.history, color: primaryColor),
//                                     const SizedBox(width: 12),
//                                     Text(
//                                       'No historical dates added',
//                                       style: TextStyle(color: hintColor, fontSize: 15),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             }
//                             return const SizedBox.shrink();
//                           }),
//                         ],
//                       ),
//                     ],
//                   ),
                  
//                   const SizedBox(height: 16),
                  
//                   // Geomorphology      
//                   _buildSectionCard(
//                     title: 'Geomorphology',
//                     primaryColor: primaryColor,
//                     cardColor: cardColor,
//                     textColor: textColor,
//                     children: [
//                       _buildTextField(
//                         label: 'Enter geomorphology',
//                         controller: controller.geomorphologyController,
//                         maxLines: 2,
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 16),

//                   // Geology
//                   _buildSectionCard(
//                     title: 'Geology *',
//                     primaryColor: primaryColor,
//                     cardColor: cardColor,
//                     textColor: textColor,
//                     children: [
//                       _buildTextField(
//                         label: 'Enter geology details',
//                         controller: controller.geologyController,
//                         maxLines: 2,
//                         validator: (value) => controller.validateRequired(value, 'Geology'),
//                       ),
//                     ],
//                   ),
                  
//                   const SizedBox(height: 16),
                  
//                   // Structure
//                   _buildSectionCard(
//                     title: 'Structure',
//                     primaryColor: primaryColor,
//                     cardColor: cardColor,
//                     textColor: textColor,
//                     children: [
//                       Obx(() => _buildStructureCheckboxWithFields(
//                         title: 'Bedding',
//                         value: controller.bedding.value,
//                         onChanged: (value) {
//                           controller.bedding.value = value ?? false;
//                           if (!controller.bedding.value) {
//                             for (var ctrl in controller.beddingControllers) {
//                               ctrl.dispose();
//                             }
//                             controller.beddingControllers.clear();
//                           } else if (controller.beddingControllers.isEmpty) {
//                             controller.addBeddingField();
//                           }
//                         },
//                         controllers: controller.beddingControllers,
//                         onAddField: () => controller.addBeddingField(),
//                         onRemoveField: (index) => controller.removeBeddingField(index),
//                         primaryColor: primaryColor,
//                         textColor: textColor,
//                       )),
//                       const SizedBox(height: 16),
                      
//                       Obx(() => _buildStructureCheckboxWithFields(
//                         title: 'Joints',
//                         value: controller.joints.value,
//                         onChanged: (value) {
//                           controller.joints.value = value ?? false;
//                           if (!controller.joints.value) {
//                             for (var ctrl in controller.jointsControllers) {
//                               ctrl.dispose();
//                             }
//                             controller.jointsControllers.clear();
//                           } else if (controller.jointsControllers.isEmpty) {
//                             controller.addJointsField();
//                           }
//                         },
//                         controllers: controller.jointsControllers,
//                         onAddField: () => controller.addJointsField(),
//                         onRemoveField: (index) => controller.removeJointsField(index),
//                         primaryColor: primaryColor,
//                         textColor: textColor,
//                       )),
//                       const SizedBox(height: 16),
                      
//                       Obx(() => _buildStructureCheckboxWithFields(
//                         title: 'RMR',
//                         value: controller.rmr.value,
//                         onChanged: (value) {
//                           controller.rmr.value = value ?? false;
//                           if (!controller.rmr.value) {
//                             for (var ctrl in controller.rmrControllers) {
//                               ctrl.dispose();
//                             }
//                             controller.rmrControllers.clear();
//                           } else if (controller.rmrControllers.isEmpty) {
//                             controller.addRmrField();
//                           }
//                         },
//                         controllers: controller.rmrControllers,
//                         onAddField: () => controller.addRmrField(),
//                         onRemoveField: (index) => controller.removeRmrField(index),
//                         primaryColor: primaryColor,
//                         textColor: textColor,
//                       )),
//                     ],
//                   ),
                  
//                   const SizedBox(height: 16),
                  
//                   // Hydrological Condition
//                   _buildSectionCard(
//                     title: 'Hydrological Condition',
//                     primaryColor: primaryColor,
//                     cardColor: cardColor,
//                     textColor: textColor,
//                     children: [
//                       Obx(() => _buildDropdown(
//                         hint: 'Select hydrological condition',
//                         value: controller.hydrologicalConditionValue.value,
//                         items: ['Dry', 'Damp', 'Wet', 'Dipping', 'Flowing'],
//                         onChanged: (value) => controller.hydrologicalConditionValue.value = value,
//                         icon: Icons.water_drop,
//                         hasInfoIcon: true,
//                         onInfoTap: () => showHydrologicalConditionDialog(context),
//                       )),
//                     ],
//                   ),
                  
//                   const SizedBox(height: 16),
                  
//                   // What induced/triggered the landslide
//                   _buildSectionCard(
//                     title: 'What induced the landslide? *',
//                     primaryColor: primaryColor,
//                     cardColor: cardColor,
//                     textColor: textColor,
//                     children: [
//                       Obx(() => _buildDropdown(
//                         hint: 'Select trigger',
//                         value: controller.whatInducedLandslideValue.value,
//                         items: ['Rainfall', 'Earthquake', 'Man made', 'Snow melt', 'Vibration', 'Toe erosion', 'I don\'t know'],
//                         onChanged: (value) => controller.whatInducedLandslideValue.value = value,
//                         icon: Icons.warning_amber,
//                       )),
//                     ],
//                   ),
                  
//                   const SizedBox(height: 16),

//                   // Geo-Scientific causes
//                   _buildSectionCard(
//                     title: 'Geo-Scientific Causes *',
//                     primaryColor: primaryColor,
//                     cardColor: cardColor,
//                     textColor: textColor,
//                     children: [
//                       Obx(() => _buildHierarchicalCheckbox(
//                         title: 'Geological Causes',
//                         value: controller.geologicalCauses.value,
//                         onChanged: (value) {
//                           controller.geologicalCauses.value = value ?? false;
//                           if (!controller.geologicalCauses.value) {
//                             controller.weakOrSensitiveMaterials.value = false;
//                             controller.contrastInPermeability.value = false;
//                             controller.geologicalOtherController.clear();
//                           }
//                         },
//                         subItems: controller.geologicalCauses.value ? [
//                           Obx(() => _buildSubCheckbox(
//                             title: 'Weak or sensitive materials',
//                             value: controller.weakOrSensitiveMaterials.value,
//                             onChanged: (value) => controller.weakOrSensitiveMaterials.value = value ?? false,
//                             primaryColor: primaryColor,
//                             textColor: textColor,
//                           )),
//                           Obx(() => _buildSubCheckbox(
//                             title: 'Contrast in permeability and/or stiffness of materials',
//                             value: controller.contrastInPermeability.value,
//                             onChanged: (value) => controller.contrastInPermeability.value = value ?? false,
//                             primaryColor: primaryColor,
//                             textColor: textColor,
//                           )),
//                           const SizedBox(height: 8),
//                           _buildOtherTextField(
//                             label: 'Other',
//                             controller: controller.geologicalOtherController,
//                             primaryColor: primaryColor,
//                           ),
//                         ] : [],
//                         primaryColor: primaryColor,
//                         textColor: textColor,
//                       )),
//                       const SizedBox(height: 16),
                      
//                       Obx(() => _buildHierarchicalCheckbox(
//                         title: 'Morphological Causes',
//                         value: controller.morphologicalCauses.value,
//                         onChanged: (value) {
//                           controller.morphologicalCauses.value = value ?? false;
//                           if (!controller.morphologicalCauses.value) {
//                             controller.tectonicOrVolcanicUplift.value = false;
//                             controller.glacialRebound.value = false;
//                             controller.fluvialWaveGlacialErosion.value = false;
//                             controller.subterraneanErosion.value = false;
//                             controller.depositionLoading.value = false;
//                             controller.vegetationRemoval.value = false;
//                             controller.thawing.value = false;
//                             controller.morphologicalOtherController.clear();
//                           }
//                         },
//                         subItems: controller.morphologicalCauses.value ? [
//                           Obx(() => _buildSubCheckbox(
//                             title: 'Tectonic or volcanic uplift',
//                             value: controller.tectonicOrVolcanicUplift.value,
//                             onChanged: (value) => controller.tectonicOrVolcanicUplift.value = value ?? false,
//                             primaryColor: primaryColor,
//                             textColor: textColor,
//                           )),
//                           Obx(() => _buildSubCheckbox(
//                             title: 'Glacial rebound',
//                             value: controller.glacialRebound.value,
//                             onChanged: (value) => controller.glacialRebound.value = value ?? false,
//                             primaryColor: primaryColor,
//                             textColor: textColor,
//                           )),
//                           Obx(() => _buildSubCheckbox(
//                             title: 'Fluvial, wave, or glacial erosion of slope toe or lateral margins',
//                             value: controller.fluvialWaveGlacialErosion.value,
//                             onChanged: (value) => controller.fluvialWaveGlacialErosion.value = value ?? false,
//                             primaryColor: primaryColor,
//                             textColor: textColor,
//                           )),
//                           Obx(() => _buildSubCheckbox(
//                             title: 'Subterranean erosion (solution, piping)',
//                             value: controller.subterraneanErosion.value,
//                             onChanged: (value) => controller.subterraneanErosion.value = value ?? false,
//                             primaryColor: primaryColor,
//                             textColor: textColor,
//                           )),
//                           Obx(() => _buildSubCheckbox(
//                             title: 'Deposition loading slope or its crest',
//                             value: controller.depositionLoading.value,
//                             onChanged: (value) => controller.depositionLoading.value = value ?? false,
//                             primaryColor: primaryColor,
//                             textColor: textColor,
//                           )),
//                           Obx(() => _buildSubCheckbox(
//                             title: 'Vegetation removal (by fire, drought)',
//                             value: controller.vegetationRemoval.value,
//                             onChanged: (value) => controller.vegetationRemoval.value = value ?? false,
//                             primaryColor: primaryColor,
//                             textColor: textColor,
//                           )),
//                           Obx(() => _buildSubCheckbox(
//                             title: 'Thawing',
//                             value: controller.thawing.value,
//                             onChanged: (value) => controller.thawing.value = value ?? false,
//                             primaryColor: primaryColor,
//                             textColor: textColor,
//                           )),
//                           const SizedBox(height: 8),
//                           _buildOtherTextField(
//                             label: 'Other',
//                             controller: controller.morphologicalOtherController,
//                             primaryColor: primaryColor,
//                           ),
//                         ] : [],
//                         primaryColor: primaryColor,
//                         textColor: textColor,
//                       )),
//                       const SizedBox(height: 16),
                      
//                       Obx(() => _buildHierarchicalCheckbox(
//                         title: 'Human Causes',
//                         value: controller.humanCauses.value,
//                         onChanged: (value) {
//                           controller.humanCauses.value = value ?? false;
//                           if (!controller.humanCauses.value) {
//                             controller.excavationOfSlope.value = false;
//                             controller.loadingOfSlope.value = false;
//                             controller.drawdown.value = false;
//                             controller.deforestation.value = false;
//                             controller.irrigation.value = false;
//                             controller.mining.value = false;
//                             controller.artificialVibration.value = false;
//                             controller.waterLeakage.value = false;
//                             controller.humanOtherController.clear();
//                           }
//                         },
//                         subItems: controller.humanCauses.value ? [
//                           Obx(() => _buildSubCheckbox(
//                             title: 'Excavation of slope or its toe',
//                             value: controller.excavationOfSlope.value,
//                             onChanged: (value) => controller.excavationOfSlope.value = value ?? false,
//                             primaryColor: primaryColor,
//                             textColor: textColor,
//                           )),
//                           Obx(() => _buildSubCheckbox(
//                             title: 'Loading of slope or its crest',
//                             value: controller.loadingOfSlope.value,
//                             onChanged: (value) => controller.loadingOfSlope.value = value ?? false,
//                             primaryColor: primaryColor,
//                             textColor: textColor,
//                           )),
//                           Obx(() => _buildSubCheckbox(
//                             title: 'Drawdown (of reservoirs)',
//                             value: controller.drawdown.value,
//                             onChanged: (value) => controller.drawdown.value = value ?? false,
//                             primaryColor: primaryColor,
//                             textColor: textColor,
//                           )),
//                           Obx(() => _buildSubCheckbox(
//                             title: 'Deforestation',
//                             value: controller.deforestation.value,
//                             onChanged: (value) => controller.deforestation.value = value ?? false,
//                             primaryColor: primaryColor,
//                             textColor: textColor,
//                           )),
//                           Obx(() => _buildSubCheckbox(
//                             title: 'Irrigation',
//                             value: controller.irrigation.value,
//                             onChanged: (value) => controller.irrigation.value = value ?? false,
//                             primaryColor: primaryColor,
//                             textColor: textColor,
//                           )),
//                           Obx(() => _buildSubCheckbox(
//                             title: 'Mining',
//                             value: controller.mining.value,
//                             onChanged: (value) => controller.mining.value = value ?? false,
//                             primaryColor: primaryColor,
//                             textColor: textColor,
//                           )),
//                           Obx(() => _buildSubCheckbox(
//                             title: 'Artificial vibration',
//                             value: controller.artificialVibration.value,
//                             onChanged: (value) => controller.artificialVibration.value = value ?? false,
//                             primaryColor: primaryColor,
//                             textColor: textColor,
//                           )),
//                           Obx(() => _buildSubCheckbox(
//                             title: 'Water leakage from utilities',
//                             value: controller.waterLeakage.value,
//                             onChanged: (value) => controller.waterLeakage.value = value ?? false,
//                             primaryColor: primaryColor,
//                             textColor: textColor,
//                           )),
//                           const SizedBox(height: 8),
//                           _buildOtherTextField(
//                             label: 'Other',
//                             controller: controller.humanOtherController,
//                             primaryColor: primaryColor,
//                           ),
//                         ] : [],
//                         primaryColor: primaryColor,
//                         textColor: textColor,
//                       )),
//                       const SizedBox(height: 16),
                      
//                       Obx(() => _buildHierarchicalCheckbox(
//                         title: 'Other Causes',
//                         value: controller.otherCauses.value,
//                         onChanged: (value) {
//                           controller.otherCauses.value = value ?? false;
//                           if (!controller.otherCauses.value) {
//                             controller.otherCausesController.clear();
//                           }
//                         },
//                         subItems: controller.otherCauses.value ? [
//                           _buildOtherTextField(
//                             label: 'Specify other causes',
//                             controller: controller.otherCausesController,
//                             primaryColor: primaryColor,
//                           ),
//                         ] : [],
//                         primaryColor: primaryColor,
//                         textColor: textColor,
//                       )),
//                     ],
//                   ),

//                   const SizedBox(height: 16),

//                   // Enhanced Impact/Damage Section
//                   _buildSectionCard(
//                     title: 'What is the Impact/Damage Caused\n by Landslide ?',
//                     primaryColor: primaryColor,
//                     cardColor: cardColor,
//                     textColor: textColor,
//                     children: [
//                       // People affected
//                       Obx(() => _buildHierarchicalCheckbox(
//                         title: 'People affected',
//                         value: controller.peopleAffected.value,
//                         onChanged: (value) {
//                           controller.peopleAffected.value = value ?? false;
//                           if (!controller.peopleAffected.value) {
//                             controller.peopleDeadController.clear();
//                             controller.peopleInjuredController.clear();
//                           }
//                         },
//                         subItems: controller.peopleAffected.value ? [
//                           const SizedBox(height: 8),
//                           _buildDamageDetailRow(
//                             label1: 'Dead',
//                             label2: 'Injured',
//                             controller1: controller.peopleDeadController,
//                             controller2: controller.peopleInjuredController,
//                             primaryColor: primaryColor,
//                           ),
//                         ] : [],
//                         primaryColor: primaryColor,
//                         textColor: textColor,
//                       )),
//                       const SizedBox(height: 12),
                      
//                       // Livestock affected
//                       Obx(() => _buildHierarchicalCheckbox(
//                         title: 'Livestock affected',
//                         value: controller.livestockAffected.value,
//                         onChanged: (value) {
//                           controller.livestockAffected.value = value ?? false;
//                           if (!controller.livestockAffected.value) {
//                             controller.livestockDeadController.clear();
//                             controller.livestockInjuredController.clear();
//                           }
//                         },
//                         subItems: controller.livestockAffected.value ? [
//                           const SizedBox(height: 8),
//                           _buildDamageDetailRow(
//                             label1: 'Dead',
//                             label2: 'Injured',
//                             controller1: controller.livestockDeadController,
//                             controller2: controller.livestockInjuredController,
//                             primaryColor: primaryColor,
//                           ),
//                         ] : [],
//                         primaryColor: primaryColor,
//                         textColor: textColor,
//                       )),
//                       const SizedBox(height: 12),
                      
//                       // Houses and buildings affected
//                       Obx(() => _buildHierarchicalCheckbox(
//                         title: 'Houses and buildings affected',
//                         value: controller.housesBuildingAffected.value,
//                         onChanged: (value) {
//                           controller.housesBuildingAffected.value = value ?? false;
//                           if (!controller.housesBuildingAffected.value) {
//                             controller.housesFullyController.clear();
//                             controller.housesPartiallyController.clear();
//                           }
//                         },
//                         subItems: controller.housesBuildingAffected.value ? [
//                           const SizedBox(height: 8),
//                           _buildDamageDetailRow(
//                             label1: 'Number of houses / buildings affected FULLY',
//                             label2: 'Number of houses / buildings affected PARTIALLY',
//                             controller1: controller.housesFullyController,
//                             controller2: controller.housesPartiallyController,
//                             primaryColor: primaryColor,
//                           ),
//                         ] : [],
//                         primaryColor: primaryColor,
//                         textColor: textColor,
//                       )),
//                       const SizedBox(height: 12),
                      
//                       // Dams / Barrages affected
//                       Obx(() => _buildHierarchicalCheckbox(
//                         title: 'Dams / Barrages affected',
//                         value: controller.damsBarragesAffected.value,
//                         onChanged: (value) {
//                           controller.damsBarragesAffected.value = value ?? false;
//                           if (!controller.damsBarragesAffected.value) {
//                             controller.damsNameController.clear();
//                             controller.damsExtentValue.value = null;
//                           }
//                         },
//                         subItems: controller.damsBarragesAffected.value ? [
//                           const SizedBox(height: 8),
//                           _buildDamageDetailRowMixed(
//                             label1: 'Name of Dams / Barrages',
//                             label2: 'Extent of damage',
//                             controller1: controller.damsNameController,
//                             dropdownValue: controller.damsExtentValue.value,
//                             dropdownItems: ['Full', 'Partial'],
//                             onDropdownChanged: (String? value) {
//                               controller.damsExtentValue.value = value;
//                             },
//                             primaryColor: primaryColor,
//                           ),
//                         ] : [],
//                         primaryColor: primaryColor,
//                         textColor: textColor,
//                       )),
//                       const SizedBox(height: 12),
                      
//                       // Roads affected
//                       Obx(() => _buildHierarchicalCheckbox(
//                         title: 'Roads affected',
//                         value: controller.roadsAffected.value,
//                         onChanged: (value) {
//                           controller.roadsAffected.value = value ?? false;
//                           if (!controller.roadsAffected.value) {
//                             controller.roadTypeValue.value = null;
//                             controller.roadExtentValue.value = null;
//                           }
//                         },
//                         subItems: controller.roadsAffected.value ? [
//                           const SizedBox(height: 8),
//                           _buildRoadDamageFields(controller, primaryColor),
//                         ] : [],
//                         primaryColor: primaryColor,
//                         textColor: textColor,
//                       )),
//                       const SizedBox(height: 12),
                      
//                       // Roads blocked
//                       Obx(() => _buildHierarchicalCheckbox(
//                         title: 'Roads blocked',
//                         value: controller.roadsBlocked.value,
//                         onChanged: (value) {
//                           controller.roadsBlocked.value = value ?? false;
//                           if (!controller.roadsBlocked.value) {
//                             controller.roadBlockageValue.value = null;
//                           }
//                         },
//                         subItems: controller.roadsBlocked.value ? [
//                           const SizedBox(height: 8),
//                           _buildDropdownDamageField(
//                             label: 'Road Blockage',
//                             value: controller.roadBlockageValue.value,
//                             items: [
//                               'Yes, for few hours',
//                               'Yes, half a day',
//                               'Yes, one day',
//                               'Yes, more than a day',
//                               'No blockage'
//                             ],
//                             onChanged: (String? value) {
//                               controller.roadBlockageValue.value = value;
//                             },
//                             primaryColor: primaryColor,
//                           ),
//                         ] : [],
//                         primaryColor: primaryColor,
//                         textColor: textColor,
//                       )),
//                       const SizedBox(height: 12),
                      
//                       // Road benches damaged
//                       Obx(() => _buildHierarchicalCheckbox(
//                         title: 'Road benches damaged',
//                         value: controller.roadBenchesDamaged.value,
//                         onChanged: (value) {
//                           controller.roadBenchesDamaged.value = value ?? false;
//                           if (!controller.roadBenchesDamaged.value) {
//                             controller.roadBenchesExtentValue.value = null;
//                           }
//                         },
//                         subItems: controller.roadBenchesDamaged.value ? [
//                           const SizedBox(height: 8),
//                           _buildDropdownDamageField(
//                             label: 'Extent of damage',
//                             value: controller.roadBenchesExtentValue.value,
//                             items: ['Full', 'Partial'],
//                             onChanged: (String? value) {
//                               controller.roadBenchesExtentValue.value = value;
//                             },
//                             primaryColor: primaryColor,
//                           ),
//                         ] : [],
//                         primaryColor: primaryColor,
//                         textColor: textColor,
//                       )),
//                       const SizedBox(height: 12),
                      
//                       // Railway line affected
//                       Obx(() => _buildHierarchicalCheckbox(
//                         title: 'Railway line affected',
//                         value: controller.railwayLineAffected.value,
//                         onChanged: (value) {
//                           controller.railwayLineAffected.value = value ?? false;
//                           if (!controller.railwayLineAffected.value) {
//                             controller.railwayDetailsController.clear();
//                           }
//                         },
//                         subItems: controller.railwayLineAffected.value ? [
//                           const SizedBox(height: 8),
//                           _buildSingleDamageField(
//                             label: 'Mention details',
//                             controller: controller.railwayDetailsController,
//                             primaryColor: primaryColor,
//                           ),
//                         ] : [],
//                         primaryColor: primaryColor,
//                         textColor: textColor,
//                       )),
//                       const SizedBox(height: 12),
                      
//                       // Railway blocked
//                       Obx(() => _buildHierarchicalCheckbox(
//                         title: 'Railway blocked',
//                         value: controller.railwayBlocked.value,
//                         onChanged: (value) {
//                           controller.railwayBlocked.value = value ?? false;
//                           if (!controller.railwayBlocked.value) {
//                             controller.railwayBlockageValue.value = null;
//                           }
//                         },
//                         subItems: controller.railwayBlocked.value ? [
//                           const SizedBox(height: 8),
//                           _buildDropdownDamageField(
//                             label: 'Railway Blockage',
//                             value: controller.railwayBlockageValue.value,
//                             items: [
//                               'Yes, for few hours',
//                               'Yes, half a day',
//                               'Yes, one day',
//                               'Yes, more than a day',
//                               'No blockage'
//                             ],
//                             onChanged: (String? value) {
//                               controller.railwayBlockageValue.value = value;
//                             },
//                             primaryColor: primaryColor,
//                           ),
//                         ] : [],
//                         primaryColor: primaryColor,
//                         textColor: textColor,
//                       )),
//                       const SizedBox(height: 12),
                      
//                       // Railway benches damaged
//                       Obx(() => _buildHierarchicalCheckbox(
//                         title: 'Railway benches damaged',
//                         value: controller.railwayBenchesDamaged.value,
//                         onChanged: (value) {
//                           controller.railwayBenchesDamaged.value = value ?? false;
//                           if (!controller.railwayBenchesDamaged.value) {
//                             controller.railwayBenchesExtentValue.value = null;
//                           }
//                         },
//                         subItems: controller.railwayBenchesDamaged.value ? [
//                           const SizedBox(height: 8),
//                           _buildDropdownDamageField(
//                             label: 'Extent of damage',
//                             value: controller.railwayBenchesExtentValue.value,
//                             items: ['Full', 'Partial'],
//                             onChanged: (String? value) {
//                               controller.railwayBenchesExtentValue.value = value;
//                             },
//                             primaryColor: primaryColor,
//                           ),
//                         ] : [],
//                         primaryColor: primaryColor,
//                         textColor: textColor,
//                       )),
                      
//                       const SizedBox(height: 12),
                      
//                       // Power infrastructure affected
//                       Obx(() => _buildHierarchicalCheckbox(
//                         title: 'Power infrastructure and\ntelecommunication affected',
//                         value: controller.powerInfrastructureAffected.value,
//                         onChanged: (value) {
//                           controller.powerInfrastructureAffected.value = value ?? false;
//                           if (!controller.powerInfrastructureAffected.value) {
//                             controller.powerExtentValue.value = null;
//                           }
//                         },
//                         subItems: controller.powerInfrastructureAffected.value ? [
//                           const SizedBox(height: 8),
//                           _buildDropdownDamageField(
//                             label: 'Extent of damage',
//                             value: controller.powerExtentValue.value,
//                             items: ['Full', 'Partial'],
//                             onChanged: (String? value) {
//                               controller.powerExtentValue.value = value;
//                             },
//                             primaryColor: primaryColor,
//                           ),
//                         ] : [],
//                         primaryColor: primaryColor,
//                         textColor: textColor,
//                       )),
//                       const SizedBox(height: 12),
                      
//                       // Damages to Agriculture/Barren/Forest
//                       Obx(() => _buildSimpleCheckboxListTile(
//                         title: 'Damages to Agriculture/Barren/Forest',
//                         value: controller.damagesToAgriculturalForestLand.value,
//                         onChanged: (value) {
//                           controller.damagesToAgriculturalForestLand.value = value ?? false;
//                         },
//                         primaryColor: primaryColor,
//                         textColor: textColor,
//                       )),
                      
//                       // Other damages
//                       Obx(() => _buildHierarchicalCheckbox(
//                         title: 'Other',
//                         value: controller.other.value,
//                         onChanged: (value) {
//                           controller.other.value = value ?? false;
//                           if (!controller.other.value) {
//                             controller.otherDamageDetailsController.clear();
//                           }
//                         },
//                         subItems: controller.other.value ? [
//                           const SizedBox(height: 8),
//                           _buildSingleDamageField(
//                             label: 'Mention details *',
//                             controller: controller.otherDamageDetailsController,
//                             primaryColor: primaryColor,
//                           ),
//                         ] : [],
//                         primaryColor: primaryColor,
//                         textColor: textColor,
//                       )),
//                       const SizedBox(height: 12),
                      
//                       // No damages
//                       Obx(() => _buildSimpleCheckboxListTile(
//                         title: 'No damages',
//                         value: controller.noDamages.value,
//                         onChanged: (value) {
//                           controller.noDamages.value = value ?? false;
//                         },
//                         primaryColor: primaryColor,
//                         textColor: textColor,
//                       )),
                      
//                       // I don't know
//                       Obx(() => _buildSimpleCheckboxListTile(
//                         title: 'I don\'t know',
//                         value: controller.iDontKnow.value,
//                         onChanged: (value) {
//                           controller.iDontKnow.value = value ?? false;
//                         },
//                         primaryColor: primaryColor,
//                         textColor: textColor,
//                       )),
//                     ],
//                   ),

//                   const SizedBox(height: 16),

//                   // Remedial Measures - Complete Section
//                   _buildSectionCard(
//                     title: 'Remedial Measures *',
//                     primaryColor: primaryColor,
//                     cardColor: cardColor,
//                     textColor: textColor,
//                     children: [
//                       // Modification of Slope Geometry
//                       Obx(() => _buildHierarchicalCheckbox(
//                         title: 'Modification of Slope Geometry',
//                         value: controller.modificationOfSlopeGeometry.value,
//                         onChanged: (value) {
//                           controller.modificationOfSlopeGeometry.value = value ?? false;
//                           if (!controller.modificationOfSlopeGeometry.value) {
//                             controller.removingMaterial.value = false;
//                             controller.addingMaterial.value = false;
//                             controller.reducingGeneralSlopeAngle.value = false;
//                             controller.slopeGeometryOtherController.clear();
//                           }
//                         },
//                         subItems: controller.modificationOfSlopeGeometry.value ? [
//                           Obx(() => _buildSubCheckbox(
//                             title: 'Removing material from the area driving the landslide (with possible substitution by lightweight fill)',
//                             value: controller.removingMaterial.value,
//                             onChanged: (value) {
//                               controller.removingMaterial.value = value ?? false;
//                             },
//                             primaryColor: primaryColor,
//                             textColor: textColor,
//                           )),
//                           Obx(() => _buildSubCheckbox(
//                             title: 'Adding material to the area maintaining stability (counterweight berm or fill)',
//                             value: controller.addingMaterial.value,
//                             onChanged: (value) {
//                               controller.addingMaterial.value = value ?? false;
//                             },
//                             primaryColor: primaryColor,
//                             textColor: textColor,
//                           )),
//                           Obx(() => _buildSubCheckbox(
//                             title: 'Reducing general slope angle',
//                             value: controller.reducingGeneralSlopeAngle.value,
//                             onChanged: (value) {
//                               controller.reducingGeneralSlopeAngle.value = value ?? false;
//                             },
//                             primaryColor: primaryColor,
//                             textColor: textColor,
//                           )),
//                           const SizedBox(height: 8),
//                           _buildOtherTextField(
//                             label: 'Other',
//                             controller: controller.slopeGeometryOtherController,
//                             primaryColor: primaryColor,
//                           ),
//                         ] : [],
//                         primaryColor: primaryColor,
//                         textColor: textColor,
//                       )),
//                       const SizedBox(height: 16),

//                       // Drainage
//                       Obx(() => _buildHierarchicalCheckbox(
//                         title: 'Drainage',
//                         value: controller.drainage.value,
//                         onChanged: (value) {
//                           controller.drainage.value = value ?? false;
//                           if (!controller.drainage.value) {
//                             controller.surfaceDrains.value = false;
//                             controller.shallowDeepTrenchDrains.value = false;
//                             controller.buttressCounterfortDrains.value = false;
//                             controller.verticalSmallDiameterBoreholes.value = false;
//                             controller.verticalLargeDiameterWells.value = false;
//                             controller.subHorizontalBoreholes.value = false;
//                             controller.drainageTunnels.value = false;
//                             controller.vacuumDewatering.value = false;
//                             controller.drainageBySiphoning.value = false;
//                             controller.electroosmoticDewatering.value = false;
//                             controller.vegetationPlanting.value = false;
//                             controller.drainageOtherController.clear();
//                           }
//                         },
//                         subItems: controller.drainage.value ? [
//                           Obx(() => _buildSubCheckbox(
//                             title: 'Surface drains to divert water from flowing onto the slide area (collecting ditches and pipes)',
//                             value: controller.surfaceDrains.value,
//                             onChanged: (value) {
//                               controller.surfaceDrains.value = value ?? false;
//                             },
//                             primaryColor: primaryColor,
//                             textColor: textColor,
//                           )),
//                           Obx(() => _buildSubCheckbox(
//                             title: 'Shallow or deep trench drains filled with free-draining geomaterials (including rock fill and geosynthetics)',
//                             value: controller.shallowDeepTrenchDrains.value,
//                             onChanged: (value) {
//                               controller.shallowDeepTrenchDrains.value = value ?? false;
//                             },
//                             primaryColor: primaryColor,
//                             textColor: textColor,
//                           )),
//                           Obx(() => _buildSubCheckbox(
//                             title: 'Buttress counterfort for sand coarse-grained materials (hydrological effect)',
//                             value: controller.buttressCounterfortDrains.value,
//                             onChanged: (value) {
//                               controller.buttressCounterfortDrains.value = value ?? false;
//                             },
//                             primaryColor: primaryColor,
//                             textColor: textColor,
//                           )),
//                           Obx(() => _buildSubCheckbox(
//                             title: 'Vertical (small diameter) boreholes with pumping or self draining',
//                             value: controller.verticalSmallDiameterBoreholes.value,
//                             onChanged: (value) {
//                               controller.verticalSmallDiameterBoreholes.value = value ?? false;
//                             },
//                             primaryColor: primaryColor,
//                             textColor: textColor,
//                           )),
//                           Obx(() => _buildSubCheckbox(
//                             title: 'Vertical (large diameter) wells with gravity draining',
//                             value: controller.verticalLargeDiameterWells.value,
//                             onChanged: (value) {
//                               controller.verticalLargeDiameterWells.value = value ?? false;
//                             },
//                             primaryColor: primaryColor,
//                             textColor: textColor,
//                           )),
//                           Obx(() => _buildSubCheckbox(
//                             title: 'Sub horizontal or sub vertical boreholes',
//                             value: controller.subHorizontalBoreholes.value,
//                             onChanged: (value) {
//                               controller.subHorizontalBoreholes.value = value ?? false;
//                             },
//                             primaryColor: primaryColor,
//                             textColor: textColor,
//                           )),
//                           Obx(() => _buildSubCheckbox(
//                             title: 'Drainage tunnels, galleries or adits',
//                             value: controller.drainageTunnels.value,
//                             onChanged: (value) {
//                               controller.drainageTunnels.value = value ?? false;
//                             },
//                             primaryColor: primaryColor,
//                             textColor: textColor,
//                           )),
//                           Obx(() => _buildSubCheckbox(
//                             title: 'Vacuum dewatering',
//                             value: controller.vacuumDewatering.value,
//                             onChanged: (value) {
//                               controller.vacuumDewatering.value = value ?? false;
//                             },
//                             primaryColor: primaryColor,
//                             textColor: textColor,
//                           )),
//                           Obx(() => _buildSubCheckbox(
//                             title: 'Drainage by siphoning',
//                             value: controller.drainageBySiphoning.value,
//                             onChanged: (value) {
//                               controller.drainageBySiphoning.value = value ?? false;
//                             },
//                             primaryColor: primaryColor,
//                             textColor: textColor,
//                           )),
//                           Obx(() => _buildSubCheckbox(
//                             title: 'Electro-osmotic dewatering',
//                             value: controller.electroosmoticDewatering.value,
//                             onChanged: (value) {
//                               controller.electroosmoticDewatering.value = value ?? false;
//                             },
//                             primaryColor: primaryColor,
//                             textColor: textColor,
//                           )),
//                           Obx(() => _buildSubCheckbox(
//                             title: 'Vegetation planting (hydrological effect)',
//                             value: controller.vegetationPlanting.value,
//                             onChanged: (value) {
//                               controller.vegetationPlanting.value = value ?? false;
//                             },
//                             primaryColor: primaryColor,
//                             textColor: textColor,
//                           )),
//                           const SizedBox(height: 8),
//                           _buildOtherTextField(
//                             label: 'Other',
//                             controller: controller.drainageOtherController,
//                             primaryColor: primaryColor,
//                           ),
//                         ] : [],
//                         primaryColor: primaryColor,
//                         textColor: textColor,
//                       )),
//                       const SizedBox(height: 16),

//                       // Retaining Structures
//                       Obx(() => _buildHierarchicalCheckbox(
//                         title: 'Retaining Structures',
//                         value: controller.retainingStructures.value,
//                         onChanged: (value) {
//                           controller.retainingStructures.value = value ?? false;
//                           if (!controller.retainingStructures.value) {
//                             controller.gravityRetainingWalls.value = false;
//                             controller.cribBlockWalls.value = false;
//                             controller.gabionWalls.value = false;
//                             controller.passivePilesPiers.value = false;
//                             controller.castInSituWalls.value = false;
//                             controller.reinforcedEarthRetaining.value = false;
//                             controller.buttressCounterforts.value = false;
//                             controller.retainingOtherController.clear();
//                           }
//                         },
//                         subItems: controller.retainingStructures.value ? [
//                           Obx(() => _buildSubCheckbox(
//                             title: 'Gravity retaining walls',
//                             value: controller.gravityRetainingWalls.value,
//                             onChanged: (value) {
//                               controller.gravityRetainingWalls.value = value ?? false;
//                             },
//                             primaryColor: primaryColor,
//                             textColor: textColor,
//                           )),
//                           Obx(() => _buildSubCheckbox(
//                             title: 'Crib-block walls',
//                             value: controller.cribBlockWalls.value,
//                             onChanged: (value) {
//                               controller.cribBlockWalls.value = value ?? false;
//                             },
//                             primaryColor: primaryColor,
//                             textColor: textColor,
//                           )),
//                           Obx(() => _buildSubCheckbox(
//                             title: 'Gabion walls',
//                             value: controller.gabionWalls.value,
//                             onChanged: (value) {
//                               controller.gabionWalls.value = value ?? false;
//                             },
//                             primaryColor: primaryColor,
//                             textColor: textColor,
//                           )),
//                           Obx(() => _buildSubCheckbox(
//                             title: 'Passive piles, piers and caissons',
//                             value: controller.passivePilesPiers.value,
//                             onChanged: (value) {
//                               controller.passivePilesPiers.value = value ?? false;
//                             },
//                             primaryColor: primaryColor,
//                             textColor: textColor,
//                           )),
//                           Obx(() => _buildSubCheckbox(
//                             title: 'Cast-in situ reinforced concrete walls',
//                             value: controller.castInSituWalls.value,
//                             onChanged: (value) {
//                               controller.castInSituWalls.value = value ?? false;
//                             },
//                             primaryColor: primaryColor,
//                             textColor: textColor,
//                           )),
//                           Obx(() => _buildSubCheckbox(
//                             title: 'Reinforced earth retaining structures with strip/ sheet - polymer/metallic reinforcement elements',
//                             value: controller.reinforcedEarthRetaining.value,
//                             onChanged: (value) {
//                               controller.reinforcedEarthRetaining.value = value ?? false;
//                             },
//                             primaryColor: primaryColor,
//                             textColor: textColor,
//                           )),
//                           Obx(() => _buildSubCheckbox(
//                             title: 'Buttress counterforts of coarse-grained material (mechanical effect)',
//                             value: controller.buttressCounterforts.value,
//                             onChanged: (value) {
//                               controller.buttressCounterforts.value = value ?? false;
//                             },
//                             primaryColor: primaryColor,
//                             textColor: textColor,
//                           )),
//                           const SizedBox(height: 8),
//                           _buildOtherTextField(
//                             label: 'Other',
//                             controller: controller.retainingOtherController,
//                             primaryColor: primaryColor,
//                           ),
//                         ] : [],
//                         primaryColor: primaryColor,
//                         textColor: textColor,
//                       )),
//                       const SizedBox(height: 16),

//                       // Internal Slope Reinforcement
//                       Obx(() => _buildHierarchicalCheckbox(
//                         title: 'Internal Slope Reinforcement',
//                         value: controller.internalSlopeReinforcement.value,
//                         onChanged: (value) {
//                           controller.internalSlopeReinforcement.value = value ?? false;
//                           if (!controller.internalSlopeReinforcement.value) {
//                             controller.anchors.value = false;
//                             controller.grouting.value = false;
//                             controller.internalReinforcementOtherController.clear();
//                           }
//                         },
//                         subItems: controller.internalSlopeReinforcement.value ? [
//                           Obx(() => _buildSubCheckbox(
//                             title: 'Anchors (prestressed or not)',
//                             value: controller.anchors.value,
//                             onChanged: (value) {
//                               controller.anchors.value = value ?? false;
//                             },
//                             primaryColor: primaryColor,
//                             textColor: textColor,
//                           )),
//                           Obx(() => _buildSubCheckbox(
//                             title: 'Grouting',
//                             value: controller.grouting.value,
//                             onChanged: (value) {
//                               controller.grouting.value = value ?? false;
//                             },
//                             primaryColor: primaryColor,
//                             textColor: textColor,
//                           )),
//                           const SizedBox(height: 8),
//                           _buildOtherTextField(
//                             label: 'Other',
//                             controller: controller.internalReinforcementOtherController,
//                             primaryColor: primaryColor,
//                           ),
//                         ] : [],
//                         primaryColor: primaryColor,
//                         textColor: textColor,
//                       )),
//                       const SizedBox(height: 16),

//                       // Remedial measures not required
//                       Obx(() => _buildHierarchicalCheckbox(
//                         title: 'Remedial measures not required',
//                         value: controller.remedialMeasuresNotRequired.value,
//                         onChanged: (value) {
//                           controller.remedialMeasuresNotRequired.value = value ?? false;
//                           if (!controller.remedialMeasuresNotRequired.value) {
//                             controller.remedialNotRequiredWhyController.clear();
//                           }
//                         },
//                         subItems: controller.remedialMeasuresNotRequired.value ? [
//                           const SizedBox(height: 8),
//                           _buildOtherTextField(
//                             label: 'Why?',
//                             controller: controller.remedialNotRequiredWhyController,
//                             primaryColor: primaryColor,
//                           ),
//                         ] : [],
//                         primaryColor: primaryColor,
//                         textColor: textColor,
//                       )),
//                       const SizedBox(height: 16),

//                       // Remedial measures not adequately safeguard the slide
//                       Obx(() => _buildHierarchicalCheckbox(
//                         title: 'Remedial measures not adequately\nsafeguard the slide',
//                         value: controller.remedialMeasuresNotAdequate.value,
//                         onChanged: (value) {
//                           controller.remedialMeasuresNotAdequate.value = value ?? false;
//                           if (!controller.remedialMeasuresNotAdequate.value) {
//                             controller.shiftingOfVillage.value = false;
//                             controller.evacuationOfInfrastructure.value = false;
//                             controller.realignmentOfCommunicationCorridors.value = false;
//                             controller.communicationCorridorType.value = null;
//                             controller.notAdequateOtherController.clear();
//                           }
//                         },
//                         subItems: controller.remedialMeasuresNotAdequate.value ? [
//                           Obx(() => _buildSubCheckbox(
//                             title: 'Shifting of the village',
//                             value: controller.shiftingOfVillage.value,
//                             onChanged: (value) {
//                               controller.shiftingOfVillage.value = value ?? false;
//                             },
//                             primaryColor: primaryColor,
//                             textColor: textColor,
//                           )),
//                           Obx(() => _buildSubCheckbox(
//                             title: 'Evacuation of the infrastructure',
//                             value: controller.evacuationOfInfrastructure.value,
//                             onChanged: (value) {
//                               controller.evacuationOfInfrastructure.value = value ?? false;
//                             },
//                             primaryColor: primaryColor,
//                             textColor: textColor,
//                           )),
                          
//                           // Realignment of communication corridors with dropdown
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Obx(() => _buildSubCheckbox(
//                                 title: 'Realignment of the communication corridors',
//                                 value: controller.realignmentOfCommunicationCorridors.value,
//                                 onChanged: (value) {
//                                   controller.realignmentOfCommunicationCorridors.value = value ?? false;
//                                   if (!controller.realignmentOfCommunicationCorridors.value) {
//                                     controller.communicationCorridorType.value = null;
//                                   }
//                                 },
//                                 primaryColor: primaryColor,
//                                 textColor: textColor,
//                               )),
//                               Obx(() {
//                                 if (controller.realignmentOfCommunicationCorridors.value) {
//                                   return Padding(
//                                     padding: const EdgeInsets.only(left: 20.0, top: 8.0),
//                                     child: _buildDropdownDamageField(
//                                       label: 'Type of communication corridor',
//                                       value: controller.communicationCorridorType.value,
//                                       items: ['Realignment of road', 'Bridge', 'Tunnel'],
//                                       onChanged: (String? value) {
//                                         controller.communicationCorridorType.value = value;
//                                       },
//                                       primaryColor: primaryColor,
//                                     ),
//                                   );
//                                 }
//                                 return const SizedBox.shrink();
//                               }),
//                             ],
//                           ),
                    
//                           const SizedBox(height: 8),
//                           _buildOtherTextField(
//                             label: 'Other',
//                             controller: controller.notAdequateOtherController,
//                             primaryColor: primaryColor,
//                           ),
//                         ] : [],
//                         primaryColor: primaryColor,
//                         textColor: textColor,
//                       )),
//                       const SizedBox(height: 16),

//                       // Other Information
//                       Obx(() => _buildHierarchicalCheckbox(
//                         title: 'Other Information',
//                         value: controller.otherInformation.value,
//                         onChanged: (value) {
//                           controller.otherInformation.value = value ?? false;
//                           if (!controller.otherInformation.value) {
//                             controller.otherInformationController.clear();
//                           }
//                         },
//                         subItems: controller.otherInformation.value ? [
//                           const SizedBox(height: 8),
//                           _buildOtherTextField(
//                             label: 'Other',
//                             controller: controller.otherInformationController,
//                             primaryColor: primaryColor,
//                           ),
//                         ] : [],
//                         primaryColor: primaryColor,
//                         textColor: textColor,
//                       )),
//                     ],
//                   ),      
                  
//                   const SizedBox(height: 16),
                  
//                   // Alert Category
//                   _buildSectionCard(
//                     title: 'Alert Category',
//                     primaryColor: primaryColor,
//                     cardColor: cardColor,
//                     textColor: textColor,
//                     children: [
//                       Obx(() => _buildDropdown(
//                         hint: 'Select Alert level',
//                         value: controller.alertCategory.value,
//                         items: ['Category 1', 'Category 2', 'Category 3'],
//                         onChanged: (value) => controller.alertCategory.value = value,
//                         icon: Icons.trending_up,
//                         hasInfoIcon: true,
//                         onInfoTap: () => showAlertCategoryDialog(context),
//                       )),
//                     ],
//                   ),

//                   const SizedBox(height: 16),

//                   // Any other relevant information
//                   _buildSectionCard(
//                     title: 'Any other relevant information \non the landslide',
//                     primaryColor: primaryColor,
//                     cardColor: cardColor,
//                     textColor: textColor,
//                     children: [
//                       _buildTextField(
//                         label: 'Enter any other relevant information',
//                         controller: controller.otherRelevantInformation,
//                         maxLines: 2,
//                       ),
//                     ],
//                   ),
                  
//                   const SizedBox(height: 16),
                  
//                   // Selected Images Display
//                   Obx(() {
//                     if (controller.selectedImages.isNotEmpty) {
//                       return _buildSectionCard(
//                         title: 'Selected Images (${controller.selectedImages.length})',
//                         primaryColor: primaryColor,
//                         cardColor: cardColor,
//                         textColor: textColor,
//                         children: [
//                           SizedBox(
//                             height: 120,
//                             child: ListView.builder(
//                               scrollDirection: Axis.horizontal,
//                               itemCount: controller.selectedImages.length,
//                               itemBuilder: (context, index) {
//                                 return Container(
//                                   margin: const EdgeInsets.only(right: 8),
//                                   child: Stack(
//                                     children: [
//                                       ClipRRect(
//                                         borderRadius: BorderRadius.circular(8),
//                                         child: Image.file(
//                                           controller.selectedImages[index],
//                                           width: 120,
//                                           height: 120,
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                       Positioned(
//                                         top: 4,
//                                         right: 4,
//                                         child: GestureDetector(
//                                           onTap: () => controller.removeImage(index),
//                                           child: Container(
//                                             decoration: const BoxDecoration(
//                                               color: Colors.red,
//                                               shape: BoxShape.circle,
//                                             ),
//                                             child: const Icon(
//                                               Icons.close,
//                                               color: Colors.white,
//                                               size: 20,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         ],
//                       );
//                     }
//                     return const SizedBox.shrink();
//                   }),
                  
//                   const SizedBox(height: 24),
                  
//                   // Submit Button
//                   Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 8.0),
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: primaryColor,
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         elevation: 2,
//                       ),
//                       onPressed: () => controller.submitForm(),
//                       child: const Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.send),
//                           SizedBox(width: 8),
//                           Text(
//                             'SUBMIT REPORT',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               letterSpacing: 1.2,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
                  
//                   const SizedBox(height: 24),
//                 ],
//               ),
//             )),
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               spreadRadius: 1,
//               blurRadius: 5,
//               offset: const Offset(0, -1),
//             ),
//           ],
//         ),
//         child: BottomNavigationBar(
//           elevation: 0,
//           backgroundColor: Colors.white,
//           selectedItemColor: primaryColor,
//           unselectedItemColor: hintColor,
//           currentIndex: 0,
//           onTap: (index) {
//             if (index == 0) {
//               controller.openCamera();
//             } else {
//               controller.openGallery();
//             }
//           },
//           items: const [
//             BottomNavigationBarItem(
//               icon: Icon(Icons.camera_alt),
//               label: 'CAMERA',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.image),
//               label: 'GALLERY',
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Helper widgets
//   Widget _buildSectionCard({
//     required String title, 
//     required List<Widget> children,
//     required Color primaryColor,
//     required Color cardColor,
//     required Color textColor,
//   }) {
//     return Card(
//       elevation: 2,
//       margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       color: cardColor,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(bottom: 16.0),
//               child: Row(
//                 children: [
//                   Container(
//                     width: 4,
//                     height: 20,
//                     decoration: BoxDecoration(
//                       color: primaryColor,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     title,
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: textColor,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             ...children,
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _labelText(String text, Color textColor) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8.0),
//       child: Text(
//         text,
//         style: TextStyle(
//           fontSize: 15,
//           fontWeight: FontWeight.w500,
//           color: textColor,
//         ),
//       ),
//     );
//   }

//   Widget _buildTextField({
//     required String label,
//     required TextEditingController controller,
//     TextInputType keyboardType = TextInputType.text,
//     bool readOnly = false,
//     int maxLines = 1,
//     bool hasInfoIcon = false,
//     VoidCallback? onInfoTap,
//     String? Function(String?)? validator,
//   }) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Expanded(
//           child: TextFormField(
//             controller: controller,
//             keyboardType: keyboardType,
//             readOnly: readOnly,
//             maxLines: maxLines,
//             decoration: InputDecoration(
//               labelText: label,
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 12,
//               ),
//             ),
//             validator: validator,
//           ),
//         ),
        
//         if (hasInfoIcon)
//           Padding(
//             padding: const EdgeInsets.only(left: 8.0, top: 12.0),
//             child: InkWell(
//               onTap: onInfoTap,
//               child: const Icon(
//                 Icons.info_outline,
//                 color: Colors.blue,
//                 size: 24,
//               ),
//             ),
//           ),
//       ],
//     );
//   }

//   Widget _buildDropdown({
//     required String? value,
//     required List<String> items,
//     required Function(String?) onChanged,
//     bool hasInfoIcon = false,
//     IconData? icon,
//     String? hint,
//     VoidCallback? onInfoTap,
//   }) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Expanded(
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12),
//             decoration: BoxDecoration(
//               color: Colors.grey[200],
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Row(
//               children: [
//                 if (icon != null)
//                   Padding(
//                     padding: const EdgeInsets.only(right: 8.0),
//                     child: Icon(icon, color: const Color(0xFF1976D2)),
//                   ),
//                 Expanded(
//                   child: DropdownButtonHideUnderline(
//                     child: DropdownButton<String>(
//                       value: value,
//                       isExpanded: true,
//                       hint: Text(hint ?? ""),
//                       items: items.map((String item) {
//                         return DropdownMenuItem<String>(
//                           value: item,
//                           child: Text(item),
//                         );
//                       }).toList(),
//                       onChanged: onChanged,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         if (hasInfoIcon)
//           Padding(
//             padding: const EdgeInsets.only(left: 8.0),
//             child: InkWell(
//               onTap: onInfoTap,
//               child: const Icon(
//                 Icons.info_outline,
//                 color: Colors.blue,
//                 size: 24,
//               ),
//             ),
//           ),
//       ],
//     );
//   }

//  Widget _buildStructureCheckboxWithFields({
//     required String title,
//     required bool value,
//     required Function(bool?) onChanged,
//     required List<TextEditingController> controllers,
//     required VoidCallback onAddField,
//     required Function(int) onRemoveField,
//     required Color primaryColor,
//     required Color textColor,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Checkbox with custom styling
//         Row(
//           children: [
//             GestureDetector(
//               onTap: () => onChanged(!value),
//               child: Container(
//                 width: 24,
//                 height: 24,
//                 decoration: BoxDecoration(
//                   color: value ? primaryColor : Colors.transparent,
//                   border: Border.all(
//                     color: value ? primaryColor : Colors.grey,
//                     width: 2,
//                   ),
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: value
//                     ? const Icon(
//                         Icons.check,
//                         color: Colors.white,
//                         size: 16,
//                       )
//                     : null,
//               ),
//             ),
//             const SizedBox(width: 12),
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: value ? primaryColor : textColor,
//                 fontWeight: value ? FontWeight.w600 : FontWeight.normal,
//               ),
//             ),
//           ],
//         ),
        
//         // Dynamic text fields (shown only when checked)
//         if (value) ...[
//           const SizedBox(height: 12),
//           // Show existing fields
//           ...List.generate(controllers.length, (index) {
//             return Padding(
//               padding: const EdgeInsets.only(bottom: 8.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: Colors.grey[100],
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(color: Colors.grey[300]!),
//                       ),
//                       child: TextField(
//                         controller: controllers[index],
//                         decoration: InputDecoration(
//                           hintText: 'Enter ${title.toLowerCase()} details',
//                           contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 12,
//                             vertical: 10,
//                           ),
//                           border: InputBorder.none,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   GestureDetector(
//                     onTap: () => onRemoveField(index),
//                     child: Container(
//                       padding: const EdgeInsets.all(6),
//                       decoration: BoxDecoration(
//                         color: Colors.grey[400],
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(
//                         Icons.close,
//                         color: Colors.white,
//                         size: 16,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }),
          
//           // Add button
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               GestureDetector(
//                 onTap: onAddField,
//                 child: Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: primaryColor,
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                   child: const Icon(
//                     Icons.add,
//                     color: Colors.white,
//                     size: 20,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ],
//     );
//   }

// Widget _buildHierarchicalCheckbox({
//     required String title,
//     required bool value,
//     required Function(bool?) onChanged,
//     required List<Widget> subItems,
//     bool isRequired = false,
//     required Color primaryColor,
//     required Color textColor,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             GestureDetector(
//               onTap: () => onChanged(!value),
//               child: Container(
//                 width: 24,
//                 height: 24,
//                 decoration: BoxDecoration(
//                   color: value ? primaryColor : Colors.transparent,
//                   border: Border.all(
//                     color: value ? primaryColor : Colors.grey,
//                     width: 2,
//                   ),
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: value
//                     ? const Icon(
//                         Icons.check,
//                         color: Colors.white,
//                         size: 16,
//                       )
//                     : null,
//               ),
//             ),
//             const SizedBox(width: 12),
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 16,
//                 color: value ? primaryColor : textColor,
//                 fontWeight: value ? FontWeight.w600 : FontWeight.normal,
//               ),
//             ),
//             if (isRequired)
//               const Text(
//                 ' *',
//                 style: TextStyle(color: Colors.red, fontSize: 16),
//               ),
//           ],
//         ),
//         if (value && subItems.isNotEmpty) ...[
//           const SizedBox(height: 12),
//           Padding(
//             padding: const EdgeInsets.only(left: 36.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: subItems,
//             ),
//           ),
//         ],
//       ],
//     );
//   }

//   Widget _buildSubCheckbox({
//     required String title,
//     required bool value,
//     required Function(bool?) onChanged,
//     required Color primaryColor,
//     required Color textColor,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8.0),
//       child: Row(
//         children: [
//           GestureDetector(
//             onTap: () => onChanged(!value),
//             child: Container(
//               width: 20,
//               height: 20,
//               decoration: BoxDecoration(
//                 color: value ? primaryColor : Colors.transparent,
//                 border: Border.all(
//                   color: value ? primaryColor : Colors.grey,
//                   width: 2,
//                 ),
//                 borderRadius: BorderRadius.circular(3),
//               ),
//               child: value
//                   ? const Icon(
//                       Icons.check,
//                       color: Colors.white,
//                       size: 12,
//                     )
//                   : null,
//             ),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               title,
//               style: TextStyle(
//                 fontSize: 14,
//                 color: value ? primaryColor : textColor,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildOtherTextField({
//     required String label,
//     required TextEditingController controller,
//     required Color primaryColor,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 14,
//             color: primaryColor,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Container(
//           decoration: BoxDecoration(
//             color: Colors.grey[100],
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(color: Colors.grey[300]!),
//           ),
//           child: TextField(
//             controller: controller,
//             decoration: const InputDecoration(
//               contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//               border: InputBorder.none,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildSimpleCheckboxListTile({
//     required String title,
//     required bool value,
//     required Function(bool?) onChanged,
//     required Color primaryColor,
//     required Color textColor,
//   }) {
//     return Row(
//       children: [
//         GestureDetector(
//           onTap: () => onChanged(!value),
//           child: Container(
//             width: 24,
//             height: 24,
//             decoration: BoxDecoration(
//               color: value ? primaryColor : Colors.transparent,
//               border: Border.all(
//                 color: value ? primaryColor : Colors.grey,
//                 width: 2,
//               ),
//               borderRadius: BorderRadius.circular(4),
//             ),
//             child: value
//                 ? const Icon(
//                     Icons.check,
//                     color: Colors.white,
//                     size: 16,
//                   )
//                 : null,
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Text(
//             title,
//             style: TextStyle(
//               fontSize: 16,
//               color: value ? primaryColor : textColor,
//               fontWeight: value ? FontWeight.w600 : FontWeight.normal,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildDamageDetailRow({
//     required String label1,
//     required String label2,
//     required TextEditingController controller1,
//     required TextEditingController controller2,
//     required Color primaryColor,
//   }) {
//     return Row(
//       children: [
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label1,
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: primaryColor,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Container(
//                 height: 40,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[200],
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 child: TextField(
//                   controller: controller1,
//                   textAlign: TextAlign.center,
//                   decoration: const InputDecoration(
//                     contentPadding: EdgeInsets.symmetric(horizontal: 8),
//                     border: InputBorder.none,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label2,
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: primaryColor,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Container(
//                 height: 40,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[200],
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 child: TextField(
//                   controller: controller2,
//                   textAlign: TextAlign.center,
//                   decoration: const InputDecoration(
//                     contentPadding: EdgeInsets.symmetric(horizontal: 8),
//                     border: InputBorder.none,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildSingleDamageField({
//     required String label,
//     required TextEditingController controller,
//     required Color primaryColor,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 12,
//             color: primaryColor,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Container(
//           height: 40,
//           decoration: BoxDecoration(
//             color: Colors.grey[200],
//             borderRadius: BorderRadius.circular(6),
//           ),
//           child: TextField(
//             controller: controller,
//             decoration: const InputDecoration(
//               contentPadding: EdgeInsets.symmetric(horizontal: 12),
//               border: InputBorder.none,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildDamageDetailRowMixed({
//     required String label1,
//     required String label2,
//     required TextEditingController controller1,
//     String? dropdownValue,
//     List<String>? dropdownItems,
//     Function(String?)? onDropdownChanged,
//     required Color primaryColor,
//   }) {
//     return Row(
//       children: [
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label1,
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: primaryColor,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Container(
//                 height: 40,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[200],
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 child: TextField(
//                   controller: controller1,
//                   textAlign: TextAlign.center,
//                   decoration: const InputDecoration(
//                     contentPadding: EdgeInsets.symmetric(horizontal: 8),
//                     border: InputBorder.none,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label2,
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: primaryColor,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Container(
//                 height: 40,
//                 padding: const EdgeInsets.symmetric(horizontal: 8),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[200],
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 child: DropdownButtonHideUnderline(
//                   child: DropdownButton<String>(
//                     value: dropdownValue,
//                     isExpanded: true,
//                     hint: const Text(
//                       '---Select---',
//                       style: TextStyle(fontSize: 12),
//                     ),
//                     items: dropdownItems?.map((String item) {
//                       return DropdownMenuItem<String>(
//                         value: item,
//                         child: Text(
//                           item,
//                           style: const TextStyle(fontSize: 12),
//                         ),
//                       );
//                     }).toList(),
//                     onChanged: onDropdownChanged,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildDropdownDamageField({
//     required String label,
//     String? value,
//     required List<String> items,
//     required Function(String?) onChanged,
//     required Color primaryColor,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 12,
//             color: primaryColor,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Container(
//           height: 40,
//           padding: const EdgeInsets.symmetric(horizontal: 12),
//           decoration: BoxDecoration(
//             color: Colors.grey[200],
//             borderRadius: BorderRadius.circular(6),
//           ),
//           child: DropdownButtonHideUnderline(
//             child: DropdownButton<String>(
//               value: value,
//               isExpanded: true,
//               hint: const Text(
//                 '---Select---',
//                 style: TextStyle(fontSize: 12),
//               ),
//               items: items.map((String item) {
//                 return DropdownMenuItem<String>(
//                   value: item,
//                   child: Text(
//                     item,
//                     style: const TextStyle(fontSize: 12),
//                   ),
//                 );
//               }).toList(),
//               onChanged: onChanged,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildRoadDamageFields(LandslideReportController controller, Color primaryColor) {
//     return Row(
//       children: [
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Road type',
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: primaryColor,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Container(
//                 height: 40,
//                 padding: const EdgeInsets.symmetric(horizontal: 8),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[200],
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 child: Obx(() => DropdownButtonHideUnderline(
//                   child: DropdownButton<String>(
//                     value: controller.roadTypeValue.value,
//                     isExpanded: true,
//                     hint: const Text(
//                       '---Select---',
//                       style: TextStyle(fontSize: 12),
//                     ),
//                     items: ['State Highway', 'National Highway', 'Local'].map((String item) {
//                       return DropdownMenuItem<String>(
//                         value: item,
//                         child: Text(
//                           item,
//                           style: const TextStyle(fontSize: 12),
//                         ),
//                       );
//                     }).toList(),
//                     onChanged: (String? value) {
//                       controller.roadTypeValue.value = value;
//                     },
//                   ),
//                 )),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Extent of damage',
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: primaryColor,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Container(
//                 height: 40,
//                 padding: const EdgeInsets.symmetric(horizontal: 8),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[200],
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 child: Obx(() => DropdownButtonHideUnderline(
//                   child: DropdownButton<String>(
//                     value: controller.roadExtentValue.value,
//                     isExpanded: true,
//                     hint: const Text(
//                       '---Select---',
//                       style: TextStyle(fontSize: 12),
//                     ),
//                     items: ['Full', 'Partial'].map((String item) {
//                       return DropdownMenuItem<String>(
//                         value: item,
//                         child: Text(
//                           item,
//                           style: const TextStyle(fontSize: 12),
//                         ),
//                       );
//                     }).toList(),
//                     onChanged: (String? value) {
//                       controller.roadExtentValue.value = value;
//                     },
//                   ),
//                 )),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   void _showDimensionsDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Container(
//             width: MediaQuery.of(context).size.width * 0.9,
//             height: MediaQuery.of(context).size.height * 0.7,
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       'Landslide Dimensions',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: () => Navigator.of(context).pop(),
//                       icon: Container(
//                         decoration: const BoxDecoration(
//                           color: Colors.black,
//                           shape: BoxShape.circle,
//                         ),
//                         child: const Icon(
//                           Icons.close,
//                           color: Colors.white,
//                           size: 20,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
//                 Expanded(
//                   child: Center(
//                     child: Container(
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: Colors.grey[300]!),
//                       ),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(12),
//                         child: Image.asset(
//                           'assets/dimension_landslide.png',
//                           fit: BoxFit.contain,
//                           errorBuilder: (context, error, stackTrace) {
//                             return Container(
//                               height: 300,
//                               color: Colors.grey[200],
//                               child: const Center(
//                                 child: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Icon(
//                                       Icons.image_not_supported,
//                                       size: 50,
//                                       color: Colors.grey,
//                                     ),
//                                     SizedBox(height: 8),
//                                     Text(
//                                       'Image not found',
//                                       style: TextStyle(
//                                         color: Colors.grey,
//                                         fontSize: 14,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 const Text(
//                   'This diagram shows how to measure the key dimensions of a landslide:',
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 const Text(
//                   '• Length: The distance along the slope from crown to toe\n'
//                   '• Width: The maximum width perpendicular to the length\n'
//                   '• Height: The vertical distance from crown to toe',
//                   style: TextStyle(
//                     fontSize: 14,
//                     height: 1.4,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }



