// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:bhooskhalann/services/api_service.dart';

// class LandslideReportController extends GetxController {
//   final formKey = GlobalKey<FormState>();
//   final ImagePicker _picker = ImagePicker();
  
//   // Loading state
//   var isLoading = false.obs;

//   var selectedDateText = ''.obs;
//   var selectedTimeText = ''.obs;
  
//   // Images
//   var selectedImages = <File>[].obs;
  
//   // Form controllers - Location Information
//   late TextEditingController latitudeController;
//   late TextEditingController longitudeController;
//   final stateController = TextEditingController();
//   final districtController = TextEditingController();
//   final subdivisionController = TextEditingController();
//   final villageController = TextEditingController();
//   final locationDetailsController = TextEditingController();
  
//   // Form controllers - Dimensions
//   final lengthController = TextEditingController();
//   final widthController = TextEditingController();
//   final heightController = TextEditingController();
//   final areaController = TextEditingController();
//   final depthController = TextEditingController();
//   final volumeController = TextEditingController();
//   final runoutDistanceController = TextEditingController();
  
//   // Form controllers - Other fields
//   final geologyController = TextEditingController();
//   final dateController = TextEditingController();
//   final timeController = TextEditingController();
//   final occurrenceDateRangeController = TextEditingController();
//   final geomorphologyController = TextEditingController();
//   final otherRelevantInformation = TextEditingController();
  
//   // History dates management
//   var historyDates = <String>[].obs;
  
//   // Dynamic controllers for Structure
//   var beddingControllers = <TextEditingController>[].obs;
//   var jointsControllers = <TextEditingController>[].obs;
//   var rmrControllers = <TextEditingController>[].obs;
  
//   // Dropdown values - Main form
//   var landslideOccurrenceValue = Rxn<String>();
//   var howDoYouKnowValue = Rxn<String>();
//   var whereDidLandslideOccurValue = Rxn<String>();
//   var typeOfMaterialValue = Rxn<String>();
//   var typeOfMovementValue = Rxn<String>();
//   var rateOfMovementValue = Rxn<String>();
//   var activityValue = Rxn<String>();
//   var distributionValue = Rxn<String>();
//   var styleValue = Rxn<String>();
//   var failureMechanismValue = Rxn<String>();
//   var hydrologicalConditionValue = Rxn<String>();
//   var whatInducedLandslideValue = Rxn<String>();
//   var alertCategory = Rxn<String>();
  
//   // Structure checkboxes
//   var bedding = false.obs;
//   var joints = false.obs;
//   var rmr = false.obs;
  
//   // Geo-Scientific Causes - Main categories
//   var geologicalCauses = false.obs;
//   var morphologicalCauses = false.obs;
//   var humanCauses = false.obs;
//   var otherCauses = false.obs;
  
//   // Geological Causes sub-items
//   var weakOrSensitiveMaterials = false.obs;
//   var contrastInPermeability = false.obs;
//   final geologicalOtherController = TextEditingController();
  
//   // Morphological Causes sub-items
//   var tectonicOrVolcanicUplift = false.obs;
//   var glacialRebound = false.obs;
//   var fluvialWaveGlacialErosion = false.obs;
//   var subterraneanErosion = false.obs;
//   var depositionLoading = false.obs;
//   var vegetationRemoval = false.obs;
//   var thawing = false.obs;
//   final morphologicalOtherController = TextEditingController();
  
//   // Human Causes sub-items
//   var excavationOfSlope = false.obs;
//   var loadingOfSlope = false.obs;
//   var drawdown = false.obs;
//   var deforestation = false.obs;
//   var irrigation = false.obs;
//   var mining = false.obs;
//   var artificialVibration = false.obs;
//   var waterLeakage = false.obs;
//   final humanOtherController = TextEditingController();
//   final otherCausesController = TextEditingController();
  
//   // Impact/Damage - Main categories
//   var peopleAffected = false.obs;
//   var livestockAffected = false.obs;
//   var housesBuildingAffected = false.obs;
//   var damsBarragesAffected = false.obs;
//   var roadsAffected = false.obs;
//   var roadsBlocked = false.obs;
//   var roadBenchesDamaged = false.obs;
//   var railwayLineAffected = false.obs;
//   var railwayBlocked = false.obs;
//   var railwayBenchesDamaged = false.obs;
//   var powerInfrastructureAffected = false.obs;
//   var damagesToAgriculturalForestLand = false.obs;
//   var other = false.obs;
//   var noDamages = false.obs;
//   var iDontKnow = false.obs;
  
//   // Impact/Damage detail controllers
//   final peopleDeadController = TextEditingController();
//   final peopleInjuredController = TextEditingController();
//   final livestockDeadController = TextEditingController();
//   final livestockInjuredController = TextEditingController();
//   final housesFullyController = TextEditingController();
//   final housesPartiallyController = TextEditingController();
//   final damsNameController = TextEditingController();
//   var damsExtentValue = Rxn<String>();
//   var roadTypeValue = Rxn<String>();
//   var roadExtentValue = Rxn<String>();
//   var roadBlockageValue = Rxn<String>();
//   var roadBenchesExtentValue = Rxn<String>();
//   final railwayDetailsController = TextEditingController();
//   var railwayBlockageValue = Rxn<String>();
//   var railwayBenchesExtentValue = Rxn<String>();
//   var powerExtentValue = Rxn<String>();
//   final otherDamageDetailsController = TextEditingController();
  
//   // Remedial Measures - Main categories
//   var modificationOfSlopeGeometry = false.obs;
//   var drainage = false.obs;
//   var retainingStructures = false.obs;
//   var internalSlopeReinforcement = false.obs;
//   var remedialMeasuresNotRequired = false.obs;
//   var remedialMeasuresNotAdequate = false.obs;
//   var otherInformation = false.obs;
  
//   // Modification of Slope Geometry sub-items
//   var removingMaterial = false.obs;
//   var addingMaterial = false.obs;
//   var reducingGeneralSlopeAngle = false.obs;
//   final slopeGeometryOtherController = TextEditingController();
  
//   // Drainage sub-items
//   var surfaceDrains = false.obs;
//   var shallowDeepTrenchDrains = false.obs;
//   var buttressCounterfortDrains = false.obs;
//   var verticalSmallDiameterBoreholes = false.obs;
//   var verticalLargeDiameterWells = false.obs;
//   var subHorizontalBoreholes = false.obs;
//   var drainageTunnels = false.obs;
//   var vacuumDewatering = false.obs;
//   var drainageBySiphoning = false.obs;
//   var electroosmoticDewatering = false.obs;
//   var vegetationPlanting = false.obs;
//   final drainageOtherController = TextEditingController();
  
//   // Retaining Structures sub-items
//   var gravityRetainingWalls = false.obs;
//   var cribBlockWalls = false.obs;
//   var gabionWalls = false.obs;
//   var passivePilesPiers = false.obs;
//   var castInSituWalls = false.obs;
//   var reinforcedEarthRetaining = false.obs;
//   var buttressCounterforts = false.obs;
//   final retainingOtherController = TextEditingController();
  
//   // Internal Slope Reinforcement sub-items
//   var anchors = false.obs;
//   var grouting = false.obs;
//   final internalReinforcementOtherController = TextEditingController();
  
//   // Remedial measures not adequate sub-items
//   var shiftingOfVillage = false.obs;
//   var evacuationOfInfrastructure = false.obs;
//   var realignmentOfCommunicationCorridors = false.obs;
//   var communicationCorridorType = Rxn<String>();
//   final notAdequateOtherController = TextEditingController();
  
//   // Other remedial measure controllers
//   final remedialNotRequiredWhyController = TextEditingController();
//   final otherInformationController = TextEditingController();

//   // Helper method to convert date from DD/MM/YYYY to YYYY-MM-DDTHH:mm:ss
// String formatDateForAPI(String displayDate) {
//   if (displayDate.isEmpty) return "";
  
//   try {
//     List<String> parts = displayDate.split('/');
//     if (parts.length == 3) {
//       String day = parts[0];
//       String month = parts[1];
//       String year = parts[2];
//       return "${year}-${month.padLeft(2, '0')}-${day.padLeft(2, '0')}T00:00:00";
//     }
//   } catch (e) {
//     print("Error formatting date: $e");
//   }
//   return "";
// }

// // Helper method to convert time from HH:MM to HH:MM:SS
// String formatTimeForAPI(String displayTime) {
//   if (displayTime.isEmpty) return "";
  
//   try {
//     if (displayTime.contains(':') && displayTime.split(':').length == 2) {
//       return "$displayTime:00";
//     }
//   } catch (e) {
//     print("Error formatting time: $e");
//   }
//   return "";
// }
  
//   @override
//   void onInit() {
//     super.onInit();
//     // Initialize with coordinates from arguments or parameters
//     final args = Get.arguments as Map<String, dynamic>?;
//     if (args != null) {
//       latitudeController = TextEditingController(
//         text: args['latitude']?.toStringAsFixed(7) ?? '',
//       );
//       longitudeController = TextEditingController(
//         text: args['longitude']?.toStringAsFixed(7) ?? '',
//       );
//     } else {
//       latitudeController = TextEditingController();
//       longitudeController = TextEditingController();
//     }
//   }
  
//   // Set coordinates method (can be called from the screen constructor)
//   void setCoordinates(double latitude, double longitude) {
//     latitudeController.text = latitude.toStringAsFixed(7);
//     longitudeController.text = longitude.toStringAsFixed(7);
//   }
  
//   @override
//   void onClose() {
//     // Dispose all controllers
//     latitudeController.dispose();
//     longitudeController.dispose();
//     stateController.dispose();
//     districtController.dispose();
//     subdivisionController.dispose();
//     villageController.dispose();
//     locationDetailsController.dispose();
//     lengthController.dispose();
//     widthController.dispose();
//     heightController.dispose();
//     areaController.dispose();
//     depthController.dispose();
//     volumeController.dispose();
//     runoutDistanceController.dispose();
//     geologyController.dispose();
//     dateController.dispose();
//     timeController.dispose();
//     occurrenceDateRangeController.dispose();
//     geomorphologyController.dispose();
//     otherRelevantInformation.dispose();
    
//     // Dispose dynamic controllers
//     for (var controller in beddingControllers) {
//       controller.dispose();
//     }
//     for (var controller in jointsControllers) {
//       controller.dispose();
//     }
//     for (var controller in rmrControllers) {
//       controller.dispose();
//     }
//     beddingControllers.clear();
//     jointsControllers.clear();
//     rmrControllers.clear();
    
//     // Dispose geo-scientific controllers
//     geologicalOtherController.dispose();
//     morphologicalOtherController.dispose();
//     humanOtherController.dispose();
//     otherCausesController.dispose();
    
//     // Dispose impact controllers
//     peopleDeadController.dispose();
//     peopleInjuredController.dispose();
//     livestockDeadController.dispose();
//     livestockInjuredController.dispose();
//     housesFullyController.dispose();
//     housesPartiallyController.dispose();
//     damsNameController.dispose();
//     railwayDetailsController.dispose();
//     otherDamageDetailsController.dispose();
    
//     // Dispose remedial controllers
//     slopeGeometryOtherController.dispose();
//     drainageOtherController.dispose();
//     retainingOtherController.dispose();
//     internalReinforcementOtherController.dispose();
//     remedialNotRequiredWhyController.dispose();
//     notAdequateOtherController.dispose();
//     otherInformationController.dispose();
    
//     super.onClose();
//   }
  
//   // Image handling methods
//   Future<void> openCamera() async {
//     try {
//       final XFile? photo = await _picker.pickImage(
//         source: ImageSource.camera,
//         maxWidth: 1800,
//         maxHeight: 1800,
//         imageQuality: 85,
//       );
      
//       if (photo != null) {
//         selectedImages.add(File(photo.path));
//         Get.snackbar(
//           'Success',
//           'Photo captured! Total images: ${selectedImages.length}',
//           backgroundColor: const Color(0xFF1976D2),
//           colorText: Colors.white,
//           snackPosition: SnackPosition.BOTTOM,
//         );
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Error accessing camera: $e',
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     }
//   }
  
//   Future<void> openGallery() async {
//     try {
//       final List<XFile> photos = await _picker.pickMultiImage(
//         maxWidth: 1800,
//         maxHeight: 1800,
//         imageQuality: 85,
//       );
      
//       if (photos.isNotEmpty) {
//         selectedImages.addAll(photos.map((photo) => File(photo.path)));
//         Get.snackbar(
//           'Success',
//           '${photos.length} images selected! Total images: ${selectedImages.length}',
//           backgroundColor: const Color(0xFF1976D2),
//           colorText: Colors.white,
//           snackPosition: SnackPosition.BOTTOM,
//         );
//       }
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Error accessing gallery: $e',
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     }
//   }
  
//   void removeImage(int index) {
//     selectedImages.removeAt(index);
//   }
  
//   // History date methods
//   Future<void> selectHistoryDate() async {
//     final DateTime? picked = await showDatePicker(
//       context: Get.context!,
//       initialDate: DateTime.now().subtract(const Duration(days: 1)),
//       firstDate: DateTime(1900),
//       lastDate: DateTime.now().subtract(const Duration(days: 1)),
//       helpText: 'Select Historical Date',
//       confirmText: 'ADD',
//       cancelText: 'CANCEL',
//     );
    
//     if (picked != null) {
//       final String formattedDate = "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}";
      
//       if (!historyDates.contains(formattedDate)) {
//         historyDates.add(formattedDate);
//         // Sort dates in descending order (newest first)
//         historyDates.sort((a, b) {
//           DateTime dateA = parseDate(a);
//           DateTime dateB = parseDate(b);
//           return dateB.compareTo(dateA);
//         });
//       } else {
//         Get.snackbar(
//           'Warning',
//           'This date is already added',
//           backgroundColor: Colors.orange,
//           colorText: Colors.white,
//           snackPosition: SnackPosition.BOTTOM,
//         );
//       }
//     }
//   }
  
//   DateTime parseDate(String dateString) {
//     List<String> parts = dateString.split('-');
//     return DateTime(
//       int.parse(parts[2]), // year
//       int.parse(parts[1]), // month
//       int.parse(parts[0]), // day
//     );
//   }
  
//   void removeHistoryDate(int index) {
//     historyDates.removeAt(index);
//   }
  
//   // Dynamic field methods for Structure
//   void addBeddingField() {
//     beddingControllers.add(TextEditingController());
//   }
  
//   void removeBeddingField(int index) {
//     beddingControllers[index].dispose();
//     beddingControllers.removeAt(index);
//   }
  
//   void addJointsField() {
//     jointsControllers.add(TextEditingController());
//   }
  
//   void removeJointsField(int index) {
//     jointsControllers[index].dispose();
//     jointsControllers.removeAt(index);
//   }
  
//   void addRmrField() {
//     rmrControllers.add(TextEditingController());
//   }
  
//   void removeRmrField(int index) {
//     rmrControllers[index].dispose();
//     rmrControllers.removeAt(index);
//   }
  
//   // Date and time selection methods
// // Update the date selection method
// Future<void> selectDate() async {
//   final DateTime? picked = await showDatePicker(
//     context: Get.context!,
//     initialDate: DateTime.now(),
//     firstDate: DateTime(2000),
//     lastDate: DateTime.now(),
//   );
//   if (picked != null) {
//     final formattedDate = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
//     dateController.text = formattedDate;
//     selectedDateText.value = formattedDate; // Update reactive variable
//   }
// }

// // Update the time selection method
// Future<void> selectTime() async {
//   final TimeOfDay? picked = await showTimePicker(
//     context: Get.context!,
//     initialTime: TimeOfDay.now(),
//     builder: (BuildContext context, Widget? child) {
//       return MediaQuery(
//         data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
//         child: child!,
//       );
//     },
//   );
//   if (picked != null) {
//     final formattedTime = "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
//     timeController.text = formattedTime;
//     selectedTimeText.value = formattedTime; // Update reactive variable
//   }
// }
//   // Validation methods
//   String? validateRequired(String? value, String fieldName) {
//     if (value == null || value.trim().isEmpty) {
//       return '$fieldName is required';
//     }
//     return null;
//   }
  
//   String? validateNumber(String? value, String fieldName) {
//     if (value == null || value.trim().isEmpty) {
//       return '$fieldName is required';
//     }
//     if (double.tryParse(value) == null) {
//       return '$fieldName must be a valid number';
//     }
//     return null;
//   }
  
//   bool validateForm() {
//     bool isValid = true;
//     String errorMessage = '';
    
//     // Check required fields
//     if (stateController.text.trim().isEmpty) {
//       errorMessage += 'State is required\n';
//       isValid = false;
//     }
    
//     if (districtController.text.trim().isEmpty) {
//       errorMessage += 'District is required\n';
//       isValid = false;
//     }
    
//     if (landslideOccurrenceValue.value == null) {
//       errorMessage += 'Landslide occurrence is required\n';
//       isValid = false;
//     }
    
//     if (whereDidLandslideOccurValue.value == null) {
//       errorMessage += 'Landslide location type is required\n';
//       isValid = false;
//     }
    
//     if (typeOfMaterialValue.value == null) {
//       errorMessage += 'Type of material is required\n';
//       isValid = false;
//     }
    
//     if (typeOfMovementValue.value == null) {
//       errorMessage += 'Type of movement is required\n';
//       isValid = false;
//     }
    
//     if (lengthController.text.trim().isEmpty) {
//       errorMessage += 'Length is required\n';
//       isValid = false;
//     }
    
//     if (widthController.text.trim().isEmpty) {
//       errorMessage += 'Width is required\n';
//       isValid = false;
//     }
    
//     if (heightController.text.trim().isEmpty) {
//       errorMessage += 'Height is required\n';
//       isValid = false;
//     }
    
//     if (areaController.text.trim().isEmpty) {
//       errorMessage += 'Area is required\n';
//       isValid = false;
//     }
    
//     if (depthController.text.trim().isEmpty) {
//       errorMessage += 'Depth is required\n';
//       isValid = false;
//     }
    
//     if (volumeController.text.trim().isEmpty) {
//       errorMessage += 'Volume is required\n';
//       isValid = false;
//     }
    
//     if (activityValue.value == null) {
//       errorMessage += 'Activity is required\n';
//       isValid = false;
//     }
    
//     if (styleValue.value == null) {
//       errorMessage += 'Style is required\n';
//       isValid = false;
//     }
    
//     if (failureMechanismValue.value == null) {
//       errorMessage += 'Failure mechanism is required\n';
//       isValid = false;
//     }
    
//     if (geologyController.text.trim().isEmpty) {
//       errorMessage += 'Geology is required\n';
//       isValid = false;
//     }
    
//     if (whatInducedLandslideValue.value == null) {
//       errorMessage += 'What induced landslide is required\n';
//       isValid = false;
//     }
    
//     // Check geo-scientific causes - at least one is required
//     if (!geologicalCauses.value && !morphologicalCauses.value && !humanCauses.value && !otherCauses.value) {
//       errorMessage += 'At least one geo-scientific cause is required\n';
//       isValid = false;
//     }
    
//     // Check remedial measures - at least one is required
//     if (!modificationOfSlopeGeometry.value && !drainage.value && !retainingStructures.value && 
//         !internalSlopeReinforcement.value && !remedialMeasuresNotRequired.value && 
//         !remedialMeasuresNotAdequate.value && !otherInformation.value) {
//       errorMessage += 'At least one remedial measure is required\n';
//       isValid = false;
//     }
    
//     if (!isValid) {
//       Get.snackbar(
//         'Validation Error',
//         errorMessage.trim(),
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//         duration: const Duration(seconds: 5),
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     }
    
//     return isValid;
//   }
  
//   // Convert image to base64
//   Future<String> imageToBase64(File imageFile) async {
//     List<int> imageBytes = await imageFile.readAsBytes();
//     return base64Encode(imageBytes);
//   }
  
//   // Submit form
//   Future<void> submitForm() async {
//     if (!validateForm()) return;
    
//     try {
//       isLoading.value = true;
      
//       // Get user data from SharedPreferences
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('token');
//       final mobile = prefs.getString('mobile') ?? '';
//       final userType = prefs.getString('userType') ?? '';
      
//       if (token == null || mobile.isEmpty || userType.isEmpty) {
//         Get.snackbar(
//           'Error',
//           'User authentication data not found. Please login again.',
//           backgroundColor: Colors.red,
//           colorText: Colors.white,
//           snackPosition: SnackPosition.BOTTOM,
//         );
//         return;
//       }
      
//       // Convert first image to base64 (required)
//       String landslidePhotographs = '';
//       if (selectedImages.isNotEmpty) {
//         landslidePhotographs = await imageToBase64(selectedImages.first);
//       }
      
//       // Build the payload
//       Map<String, dynamic> payload = {
//         "Latitude": latitudeController.text.trim(),
//         "Longitude": longitudeController.text.trim(),
//         "State": stateController.text.trim(),
//         "District": districtController.text.trim(),
//         "SubdivisionOrTaluk": subdivisionController.text.trim(),
//         "Village": villageController.text.trim(),
//         "LocationDetails": locationDetailsController.text.trim(),
//        "LandslideDate": dateController.text.trim().isNotEmpty ? formatDateForAPI(dateController.text.trim()) : null,
//        "LandslideTime": timeController.text.trim().isNotEmpty ? formatTimeForAPI(timeController.text.trim()) : null,
//         "LandslidePhotographs": landslidePhotographs,
//         "LanduseOrLandcover": whereDidLandslideOccurValue.value ?? "",
//         "MaterialInvolved": typeOfMaterialValue.value ?? "",
//         "MovementType": typeOfMovementValue.value ?? "",
//         "LengthInMeters": lengthController.text.trim(),
//         "WidthInMeters": widthController.text.trim(),
//         "HeightInMeters": heightController.text.trim(),
//         "AreaInSqMeters": areaController.text.trim(),
//         "DepthInMeters": depthController.text.trim(),
//         "VolumeInCubicMeters": volumeController.text.trim(),
//         "RunOutDistanceInMeters": runoutDistanceController.text.trim().isNotEmpty ? runoutDistanceController.text.trim() : "0.0",
//         "MovementRate": rateOfMovementValue.value ?? "",
//         "Activity": activityValue.value ?? "",
//         "Distribution": distributionValue.value ?? "",
//         "Style": styleValue.value ?? "",
//         "FailureMechanism": failureMechanismValue.value ?? "",
//         "Geomorphology": geomorphologyController.text.trim(),
//         "Geology": geologyController.text.trim(),
//         "Structure": buildStructureString(),
//         "HydrologicalCondition": hydrologicalConditionValue.value ?? "",
//         "InducingFactor": whatInducedLandslideValue.value ?? "",
//         "ImpactOrDamage": buildImpactDamageString(),
//         "GeoScientificCauses": buildGeoScientificCausesString(),
//         "PreliminaryRemedialMeasures": buildRemedialMeasuresString(),
//         "VulnerabilityCategory": alertCategory.value ?? "",
//         "OtherInformation": otherRelevantInformation.text.trim(),
//         "Status": null,
//         "LivestockDead": livestockDeadController.text.trim().isNotEmpty ? livestockDeadController.text.trim() : "0",
//         "LivestockInjured": livestockInjuredController.text.trim().isNotEmpty ? livestockInjuredController.text.trim() : "0",
//         "HousesBuildingfullyaffected": housesFullyController.text.trim().isNotEmpty ? housesFullyController.text.trim() : "0",
//         "HousesBuildingpartialaffected": housesPartiallyController.text.trim().isNotEmpty ? housesPartiallyController.text.trim() : "0",
//         "DamsBarragesCount": damsNameController.text.trim().isNotEmpty ? "1" : "0",
//         "DamsBarragesExtentOfDamage": damsExtentValue.value ?? "",
//         "RoadsAffectedType": roadTypeValue.value ?? "",
//         "RoadsAffectedExtentOfDamage": roadExtentValue.value ?? "",
//         "RoadBlocked": roadBlockageValue.value ?? "",
//         "RoadBenchesAffected": roadBenchesExtentValue.value ?? "",
//         "RailwayLineAffected": railwayDetailsController.text.trim(),
//         "RailwayLineBlockage": railwayBlockageValue.value ?? "",
//         "RailwayBenchesAffected": railwayBenchesExtentValue.value ?? "",
//         "PowerInfrastructureAffected": powerExtentValue.value ?? "",
//         "OthersAffected": otherDamageDetailsController.text.trim(),
//         "History_date": historyDates.isNotEmpty ? historyDates.join(", ") : "NaN-NaN-NaN",
//         "Amount_of_rainfall": "0",
//         "Duration_of_rainfall": "",
//         "Date_and_time_Range": occurrenceDateRangeController.text.trim(),
//         "OtherLandUse": "",
//         "datacreatedby": mobile,
//         "DateTimeType": landslideOccurrenceValue.value ?? "",
//         "LandslidePhotograph1": selectedImages.length > 1 ? await imageToBase64(selectedImages[1]) : null,
//         "LandslidePhotograph2": selectedImages.length > 2 ? await imageToBase64(selectedImages[2]) : null,
//         "LandslidePhotograph3": selectedImages.length > 3 ? await imageToBase64(selectedImages[3]) : null,
//         "LandslidePhotograph4": selectedImages.length > 4 ? await imageToBase64(selectedImages[4]) : null,
//         "check_Status": "Pending",
//         "GSI_User": null,
//         "Rejected_Reason": null,
//         "Reviewed_Date": null,
//         "Reviewed_Time": null,
//         "PeopleDead": peopleDeadController.text.trim().isNotEmpty ? peopleDeadController.text.trim() : "0",
//         "PeopleInjured": peopleInjuredController.text.trim().isNotEmpty ? peopleInjuredController.text.trim() : "0",
//         "LandslideSize": "",
//         "ContactName": "",
//         "ContactAffiliation": "",
//         "ContactEmailId": "",
//         "ContactMobile": mobile,
//         "UserType": userType,
//         "source": "webportal",
//         "u_lat": null,
//         "u_long": null,
//         "LandslideCauses": null,
//         "GeologicalCauses": buildGeologicalCausesString(),
//         "MorphologicalCauses": buildMorphologicalCausesString(),
//         "HumanCauses": buildHumanCausesString(),
//         "CausesOtherInfo": otherCausesController.text.trim(),
//         "WeatheredMaterial": "",
//         "Bedding": buildBeddingString(),
//         "Joint": buildJointsString(),
//         "RMR": buildRmrString(),
//         "ExactDateInfo": howDoYouKnowValue.value ?? "",
//         "RainfallIntensity": null,
//         "SlopeGeometry": buildSlopeGeometryString(),
//         "Drainage": buildDrainageString(),
//         "RetainingStructures": buildRetainingStructuresString(),
//         "InternalSlopeReinforcememt": buildInternalReinforcementString(),
//         "RemedialNotRequired": remedialNotRequiredWhyController.text.trim(),
//         "RemedialNotSufficient": buildRemedialNotSufficientString(),
//         "RemedialOtherInfo": otherInformationController.text.trim(),
//         "ID_project": null,
//         "ID_lan": null,
//         "class_number": null,
//         "class_type": null,
//         "geo_acc": null,
//         "date": null,
//         "date_acc": null,
//         "Realignment": communicationCorridorType.value ?? "",
//         "Toposheet_No": "",
//         "OldSlide_No": null,
//         "Initiation_Year": null,
//         "Slide_No": null,
//         "ImageCaptions": null,
//         "DamsBarragesName": damsNameController.text.trim(),
//       };
      
//       // Make API call
//       await ApiService.postLandslide('/Landslide/create/$mobile/$userType', [payload]);
      
//       Get.snackbar(
//         'Success',
//         'Landslide report submitted successfully!',
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//         snackPosition: SnackPosition.BOTTOM,
//       );
      
//       Get.back(); // Navigate back
      
//     } catch (e) {
//       Get.snackbar(
//         'Error',
//         'Failed to submit report: $e',
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//         snackPosition: SnackPosition.BOTTOM,
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
  
//   // Helper methods to build complex strings for API payload
//   String buildStructureString() {
//     List<String> structures = [];
//     if (bedding.value) structures.add("Bedding");
//     if (joints.value) structures.add("Joints");
//     if (rmr.value) structures.add("RMR");
//     return structures.join(", ");
//   }
  
//   String buildImpactDamageString() {
//     List<String> impacts = [];
//     if (peopleAffected.value) impacts.add("People affected");
//     if (livestockAffected.value) impacts.add("Livestock affected");
//     if (housesBuildingAffected.value) impacts.add("Houses and buildings affected");
//     if (damsBarragesAffected.value) impacts.add("Dams / Barrages affected");
//     if (roadsAffected.value) impacts.add("Roads affected");
//     if (roadsBlocked.value) impacts.add("Roads blocked");
//     if (roadBenchesDamaged.value) impacts.add("Road benches damaged");
//     if (railwayLineAffected.value) impacts.add("Railway line affected");
//     if (railwayBlocked.value) impacts.add("Railway blocked");
//     if (railwayBenchesDamaged.value) impacts.add("Railway benches damaged");
//     if (powerInfrastructureAffected.value) impacts.add("Power infrastructure and telecommunication affected");
//     if (damagesToAgriculturalForestLand.value) impacts.add("Damages to Agriculture/Barren/Forest");
//     if (other.value) impacts.add("Other");
//     if (noDamages.value) impacts.add("No damages");
//     if (iDontKnow.value) impacts.add("I don't know");
//     return impacts.join(", ");
//   }
  
//   String buildGeoScientificCausesString() {
//     List<String> causes = [];
//     if (geologicalCauses.value) causes.add("Geological Causes");
//     if (morphologicalCauses.value) causes.add("Morphological Causes");
//     if (humanCauses.value) causes.add("Human Causes");
//     if (otherCauses.value) causes.add("Other Causes");
//     return causes.join(", ");
//   }
  
//   String buildRemedialMeasuresString() {
//     List<String> measures = [];
//     if (modificationOfSlopeGeometry.value) measures.add("Modification of Slope Geometry");
//     if (drainage.value) measures.add("Drainage");
//     if (retainingStructures.value) measures.add("Retaining Structures");
//     if (internalSlopeReinforcement.value) measures.add("Internal Slope Reinforcement");
//     if (remedialMeasuresNotRequired.value) measures.add("Remedial measures not required");
//     if (remedialMeasuresNotAdequate.value) measures.add("Remedial measures not adequately safeguard the slide");
//     if (otherInformation.value) measures.add("Other Information");
//     return measures.join(", ");
//   }
  
//   String buildGeologicalCausesString() {
//     List<String> causes = [];
//     if (weakOrSensitiveMaterials.value) causes.add("Weak or sensitive materials");
//     if (contrastInPermeability.value) causes.add("Contrast in permeability and/or stiffness of materials");
//     if (geologicalOtherController.text.trim().isNotEmpty) causes.add(geologicalOtherController.text.trim());
//     return causes.join(", ");
//   }
  
//   String buildMorphologicalCausesString() {
//     List<String> causes = [];
//     if (tectonicOrVolcanicUplift.value) causes.add("Tectonic or volcanic uplift");
//     if (glacialRebound.value) causes.add("Glacial rebound");
//     if (fluvialWaveGlacialErosion.value) causes.add("Fluvial, wave, or glacial erosion");
//     if (subterraneanErosion.value) causes.add("Subterranean erosion");
//     if (depositionLoading.value) causes.add("Deposition loading");
//     if (vegetationRemoval.value) causes.add("Vegetation removal");
//     if (thawing.value) causes.add("Thawing");
//     if (morphologicalOtherController.text.trim().isNotEmpty) causes.add(morphologicalOtherController.text.trim());
//     return causes.join(", ");
//   }
  
//   String buildHumanCausesString() {
//     List<String> causes = [];
//     if (excavationOfSlope.value) causes.add("Excavation of slope");
//     if (loadingOfSlope.value) causes.add("Loading of slope");
//     if (drawdown.value) causes.add("Drawdown");
//     if (deforestation.value) causes.add("Deforestation");
//     if (irrigation.value) causes.add("Irrigation");
//     if (mining.value) causes.add("Mining");
//     if (artificialVibration.value) causes.add("Artificial vibration");
//     if (waterLeakage.value) causes.add("Water leakage");
//     if (humanOtherController.text.trim().isNotEmpty) causes.add(humanOtherController.text.trim());
//     return causes.join(", ");
//   }
  
//   String buildBeddingString() {
//     return beddingControllers
//         .map((controller) => controller.text.trim())
//         .where((text) => text.isNotEmpty)
//         .join(", ");
//   }
  
//   String buildJointsString() {
//     return jointsControllers
//         .map((controller) => controller.text.trim())
//         .where((text) => text.isNotEmpty)
//         .join(", ");
//   }
  
//   String buildRmrString() {
//     return rmrControllers
//         .map((controller) => controller.text.trim())
//         .where((text) => text.isNotEmpty)
//         .join(", ");
//   }
  
//   String buildSlopeGeometryString() {
//     List<String> items = [];
//     if (removingMaterial.value) items.add("Removing material");
//     if (addingMaterial.value) items.add("Adding material");
//     if (reducingGeneralSlopeAngle.value) items.add("Reducing general slope angle");
//     if (slopeGeometryOtherController.text.trim().isNotEmpty) items.add(slopeGeometryOtherController.text.trim());
//     return items.join(", ");
//   }
  
//   String buildDrainageString() {
//     List<String> items = [];
//     if (surfaceDrains.value) items.add("Surface drains");
//     if (shallowDeepTrenchDrains.value) items.add("Shallow or deep trench drains");
//     if (buttressCounterfortDrains.value) items.add("Buttress counterfort drains");
//     if (verticalSmallDiameterBoreholes.value) items.add("Vertical small diameter boreholes");
//     if (verticalLargeDiameterWells.value) items.add("Vertical large diameter wells");
//     if (subHorizontalBoreholes.value) items.add("Sub horizontal boreholes");
//     if (drainageTunnels.value) items.add("Drainage tunnels");
//     if (vacuumDewatering.value) items.add("Vacuum dewatering");
//     if (drainageBySiphoning.value) items.add("Drainage by siphoning");
//     if (electroosmoticDewatering.value) items.add("Electro-osmotic dewatering");
//     if (vegetationPlanting.value) items.add("Vegetation planting");
//     if (drainageOtherController.text.trim().isNotEmpty) items.add(drainageOtherController.text.trim());
//     return items.join(", ");
//   }
  
//   String buildRetainingStructuresString() {
//     List<String> items = [];
//     if (gravityRetainingWalls.value) items.add("Gravity retaining walls");
//     if (cribBlockWalls.value) items.add("Crib-block walls");
//     if (gabionWalls.value) items.add("Gabion walls");
//     if (passivePilesPiers.value) items.add("Passive piles, piers and caissons");
//     if (castInSituWalls.value) items.add("Cast-in situ walls");
//     if (reinforcedEarthRetaining.value) items.add("Reinforced earth retaining");
//     if (buttressCounterforts.value) items.add("Buttress counterforts");
//     if (retainingOtherController.text.trim().isNotEmpty) items.add(retainingOtherController.text.trim());
//     return items.join(", ");
//   }
  
//   String buildInternalReinforcementString() {
//     List<String> items = [];
//     if (anchors.value) items.add("Anchors");
//     if (grouting.value) items.add("Grouting");
//     if (internalReinforcementOtherController.text.trim().isNotEmpty) items.add(internalReinforcementOtherController.text.trim());
//     return items.join(", ");
//   }
  
//   String buildRemedialNotSufficientString() {
//     List<String> items = [];
//     if (shiftingOfVillage.value) items.add("Shifting of village");
//     if (evacuationOfInfrastructure.value) items.add("Evacuation of infrastructure");
//     if (realignmentOfCommunicationCorridors.value) items.add("Realignment of communication corridors");
//     if (notAdequateOtherController.text.trim().isNotEmpty) items.add(notAdequateOtherController.text.trim());
//     return items.join(", ");
//   }
// }