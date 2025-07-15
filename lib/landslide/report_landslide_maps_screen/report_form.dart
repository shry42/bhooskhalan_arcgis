// // import 'package:bhooskhalann/landslide/report_landslide_g_maps_screen/widgets/show_activity_dialog.dart';
// import 'package:bhooskhalann/landslide/report_landslide_maps_screen/widgets/show_activity_dialog.dart';
// import 'package:bhooskhalann/landslide/report_landslide_maps_screen/widgets/show_alert_category_dialog.dart';
// import 'package:bhooskhalann/landslide/report_landslide_maps_screen/widgets/show_distribution_dialog.dart';
// import 'package:bhooskhalann/landslide/report_landslide_maps_screen/widgets/show_hydrological_condition_dialog.dart';
// import 'package:bhooskhalann/landslide/report_landslide_maps_screen/widgets/show_material_type_dialog.dart';
// import 'package:bhooskhalann/landslide/report_landslide_maps_screen/widgets/show_movement_type_dialog.dart';
// import 'package:bhooskhalann/landslide/report_landslide_maps_screen/widgets/show_rate_of_movement_dialog.dart';
// import 'package:bhooskhalann/landslide/report_landslide_maps_screen/widgets/show_style_dialog.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// class LandslideReportingScreen extends StatefulWidget {
//   const LandslideReportingScreen({Key? key, required this.latitude, required this.longitude}) : super(key: key);
//   final double latitude;
//   final double longitude;

//   @override
//   State<LandslideReportingScreen> createState() => _LandslideReportingScreenState();
// }

// class _LandslideReportingScreenState extends State<LandslideReportingScreen> {
//   final _formKey = GlobalKey<FormState>();
//   bool _isLoading = false;
//   final ImagePicker _picker = ImagePicker();
//   List<File> _selectedImages = [];
  
//   // Form controllers - Initialize with actual coordinates
//   //
// List<String> _historyDates = [];
// List<TextEditingController> _beddingControllers = [];
// List<TextEditingController> _jointsControllers = [];
// List<TextEditingController> _rmrControllers = [];
//   //

//   late final TextEditingController _latitudeController;
//   late final TextEditingController _longitudeController;
//   final TextEditingController _stateController = TextEditingController();
//   final TextEditingController _districtController = TextEditingController();
//   final TextEditingController _subdivisionController = TextEditingController();
//   final TextEditingController _villageController = TextEditingController();
//   final TextEditingController _locationDetailsController = TextEditingController();
//   final TextEditingController _lengthController = TextEditingController();
//   final TextEditingController _widthController = TextEditingController();
//   final TextEditingController _heightController = TextEditingController();
//   final TextEditingController _areaController = TextEditingController();
//   final TextEditingController _depthController = TextEditingController();
//   final TextEditingController _volumeController = TextEditingController();
//   final TextEditingController _runoutDistanceController = TextEditingController();
//   final TextEditingController _geologyController = TextEditingController();
//   final TextEditingController _dateController = TextEditingController();
//   final TextEditingController _timeController = TextEditingController();
//   final TextEditingController _occurrenceDateRangeController = TextEditingController();
//   final TextEditingController _geomorphologyController = TextEditingController();
//   final TextEditingController _otherRelevantInformation = TextEditingController();

//   // Dropdown values
//   String? _landslideOccurrenceValue;
//   String? _howDoYouKnowValue;
//   String? _whereDidLandslideOccurValue;
//   String? _typeOfMaterialValue;
//   String? _typeOfMovementValue;
//   String? _rateOfMovementValue;
//   String? _activityValue;
//   String? _distributionValue;
//   String? _styleValue;
//   String? _failureMechanismValue;
//   String? _hydrologicalConditionValue;
//   String? _whatInducedLandslideValue;
//   String? _alertCategory;

//   // Checkbox values
//   bool _geologicalCauses = false;
//   bool _morphologicalCauses = false;
//   bool _otherCauses = false;
//   bool _humanCauses = false;
//   bool _peopleAffected = false;
//   bool _livestockAffected = false;
//   bool _housesBuildingAffected = false;
//   bool _damsBarragesAffected = false;
//   bool _roadsAffected = false;
//   bool _roadsBlocked = false;
//   bool _roadBenchesDamaged = false;
//   bool _railwayLineAffected = false;
//   bool _railwayBlocked = false;
//   bool _railwayBenchesDamaged = false;
//   bool _powerInfrastructureAffected = false;
//   bool _damagesToAgriculturalForestLand = false;
//   bool _other = false;
//   bool _noDamages = false;
//   bool _iDontKnow = false;
//   bool _modificationOfSlopeGeometry = false;
//   bool _drainage = false;
//   bool _retainingStructures = false;
//   bool _internalSlopeReinforcement = false;
//   bool _remedialMeasuresNotRequired = false;
//   bool _remedialMeasuresNotAdequate = false;
//   bool _otherInformation = false;
//   bool _bedding = false;
//   bool _joints = false;
//   bool _rmr = false;

//   // Colors for professional appearance
//   final Color _primaryColor = const Color(0xFF1976D2);
//   final Color _secondaryColor = const Color(0xFF64B5F6);
//   final Color _backgroundColor = const Color(0xFFF5F7FA);
//   final Color _cardColor = Colors.white;
//   final Color _textColor = const Color(0xFF2C3E50);
//   final Color _hintColor = const Color(0xFF7F8C8D);

//   @override
//   void initState() {
//     super.initState();
//     // Initialize with actual coordinates from previous screen
//     _latitudeController = TextEditingController(text: widget.latitude.toStringAsFixed(7));
//     _longitudeController = TextEditingController(text: widget.longitude.toStringAsFixed(7));
//   }

//   @override
//   void dispose() {
//     // Dispose controllers
//     _historyDates.clear();
//     _latitudeController.dispose();
//     _longitudeController.dispose();
//     _stateController.dispose();
//     _districtController.dispose();
//     _subdivisionController.dispose();
//     _villageController.dispose();
//     _locationDetailsController.dispose();
//     _lengthController.dispose();
//     _widthController.dispose();
//     _heightController.dispose();
//     _areaController.dispose();
//     _depthController.dispose();
//     _volumeController.dispose();
//     _runoutDistanceController.dispose();
//     _geologyController.dispose();
//     _dateController.dispose();
//     _timeController.dispose();
//     _occurrenceDateRangeController.dispose();
//     for (var controller in _beddingControllers) {
//     controller.dispose();
//   }
//   for (var controller in _jointsControllers) {
//     controller.dispose();
//   }
//   for (var controller in _rmrControllers) {
//     controller.dispose();
//   }
//   _beddingControllers.clear();
//   _jointsControllers.clear();
//   _rmrControllers.clear();

//   //
//   _geologicalOtherController.dispose();
//   _morphologicalOtherController.dispose();
//   _humanOtherController.dispose();
//   _otherCausesController.dispose();
//   _peopleDeadController.dispose();
//   _peopleInjuredController.dispose();
//   _livestockDeadController.dispose();
//   _livestockInjuredController.dispose();
//   _housesFullyController.dispose();
//   _housesPartiallyController.dispose();
//   _damsNameController.dispose();
//   _damsExtentController.dispose();
//   _roadTypeController.dispose();
//   _roadExtentController.dispose();
//   _roadBlockageController.dispose();
//   _roadBenchesExtentController.dispose();
//   _railwayDetailsController.dispose();
//   _railwayBlockageController.dispose();
//   _railwayBenchesExtentController.dispose();
//   _powerExtentController.dispose();
//   _otherDamageDetailsController.dispose();

//     // Impact/Damage detailed controllers
//   _peopleDeadController.dispose();
//   _peopleInjuredController.dispose();
//   _livestockDeadController.dispose();
//   _livestockInjuredController.dispose();
//   _housesFullyController.dispose();
//   _housesPartiallyController.dispose();
//   _damsNameController.dispose();
//   _railwayDetailsController.dispose();
//   _otherDamageDetailsController.dispose();
  

//     // Remedial Measures controllers
//   _slopeGeometryOtherController.dispose();
//   _drainageOtherController.dispose();
//   _retainingOtherController.dispose();
//   _internalReinforcementOtherController.dispose();
//   _remedialNotRequiredWhyController.dispose();
//   _notAdequateOtherController.dispose();
//   _otherInformationController.dispose();
//   //
//     super.dispose();
//   }

//   // Camera functionality
//   Future<void> _openCamera() async {
//     try {
//       final XFile? photo = await _picker.pickImage(
//         source: ImageSource.camera,
//         maxWidth: 1800,
//         maxHeight: 1800,
//         imageQuality: 85,
//       );
      
//       if (photo != null) {
//         setState(() {
//           _selectedImages.add(File(photo.path));
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Photo captured! Total images: ${_selectedImages.length}'),
//             backgroundColor: _primaryColor,
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//           ),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error accessing camera: $e'),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//     }
//   }

//   // Gallery functionality
//   Future<void> _openGallery() async {
//     try {
//       final List<XFile> photos = await _picker.pickMultiImage(
//         maxWidth: 1800,
//         maxHeight: 1800,
//         imageQuality: 85,
//       );
      
//       if (photos.isNotEmpty) {
//         setState(() {
//           _selectedImages.addAll(photos.map((photo) => File(photo.path)));
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('${photos.length} images selected! Total images: ${_selectedImages.length}'),
//             backgroundColor: _primaryColor,
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//           ),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error accessing gallery: $e'),
//           backgroundColor: Colors.red,
//           behavior: SnackBarBehavior.floating,
//         ),
//       );
//     }
//   }

//   // Remove image functionality
//   void _removeImage(int index) {
//     setState(() {
//       _selectedImages.removeAt(index);
//     });
//   }


// // Add this method to handle date selection for history
// Future<void> _selectHistoryDate() async {
//   final DateTime? picked = await showDatePicker(
//     context: context,
//     initialDate: DateTime.now().subtract(const Duration(days: 1)), // Start from yesterday
//     firstDate: DateTime(1900), // Allow very old dates
//     lastDate: DateTime.now().subtract(const Duration(days: 1)), // Only past dates allowed
//     helpText: 'Select Historical Date',
//     confirmText: 'ADD',
//     cancelText: 'CANCEL',
//   );
  
//   if (picked != null) {
//     final String formattedDate = "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}";
    
//     // Check if date is already added
//     if (!_historyDates.contains(formattedDate)) {
//       setState(() {
//         _historyDates.add(formattedDate);
//         // Sort dates in descending order (newest first)
//         _historyDates.sort((a, b) {
//           DateTime dateA = _parseDate(a);
//           DateTime dateB = _parseDate(b);
//           return dateB.compareTo(dateA);
//         });
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text('This date is already added'),
//           backgroundColor: Colors.orange,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         ),
//       );
//     }
//   }
// }

// // Helper method to parse date string back to DateTime
// DateTime _parseDate(String dateString) {
//   List<String> parts = dateString.split('-');
//   return DateTime(
//     int.parse(parts[2]), // year
//     int.parse(parts[1]), // month
//     int.parse(parts[0]), // day
//   );
// }

// // Method to remove a history date
// void _removeHistoryDate(int index) {
//   setState(() {
//     _historyDates.removeAt(index);
//   });
// }


// // Methods for managing dynamic text fields
// void _addBeddingField() {
//   setState(() {
//     _beddingControllers.add(TextEditingController());
//   });
// }

// void _removeBeddingField(int index) {
//   setState(() {
//     _beddingControllers[index].dispose();
//     _beddingControllers.removeAt(index);
//   });
// }

// void _addJointsField() {
//   setState(() {
//     _jointsControllers.add(TextEditingController());
//   });
// }

// void _removeJointsField(int index) {
//   setState(() {
//     _jointsControllers[index].dispose();
//     _jointsControllers.removeAt(index);
//   });
// }

// void _addRmrField() {
//   setState(() {
//     _rmrControllers.add(TextEditingController());
//   });
// }

// void _removeRmrField(int index) {
//   setState(() {
//     _rmrControllers[index].dispose();
//     _rmrControllers.removeAt(index);
//   });
// }

// // Enhanced checkbox list tile with dynamic fields
// Widget _buildStructureCheckboxWithFields({
//   required String title,
//   required bool value,
//   required Function(bool?) onChanged,
//   required List<TextEditingController> controllers,
//   required VoidCallback onAddField,
//   required Function(int) onRemoveField,
// }) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       // Checkbox with custom styling
//       Row(
//         children: [
//           GestureDetector(
//             onTap: () {
//               onChanged(!value);
//               if (!value) {
//                 // When checking, add first field if none exist
//                 if (controllers.isEmpty) {
//                   if (title == 'Bedding') _addBeddingField();
//                   if (title == 'Joints') _addJointsField();
//                   if (title == 'RMR') _addRmrField();
//                 }
//               } else {
//                 // When unchecking, clear all fields
//                 for (var controller in controllers) {
//                   controller.dispose();
//                 }
//                 controllers.clear();
//               }
//             },
//             child: Container(
//               width: 24,
//               height: 24,
//               decoration: BoxDecoration(
//                 color: value ? _primaryColor : Colors.transparent,
//                 border: Border.all(
//                   color: value ? _primaryColor : Colors.grey,
//                   width: 2,
//                 ),
//                 borderRadius: BorderRadius.circular(4),
//               ),
//               child: value
//                   ? const Icon(
//                       Icons.check,
//                       color: Colors.white,
//                       size: 16,
//                     )
//                   : null,
//             ),
//           ),
//           const SizedBox(width: 12),
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 16,
//               color: value ? _primaryColor : _textColor,
//               fontWeight: value ? FontWeight.w600 : FontWeight.normal,
//             ),
//           ),
//         ],
//       ),
      
//       // Dynamic text fields (shown only when checked)
//       if (value) ...[
//         const SizedBox(height: 12),
//         ...List.generate(controllers.length, (index) {
//           return Padding(
//             padding: const EdgeInsets.only(bottom: 8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.grey[100],
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(color: Colors.grey[300]!),
//                     ),
//                     child: TextField(
//                       controller: controllers[index],
//                       decoration: InputDecoration(
//                         hintText: 'Enter ${title.toLowerCase()} details',
//                         contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 10,
//                         ),
//                         border: InputBorder.none,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 GestureDetector(
//                   onTap: () => onRemoveField(index),
//                   child: Container(
//                     padding: const EdgeInsets.all(6),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[400],
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(
//                       Icons.close,
//                       color: Colors.white,
//                       size: 16,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }),
        
//         // Add button
//         Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             GestureDetector(
//               onTap: onAddField,
//               child: Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: _primaryColor,
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 child: const Icon(
//                   Icons.add,
//                   color: Colors.white,
//                   size: 20,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     ],
//   );
// }


// // for Geo-scientific causes everything below

// // Geological Causes sub-items

// //
// String? _damsExtentValue;
// String? _roadExtentValue;
// String? _roadTypeValue;
// String? _roadBlockageValue;
// String? _roadBenchesExtentValue;
// String? _railwayBlockageValue;
// String? _railwayBenchesExtentValue;
// String? _powerExtentValue;
// //
// bool _weakOrSensitiveMaterials = false;
// bool _contrastInPermeability = false;
// final TextEditingController _geologicalOtherController = TextEditingController();

// // Morphological Causes sub-items
// bool _tectonicOrVolcanicUplift = false;
// bool _glacialRebound = false;
// bool _fluvialWaveGlacialErosion = false;
// bool _subterraneanErosion = false;
// bool _depositionLoading = false;
// bool _vegetationRemoval = false;
// bool _thawing = false;
// final TextEditingController _morphologicalOtherController = TextEditingController();

// // Human Causes sub-items
// bool _excavationOfSlope = false;
// bool _loadingOfSlope = false;
// bool _drawdown = false;
// bool _deforestation = false;
// bool _irrigation = false;
// bool _mining = false;
// bool _artificialVibration = false;
// bool _waterLeakage = false;
// final TextEditingController _humanOtherController = TextEditingController();

// // Other Causes
// final TextEditingController _otherCausesController = TextEditingController();

// // Impact/Damage detailed fields
// final TextEditingController _peopleDeadController = TextEditingController();
// final TextEditingController _peopleInjuredController = TextEditingController();
// final TextEditingController _livestockDeadController = TextEditingController();
// final TextEditingController _livestockInjuredController = TextEditingController();
// final TextEditingController _housesFullyController = TextEditingController();
// final TextEditingController _housesPartiallyController = TextEditingController();
// final TextEditingController _damsNameController = TextEditingController();
// final TextEditingController _damsExtentController = TextEditingController();
// final TextEditingController _roadTypeController = TextEditingController();
// final TextEditingController _roadExtentController = TextEditingController();
// final TextEditingController _roadBlockageController = TextEditingController();
// final TextEditingController _roadBenchesExtentController = TextEditingController();
// final TextEditingController _railwayDetailsController = TextEditingController();
// final TextEditingController _railwayBlockageController = TextEditingController();
// final TextEditingController _railwayBenchesExtentController = TextEditingController();
// final TextEditingController _powerExtentController = TextEditingController();
// final TextEditingController _otherDamageDetailsController = TextEditingController();

// // Enhanced checkbox widget with sub-items
// Widget _buildHierarchicalCheckbox({
//   required String title,
//   required bool value,
//   required Function(bool?) onChanged,
//   required List<Widget> subItems,
//   bool isRequired = false,
// }) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Row(
//         children: [
//           GestureDetector(
//             onTap: () => onChanged(!value),
//             child: Container(
//               width: 24,
//               height: 24,
//               decoration: BoxDecoration(
//                 color: value ? _primaryColor : Colors.transparent,
//                 border: Border.all(
//                   color: value ? _primaryColor : Colors.grey,
//                   width: 2,
//                 ),
//                 borderRadius: BorderRadius.circular(4),
//               ),
//               child: value
//                   ? const Icon(
//                       Icons.check,
//                       color: Colors.white,
//                       size: 16,
//                     )
//                   : null,
//             ),
//           ),
//           const SizedBox(width: 12),
//           Text(
//             title,
//             style: TextStyle(
//               fontSize: 16,
//               color: value ? _primaryColor : _textColor,
//               fontWeight: value ? FontWeight.w600 : FontWeight.normal,
//             ),
//           ),
//           if (isRequired)
//             const Text(
//               ' *',
//               style: TextStyle(color: Colors.red, fontSize: 16),
//             ),
//         ],
//       ),
//       if (value && subItems.isNotEmpty) ...[
//         const SizedBox(height: 12),
//         Padding(
//           padding: const EdgeInsets.only(left: 36.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: subItems,
//           ),
//         ),
//       ],
//     ],
//   );
// }

// // Simple sub-checkbox widget
// Widget _buildSubCheckbox({
//   required String title,
//   required bool value,
//   required Function(bool?) onChanged,
// }) {
//   return Padding(
//     padding: const EdgeInsets.only(bottom: 8.0),
//     child: Row(
//       children: [
//         GestureDetector(
//           onTap: () => onChanged(!value),
//           child: Container(
//             width: 20,
//             height: 20,
//             decoration: BoxDecoration(
//               color: value ? _primaryColor : Colors.transparent,
//               border: Border.all(
//                 color: value ? _primaryColor : Colors.grey,
//                 width: 2,
//               ),
//               borderRadius: BorderRadius.circular(3),
//             ),
//             child: value
//                 ? const Icon(
//                     Icons.check,
//                     color: Colors.white,
//                     size: 12,
//                   )
//                 : null,
//           ),
//         ),
//         const SizedBox(width: 8),
//         Expanded(
//           child: Text(
//             title,
//             style: TextStyle(
//               fontSize: 14,
//               color: value ? _primaryColor : _textColor,
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }

// // Text field for "Other" options
// Widget _buildOtherTextField({
//   required String label,
//   required TextEditingController controller,
// }) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(
//         label,
//         style: TextStyle(
//           fontSize: 14,
//           color: _primaryColor,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//       const SizedBox(height: 8),
//       Container(
//         decoration: BoxDecoration(
//           color: Colors.grey[100],
//           borderRadius: BorderRadius.circular(8),
//           border: Border.all(color: Colors.grey[300]!),
//         ),
//         child: TextField(
//           controller: controller,
//           decoration: const InputDecoration(
//             contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//             border: InputBorder.none,
//           ),
//         ),
//       ),
//     ],
//   );
// }

// // Damage detail input widget
// Widget _buildDamageDetailRow({
//   required String label1,
//   required String label2,
//   required TextEditingController controller1,
//   required TextEditingController controller2,
// }) {
//   return Row(
//     children: [
//       Expanded(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               label1,
//               style: TextStyle(
//                 fontSize: 12,
//                 color: _primaryColor,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Container(
//               height: 40,
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(6),
//               ),
//               child: TextField(
//                 controller: controller1,
//                 textAlign: TextAlign.center,
//                 decoration: const InputDecoration(
//                   contentPadding: EdgeInsets.symmetric(horizontal: 8),
//                   border: InputBorder.none,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       const SizedBox(width: 12),
//       Expanded(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               label2,
//               style: TextStyle(
//                 fontSize: 12,
//                 color: _primaryColor,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Container(
//               height: 40,
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(6),
//               ),
//               child: TextField(
//                 controller: controller2,
//                 textAlign: TextAlign.center,
//                 decoration: const InputDecoration(
//                   contentPadding: EdgeInsets.symmetric(horizontal: 8),
//                   border: InputBorder.none,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ],
//   );
// }

// Widget _buildSingleDamageField({
//   required String label,
//   required TextEditingController controller,
// }) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(
//         label,
//         style: TextStyle(
//           fontSize: 12,
//           color: _primaryColor,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//       const SizedBox(height: 4),
//       Container(
//         height: 40,
//         decoration: BoxDecoration(
//           color: Colors.grey[200],
//           borderRadius: BorderRadius.circular(6),
//         ),
//         child: TextField(
//           controller: controller,
//           decoration: const InputDecoration(
//             contentPadding: EdgeInsets.symmetric(horizontal: 12),
//             border: InputBorder.none,
//           ),
//         ),
//       ),
//     ],
//   );
// }

// // Enhanced damage detail input widget with dropdown support
// Widget _buildDamageDetailRowMixed({
//   required String label1,
//   required String label2,
//   required TextEditingController controller1,
//   String? dropdownValue,
//   List<String>? dropdownItems,
//   Function(String?)? onDropdownChanged,
// }) {
//   return Row(
//     children: [
//       Expanded(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               label1,
//               style: TextStyle(
//                 fontSize: 12,
//                 color: _primaryColor,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Container(
//               height: 40,
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(6),
//               ),
//               child: TextField(
//                 controller: controller1,
//                 textAlign: TextAlign.center,
//                 decoration: const InputDecoration(
//                   contentPadding: EdgeInsets.symmetric(horizontal: 8),
//                   border: InputBorder.none,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       const SizedBox(width: 12),
//       Expanded(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               label2,
//               style: TextStyle(
//                 fontSize: 12,
//                 color: _primaryColor,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Container(
//               height: 40,
//               padding: const EdgeInsets.symmetric(horizontal: 8),
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(6),
//               ),
//               child: DropdownButtonHideUnderline(
//                 child: DropdownButton<String>(
//                   value: dropdownValue,
//                   isExpanded: true,
//                   hint: const Text(
//                     '---Select---',
//                     style: TextStyle(fontSize: 12),
//                   ),
//                   items: dropdownItems?.map((String item) {
//                     return DropdownMenuItem<String>(
//                       value: item,
//                       child: Text(
//                         item,
//                         style: const TextStyle(fontSize: 12),
//                       ),
//                     );
//                   }).toList(),
//                   onChanged: onDropdownChanged,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ],
//   );
// }

// // Dropdown-only damage field
// Widget _buildDropdownDamageField({
//   required String label,
//   String? value,
//   required List<String> items,
//   required Function(String?) onChanged,
// }) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(
//         label,
//         style: TextStyle(
//           fontSize: 12,
//           color: _primaryColor,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//       const SizedBox(height: 4),
//       Container(
//         height: 40,
//         padding: const EdgeInsets.symmetric(horizontal: 12),
//         decoration: BoxDecoration(
//           color: Colors.grey[200],
//           borderRadius: BorderRadius.circular(6),
//         ),
//         child: DropdownButtonHideUnderline(
//           child: DropdownButton<String>(
//             value: value,
//             isExpanded: true,
//             hint: const Text(
//               '---Select---',
//               style: TextStyle(fontSize: 12),
//             ),
//             items: items.map((String item) {
//               return DropdownMenuItem<String>(
//                 value: item,
//                 child: Text(
//                   item,
//                   style: const TextStyle(fontSize: 12),
//                 ),
//               );
//             }).toList(),
//             onChanged: onChanged,
//           ),
//         ),
//       ),
//     ],
//   );
// }

// // Mixed field for road type and extent
// Widget _buildRoadDamageFields() {
//   return Row(
//     children: [
//       Expanded(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Road type',
//               style: TextStyle(
//                 fontSize: 12,
//                 color: _primaryColor,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Container(
//               height: 40,
//               padding: const EdgeInsets.symmetric(horizontal: 8),
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(6),
//               ),
//               child: DropdownButtonHideUnderline(
//                 child: DropdownButton<String>(
//                   value: _roadTypeValue,
//                   isExpanded: true,
//                   hint: const Text(
//                     '---Select---',
//                     style: TextStyle(fontSize: 12),
//                   ),
//                   items: ['State Highway', 'National Highway', 'Local'].map((String item) {
//                     return DropdownMenuItem<String>(
//                       value: item,
//                       child: Text(
//                         item,
//                         style: const TextStyle(fontSize: 12),
//                       ),
//                     );
//                   }).toList(),
//                   onChanged: (String? value) {
//                     setState(() {
//                       _roadTypeValue = value;
//                     });
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       const SizedBox(width: 12),
//       Expanded(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Extent of damage',
//               style: TextStyle(
//                 fontSize: 12,
//                 color: _primaryColor,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Container(
//               height: 40,
//               padding: const EdgeInsets.symmetric(horizontal: 8),
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(6),
//               ),
//               child: DropdownButtonHideUnderline(
//                 child: DropdownButton<String>(
//                   value: _roadExtentValue,
//                   isExpanded: true,
//                   hint: const Text(
//                     '---Select---',
//                     style: TextStyle(fontSize: 12),
//                   ),
//                   items: ['Full', 'Partial'].map((String item) {
//                     return DropdownMenuItem<String>(
//                       value: item,
//                       child: Text(
//                         item,
//                         style: const TextStyle(fontSize: 12),
//                       ),
//                     );
//                   }).toList(),
//                   onChanged: (String? value) {
//                     setState(() {
//                       _roadExtentValue = value;
//                     });
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ],
//   );
// }

// //
// // Modification of Slope Geometry sub-items
// bool _removingMaterial = false;
// bool _addingMaterial = false;
// bool _reducingGeneralSlopeAngle = false;
// final TextEditingController _slopeGeometryOtherController = TextEditingController();

// // Drainage sub-items
// bool _surfaceDrains = false;
// bool _shallowDeepTrenchDrains = false;
// bool _buttressCounterfortDrains = false;
// bool _verticalSmallDiameterBoreholes = false;
// bool _verticalLargeDiameterWells = false;
// bool _subHorizontalBoreholes = false;
// bool _drainageTunnels = false;
// bool _vacuumDewatering = false;
// bool _drainageBySiphoning = false;
// bool _electroosmoticDewatering = false;
// bool _vegetationPlanting = false;
// final TextEditingController _drainageOtherController = TextEditingController();

// // Retaining Structures sub-items
// bool _gravityRetainingWalls = false;
// bool _cribBlockWalls = false;
// bool _gabionWalls = false;
// bool _passivePilesPiers = false;
// bool _castInSituWalls = false;
// bool _reinforcedEarthRetaining = false;
// bool _buttressCounterforts = false;
// final TextEditingController _retainingOtherController = TextEditingController();

// // Internal Slope Reinforcement sub-items
// bool _anchors = false;
// bool _grouting = false;
// final TextEditingController _internalReinforcementOtherController = TextEditingController();

// // Remedial measures not adequately safeguard sub-items
// bool _shiftingOfVillage = false;
// bool _evacuationOfInfrastructure = false;
// bool _realignmentOfCommunicationCorridors = false;
// bool _realignmentOfRoad = false;
// final TextEditingController _notAdequateOtherController = TextEditingController();

// // Other Information
// final TextEditingController _otherInformationController = TextEditingController();

// // Variables for communication corridors selection
// String? _communicationCorridorType;
// final List<String> _communicationCorridorOptions = [
//   'Realignment of road',
//   'Bridge',
//   'Tunnel',
// ];

// // Remedial measures not required - Why field
// final TextEditingController _remedialNotRequiredWhyController = TextEditingController();

// //


// //

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _backgroundColor,
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: _primaryColor,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//         title: const Text(
//           'Report Landslide',
//           style: TextStyle(fontWeight: FontWeight.w600),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: const Text('Form saved as draft'),
//                   backgroundColor: _primaryColor,
//                   behavior: SnackBarBehavior.floating,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               );
//             },
//             child: const Text(
//               'SAVE',
//               style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(color: _primaryColor),
//                   const SizedBox(height: 16),
//                   Text(
//                     'Submitting report...',
//                     style: TextStyle(
//                       color: _textColor,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           : Form(
//               key: _formKey,
//               child: ListView(
//                 padding: const EdgeInsets.all(16.0),
//                 children: [
//                   // Location Information Section
//                   _buildSectionCard(
//                     title: 'Location Information',
//                     children: [
//                       _buildTextField(
//                         label: 'Latitude *',
//                         controller: _latitudeController,
//                         readOnly: true,
//                       ),
//                       const SizedBox(height: 16),
//                       _buildTextField(
//                         label: 'Longitude *',
//                         controller: _longitudeController,
//                         readOnly: true,
//                       ),
//                       const SizedBox(height: 16),
//                       _buildTextField(
//                         label: 'State *',
//                         controller: _stateController,
//                         readOnly: false,
//                       ),
//                       const SizedBox(height: 16),
//                       _buildTextField(
//                         label: 'District *',
//                         controller: _districtController,
//                       ),
//                       const SizedBox(height: 16),
//                       _buildTextField(
//                         label: 'Subdivision/Taluk',
//                         controller: _subdivisionController,
//                         readOnly: false,
//                       ),
//                       const SizedBox(height: 16),
//                       _buildTextField(
//                         label: 'Village',
//                         controller: _villageController,
//                       ),
//                       const SizedBox(height: 16),
//                       _buildTextField(
//                         label: 'Other relevant location details \nif any such as landmark etc',
//                         controller: _locationDetailsController,
//                         maxLines: 3,
//                       ),
//                     ],
//                   ),
                  
//                   const SizedBox(height: 16),
                  
//                   // Occurrence Information Section
//                   _buildSectionCard(
//                     title: 'Occurrence of Landslide \n(Date & Time) *',
//                     children: [
//                       _buildDropdown(
//                         hint: '---Select---',
//                         value: _landslideOccurrenceValue,
//                         items: [
//                           'I know the EXACT occurrence date',
//                           'I know the APPROXIMATE occurrence date', 
//                           'I DO NOT know the occurrence date'
//                         ],
//                         onChanged: (value) {
//                           setState(() {
//                             _landslideOccurrenceValue = value;
//                             // Clear dependent fields when selection changes
//                             _dateController.clear();
//                             _timeController.clear();
//                             _howDoYouKnowValue = null;
//                             _occurrenceDateRangeController.clear();
//                           });
//                         },
//                         icon: Icons.event,
//                       ),
                      
//                       // Show additional fields based on selection
//                       if (_landslideOccurrenceValue == 'I know the EXACT occurrence date') ...[
//                         const SizedBox(height: 16),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   _labelText('Date *'),
//                                   GestureDetector(
//                                     onTap: () => _selectDate(context),
//                                     child: Container(
//                                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                                       decoration: BoxDecoration(
//                                         color: Colors.grey[200],
//                                         borderRadius: BorderRadius.circular(8),
//                                         border: Border.all(color: Colors.grey[300]!),
//                                       ),
//                                       child: Row(
//                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                             _dateController.text.isEmpty ? 'Select Date' : _dateController.text,
//                                             style: TextStyle(
//                                               color: _dateController.text.isEmpty ? Colors.grey[600] : Colors.black,
//                                             ),
//                                           ),
//                                           Icon(Icons.calendar_today, color: Colors.grey[600]),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(width: 16),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   _labelText('Time'),
//                                   GestureDetector(
//                                     onTap: () => _selectTime(context),
//                                     child: Container(
//                                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                                       decoration: BoxDecoration(
//                                         color: Colors.grey[200],
//                                         borderRadius: BorderRadius.circular(8),
//                                         border: Border.all(color: Colors.grey[300]!),
//                                       ),
//                                       child: Row(
//                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                             _timeController.text.isEmpty ? 'Select Time' : _timeController.text,
//                                             style: TextStyle(
//                                               color: _timeController.text.isEmpty ? Colors.grey[600] : Colors.black,
//                                             ),
//                                           ),
//                                           Icon(Icons.access_time, color: Colors.grey[600]),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 16),
//                         _labelText('How do you know this Information? *'),
//                         _buildDropdown(
//                           hint: 'Select source',
//                           value: _howDoYouKnowValue,
//                           items: [
//                             'I observed it',
//                             'Through a local',
//                             'Social media',
//                             'News',
//                             'I don\'t know',
                            
//                           ],
//                           onChanged: (value) {
//                             setState(() {
//                               _howDoYouKnowValue = value;
//                             });
//                           },
//                           icon: Icons.info,
//                         ),
//                       ],
                      
//                       if (_landslideOccurrenceValue == 'I know the APPROXIMATE occurrence date') ...[
//                         const SizedBox(height: 16),
//                         _labelText('Occurrence Date Range *'),
//                         _buildDropdown(
//                           hint: '---Select---',
//                           value: _occurrenceDateRangeController.text.isEmpty ? null : _occurrenceDateRangeController.text,
//                           items: [
//                             'In the last 3 days',
//                             'In the last week', 
//                             'In the last month',
//                             'In the last 3 months',
//                             'In the last year',
//                             'Older than a year',                        
//                           ],
//                           onChanged: (value) {
//                             setState(() {
//                               _occurrenceDateRangeController.text = value ?? '';
//                             });
//                           },
//                           icon: Icons.date_range,
//                         ),
//                       ],
//                     ],
//                   ),
                  
//                   const SizedBox(height: 16),
                  
//                   // Landslide Location Type
//                   _buildSectionCard(
//                     title: 'Where did the landslide take place\n(Landuse/Landcover) *',
//                     children: [
//                       _buildDropdown(
//                         hint: 'Select location type',
//                         value: _whereDidLandslideOccurValue,
//                         items: ['Near/onroad', 'Next to river', 'Settlement', 'Plantation (tea,rubber .... etc.)', 'Forest Area', 'Cultivation','Barren Land','Other (Specify)'],
//                         onChanged: (value) {
//                           setState(() {
//                             _whereDidLandslideOccurValue = value;
//                           });
//                         },
//                         icon: Icons.landscape,
//                       ),
//                     ],
//                   ),
                  
//                   const SizedBox(height: 16),
                  
//                   // Type of Material
//                   _buildSectionCard(
//                     title: 'Type of Material *',
//                     children: [
//                       _buildDropdown(
//                         hint: 'Select material type',
//                         value: _typeOfMaterialValue,
//                         items: ['Rock', 'Soil', 'Debris (mixture of Rock and Soil)'],
//                         onChanged: (value) {
//                           setState(() {
//                             _typeOfMaterialValue = value;
//                           });
//                         },
//                         icon: Icons.move_down,
//                         hasInfoIcon: true,
//                         infoType: 'material_type',
//                       ),
//                     ],
//                   ),
                  
//                   const SizedBox(height: 16),
                  
//                   // Type of Movement
//                   _buildSectionCard(
//                     title: 'Type of Movement *',
//                     children: [
//                       _buildDropdown(
//                         hint: 'Select movement type',
//                         value: _typeOfMovementValue,
//                         items: ['Slide','Fall', 'Topple','Subsidence','Creep','Lateral spread', 'Flow','Complex'],
//                         onChanged: (value) {
//                           setState(() {
//                             _typeOfMovementValue = value;
//                           });
//                         },
//                         icon: Icons.move_down,
//                         hasInfoIcon: true,
//                          infoType: 'movement_type',
//                       ),
//                     ],
//                   ),
                  
//                   const SizedBox(height: 16),
                  
//                   // Dimensions Section
//                   _buildSectionCard(
//                     title: 'Dimensions',
//                     children: [
//                       _buildTextField(
//                         label: 'Length (in meters) *',
//                         controller: _lengthController,
//                         keyboardType: TextInputType.number,
//                         hasInfoIcon: true,
//                         infoType: 'dimensions',
                        
//                       ),
//                       const SizedBox(height: 16),
//                       _buildTextField(
//                         label: 'Width (in meters) *',
//                         controller: _widthController,
//                         keyboardType: TextInputType.number,
//                         hasInfoIcon: true,
//                         infoType: 'dimensions',
//                       ),
//                       const SizedBox(height: 16),
//                       _buildTextField(
//                         label: 'Height (in meters) *',
//                         controller: _heightController,
//                         keyboardType: TextInputType.number,
//                         hasInfoIcon: true,
//                         infoType: 'dimensions',
//                       ),
//                       const SizedBox(height: 16),
//                       _buildTextField(
//                         label: 'Area (in sq.meters) *',
//                         controller: _areaController,
//                         keyboardType: TextInputType.number,
//                         hasInfoIcon: false,
//                       ),
//                       _buildTextField(
//                         label: 'Depth (in meters)*',
//                         controller: _depthController,
//                         keyboardType: TextInputType.number,
//                         hasInfoIcon: false,
//                       ),
//                       const SizedBox(height: 16),
//                       _buildTextField(
//                         label: 'Volume (in cu.meters) *',
//                         controller: _volumeController,
//                         keyboardType: TextInputType.number,
//                         hasInfoIcon: false,
//                       ),
//                       const SizedBox(height: 16),
//                       _buildTextField(
//                         label: 'Run-out distance (in meters)',
//                         controller: _runoutDistanceController,
//                         keyboardType: TextInputType.number,
//                       ),
//                     ],
//                   ),
                  
//                   const SizedBox(height: 16),
                  
//                   // Rate of Movement
//                   _buildSectionCard(
//                     title: 'Rate of Movement',
//                     children: [
//                       _buildDropdown(
//                         hint: 'Select rate of movement',
//                         value: _rateOfMovementValue,
//                         items: ['Extremely Rapid', 'Very Rapid', 'Rapid', 'Moderate', 'Slow', 'Very Slow', 'Extremely Slow'],
//                         onChanged: (value) {
//                           setState(() {
//                             _rateOfMovementValue = value;
//                           });
//                         },
//                         icon: Icons.speed,
//                         hasInfoIcon: true,
//                         infoType: 'rate_movement',
//                       ),
//                     ],
//                   ),
                  
//                   const SizedBox(height: 16),
                  
//                   // Activity
//                   _buildSectionCard(
//                     title: 'Activity *',
//                     children: [
//                       _buildDropdown(
//                         hint: 'Select activity status',
//                         value: _activityValue,
//                         items: ['Active', 'Reactivated','Suspended','Dormant','Abandoned','Stabilised', 'Relict'],
//                         onChanged: (value) {
//                           setState(() {
//                             _activityValue = value;
//                           });
//                         },
//                         icon: Icons.monitor_heart,
//                         hasInfoIcon: true,
//                         infoType: 'activity',
//                       ),
//                     ],
//                   ),
                  
//                   const SizedBox(height: 16),
                  
//                   // Distribution
//                   _buildSectionCard(
//                     title: 'Distribution',
//                     children: [
//                       _buildDropdown(
//                         hint: 'Select distribution pattern',
//                         value: _distributionValue,
//                         items: ['Advancing', 'Retrogressive', 'Widening','Enlarging','Confined', 'Diminishing','Moving', ],
//                         onChanged: (value) {
//                           setState(() {
//                             _distributionValue = value;
//                           });
//                         },
//                         icon: Icons.scatter_plot,
//                         hasInfoIcon: true,
//                         infoType: 'distribution'
//                       ),
//                     ],
//                   ),
                  
//                   const SizedBox(height: 16),
                  
//                   // Style
//                   _buildSectionCard(
//                     title: 'Style *',
//                     children: [
//                       _buildDropdown(
//                         hint: 'Select style',
//                         value: _styleValue,
//                         items: ['Complex','Successive', 'Multiple','Single','Composite'],
//                         onChanged: (value) {
//                           setState(() {
//                             _styleValue = value;
//                           });
//                         },
//                         icon: Icons.style,
//                         hasInfoIcon: true,
//                         infoType: 'style',
//                       ),
//                     ],
//                   ),
                  
//                   const SizedBox(height: 16),
                  
//                   // Failure Mechanism
//                   _buildSectionCard(
//                     title: 'Failure Mechanism *',
//                     children: [
//                       _buildDropdown(
//                         hint: 'Select failure mechanism',
//                         value: _failureMechanismValue,
//                         items: ['Translational', 'Rotational', 'Planar', 'Wedge', 'Topple'],
//                         onChanged: (value) {
//                           setState(() {
//                             _failureMechanismValue = value;
//                           });
//                         },
//                         icon: Icons.broken_image,
//                       ),
//                     ],
//                   ),
                  
//                   const SizedBox(height: 16),
                  
//                   // History
//                _buildSectionCard(
//   title: 'History',
//   children: [
//     Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Dates of past movement, if any reactivation date and time',
//           style: TextStyle(
//             color: _hintColor,
//             fontSize: 14,
//             height: 1.4,
//           ),
//         ),
//         const SizedBox(height: 16),
        
//         // Display selected dates
//         if (_historyDates.isNotEmpty) ...[
//           ...List.generate(_historyDates.length, (index) {
//             return Padding(
//               padding: const EdgeInsets.only(bottom: 12.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                       decoration: BoxDecoration(
//                         color: Colors.grey[100],
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(color: Colors.grey[300]!),
//                       ),
//                       child: Text(
//                         _historyDates[index],
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   GestureDetector(
//                     onTap: () => _removeHistoryDate(index),
//                     child: Container(
//                       padding: const EdgeInsets.all(8),
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
//           const SizedBox(height: 12),
//         ],
        
//         // Add date button
//         Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: _primaryColor,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 elevation: 2,
//               ),
//               onPressed: _selectHistoryDate,
//               child: const Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(Icons.add, size: 20),
//                   SizedBox(width: 8),
//                   Text(
//                     'Add Date',
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
        
//         // Show placeholder text when no dates are added
//         if (_historyDates.isEmpty)
//           Container(
//             padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
//             decoration: BoxDecoration(
//               color: _backgroundColor,
//               borderRadius: BorderRadius.circular(8),
//               border: Border.all(color: _primaryColor.withOpacity(0.3)),
//             ),
//             child: Row(
//               children: [
//                 Icon(Icons.history, color: _primaryColor),
//                 const SizedBox(width: 12),
//                 Text(
//                   'No historical dates added',
//                   style: TextStyle(color: _hintColor, fontSize: 15),
//                 ),
//               ],
//             ),
//           ),
//       ],
//     ),
//   ],
// ), 
                
//                   const SizedBox(height: 16),
                  
//                   //GeoMorphology      
//                   _buildSectionCard(
//                     title: 'Geomorphology',
//                     children: [
//                       _buildTextField(
//                         label: 'Enter geomorphology',
//                         controller: _geomorphologyController,
//                         maxLines: 2,
//                       ),
//                     ],
//                   ),

//                   // Geology
//                   _buildSectionCard(
//                     title: 'Geology *',
//                     children: [
//                       _buildTextField(
//                         label: 'Enter geology details',
//                         controller: _geologyController,
//                         maxLines: 2,
//                       ),
//                     ],
//                   ),
                  
//                   const SizedBox(height: 16),
                  
//                   // Structure
//            _buildSectionCard(
//   title: 'Structure',
//   children: [
//     _buildStructureCheckboxWithFields(
//       title: 'Bedding',
//       value: _bedding,
//       onChanged: (value) {
//         setState(() {
//           _bedding = value ?? false;
//         });
//       },
//       controllers: _beddingControllers,
//       onAddField: _addBeddingField,
//       onRemoveField: _removeBeddingField,
//     ),
//     const SizedBox(height: 16),
    
//     _buildStructureCheckboxWithFields(
//       title: 'Joints',
//       value: _joints,
//       onChanged: (value) {
//         setState(() {
//           _joints = value ?? false;
//         });
//       },
//       controllers: _jointsControllers,
//       onAddField: _addJointsField,
//       onRemoveField: _removeJointsField,
//     ),
//     const SizedBox(height: 16),
    
//     _buildStructureCheckboxWithFields(
//       title: 'RMR',
//       value: _rmr,
//       onChanged: (value) {
//         setState(() {
//           _rmr = value ?? false;
//         });
//       },
//       controllers: _rmrControllers,
//       onAddField: _addRmrField,
//       onRemoveField: _removeRmrField,
//     ),
//   ],
// ),
   
//                   const SizedBox(height: 16),
                  
//                   // Hydrological Condition
//                   _buildSectionCard(
//                     title: 'Hydrological Condition',
//                     children: [
//                       _buildDropdown(
//                         hint: 'Select hydrological condition',
//                         value: _hydrologicalConditionValue,
//                         items: ['Dry', 'Damp', 'Wet', 'Dipping', 'Flowing'],
//                         onChanged: (value) {
//                           setState(() {
//                             _hydrologicalConditionValue = value;
//                           });
//                         },
//                         icon: Icons.water_drop,
//                         hasInfoIcon: true,
//                         infoType: 'hydrological',
//                       ),
//                     ],
//                   ),
                  
//                   const SizedBox(height: 16),
                  
//                   // What induced/triggered the landslide
//                   _buildSectionCard(
//                     title: 'What induced the landslide? *',
//                     children: [
//                       _buildDropdown(
//                         hint: 'Select trigger',
//                         value: _whatInducedLandslideValue,
//                         items: ['Rainfall', 'Earthquake', 'Man made', 'Snow melt', 'Vibration', 'Toe erosion', 'I don\'t know'],
//                         onChanged: (value) {
//                           setState(() {
//                             _whatInducedLandslideValue = value;
//                           });
//                         },
//                         icon: Icons.warning_amber,
//                         // hasInfoIcon: true,
//                       ),
//                       const SizedBox(height: 16), 
//                     ],
//                   ),
                  
//                   const SizedBox(height: 16),

//                  // Geo-Scientific causes

// _buildSectionCard(
//   title: 'Geo-Scientific Causes *',
//   children: [
//     _buildHierarchicalCheckbox(
//       title: 'Geological Causes',
//       value: _geologicalCauses,
//       onChanged: (value) {
//         setState(() {
//           _geologicalCauses = value ?? false;
//           if (!_geologicalCauses) {
//             _weakOrSensitiveMaterials = false;
//             _contrastInPermeability = false;
//             _geologicalOtherController.clear();
//           }
//         });
//       },
//       subItems: [
//         _buildSubCheckbox(
//           title: 'Weak or sensitive materials',
//           value: _weakOrSensitiveMaterials,
//           onChanged: (value) {
//             setState(() {
//               _weakOrSensitiveMaterials = value ?? false;
//             });
//           },
//         ),
//         _buildSubCheckbox(
//           title: 'Contrast in permeability and/or stiffness of materials',
//           value: _contrastInPermeability,
//           onChanged: (value) {
//             setState(() {
//               _contrastInPermeability = value ?? false;
//             });
//           },
//         ),
//         const SizedBox(height: 8),
//         _buildOtherTextField(
//           label: 'Other',
//           controller: _geologicalOtherController,
//         ),
//       ],
//     ),
//     const SizedBox(height: 16),
    
//     _buildHierarchicalCheckbox(
//       title: 'Morphological Causes',
//       value: _morphologicalCauses,
//       onChanged: (value) {
//         setState(() {
//           _morphologicalCauses = value ?? false;
//           if (!_morphologicalCauses) {
//             _tectonicOrVolcanicUplift = false;
//             _glacialRebound = false;
//             _fluvialWaveGlacialErosion = false;
//             _subterraneanErosion = false;
//             _depositionLoading = false;
//             _vegetationRemoval = false;
//             _thawing = false;
//             _morphologicalOtherController.clear();
//           }
//         });
//       },
//       subItems: [
//         _buildSubCheckbox(
//           title: 'Tectonic or volcanic uplift',
//           value: _tectonicOrVolcanicUplift,
//           onChanged: (value) {
//             setState(() {
//               _tectonicOrVolcanicUplift = value ?? false;
//             });
//           },
//         ),
//         _buildSubCheckbox(
//           title: 'Glacial rebound',
//           value: _glacialRebound,
//           onChanged: (value) {
//             setState(() {
//               _glacialRebound = value ?? false;
//             });
//           },
//         ),
//         _buildSubCheckbox(
//           title: 'Fluvial, wave, or glacial erosion of slope toe or lateral margins',
//           value: _fluvialWaveGlacialErosion,
//           onChanged: (value) {
//             setState(() {
//               _fluvialWaveGlacialErosion = value ?? false;
//             });
//           },
//         ),
//         _buildSubCheckbox(
//           title: 'Subterranean erosion (solution, piping)',
//           value: _subterraneanErosion,
//           onChanged: (value) {
//             setState(() {
//               _subterraneanErosion = value ?? false;
//             });
//           },
//         ),
//         _buildSubCheckbox(
//           title: 'Deposition loading slope or its crest',
//           value: _depositionLoading,
//           onChanged: (value) {
//             setState(() {
//               _depositionLoading = value ?? false;
//             });
//           },
//         ),
//         _buildSubCheckbox(
//           title: 'Vegetation removal (by fire, drought)',
//           value: _vegetationRemoval,
//           onChanged: (value) {
//             setState(() {
//               _vegetationRemoval = value ?? false;
//             });
//           },
//         ),
//         _buildSubCheckbox(
//           title: 'Thawing',
//           value: _thawing,
//           onChanged: (value) {
//             setState(() {
//               _thawing = value ?? false;
//             });
//           },
//         ),
//         const SizedBox(height: 8),
//         _buildOtherTextField(
//           label: 'Other',
//           controller: _morphologicalOtherController,
//         ),
//       ],
//     ),
//     const SizedBox(height: 16),
    
//     _buildHierarchicalCheckbox(
//       title: 'Human Causes',
//       value: _humanCauses,
//       onChanged: (value) {
//         setState(() {
//           _humanCauses = value ?? false;
//           if (!_humanCauses) {
//             _excavationOfSlope = false;
//             _loadingOfSlope = false;
//             _drawdown = false;
//             _deforestation = false;
//             _irrigation = false;
//             _mining = false;
//             _artificialVibration = false;
//             _waterLeakage = false;
//             _humanOtherController.clear();
//           }
//         });
//       },
//       subItems: [
//         _buildSubCheckbox(
//           title: 'Excavation of slope or its toe',
//           value: _excavationOfSlope,
//           onChanged: (value) {
//             setState(() {
//               _excavationOfSlope = value ?? false;
//             });
//           },
//         ),
//         _buildSubCheckbox(
//           title: 'Loading of slope or its crest',
//           value: _loadingOfSlope,
//           onChanged: (value) {
//             setState(() {
//               _loadingOfSlope = value ?? false;
//             });
//           },
//         ),
//         _buildSubCheckbox(
//           title: 'Drawdown (of reservoirs)',
//           value: _drawdown,
//           onChanged: (value) {
//             setState(() {
//               _drawdown = value ?? false;
//             });
//           },
//         ),
//         _buildSubCheckbox(
//           title: 'Deforestation',
//           value: _deforestation,
//           onChanged: (value) {
//             setState(() {
//               _deforestation = value ?? false;
//             });
//           },
//         ),
//         _buildSubCheckbox(
//           title: 'Irrigation',
//           value: _irrigation,
//           onChanged: (value) {
//             setState(() {
//               _irrigation = value ?? false;
//             });
//           },
//         ),
//         _buildSubCheckbox(
//           title: 'Mining',
//           value: _mining,
//           onChanged: (value) {
//             setState(() {
//               _mining = value ?? false;
//             });
//           },
//         ),
//         _buildSubCheckbox(
//           title: 'Artificial vibration',
//           value: _artificialVibration,
//           onChanged: (value) {
//             setState(() {
//               _artificialVibration = value ?? false;
//             });
//           },
//         ),
//         _buildSubCheckbox(
//           title: 'Water leakage from utilities',
//           value: _waterLeakage,
//           onChanged: (value) {
//             setState(() {
//               _waterLeakage = value ?? false;
//             });
//           },
//         ),
//         const SizedBox(height: 8),
//         _buildOtherTextField(
//           label: 'Other',
//           controller: _humanOtherController,
//         ),
//       ],
//     ),
//     const SizedBox(height: 16),
    
//     _buildHierarchicalCheckbox(
//       title: 'Other Causes',
//       value: _otherCauses,
//       onChanged: (value) {
//         setState(() {
//           _otherCauses = value ?? false;
//           if (!_otherCauses) {
//             _otherCausesController.clear();
//           }
//         });
//       },
//       subItems: [
//         _buildOtherTextField(
//           label: 'Specify other causes',
//           controller: _otherCausesController,
//         ),
//       ],
//     ),
//   ],
// ),

// const SizedBox(height: 16),

// // Enhanced Impact/Damage Section
// _buildSectionCard(
//   title: 'What is the Impact/Damage Caused\n by Landslide ?',
//   children: [
//     // People affected
//     _buildHierarchicalCheckbox(
//       title: 'People affected',
//       value: _peopleAffected,
//       onChanged: (value) {
//         setState(() {
//           _peopleAffected = value ?? false;
//           if (!_peopleAffected) {
//             _peopleDeadController.clear();
//             _peopleInjuredController.clear();
//           }
//         });
//       },
//       subItems: _peopleAffected ? [
//         const SizedBox(height: 8),
//         _buildDamageDetailRow(
//           label1: 'Dead',
//           label2: 'Injured',
//           controller1: _peopleDeadController,
//           controller2: _peopleInjuredController,
//         ),
//       ] : [],
//     ),
//     const SizedBox(height: 12),
    
//     // Livestock affected
//     _buildHierarchicalCheckbox(
//       title: 'Livestock affected',
//       value: _livestockAffected,
//       onChanged: (value) {
//         setState(() {
//           _livestockAffected = value ?? false;
//           if (!_livestockAffected) {
//             _livestockDeadController.clear();
//             _livestockInjuredController.clear();
//           }
//         });
//       },
//       subItems: _livestockAffected ? [
//         const SizedBox(height: 8),
//         _buildDamageDetailRow(
//           label1: 'Dead',
//           label2: 'Injured',
//           controller1: _livestockDeadController,
//           controller2: _livestockInjuredController,
//         ),
//       ] : [],
//     ),
//     const SizedBox(height: 12),
    
//     // Houses and buildings affected
//     _buildHierarchicalCheckbox(
//       title: 'Houses and buildings affected',
//       value: _housesBuildingAffected,
//       onChanged: (value) {
//         setState(() {
//           _housesBuildingAffected = value ?? false;
//           if (!_housesBuildingAffected) {
//             _housesFullyController.clear();
//             _housesPartiallyController.clear();
//           }
//         });
//       },
//       subItems: _housesBuildingAffected ? [
//         const SizedBox(height: 8),
//         _buildDamageDetailRow(
//           label1: 'Number of houses / buildings affected FULLY',
//           label2: 'Number of houses / buildings affected PARTIALLY',
//           controller1: _housesFullyController,
//           controller2: _housesPartiallyController,
//         ),
//       ] : [],
//     ),
//     const SizedBox(height: 12),
    
//     // Dams / Barrages affected
//    _buildHierarchicalCheckbox(
//   title: 'Dams / Barrages affected',
//   value: _damsBarragesAffected,
//   onChanged: (value) {
//     setState(() {
//       _damsBarragesAffected = value ?? false;
//       if (!_damsBarragesAffected) {
//         _damsNameController.clear();
//         _damsExtentValue = null;
//       }
//     });
//   },
//   subItems: _damsBarragesAffected ? [
//     const SizedBox(height: 8),
//     _buildDamageDetailRowMixed(
//       label1: 'Name of Dams / Barrages',
//       label2: 'Extent of damage',
//       controller1: _damsNameController,
//       dropdownValue: _damsExtentValue,
//       dropdownItems: ['Full', 'Partial'],
//       onDropdownChanged: (String? value) {
//         setState(() {
//           _damsExtentValue = value;
//         });
//       },
//     ),
//   ] : [],
// ),
//     const SizedBox(height: 12),
    
//     // Roads affected
//   _buildHierarchicalCheckbox(
//   title: 'Roads affected',
//   value: _roadsAffected,
//   onChanged: (value) {
//     setState(() {
//       _roadsAffected = value ?? false;
//       if (!_roadsAffected) {
//         _roadTypeValue = null;
//         _roadExtentValue = null;
//       }
//     });
//   },
//   subItems: _roadsAffected ? [
//     const SizedBox(height: 8),
//     _buildRoadDamageFields(),
//   ] : [],
// ),
//     const SizedBox(height: 12),
    
//     // Roads blocked
//   _buildHierarchicalCheckbox(
//   title: 'Roads blocked',
//   value: _roadsBlocked,
//   onChanged: (value) {
//     setState(() {
//       _roadsBlocked = value ?? false;
//       if (!_roadsBlocked) {
//         _roadBlockageValue = null;
//       }
//     });
//   },
//   subItems: _roadsBlocked ? [
//     const SizedBox(height: 8),
//     _buildDropdownDamageField(
//       label: 'Road Blockage',
//       value: _roadBlockageValue,
//       items: [
//         'Yes, for few hours',
//         'Yes, half a day',
//         'Yes, one day',
//         'Yes, more than a day',
//         'No blockage'
//       ],
//       onChanged: (String? value) {
//         setState(() {
//           _roadBlockageValue = value;
//         });
//       },
//     ),
//   ] : [],
// ),
//     const SizedBox(height: 12),
    
//     // Road benches damaged
// _buildHierarchicalCheckbox(
//   title: 'Road benches damaged',
//   value: _roadBenchesDamaged,
//   onChanged: (value) {
//     setState(() {
//       _roadBenchesDamaged = value ?? false;
//       if (!_roadBenchesDamaged) {
//         _roadBenchesExtentValue = null;
//       }
//     });
//   },
//   subItems: _roadBenchesDamaged ? [
//     const SizedBox(height: 8),
//     _buildDropdownDamageField(
//       label: 'Extent of damage',
//       value: _roadBenchesExtentValue,
//       items: ['Full', 'Partial'],
//       onChanged: (String? value) {
//         setState(() {
//           _roadBenchesExtentValue = value;
//         });
//       },
//     ),
//   ] : [],
// ),
//     const SizedBox(height: 12),
    
//     // Railway line affected
//     _buildHierarchicalCheckbox(
//       title: 'Railway line affected',
//       value: _railwayLineAffected,
//       onChanged: (value) {
//         setState(() {
//           _railwayLineAffected = value ?? false;
//           if (!_railwayLineAffected) {
//             _railwayDetailsController.clear();
//           }
//         });
//       },
//       subItems: _railwayLineAffected ? [
//         const SizedBox(height: 8),
//         _buildSingleDamageField(
//           label: 'Mention details',
//           controller: _railwayDetailsController,
//         ),
//       ] : [],
//     ),
//     const SizedBox(height: 12),
    
//     // Railway blocked
//    _buildHierarchicalCheckbox(
//   title: 'Railway blocked',
//   value: _railwayBlocked,
//   onChanged: (value) {
//     setState(() {
//       _railwayBlocked = value ?? false;
//       if (!_railwayBlocked) {
//         _railwayBlockageValue = null;
//       }
//     });
//   },
//   subItems: _railwayBlocked ? [
//     const SizedBox(height: 8),
//     _buildDropdownDamageField(
//       label: 'Railway Blockage',
//       value: _railwayBlockageValue,
//       items: [
//         'Yes, for few hours',
//         'Yes, half a day',
//         'Yes, one day',
//         'Yes, more than a day',
//         'No blockage'
//       ],
//       onChanged: (String? value) {
//         setState(() {
//           _railwayBlockageValue = value;
//         });
//       },
//     ),
//   ] : [],
// ),
//     const SizedBox(height: 12),
    
//     // Railway benches damaged
//   _buildHierarchicalCheckbox(
//   title: 'Railway benches damaged',
//   value: _railwayBenchesDamaged,
//   onChanged: (value) {
//     setState(() {
//       _railwayBenchesDamaged = value ?? false;
//       if (!_railwayBenchesDamaged) {
//         _railwayBenchesExtentValue = null;
//       }
//     });
//   },
//   subItems: _railwayBenchesDamaged ? [
//     const SizedBox(height: 8),
//     _buildDropdownDamageField(
//       label: 'Extent of damage',
//       value: _railwayBenchesExtentValue,
//       items: ['Full', 'Partial'],
//       onChanged: (String? value) {
//         setState(() {
//           _railwayBenchesExtentValue = value;
//         });
//       },
//     ),
//   ] : [],
// ),
  
//     const SizedBox(height: 12),
    
//     // Power infrastructure affected
//   _buildHierarchicalCheckbox(
//   title: 'Power infrastructure and\ntelecommunication affected',
//   value: _powerInfrastructureAffected,
//   onChanged: (value) {
//     setState(() {
//       _powerInfrastructureAffected = value ?? false;
//       if (!_powerInfrastructureAffected) {
//         _powerExtentValue = null;
//       }
//     });
//   },
//   subItems: _powerInfrastructureAffected ? [
//     const SizedBox(height: 8),
//     _buildDropdownDamageField(
//       label: 'Extent of damage',
//       value: _powerExtentValue,
//       items: ['Full', 'Partial'],
//       onChanged: (String? value) {
//         setState(() {
//           _powerExtentValue = value;
//         });
//       },
//     ),
//   ] : [],
// ),
//     const SizedBox(height: 12),
    
//     // Damages to Agriculture/Barren/Forest
//     _buildCheckboxListTile(
//       title: 'Damages to Agriculture/Barren/Forest',
//       value: _damagesToAgriculturalForestLand,
//       onChanged: (value) {
//         setState(() {
//           _damagesToAgriculturalForestLand = value ?? false;
//         });
//       },
//     ),
    
//     // Other damages
//     _buildHierarchicalCheckbox(
//       title: 'Other',
//       value: _other,
//       onChanged: (value) {
//         setState(() {
//           _other = value ?? false;
//           if (!_other) {
//             _otherDamageDetailsController.clear();
//           }
//         });
//       },
//       subItems: _other ? [
//         const SizedBox(height: 8),
//         _buildSingleDamageField(
//           label: 'Mention details *',
//           controller: _otherDamageDetailsController,
//         ),
//       ] : [],
//     ),
//     const SizedBox(height: 12),
    
//     // No damages
//     _buildCheckboxListTile(
//       title: 'No damages',
//       value: _noDamages,
//       onChanged: (value) {
//         setState(() {
//           _noDamages = value ?? false;
//         });
//       },
//     ),
    
//     // I don't know
//     _buildCheckboxListTile(
//       title: 'I don\'t know',
//       value: _iDontKnow,
//       onChanged: (value) {
//         setState(() {
//           _iDontKnow = value ?? false;
//         });
//       },
//     ),
//   ],
// ),

//                   const SizedBox(height: 16),

//                   // Remedial Measures
//           _buildSectionCard(
//   title: 'Remedial Measures *',
//   children: [
//     // Modification of Slope Geometry
//     _buildHierarchicalCheckbox(
//       title: 'Modification of Slope Geometry',
//       value: _modificationOfSlopeGeometry,
//       onChanged: (value) {
//         setState(() {
//           _modificationOfSlopeGeometry = value ?? false;
//           if (!_modificationOfSlopeGeometry) {
//             _removingMaterial = false;
//             _addingMaterial = false;
//             _reducingGeneralSlopeAngle = false;
//             _slopeGeometryOtherController.clear();
//           }
//         });
//       },
//       subItems: _modificationOfSlopeGeometry ? [
//         _buildSubCheckbox(
//           title: 'Removing material from the area driving the landslide (with possible substitution by lightweight fill)',
//           value: _removingMaterial,
//           onChanged: (value) {
//             setState(() {
//               _removingMaterial = value ?? false;
//             });
//           },
//         ),
//         _buildSubCheckbox(
//           title: 'Adding material to the area maintaining stability (counterweight berm or fill)',
//           value: _addingMaterial,
//           onChanged: (value) {
//             setState(() {
//               _addingMaterial = value ?? false;
//             });
//           },
//         ),
//         _buildSubCheckbox(
//           title: 'Reducing general slope angle',
//           value: _reducingGeneralSlopeAngle,
//           onChanged: (value) {
//             setState(() {
//               _reducingGeneralSlopeAngle = value ?? false;
//             });
//           },
//         ),
//         const SizedBox(height: 8),
//         _buildOtherTextField(
//           label: 'Other',
//           controller: _slopeGeometryOtherController,
//         ),
//       ] : [],
//     ),
//     const SizedBox(height: 16),

//     // Drainage
//     _buildHierarchicalCheckbox(
//       title: 'Drainage',
//       value: _drainage,
//       onChanged: (value) {
//         setState(() {
//           _drainage = value ?? false;
//           if (!_drainage) {
//             _surfaceDrains = false;
//             _shallowDeepTrenchDrains = false;
//             _buttressCounterfortDrains = false;
//             _verticalSmallDiameterBoreholes = false;
//             _verticalLargeDiameterWells = false;
//             _subHorizontalBoreholes = false;
//             _drainageTunnels = false;
//             _vacuumDewatering = false;
//             _drainageBySiphoning = false;
//             _electroosmoticDewatering = false;
//             _vegetationPlanting = false;
//             _drainageOtherController.clear();
//           }
//         });
//       },
//       subItems: _drainage ? [
//         _buildSubCheckbox(
//           title: 'Surface drains to divert water from flowing onto the slide area (collecting ditches and pipes)',
//           value: _surfaceDrains,
//           onChanged: (value) {
//             setState(() {
//               _surfaceDrains = value ?? false;
//             });
//           },
//         ),
//         _buildSubCheckbox(
//           title: 'Shallow or deep trench drains filled with free-draining geomaterials (including rock fill and geosynthetics)',
//           value: _shallowDeepTrenchDrains,
//           onChanged: (value) {
//             setState(() {
//               _shallowDeepTrenchDrains = value ?? false;
//             });
//           },
//         ),
//         _buildSubCheckbox(
//           title: 'Buttress counterfort for sand coarse-grained materials (hydrological effect)',
//           value: _buttressCounterfortDrains,
//           onChanged: (value) {
//             setState(() {
//               _buttressCounterfortDrains = value ?? false;
//             });
//           },
//         ),
//         _buildSubCheckbox(
//           title: 'Vertical (small diameter) boreholes with pumping or self draining',
//           value: _verticalSmallDiameterBoreholes,
//           onChanged: (value) {
//             setState(() {
//               _verticalSmallDiameterBoreholes = value ?? false;
//             });
//           },
//         ),
//         _buildSubCheckbox(
//           title: 'Vertical (large diameter) wells with gravity draining',
//           value: _verticalLargeDiameterWells,
//           onChanged: (value) {
//             setState(() {
//               _verticalLargeDiameterWells = value ?? false;
//             });
//           },
//         ),
//         _buildSubCheckbox(
//           title: 'Sub horizontal or sub vertical boreholes',
//           value: _subHorizontalBoreholes,
//           onChanged: (value) {
//             setState(() {
//               _subHorizontalBoreholes = value ?? false;
//             });
//           },
//         ),
//         _buildSubCheckbox(
//           title: 'Drainage tunnels, galleries or adits',
//           value: _drainageTunnels,
//           onChanged: (value) {
//             setState(() {
//               _drainageTunnels = value ?? false;
//             });
//           },
//         ),
//         _buildSubCheckbox(
//           title: 'Vacuum dewatering',
//           value: _vacuumDewatering,
//           onChanged: (value) {
//             setState(() {
//               _vacuumDewatering = value ?? false;
//             });
//           },
//         ),
//         _buildSubCheckbox(
//           title: 'Drainage by siphoning',
//           value: _drainageBySiphoning,
//           onChanged: (value) {
//             setState(() {
//               _drainageBySiphoning = value ?? false;
//             });
//           },
//         ),
//         _buildSubCheckbox(
//           title: 'Electro-osmotic dewatering',
//           value: _electroosmoticDewatering,
//           onChanged: (value) {
//             setState(() {
//               _electroosmoticDewatering = value ?? false;
//             });
//           },
//         ),
//         _buildSubCheckbox(
//           title: 'Vegetation planting (hydrological effect)',
//           value: _vegetationPlanting,
//           onChanged: (value) {
//             setState(() {
//               _vegetationPlanting = value ?? false;
//             });
//           },
//         ),
//         const SizedBox(height: 8),
//         _buildOtherTextField(
//           label: 'Other',
//           controller: _drainageOtherController,
//         ),
//       ] : [],
//     ),
//     const SizedBox(height: 16),

//     // Retaining Structures
//     _buildHierarchicalCheckbox(
//       title: 'Retaining Structures',
//       value: _retainingStructures,
//       onChanged: (value) {
//         setState(() {
//           _retainingStructures = value ?? false;
//           if (!_retainingStructures) {
//             _gravityRetainingWalls = false;
//             _cribBlockWalls = false;
//             _gabionWalls = false;
//             _passivePilesPiers = false;
//             _castInSituWalls = false;
//             _reinforcedEarthRetaining = false;
//             _buttressCounterforts = false;
//             _retainingOtherController.clear();
//           }
//         });
//       },
//       subItems: _retainingStructures ? [
//         _buildSubCheckbox(
//           title: 'Gravity retaining walls',
//           value: _gravityRetainingWalls,
//           onChanged: (value) {
//             setState(() {
//               _gravityRetainingWalls = value ?? false;
//             });
//           },
//         ),
//         _buildSubCheckbox(
//           title: 'Crib-block walls',
//           value: _cribBlockWalls,
//           onChanged: (value) {
//             setState(() {
//               _cribBlockWalls = value ?? false;
//             });
//           },
//         ),
//         _buildSubCheckbox(
//           title: 'Gabion walls',
//           value: _gabionWalls,
//           onChanged: (value) {
//             setState(() {
//               _gabionWalls = value ?? false;
//             });
//           },
//         ),
//         _buildSubCheckbox(
//           title: 'Passive piles, piers and caissons',
//           value: _passivePilesPiers,
//           onChanged: (value) {
//             setState(() {
//               _passivePilesPiers = value ?? false;
//             });
//           },
//         ),
//         _buildSubCheckbox(
//           title: 'Cast-in situ reinforced concrete walls',
//           value: _castInSituWalls,
//           onChanged: (value) {
//             setState(() {
//               _castInSituWalls = value ?? false;
//             });
//           },
//         ),
//         _buildSubCheckbox(
//           title: 'Reinforced earth retaining structures with strip/ sheet - polymer/metallic reinforcement elements',
//           value: _reinforcedEarthRetaining,
//           onChanged: (value) {
//             setState(() {
//               _reinforcedEarthRetaining = value ?? false;
//             });
//           },
//         ),
//         _buildSubCheckbox(
//           title: 'Buttress counterforts of coarse-grained material (mechanical effect)',
//           value: _buttressCounterforts,
//           onChanged: (value) {
//             setState(() {
//               _buttressCounterforts = value ?? false;
//             });
//           },
//         ),
//         const SizedBox(height: 8),
//         _buildOtherTextField(
//           label: 'Other',
//           controller: _retainingOtherController,
//         ),
//       ] : [],
//     ),
//     const SizedBox(height: 16),

//     // Internal Slope Reinforcement
//     _buildHierarchicalCheckbox(
//       title: 'Internal Slope Reinforcement',
//       value: _internalSlopeReinforcement,
//       onChanged: (value) {
//         setState(() {
//           _internalSlopeReinforcement = value ?? false;
//           if (!_internalSlopeReinforcement) {
//             _anchors = false;
//             _grouting = false;
//             _internalReinforcementOtherController.clear();
//           }
//         });
//       },
//       subItems: _internalSlopeReinforcement ? [
//         _buildSubCheckbox(
//           title: 'Anchors (prestressed or not)',
//           value: _anchors,
//           onChanged: (value) {
//             setState(() {
//               _anchors = value ?? false;
//             });
//           },
//         ),
//         _buildSubCheckbox(
//           title: 'Grouting',
//           value: _grouting,
//           onChanged: (value) {
//             setState(() {
//               _grouting = value ?? false;
//             });
//           },
//         ),
//         const SizedBox(height: 8),
//         _buildOtherTextField(
//           label: 'Other',
//           controller: _internalReinforcementOtherController,
//         ),
//       ] : [],
//     ),
//     const SizedBox(height: 16),

//     // Remedial measures not required
//     _buildHierarchicalCheckbox(
//       title: 'Remedial measures not required',
//       value: _remedialMeasuresNotRequired,
//       onChanged: (value) {
//         setState(() {
//           _remedialMeasuresNotRequired = value ?? false;
//           if (!_remedialMeasuresNotRequired) {
//             _remedialNotRequiredWhyController.clear();
//           }
//         });
//       },
//       subItems: _remedialMeasuresNotRequired ? [
//         const SizedBox(height: 8),
//         _buildOtherTextField(
//           label: 'Why?',
//           controller: _remedialNotRequiredWhyController,
//         ),
//       ] : [],
//     ),
//     const SizedBox(height: 16),

//     // Remedial measures not adequately safeguard the slide
//     _buildHierarchicalCheckbox(
//       title: 'Remedial measures not adequately\nsafeguard the slide',
//       value: _remedialMeasuresNotAdequate,
//       onChanged: (value) {
//         setState(() {
//           _remedialMeasuresNotAdequate = value ?? false;
//           if (!_remedialMeasuresNotAdequate) {
//             _shiftingOfVillage = false;
//             _evacuationOfInfrastructure = false;
//             _realignmentOfCommunicationCorridors = false;
//             _realignmentOfRoad = false;
//             _communicationCorridorType = null;
//             _notAdequateOtherController.clear();
//           }
//         });
//       },
//       subItems: _remedialMeasuresNotAdequate ? [
//         _buildSubCheckbox(
//           title: 'Shifting of the village',
//           value: _shiftingOfVillage,
//           onChanged: (value) {
//             setState(() {
//               _shiftingOfVillage = value ?? false;
//             });
//           },
//         ),
//         _buildSubCheckbox(
//           title: 'Evacuation of the infrastructure',
//           value: _evacuationOfInfrastructure,
//           onChanged: (value) {
//             setState(() {
//               _evacuationOfInfrastructure = value ?? false;
//             });
//           },
//         ),
        
//         // Realignment of communication corridors with dropdown
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildSubCheckbox(
//               title: 'Realignment of the communication corridors',
//               value: _realignmentOfCommunicationCorridors,
//               onChanged: (value) {
//                 setState(() {
//                   _realignmentOfCommunicationCorridors = value ?? false;
//                   if (!_realignmentOfCommunicationCorridors) {
//                     _communicationCorridorType = null;
//                   }
//                 });
//               },
//             ),
//             if (_realignmentOfCommunicationCorridors) ...[
//               const SizedBox(height: 8),
//               Padding(
//                 padding: const EdgeInsets.only(left: 20.0),
//                 child: _buildDropdownDamageField(
//                   label: 'Type of communication corridor',
//                   value: _communicationCorridorType,
//                   items: _communicationCorridorOptions,
//                   onChanged: (String? value) {
//                     setState(() {
//                       _communicationCorridorType = value;
//                     });
//                   },
//                 ),
//               ),
//             ],
//           ],
//         ),
  
//         const SizedBox(height: 8),
//         _buildOtherTextField(
//           label: 'Other',
//           controller: _notAdequateOtherController,
//         ),
//       ] : [],
//     ),
//     const SizedBox(height: 16),

//     // Other Information
//     _buildHierarchicalCheckbox(
//       title: 'Other Information',
//       value: _otherInformation,
//       onChanged: (value) {
//         setState(() {
//           _otherInformation = value ?? false;
//           if (!_otherInformation) {
//             _otherInformationController.clear();
//           }
//         });
//       },
//       subItems: _otherInformation ? [
//         const SizedBox(height: 8),
//         _buildOtherTextField(
//           label: 'Other',
//           controller: _otherInformationController,
//         ),
//       ] : [],
//     ),
//   ],
// ),      
//                   const SizedBox(height: 16),
                  
//                   // Alert Category
//                   _buildSectionCard(
//                     title: 'Alert Category',
//                     children: [
//                       _buildDropdown(
//                         hint: 'Select Alert level',
//                         value: _alertCategory,
//                         items: ['Category 1', 'Category 2', 'Category 3'],
//                         onChanged: (value) {
//                           setState(() {
//                             _alertCategory = value;
//                           });
//                         },
//                         icon: Icons.trending_up,
//                         hasInfoIcon: true,
//                         infoType: 'alert_category',

//                       ),
//                     ],
//                   ),

//                   //Any other relevant information on the landslide
//                   _buildSectionCard(
//                     title: 'Any other relevant information \non the landslide',
//                     children: [
//                       _buildTextField(
//                         label: 'Enter any other relevant information',
//                         controller: _otherRelevantInformation,
//                         maxLines: 2,
//                         hasInfoIcon: false,
//                       ),
//                     ],
//                   ),
                  
//                   const SizedBox(height: 16),
                  
//                   // Selected Images Display
//                   if (_selectedImages.isNotEmpty)
//                     _buildSectionCard(
//                       title: 'Selected Images (${_selectedImages.length})',
//                       children: [
//                         SizedBox(
//                           height: 120,
//                           child: ListView.builder(
//                             scrollDirection: Axis.horizontal,
//                             itemCount: _selectedImages.length,
//                             itemBuilder: (context, index) {
//                               return Container(
//                                 margin: const EdgeInsets.only(right: 8),
//                                 child: Stack(
//                                   children: [
//                                     ClipRRect(
//                                       borderRadius: BorderRadius.circular(8),
//                                       child: Image.file(
//                                         _selectedImages[index],
//                                         width: 120,
//                                         height: 120,
//                                         fit: BoxFit.cover,
//                                       ),
//                                     ),
//                                     Positioned(
//                                       top: 4,
//                                       right: 4,
//                                       child: GestureDetector(
//                                         onTap: () => _removeImage(index),
//                                         child: Container(
//                                           decoration: const BoxDecoration(
//                                             color: Colors.red,
//                                             shape: BoxShape.circle,
//                                           ),
//                                           child: const Icon(
//                                             Icons.close,
//                                             color: Colors.white,
//                                             size: 20,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
                  
//                   const SizedBox(height: 24),
                  
//                   // Submit Button
//                   Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 8.0),
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: _primaryColor,
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         elevation: 2,
//                       ),
//                       onPressed: () {
//                         if (_formKey.currentState!.validate()) {
//                           _submitForm();
//                         } else {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: const Text('Please fill all required fields marked with *'),
//                               backgroundColor: Colors.red[600],
//                               behavior: SnackBarBehavior.floating,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                             ),
//                           );
//                         }
//                       },
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
//             ),
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
//           selectedItemColor: _primaryColor,
//           unselectedItemColor: _hintColor,
//           currentIndex: 0,
//           onTap: (index) {
//             if (index == 0) {
//               _openCamera();
//             } else {
//               _openGallery();
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

//   Widget _buildSectionCard({required String title, required List<Widget> children}) {
//     return Card(
//       elevation: 2,
//       margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       color: _cardColor,
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
//                       color: _primaryColor,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     title,
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: _textColor,
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

//   Widget _labelText(String text) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8.0),
//       child: Text(
//         text,
//         style: TextStyle(
//           fontSize: 15,
//           fontWeight: FontWeight.w500,
//           color: _textColor,
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
//     String? infoType, // Add this parameter
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
//             validator: (value) {
//               if (label.contains('*') && (value == null || value.isEmpty)) {
//                 return 'This field is required';
//               }
//               return null;
//             },
//           ),
//         ),
      
//       //
//           if (hasInfoIcon)
//   Padding(
//     padding: const EdgeInsets.only(left: 8.0, top: 12.0),
//     child: InkWell(
//       onTap: () {
//         if (infoType == 'dimensions') {
//           _showDimensionsDialog();
//         } else {
//           _showInfoDialog(label);
//         }
//       },
//       child: const Icon(
//         Icons.info_outline,
//         color: Colors.blue,
//         size: 24,
//       ),
//     ),
//   ),
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
//     String? infoType,
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
//               onTap: () {
//                 if (infoType == 'material_type') {
//                       showMaterialTypeDialog(context);
//                 }else if(infoType == 'movement_type') {
//                       showMovementTypeDialog(context);
//                 }else if (infoType == 'rate_movement') {
//                      showRateOfMovementDialog(context);
//                 }else if (infoType == 'activity') {
//                       showActivityDialog(context);
//                 }else if (infoType == 'distribution') {
//                     showDistributionDialog(context);
//                 }else if (infoType == 'style') {
//                     showStyleDialog(context);
//                 }else if (infoType == 'hydrological') {
//                     showHydrologicalConditionDialog(context);
//                 }else if (infoType == 'alert_category') {
//                    showAlertCategoryDialog(context);
//                 }
//               },
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

//   Widget _buildCheckboxListTile({
//     required String title,
//     required bool value,
//     required Function(bool?) onChanged,
//   }) {
//     return CheckboxListTile(
//       title: Text(title),
//       value: value,
//       controlAffinity: ListTileControlAffinity.leading,
//       contentPadding: EdgeInsets.zero,
//       visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
//       dense: true,
//       onChanged: onChanged,
//     );
//   }

//   // Date picker method
//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime.now(),
//     );
//     if (picked != null) {
//       setState(() {
//         _dateController.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
//       });
//     }
//   }

//   // Time picker method
//   Future<void> _selectTime(BuildContext context) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//     if (picked != null) {
//       setState(() {
//         _timeController.text = "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}:00";
//       });
//     }
//   }

//   void _showInfoDialog(String title) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Info: $title'),
//           content: const Text('Additional information about this field would appear here.'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }


// void _showDimensionsDialog() {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return Dialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Container(
//           width: MediaQuery.of(context).size.width * 0.9,
//           height: MediaQuery.of(context).size.height * 0.7,
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     'Landslide Dimensions',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: () => Navigator.of(context).pop(),
//                     icon: Container(
//                       decoration: const BoxDecoration(
//                         color: Colors.black,
//                         shape: BoxShape.circle,
//                       ),
//                       child: const Icon(
//                         Icons.close,
//                         color: Colors.white,
//                         size: 20,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               Expanded(
//                 child: Center(
//                   child: Container(
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: Colors.grey[300]!),
//                     ),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       child: Image.asset(
//                         'assets/dimension_landslide.png',
//                         fit: BoxFit.contain,
//                         errorBuilder: (context, error, stackTrace) {
//                           return Container(
//                             height: 300,
//                             color: Colors.grey[200],
//                             child: const Center(
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Icons.image_not_supported,
//                                     size: 50,
//                                     color: Colors.grey,
//                                   ),
//                                   SizedBox(height: 8),
//                                   Text(
//                                     'Image not found',
//                                     style: TextStyle(
//                                       color: Colors.grey,
//                                       fontSize: 14,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'This diagram shows how to measure the key dimensions of a landslide:',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               const Text(
//                 '• Length: The distance along the slope from crown to toe\n'
//                 '• Width: The maximum width perpendicular to the length\n'
//                 '• Height: The vertical distance from crown to toe',
//                 style: TextStyle(
//                   fontSize: 14,
//                   height: 1.4,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }

//   void _submitForm() {
//     setState(() {
//       _isLoading = true;
//     });

//     // Simulate API call
//     Future.delayed(const Duration(seconds: 2), () {
//       setState(() {
//         _isLoading = false;
//       });

//       // Show success message and navigate back
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text('Landslide report submitted successfully!'),
//           backgroundColor: Colors.green,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         ),
//       );
      
//       // Navigate back to previous screen
//       Navigator.of(context).pop();
//     });
//   }
// }

