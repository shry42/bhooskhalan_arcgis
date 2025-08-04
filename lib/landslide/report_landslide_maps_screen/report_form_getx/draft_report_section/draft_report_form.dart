import 'package:bhooskhalann/landslide/report_landslide_maps_screen/report_form_getx/draft_report_section/draft_report_form_controller.dart';
import 'package:bhooskhalann/landslide/report_landslide_maps_screen/widgets/show_activity_dialog.dart';
import 'package:bhooskhalann/landslide/report_landslide_maps_screen/widgets/show_alert_category_dialog.dart';
import 'package:bhooskhalann/landslide/report_landslide_maps_screen/widgets/show_distribution_dialog.dart';
import 'package:bhooskhalann/landslide/report_landslide_maps_screen/widgets/show_hydrological_condition_dialog.dart';
import 'package:bhooskhalann/landslide/report_landslide_maps_screen/widgets/show_material_type_dialog.dart';
import 'package:bhooskhalann/landslide/report_landslide_maps_screen/widgets/show_movement_type_dialog.dart';
import 'package:bhooskhalann/landslide/report_landslide_maps_screen/widgets/show_rate_of_movement_dialog.dart';
import 'package:bhooskhalann/landslide/report_landslide_maps_screen/widgets/show_style_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LandslideReportingScreen extends StatelessWidget {
  const LandslideReportingScreen({Key? key, required this.latitude, required this.longitude}) : super(key: key);
  
  final double latitude;
  final double longitude;

  @override
  Widget build(BuildContext context) {
    // Initialize controller with coordinates
    final controller = Get.put(LandslideReportController());
    controller.setCoordinates(latitude, longitude);
    
    // Colors for professional appearance
    final Color primaryColor = const Color(0xFF1976D2);
    final Color secondaryColor = const Color(0xFF64B5F6);
    final Color backgroundColor = const Color(0xFFF5F7FA);
    final Color cardColor = Colors.white;
    final Color textColor = const Color(0xFF2C3E50);
    final Color hintColor = const Color(0xFF7F8C8D);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
    title: Obx(() => Text(
  controller.isDraftMode.value 
    ? 'edit_draft_report_expert'.tr 
    : controller.isPendingEditMode.value 
      ? 'edit_pending_report_expert'.tr
      : 'report_landslide_expert'.tr,
  style: const TextStyle(fontWeight: FontWeight.w600),
)),
        actions: [
          Obx(() => TextButton(
            onPressed: () => controller.saveDraft(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  controller.isDraftMode.value ? Icons.update : Icons.save,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  controller.isDraftMode.value ? 'update'.tr : 'save'.tr,
                  style: const TextStyle(
                    color: Colors.white, 
                    fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
      body: Obx(() => controller.isLoading.value
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: primaryColor),
                  const SizedBox(height: 16),
                  Text(
                    'submitting_report'.tr,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : Form(
              key: controller.formKey,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  // Draft Status Banner (if applicable)
                  Obx(() {
                    if (controller.isDraftMode.value) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: primaryColor.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.drafts, color: primaryColor, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'editing_draft_expert_message'.tr,
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),

                  // Location Information Section
        // Location Information Section - REPLACE the existing section with this
_buildSectionCard(
  title: 'location_information'.tr,
  primaryColor: primaryColor,
  cardColor: cardColor,
  textColor: textColor,
  children: [
    _buildTextField(
      label: 'latitude_required'.tr,
      controller: controller.latitudeController,
      readOnly: true,
      validator: (value) => controller.validateRequired(value, 'latitude'.tr),
    ),
    const SizedBox(height: 16),
    _buildTextField(
      label: 'longitude_required'.tr,
      controller: controller.longitudeController,
      readOnly: true,
      validator: (value) => controller.validateRequired(value, 'longitude'.tr),
    ),
    const SizedBox(height: 16),

    // Add this line right after the Longitude field and before the State field
_buildLocationModeSwitch(controller, primaryColor),
    
    // State Field - Conditional UI
    Obx(() {
      if (controller.isLocationAutoPopulated.value && controller.stateController.text.isNotEmpty) {
        // Show text field when auto-populated
        return _buildTextField(
          label: 'state_required'.tr,
          controller: controller.stateController,
          readOnly: true,
          validator: (value) => controller.validateRequired(value, 'state'.tr),
        );
      } else {
        // Show dropdown when manual selection needed
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _labelText('state_required'.tr, textColor),
            _buildDropdown(
              hint: 'select_state'.tr,
              value: controller.selectedStateFromDropdown.value,
              items: controller.indianStates,
              onChanged: (value) => controller.onStateSelected(value),
              icon: Icons.location_on,
            ),
          ],
        );
      }
    }),
    
    const SizedBox(height: 16),
    
    // District Field - Conditional UI
    Obx(() {
      if (controller.isLocationAutoPopulated.value && controller.districtController.text.isNotEmpty) {
        // Show text field when auto-populated
        return _buildTextField(
          label: 'district_required'.tr,
          controller: controller.districtController,
          readOnly: true,
          validator: (value) => controller.validateRequired(value, 'district'.tr),
        );
      } else {
        // Show dropdown when manual selection needed
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _labelText('district_required'.tr, textColor),
            _buildDropdown(
              hint: controller.selectedStateFromDropdown.value == null 
                  ? 'select_state_first'.tr 
                  : 'select_district'.tr,
              value: controller.selectedDistrictFromDropdown.value,
              items: controller.getDistrictsForState(controller.selectedStateFromDropdown.value),
              onChanged: controller.selectedStateFromDropdown.value == null 
                  ? null 
                  : (value) => controller.onDistrictSelected(value),
              icon: Icons.location_city,
            ),
          ],
        );
      }
    }),
    
    const SizedBox(height: 16),
    _buildTextField(
      label: 'subdivision_taluk'.tr,
      controller: controller.subdivisionController,
    ),
    const SizedBox(height: 16),
    _buildTextField(
      label: 'village'.tr,
      controller: controller.villageController,
    ),
    const SizedBox(height: 16),
    _buildTextField(
      label: 'other_relevant_location_details_landmark'.tr,
      controller: controller.locationDetailsController,
      maxLines: 3,
    ),
  ],
),        
                  const SizedBox(height: 16),
                  
                  // Occurrence Information Section
                  _buildSectionCard(
                    title: 'occurrence_of_landslide_datetime_required'.tr,
                    primaryColor: primaryColor,
                    cardColor: cardColor,
                    textColor: textColor,
                    children: [
                      Obx(() => _buildDropdown(
                        hint: 'select_occurrence_option'.tr,
                        value: controller.getTranslatedValueForDisplay(controller.landslideOccurrenceValue.value, LandslideReportController.landslideOccurrenceOptions),
                        items: LandslideReportController.landslideOccurrenceOptions.map((key) => key.tr).toList(),
                        onChanged: (value) {
                          // Convert translated value back to English key
                          String? englishKey = controller.getEnglishKeyFromTranslatedValue(value, LandslideReportController.landslideOccurrenceOptions);
                          controller.landslideOccurrenceValue.value = englishKey;
                          controller.dateController.clear();
                          controller.timeController.clear();
                          controller.howDoYouKnowValue.value = null;
                          // controller.occurrenceDateRangeController.clear();
                        },
                        icon: Icons.event,
                      )),
                      
                      // Conditional fields based on selection
                      Obx(() {
                        if (controller.landslideOccurrenceValue.value == 'exact_occurrence_date') {
                          return Column(
                            children: [
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        _labelText('date_required'.tr, textColor),
                                        GestureDetector(
                                          onTap: () => controller.selectDate(),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: Colors.grey[300]!),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  controller.selectedDateText.value.isEmpty ? 'select_date'.tr : controller.selectedDateText.value,
                                                  style: TextStyle(
                                                    color: controller.selectedDateText.value.isEmpty ? Colors.grey[600] : Colors.black,
                                                  ),
                                                ),
                                                Icon(Icons.calendar_today, color: Colors.grey[600]),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        _labelText('time'.tr, textColor),
                                        GestureDetector(
                                          onTap: () => controller.selectTime(),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: Colors.grey[300]!),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  controller.selectedTimeText.value.isEmpty ? 'select_time'.tr : controller.selectedTimeText.value,
                                                  style: TextStyle(
                                                    color: controller.selectedTimeText.value.isEmpty ? Colors.grey[600] : Colors.black,
                                                  ),
                                                ),
                                                Icon(Icons.access_time, color: Colors.grey[600]),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _labelText('how_do_you_know_info_required'.tr, textColor),
                              _buildDropdown(
                                hint: 'select_source'.tr,
                                value: controller.getTranslatedValueForDisplay(controller.howDoYouKnowValue.value, LandslideReportController.howDoYouKnowOptions),
                                items: LandslideReportController.howDoYouKnowOptions.map((key) => key.tr).toList(),
                                onChanged: (value) {
                                  // Convert translated value back to English key
                                  String? englishKey = controller.getEnglishKeyFromTranslatedValue(value, LandslideReportController.howDoYouKnowOptions);
                                  controller.howDoYouKnowValue.value = englishKey;
                                },
                                icon: Icons.info,
                              ),
                            ],
                          );
                       } else if (controller.landslideOccurrenceValue.value == 'I know the APPROXIMATE occurrence date') {
  return Column(
    children: [
      const SizedBox(height: 16),
      _labelText('occurrence_date_range_required'.tr, textColor),
      _buildDropdown(
        hint: 'select_occurrence_option'.tr,
        value: controller.occurrenceDateRange.value.isEmpty ? null : controller.occurrenceDateRange.value,
        items: [
          'last_3_days'.tr,
          'last_week'.tr, 
          'last_month'.tr,
          'last_3_months'.tr,
          'last_year'.tr,
          'older_than_year'.tr,                        
        ],
        onChanged: (value) => controller.occurrenceDateRange.value = value ?? '',
        icon: Icons.date_range,
      ),
    ],
  );
}
                        
                        return const SizedBox.shrink();
                      }),           
           
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Landslide Location Type
                  _buildSectionCard(
                    title: 'where_landslide_occurred_landuse_required'.tr,
                    primaryColor: primaryColor,
                    cardColor: cardColor,
                    textColor: textColor,
                    children: [
                      Obx(() => _buildDropdown(
                        hint: 'select_location_type'.tr,
                        value: controller.getTranslatedValueForDisplay(controller.whereDidLandslideOccurValue.value, LandslideReportController.whereDidLandslideOccurOptions),
                        items: LandslideReportController.whereDidLandslideOccurOptions.map((key) => key.tr).toList(),
                        onChanged: (value) {
                          // Convert translated value back to English key
                          String? englishKey = controller.getEnglishKeyFromTranslatedValue(value, LandslideReportController.whereDidLandslideOccurOptions);
                          controller.whereDidLandslideOccurValue.value = englishKey;
                        },
                        icon: Icons.landscape,
                      )),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Type of Material
                  _buildSectionCard(
                    title: 'type_of_material_required'.tr,
                    primaryColor: primaryColor,
                    cardColor: cardColor,
                    textColor: textColor,
                    children: [
                      Obx(() => _buildDropdown(
                        hint: 'select_material_type'.tr,
                        value: controller.getTranslatedValueForDisplay(controller.typeOfMaterialValue.value, LandslideReportController.typeOfMaterialOptions),
                        items: LandslideReportController.typeOfMaterialOptions.map((key) => key.tr).toList(),
                        onChanged: (value) {
                          // Convert translated value back to English key
                          String? englishKey = controller.getEnglishKeyFromTranslatedValue(value, LandslideReportController.typeOfMaterialOptions);
                          controller.typeOfMaterialValue.value = englishKey;
                        },
                        icon: Icons.move_down,
                        hasInfoIcon: true,
                        onInfoTap: () => showMaterialTypeDialog(context),
                      )),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Type of Movement
                  _buildSectionCard(
                    title: 'type_of_movement_required'.tr,
                    primaryColor: primaryColor,
                    cardColor: cardColor,
                    textColor: textColor,
                    children: [
                      Obx(() => _buildDropdown(
                        hint: 'select_movement_type'.tr,
                        value: controller.getTranslatedValueForDisplay(controller.typeOfMovementValue.value, LandslideReportController.typeOfMovementOptions),
                        items: LandslideReportController.typeOfMovementOptions.map((key) => key.tr).toList(),
                        onChanged: (value) {
                          // Convert translated value back to English key
                          String? englishKey = controller.getEnglishKeyFromTranslatedValue(value, LandslideReportController.typeOfMovementOptions);
                          controller.typeOfMovementValue.value = englishKey;
                        },
                        icon: Icons.move_down,
                        hasInfoIcon: true,
                        onInfoTap: () => showMovementTypeDialog(context),
                      )),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Dimensions Section
                  _buildSectionCard(
                    title: 'dimensions'.tr,
                    primaryColor: primaryColor,
                    cardColor: cardColor,
                    textColor: textColor,
                    children: [
                      _buildTextField(
                        label: 'length_meters_required'.tr,
                        controller: controller.lengthController,
                        keyboardType: TextInputType.number,
                        hasInfoIcon: true,
                        onInfoTap: () => _showDimensionsDialog(context),
                        validator: (value) => controller.validateNumber(value, 'length'.tr),
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'width_meters_required'.tr,
                        controller: controller.widthController,
                        keyboardType: TextInputType.number,
                        hasInfoIcon: true,
                        onInfoTap: () => _showDimensionsDialog(context),
                        validator: (value) => controller.validateNumber(value, 'width'.tr),
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'height_meters_required'.tr,
                        controller: controller.heightController,
                        keyboardType: TextInputType.number,
                        hasInfoIcon: true,
                        onInfoTap: () => _showDimensionsDialog(context),
                        validator: (value) => controller.validateNumber(value, 'height'.tr),
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        readOnly: true,
                        label: 'area_sq_meters_required'.tr,
                        controller: controller.areaController,
                        keyboardType: TextInputType.number,
                        validator: (value) => controller.validateNumber(value, 'area'.tr),
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'depth_meters_required'.tr,
                        controller: controller.depthController,
                        keyboardType: TextInputType.number,
                        validator: (value) => controller.validateNumber(value, 'depth'.tr),
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        readOnly: true,
                        label: 'volume_cubic_meters_required'.tr,
                        controller: controller.volumeController,
                        keyboardType: TextInputType.number,
                        validator: (value) => controller.validateNumber(value, 'volume'.tr),
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'runout_distance_meters'.tr,
                        controller: controller.runoutDistanceController,
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Rate of Movement
                  _buildSectionCard(
                    title: 'rate_of_movement'.tr,
                    primaryColor: primaryColor,
                    cardColor: cardColor,
                    textColor: textColor,
                    children: [
                      Obx(() => _buildDropdown(
                        hint: 'select_rate_movement'.tr,
                        value: controller.getTranslatedValueForDisplay(controller.rateOfMovementValue.value, LandslideReportController.rateOfMovementOptions),
                        items: LandslideReportController.rateOfMovementOptions.map((key) => key.tr).toList(),
                        onChanged: (value) {
                          // Convert translated value back to English key
                          String? englishKey = controller.getEnglishKeyFromTranslatedValue(value, LandslideReportController.rateOfMovementOptions);
                          controller.rateOfMovementValue.value = englishKey;
                        },
                        icon: Icons.speed,
                        hasInfoIcon: true,
                        onInfoTap: () => showRateOfMovementDialog(context),
                      )),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Activity
                  _buildSectionCard(
                    title: 'activity_required'.tr,
                    primaryColor: primaryColor,
                    cardColor: cardColor,
                    textColor: textColor,
                    children: [
                      Obx(() => _buildDropdown(
                        hint: 'select_activity_status'.tr,
                        value: controller.getTranslatedValueForDisplay(controller.activityValue.value, LandslideReportController.activityOptions),
                        items: LandslideReportController.activityOptions.map((key) => key.tr).toList(),
                        onChanged: (value) {
                          // Convert translated value back to English key
                          String? englishKey = controller.getEnglishKeyFromTranslatedValue(value, LandslideReportController.activityOptions);
                          controller.activityValue.value = englishKey;
                        },
                        icon: Icons.monitor_heart,
                        hasInfoIcon: true,
                        onInfoTap: () => showActivityDialog(context),
                      )),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Distribution
                  _buildSectionCard(
                    title: 'distribution'.tr,
                    primaryColor: primaryColor,
                    cardColor: cardColor,
                    textColor: textColor,
                    children: [
                      Obx(() => _buildDropdown(
                        hint: 'select_distribution_pattern'.tr,
                        value: controller.getTranslatedValueForDisplay(controller.distributionValue.value, LandslideReportController.distributionOptions),
                        items: LandslideReportController.distributionOptions.map((key) => key.tr).toList(),
                        onChanged: (value) {
                          // Convert translated value back to English key
                          String? englishKey = controller.getEnglishKeyFromTranslatedValue(value, LandslideReportController.distributionOptions);
                          controller.distributionValue.value = englishKey;
                        },
                        icon: Icons.scatter_plot,
                        hasInfoIcon: true,
                        onInfoTap: () => showDistributionDialog(context),
                      )),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Style
                  _buildSectionCard(
                    title: 'style_required'.tr,
                    primaryColor: primaryColor,
                    cardColor: cardColor,
                    textColor: textColor,
                    children: [
                      Obx(() => _buildDropdown(
                        hint: 'select_style'.tr,
                        value: controller.getTranslatedValueForDisplay(controller.styleValue.value, LandslideReportController.styleOptions),
                        items: LandslideReportController.styleOptions.map((key) => key.tr).toList(),
                        onChanged: (value) {
                          // Convert translated value back to English key
                          String? englishKey = controller.getEnglishKeyFromTranslatedValue(value, LandslideReportController.styleOptions);
                          controller.styleValue.value = englishKey;
                        },
                        icon: Icons.style,
                        hasInfoIcon: true,
                        onInfoTap: () => showStyleDialog(context),
                      )),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Failure Mechanism
                  _buildSectionCard(
                    title: 'failure_mechanism_required'.tr,
                    primaryColor: primaryColor,
                    cardColor: cardColor,
                    textColor: textColor,
                    children: [
                      Obx(() => _buildDropdown(
                        hint: 'select_failure_mechanism'.tr,
                        value: controller.getTranslatedValueForDisplay(controller.failureMechanismValue.value, LandslideReportController.failureMechanismOptions),
                        items: LandslideReportController.failureMechanismOptions.map((key) => key.tr).toList(),
                        onChanged: (value) {
                          // Convert translated value back to English key
                          String? englishKey = controller.getEnglishKeyFromTranslatedValue(value, LandslideReportController.failureMechanismOptions);
                          controller.failureMechanismValue.value = englishKey;
                        },
                        icon: Icons.broken_image,
                      )),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // History
                  _buildSectionCard(
                    title: 'history'.tr,
                    primaryColor: primaryColor,
                    cardColor: cardColor,
                    textColor: textColor,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'dates_past_movement_reactivation'.tr,
                            style: TextStyle(
                              color: hintColor,
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Display selected dates
                          Obx(() {
                            if (controller.historyDates.isNotEmpty) {
                              return Column(
                                children: [
                                  ...List.generate(controller.historyDates.length, (index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 12.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[100],
                                                borderRadius: BorderRadius.circular(8),
                                                border: Border.all(color: Colors.grey[300]!),
                                              ),
                                              child: Text(
                                                controller.historyDates[index],
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          GestureDetector(
                                            onTap: () => controller.removeHistoryDate(index),
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[400],
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                  const SizedBox(height: 12),
                                ],
                              );
                            }
                            return const SizedBox.shrink();
                          }),
                          
                          // Add date button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 2,
                                ),
                                onPressed: () => controller.selectHistoryDate(),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.add, size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      'add_date'.tr,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          
                          // Show placeholder text when no dates are added
                          Obx(() {
                            if (controller.historyDates.isEmpty) {
                              return Container(
                                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: primaryColor.withOpacity(0.3)),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.history, color: primaryColor),
                                    const SizedBox(width: 12),
                                    Text(
                                      'no_historical_dates_added'.tr,
                                      style: TextStyle(color: hintColor, fontSize: 15),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          }),
                        ],
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Geomorphology      
                  _buildSectionCard(
                    title: 'geomorphology'.tr,
                    primaryColor: primaryColor,
                    cardColor: cardColor,
                    textColor: textColor,
                    children: [
                      _buildTextField(
                        label: 'enter_geomorphology'.tr,
                        controller: controller.geomorphologyController,
                        maxLines: 2,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Geology
                  _buildSectionCard(
                    title: 'geology'.tr,
                    primaryColor: primaryColor,
                    cardColor: cardColor,
                    textColor: textColor,
                    children: [
                      _buildTextField(
                        label: 'enter_geology_details'.tr,
                        controller: controller.geologyController,
                        maxLines: 2,
                        // validator: (value) => controller.validateRequired(value, 'Geology'),
                      ),
                    ],
                  ),
                  
                  // Structure - Show only for Rock material
                  Obx(() {
                    if (controller.isRockSelected()) {
                      return Column(
                        children: [
                          const SizedBox(height: 16),
                          _buildSectionCard(
                            title: 'structure_required'.tr,  // Add asterisk to show it's mandatory for Rock
                            primaryColor: primaryColor,
                            cardColor: cardColor,
                            textColor: textColor,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.orange.shade300),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.warning, color: Colors.orange.shade700, size: 20),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'structure_mandatory_rock'.tr,
                                        style: TextStyle(
                                          color: Colors.orange.shade700,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Obx(() => _buildStructureCheckboxWithFields(
                                title: 'bedding'.tr,
                                value: controller.bedding.value,
                                onChanged: (value) {
                                  controller.bedding.value = value ?? false;
                                  if (!controller.bedding.value) {
                                    for (var ctrl in controller.beddingControllers) {
                                      ctrl.dispose();
                                    }
                                    controller.beddingControllers.clear();
                                  } else if (controller.beddingControllers.isEmpty) {
                                    controller.addBeddingField();
                                  }
                                },
                                controllers: controller.beddingControllers,
                                onAddField: () => controller.addBeddingField(),
                                onRemoveField: (index) => controller.removeBeddingField(index),
                                primaryColor: primaryColor,
                                textColor: textColor,
                              )),
                              const SizedBox(height: 16),
                              
                              Obx(() => _buildStructureCheckboxWithFields(
                                title: 'joints'.tr,
                                value: controller.joints.value,
                                onChanged: (value) {
                                  controller.joints.value = value ?? false;
                                  if (!controller.joints.value) {
                                    for (var ctrl in controller.jointsControllers) {
                                      ctrl.dispose();
                                    }
                                    controller.jointsControllers.clear();
                                  } else if (controller.jointsControllers.isEmpty) {
                                    controller.addJointsField();
                                  }
                                },
                                controllers: controller.jointsControllers,
                                onAddField: () => controller.addJointsField(),
                                onRemoveField: (index) => controller.removeJointsField(index),
                                primaryColor: primaryColor,
                                textColor: textColor,
                              )),
                              const SizedBox(height: 16),
                              
                              Obx(() => _buildStructureCheckboxWithFields(
                                title: 'rmr'.tr,
                                value: controller.rmr.value,
                                onChanged: (value) {
                                  controller.rmr.value = value ?? false;
                                  if (!controller.rmr.value) {
                                    for (var ctrl in controller.rmrControllers) {
                                      ctrl.dispose();
                                    }
                                    controller.rmrControllers.clear();
                                  } else if (controller.rmrControllers.isEmpty) {
                                    controller.addRmrField();
                                  }
                                },
                                controllers: controller.rmrControllers,
                                onAddField: () => controller.addRmrField(),
                                onRemoveField: (index) => controller.removeRmrField(index),
                                primaryColor: primaryColor,
                                textColor: textColor,
                              )),
                            ],
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                
                  const SizedBox(height: 16),
                  
                  // Hydrological Condition
                  _buildSectionCard(
                    title: 'hydrological_condition'.tr,
                    primaryColor: primaryColor,
                    cardColor: cardColor,
                    textColor: textColor,
                    children: [
                      Obx(() => _buildDropdown(
                        hint: 'select_hydrological_condition'.tr,
                        value: controller.getTranslatedValueForDisplay(controller.hydrologicalConditionValue.value, LandslideReportController.hydrologicalConditionOptions),
                        items: LandslideReportController.hydrologicalConditionOptions.map((key) => key.tr).toList(),
                        onChanged: (value) {
                          // Convert translated value back to English key
                          String? englishKey = controller.getEnglishKeyFromTranslatedValue(value, LandslideReportController.hydrologicalConditionOptions);
                          controller.hydrologicalConditionValue.value = englishKey;
                        },
                        icon: Icons.water_drop,
                        hasInfoIcon: true,
                        onInfoTap: () => showHydrologicalConditionDialog(context),
                      )),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                 // What induced/triggered the landslide
// What induced/triggered the landslide
_buildSectionCard(
  title: 'what_induced_landslide_required'.tr,
  primaryColor: primaryColor,
  cardColor: cardColor,
  textColor: textColor,
  children: [
    Obx(() => _buildDropdown(
      hint: 'select_trigger'.tr,
      value: controller.getTranslatedValueForDisplay(controller.whatInducedLandslideValue.value, LandslideReportController.whatInducedLandslideOptions),
      items: LandslideReportController.whatInducedLandslideOptions.map((key) => key.tr).toList(),
      onChanged: (value) {
        // Convert translated value back to English key
        String? englishKey = controller.getEnglishKeyFromTranslatedValue(value, LandslideReportController.whatInducedLandslideOptions);
        controller.whatInducedLandslideValue.value = englishKey;
        // Clear rainfall fields if not rainfall
        if (englishKey != 'rainfall') {
          controller.rainfallAmountController.clear();
          controller.rainfallDurationValue.value = null;
        }
      },
      icon: Icons.warning_amber,
    )),
    
    // Conditional rainfall fields
    Obx(() {
      if (controller.whatInducedLandslideValue.value == 'rainfall') {
        return Column(
          children: [
            const SizedBox(height: 20),
            
            // Amount of rainfall
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _labelText('amount_rainfall_mm'.tr, textColor),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: TextField(
                    controller: controller.rainfallAmountController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: InputBorder.none,
                      hintText: 'enter_amount_rainfall'.tr,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Duration of rainfall
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _labelText('duration_of_rainfall'.tr, textColor),
                const SizedBox(height: 12),
                
                // Radio button options
                _buildRainfallDurationOption(
                  'no_rainfall_day_landslide'.tr,
                  controller,
                  primaryColor,
                ),
                _buildRainfallDurationOption(
                  'half_day_or_less'.tr,
                  controller,
                  primaryColor,
                ),
                _buildRainfallDurationOption(
                  'whole_day'.tr,
                  controller,
                  primaryColor,
                ),
                _buildRainfallDurationOption(
                  'few_days_less_week'.tr,
                  controller,
                  primaryColor,
                ),
                _buildRainfallDurationOption(
                  'week_or_more'.tr,
                  controller,
                  primaryColor,
                ),
                _buildRainfallDurationOption(
                  'i_dont_know'.tr,
                  controller,
                  primaryColor,
                ),
              ],
            ),
          ],
        );
      }
      return const SizedBox.shrink();
    }),
  ],
),                 
                  const SizedBox(height: 16),

                  // Geo-Scientific causes
                  _buildSectionCard(
                    title: 'geo_scientific_causes_required'.tr,
                    primaryColor: primaryColor,
                    cardColor: cardColor,
                    textColor: textColor,
                    children: [
                      Obx(() => _buildHierarchicalCheckbox(
                        title: 'geological_causes'.tr,
                        value: controller.geologicalCauses.value,
                        onChanged: (value) {
                          controller.geologicalCauses.value = value ?? false;
                          if (!controller.geologicalCauses.value) {
                            controller.weakOrSensitiveMaterials.value = false;
                            controller.contrastInPermeability.value = false;
                            controller.shearedJointedFissuredMaterials.value = false;
                            controller.adverselyOrientedDiscontinuity.value = false;
                            controller.weatheredMaterialsValue.value = null;
                            controller.geologicalOtherController.clear();
                          }
                        },
                        subItems: controller.geologicalCauses.value ? [
                          Obx(() => _buildSubCheckbox(
                            title: 'weak_sensitive_materials'.tr,
                            value: controller.weakOrSensitiveMaterials.value,
                            onChanged: (value) => controller.weakOrSensitiveMaterials.value = value ?? false,
                            primaryColor: primaryColor,
                            textColor: textColor,
                          )),
                          
                          // Show weathered materials only for Rock
                          Obx(() {
                            if (controller.isRockSelected() && controller.geologicalCauses.value) {
                              return Column(
                                children: [
                                  const SizedBox(height: 12),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 36.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        _labelText('weathered_materials'.tr, textColor),
                                        _buildDropdown(
                                          hint: 'select_weathering_grade'.tr,
                                          value: controller.getTranslatedValueForDisplay(controller.weatheredMaterialsValue.value, LandslideReportController.weatheringGradeOptions),
                                          items: LandslideReportController.weatheringGradeOptions.map((key) => key.tr).toList(),
                                          onChanged: (value) {
                                            // Convert translated value back to English key
                                            String? englishKey = controller.getEnglishKeyFromTranslatedValue(value, LandslideReportController.weatheringGradeOptions);
                                            controller.weatheredMaterialsValue.value = englishKey;
                                          },
                                          icon: Icons.layers,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }
                            return const SizedBox.shrink();
                          }),

                          // Show additional Rock-only options
                          Obx(() {
                            if (controller.isRockSelected() && controller.geologicalCauses.value) {
                              return Column(
                                children: [
                                  Obx(() => _buildSubCheckbox(
                                    title: 'sheared_jointed_fissured'.tr,
                                    value: controller.shearedJointedFissuredMaterials.value,
                                    onChanged: (value) => controller.shearedJointedFissuredMaterials.value = value ?? false,
                                    primaryColor: primaryColor,
                                    textColor: textColor,
                                  )),
                                  Obx(() => _buildSubCheckbox(
                                    title: 'adversely_oriented_discontinuity'.tr,
                                    value: controller.adverselyOrientedDiscontinuity.value,
                                    onChanged: (value) => controller.adverselyOrientedDiscontinuity.value = value ?? false,
                                    primaryColor: primaryColor,
                                    textColor: textColor,
                                  )),
                                ],
                              );
                            }
                            return const SizedBox.shrink();
                          }),
                          
                          Obx(() => _buildSubCheckbox(
                            title: 'contrast_permeability_stiffness'.tr,
                            value: controller.contrastInPermeability.value,
                            onChanged: (value) => controller.contrastInPermeability.value = value ?? false,
                            primaryColor: primaryColor,
                            textColor: textColor,
                          )),
                          
                          const SizedBox(height: 8),
                          _buildOtherTextField(
                            label: 'other'.tr,
                            controller: controller.geologicalOtherController,
                            primaryColor: primaryColor,
                          ),
                        ] : [],
                        primaryColor: primaryColor,
                        textColor: textColor,
                      )),
                      const SizedBox(height: 16),
                      
                      Obx(() => _buildHierarchicalCheckbox(
                        title: 'morphological_causes'.tr,
                        value: controller.morphologicalCauses.value,
                        onChanged: (value) {
                          controller.morphologicalCauses.value = value ?? false;
                          if (!controller.morphologicalCauses.value) {
                            controller.tectonicOrVolcanicUplift.value = false;
                            controller.glacialRebound.value = false;
                            controller.fluvialWaveGlacialErosion.value = false;
                            controller.subterraneanErosion.value = false;
                            controller.depositionLoading.value = false;
                            controller.vegetationRemoval.value = false;
                            controller.thawing.value = false;
                            controller.freezeThawWeathering.value = false;
                            controller.shrinkSwellWeathering.value = false;
                            controller.morphologicalOtherController.clear();
                          }
                        },
                        subItems: controller.morphologicalCauses.value ? [
                          Obx(() => _buildSubCheckbox(
                            title: 'tectonic_volcanic_uplift'.tr,
                            value: controller.tectonicOrVolcanicUplift.value,
                            onChanged: (value) => controller.tectonicOrVolcanicUplift.value = value ?? false,
                            primaryColor: primaryColor,
                            textColor: textColor,
                          )),
                          Obx(() => _buildSubCheckbox(
                            title: 'glacial_rebound'.tr,
                            value: controller.glacialRebound.value,
                            onChanged: (value) => controller.glacialRebound.value = value ?? false,
                            primaryColor: primaryColor,
                            textColor: textColor,
                          )),
                          Obx(() => _buildSubCheckbox(
                            title: 'fluvial_wave_glacial_erosion'.tr,
                            value: controller.fluvialWaveGlacialErosion.value,
                            onChanged: (value) => controller.fluvialWaveGlacialErosion.value = value ?? false,
                            primaryColor: primaryColor,
                            textColor: textColor,
                          )),
                          Obx(() => _buildSubCheckbox(
                            title: 'subterranean_erosion'.tr,
                            value: controller.subterraneanErosion.value,
                            onChanged: (value) => controller.subterraneanErosion.value = value ?? false,
                            primaryColor: primaryColor,
                            textColor: textColor,
                          )),
                          Obx(() => _buildSubCheckbox(
                            title: 'deposition_loading_slope'.tr,
                            value: controller.depositionLoading.value,
                            onChanged: (value) => controller.depositionLoading.value = value ?? false,
                            primaryColor: primaryColor,
                            textColor: textColor,
                          )),
                          Obx(() => _buildSubCheckbox(
                            title: 'vegetation_removal_fire_drought'.tr,
                            value: controller.vegetationRemoval.value,
                            onChanged: (value) => controller.vegetationRemoval.value = value ?? false,
                            primaryColor: primaryColor,
                            textColor: textColor,
                          )),
                          Obx(() => _buildSubCheckbox(
                            title: 'thawing'.tr,
                            value: controller.thawing.value,
                            onChanged: (value) => controller.thawing.value = value ?? false,
                            primaryColor: primaryColor,
                            textColor: textColor,
                          )),
                          
                          // Rock-only option
                          Obx(() {
                            if (controller.isRockSelected() && controller.morphologicalCauses.value) {
                              return Obx(() => _buildSubCheckbox(
                                title: 'freeze_thaw_weathering'.tr,
                                value: controller.freezeThawWeathering.value,
                                onChanged: (value) => controller.freezeThawWeathering.value = value ?? false,
                                primaryColor: primaryColor,
                                textColor: textColor,
                              ));
                            }
                            return const SizedBox.shrink();
                          }),

                          // Soil-only option
                          Obx(() {
                            if (controller.isSoilSelected() && controller.morphologicalCauses.value) {
                              return Obx(() => _buildSubCheckbox(
                                title: 'shrink_swell_weathering'.tr,
                                value: controller.shrinkSwellWeathering.value,
                                onChanged: (value) => controller.shrinkSwellWeathering.value = value ?? false,
                                primaryColor: primaryColor,
                                textColor: textColor,
                              ));
                            }
                            return const SizedBox.shrink();
                          }),
                          
                          const SizedBox(height: 8),
                          _buildOtherTextField(
                            label: 'other'.tr,
                            controller: controller.morphologicalOtherController,
                            primaryColor: primaryColor,
                          ),
                        ] : [],
                        primaryColor: primaryColor,
                        textColor: textColor,
                      )),
                      const SizedBox(height: 16),
                      
                      Obx(() => _buildHierarchicalCheckbox(
                        title: 'human_causes'.tr,
                        value: controller.humanCauses.value,
                        onChanged: (value) {
                          controller.humanCauses.value = value ?? false;
                          if (!controller.humanCauses.value) {
                            controller.excavationOfSlope.value = false;
                            controller.loadingOfSlope.value = false;
                            controller.drawdown.value = false;
                            controller.deforestation.value = false;
                            controller.irrigation.value = false;
                            controller.mining.value = false;
                            controller.artificialVibration.value = false;
                            controller.waterLeakage.value = false;
                            controller.humanOtherController.clear();
                          }
                        },
                        subItems: controller.humanCauses.value ? [
                          Obx(() => _buildSubCheckbox(
                            title: 'excavation_slope_toe'.tr,
                            value: controller.excavationOfSlope.value,
                            onChanged: (value) => controller.excavationOfSlope.value = value ?? false,
                            primaryColor: primaryColor,
                            textColor: textColor,
                          )),
                          Obx(() => _buildSubCheckbox(
                            title: 'loading_slope_crest'.tr,
                            value: controller.loadingOfSlope.value,
                            onChanged: (value) => controller.loadingOfSlope.value = value ?? false,
                            primaryColor: primaryColor,
                            textColor: textColor,
                          )),
                          Obx(() => _buildSubCheckbox(
                            title: 'drawdown_reservoirs'.tr,
                            value: controller.drawdown.value,
                            onChanged: (value) => controller.drawdown.value = value ?? false,
                            primaryColor: primaryColor,
                            textColor: textColor,
                          )),
                          Obx(() => _buildSubCheckbox(
                            title: 'deforestation'.tr,
                            value: controller.deforestation.value,
                            onChanged: (value) => controller.deforestation.value = value ?? false,
                            primaryColor: primaryColor,
                            textColor: textColor,
                          )),
                          Obx(() => _buildSubCheckbox(
                            title: 'irrigation'.tr,
                            value: controller.irrigation.value,
                            onChanged: (value) => controller.irrigation.value = value ?? false,
                            primaryColor: primaryColor,
                            textColor: textColor,
                          )),
                          Obx(() => _buildSubCheckbox(
                            title: 'mining'.tr,
                            value: controller.mining.value,
                            onChanged: (value) => controller.mining.value = value ?? false,
                            primaryColor: primaryColor,
                            textColor: textColor,
                          )),
                          Obx(() => _buildSubCheckbox(
                            title: 'artificial_vibration'.tr,
                            value: controller.artificialVibration.value,
                            onChanged: (value) => controller.artificialVibration.value = value ?? false,
                            primaryColor: primaryColor,
                            textColor: textColor,
                          )),
                          Obx(() => _buildSubCheckbox(
                            title: 'water_leakage_utilities'.tr,
                            value: controller.waterLeakage.value,
                            onChanged: (value) => controller.waterLeakage.value = value ?? false,
                            primaryColor: primaryColor,
                            textColor: textColor,
                          )),
                          const SizedBox(height: 8),
                          _buildOtherTextField(
                            label: 'other'.tr,
                            controller: controller.humanOtherController,
                            primaryColor: primaryColor,
                          ),
                        ] : [],
                        primaryColor: primaryColor,
                        textColor: textColor,
                      )),
                      const SizedBox(height: 16),
                      
                      Obx(() => _buildHierarchicalCheckbox(
                        title: 'for_any_other_information'.tr,
                        value: controller.otherCauses.value,
                        onChanged: (value) {
                          controller.otherCauses.value = value ?? false;
                          if (!controller.otherCauses.value) {
                            controller.otherCausesController.clear();
                          }
                        },
                        subItems: controller.otherCauses.value ? [
                          _buildOtherTextField(
                            label: 'specify_other_causes'.tr,
                            controller: controller.otherCausesController,
                            primaryColor: primaryColor,
                          ),
                        ] : [],
                        primaryColor: primaryColor,
                        textColor: textColor,
                      )),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Enhanced Impact/Damage Section
                  _buildCollapsibleSectionCard(
                    title: 'impact_damage_caused_landslide'.tr,
                    primaryColor: primaryColor,
                    cardColor: cardColor,
                    textColor: textColor,
                    controller: controller,
                    children: [
                      // People affected
                      Obx(() => _buildHierarchicalCheckbox(
                        title: 'people_affected'.tr,
                        value: controller.peopleAffected.value,
                        onChanged: (value) {
                          controller.peopleAffected.value = value ?? false;
                          if (!controller.peopleAffected.value) {
                            controller.peopleDeadController.clear();
                            controller.peopleInjuredController.clear();
                          }
                        },
                        subItems: controller.peopleAffected.value ? [
                          const SizedBox(height: 8),
                          _buildDamageDetailRow(
                            label1: 'dead'.tr,
                            label2: 'injured'.tr,
                            controller1: controller.peopleDeadController,
                            controller2: controller.peopleInjuredController,
                            primaryColor: primaryColor,
                          ),
                        ] : [],
                        primaryColor: primaryColor,
                        textColor: textColor,
                      )),
                      const SizedBox(height: 12),
                      
                      // Livestock affected
                      Obx(() => _buildHierarchicalCheckbox(
                        title: 'livestock_affected'.tr,
                        value: controller.livestockAffected.value,
                        onChanged: (value) {
                          controller.livestockAffected.value = value ?? false;
                          if (!controller.livestockAffected.value) {
                            controller.livestockDeadController.clear();
                            controller.livestockInjuredController.clear();
                          }
                        },
                        subItems: controller.livestockAffected.value ? [
                          const SizedBox(height: 8),
                          _buildDamageDetailRow(
                            label1: 'dead'.tr,
                            label2: 'injured'.tr,
                            controller1: controller.livestockDeadController,
                            controller2: controller.livestockInjuredController,
                            primaryColor: primaryColor,
                          ),
                        ] : [],
                        primaryColor: primaryColor,
                        textColor: textColor,
                      )),
                      const SizedBox(height: 12),
                      
                      // Houses and buildings affected
                      Obx(() => _buildHierarchicalCheckbox(
                        title: 'houses_buildings_affected'.tr,
                        value: controller.housesBuildingAffected.value,
                        onChanged: (value) {
                          controller.housesBuildingAffected.value = value ?? false;
                          if (!controller.housesBuildingAffected.value) {
                            controller.housesFullyController.clear();
                            controller.housesPartiallyController.clear();
                          }
                        },
                        subItems: controller.housesBuildingAffected.value ? [
                          const SizedBox(height: 8),
                          _buildDamageDetailRow(
                            label1: 'houses_buildings_fully'.tr,
                            label2: 'houses_buildings_partially'.tr,
                            controller1: controller.housesFullyController,
                            controller2: controller.housesPartiallyController,
                            primaryColor: primaryColor,
                          ),
                        ] : [],
                        primaryColor: primaryColor,
                        textColor: textColor,
                      )),
                      const SizedBox(height: 12),
                      
                      // Dams / Barrages affected
                      Obx(() => _buildHierarchicalCheckbox(
                        title: 'dams_barrages_affected'.tr,
                        value: controller.damsBarragesAffected.value,
                        onChanged: (value) {
                          controller.damsBarragesAffected.value = value ?? false;
                          if (!controller.damsBarragesAffected.value) {
                            controller.damsNameController.clear();
                            controller.damsExtentValue.value = null;
                          }
                        },
                        subItems: controller.damsBarragesAffected.value ? [
                          const SizedBox(height: 8),
                          _buildDamageDetailRowMixed(
                            label1: 'name_dams_barrages'.tr,
                            label2: 'extent_of_damage'.tr,
                            controller1: controller.damsNameController,
                            dropdownValue: controller.getTranslatedValueForDisplay(controller.damsExtentValue.value, LandslideReportController.extentOptions),
                            dropdownItems: LandslideReportController.extentOptions.map((key) => key.tr).toList(),
                                                          onDropdownChanged: (String? value) {
                                // Convert translated value back to English key
                                String? englishKey = controller.getEnglishKeyFromTranslatedValue(value, LandslideReportController.extentOptions);
                                controller.damsExtentValue.value = englishKey;
                              },
                            primaryColor: primaryColor,
                          ),
                        ] : [],
                        primaryColor: primaryColor,
                        textColor: textColor,
                      )),
                      const SizedBox(height: 12),
                      
                      // Roads affected
                      Obx(() => _buildHierarchicalCheckbox(
                        title: 'roads_affected'.tr,
                        value: controller.roadsAffected.value,
                        onChanged: (value) {
                          controller.roadsAffected.value = value ?? false;
                          if (!controller.roadsAffected.value) {
                            controller.roadTypeValue.value = null;
                            controller.roadExtentValue.value = null;
                          }
                        },
                        subItems: controller.roadsAffected.value ? [
                          const SizedBox(height: 8),
                          _buildRoadDamageFields(controller, primaryColor),
                        ] : [],
                        primaryColor: primaryColor,
                        textColor: textColor,
                      )),
                      const SizedBox(height: 12),
                      
                      // Roads blocked
                      Obx(() => _buildHierarchicalCheckbox(
                        title: 'roads_blocked'.tr,
                        value: controller.roadsBlocked.value,
                        onChanged: (value) {
                          controller.roadsBlocked.value = value ?? false;
                          if (!controller.roadsBlocked.value) {
                            controller.roadBlockageValue.value = null;
                          }
                        },
                        subItems: controller.roadsBlocked.value ? [
                          const SizedBox(height: 8),
                          _buildDropdownDamageField(
                            label: 'road_blockage'.tr,
                            value: controller.getTranslatedValueForDisplay(controller.roadBlockageValue.value, LandslideReportController.roadBlockageOptions),
                            items: LandslideReportController.roadBlockageOptions.map((key) => key.tr).toList(),
                                                          onChanged: (String? value) {
                                // Convert translated value back to English key
                                String? englishKey = controller.getEnglishKeyFromTranslatedValue(value, LandslideReportController.roadBlockageOptions);
                                controller.roadBlockageValue.value = englishKey;
                              },
                            primaryColor: primaryColor,
                          ),
                        ] : [],
                        primaryColor: primaryColor,
                        textColor: textColor,
                      )),
                      const SizedBox(height: 12),
                      
                      // Road benches damaged
                      Obx(() => _buildHierarchicalCheckbox(
                        title: 'road_benches_damaged'.tr,
                        value: controller.roadBenchesDamaged.value,
                        onChanged: (value) {
                          controller.roadBenchesDamaged.value = value ?? false;
                          if (!controller.roadBenchesDamaged.value) {
                            controller.roadBenchesExtentValue.value = null;
                          }
                        },
                        subItems: controller.roadBenchesDamaged.value ? [
                          const SizedBox(height: 8),
                          _buildDropdownDamageField(
                            label: 'extent_of_damage'.tr,
                            value: controller.getTranslatedValueForDisplay(controller.roadBenchesExtentValue.value, LandslideReportController.extentOptions),
                            items: LandslideReportController.extentOptions.map((key) => key.tr).toList(),
                                                          onChanged: (String? value) {
                                // Convert translated value back to English key
                                String? englishKey = controller.getEnglishKeyFromTranslatedValue(value, LandslideReportController.extentOptions);
                                controller.roadBenchesExtentValue.value = englishKey;
                              },
                            primaryColor: primaryColor,
                          ),
                        ] : [],
                        primaryColor: primaryColor,
                        textColor: textColor,
                      )),
                      const SizedBox(height: 12),
                      
                      // Railway line affected
                      Obx(() => _buildHierarchicalCheckbox(
                        title: 'railway_line_affected'.tr,
                        value: controller.railwayLineAffected.value,
                        onChanged: (value) {
                          controller.railwayLineAffected.value = value ?? false;
                          if (!controller.railwayLineAffected.value) {
                            controller.railwayDetailsController.clear();
                          }
                        },
                        subItems: controller.railwayLineAffected.value ? [
                          const SizedBox(height: 8),
                          _buildSingleDamageField(
                            label: 'mention_details'.tr,
                            controller: controller.railwayDetailsController,
                            primaryColor: primaryColor,
                          ),
                        ] : [],
                        primaryColor: primaryColor,
                        textColor: textColor,
                      )),
                      const SizedBox(height: 12),
                      
                      // Railway blocked
                      Obx(() => _buildHierarchicalCheckbox(
                        title: 'railway_blocked'.tr,
                        value: controller.railwayBlocked.value,
                        onChanged: (value) {
                          controller.railwayBlocked.value = value ?? false;
                          if (!controller.railwayBlocked.value) {
                            controller.railwayBlockageValue.value = null;
                          }
                        },
                        subItems: controller.railwayBlocked.value ? [
                          const SizedBox(height: 8),
                          _buildDropdownDamageField(
                            label: 'railway_blockage'.tr,
                            value: controller.getTranslatedValueForDisplay(controller.railwayBlockageValue.value, LandslideReportController.roadBlockageOptions),
                            items: LandslideReportController.roadBlockageOptions.map((key) => key.tr).toList(),
                                                          onChanged: (String? value) {
                                // Convert translated value back to English key
                                String? englishKey = controller.getEnglishKeyFromTranslatedValue(value, LandslideReportController.roadBlockageOptions);
                                controller.railwayBlockageValue.value = englishKey;
                              },
                            primaryColor: primaryColor,
                          ),
                        ] : [],
                        primaryColor: primaryColor,
                        textColor: textColor,
                      )),
                      const SizedBox(height: 12),
                      
                      // Railway benches damaged
                      Obx(() => _buildHierarchicalCheckbox(
                        title: 'railway_benches_damaged'.tr,
                        value: controller.railwayBenchesDamaged.value,
                        onChanged: (value) {
                          controller.railwayBenchesDamaged.value = value ?? false;
                          if (!controller.railwayBenchesDamaged.value) {
                            controller.railwayBenchesExtentValue.value = null;
                          }
                        },
                        subItems: controller.railwayBenchesDamaged.value ? [
                          const SizedBox(height: 8),
                          _buildDropdownDamageField(
                            label: 'extent_of_damage'.tr,
                            value: controller.getTranslatedValueForDisplay(controller.railwayBenchesExtentValue.value, LandslideReportController.extentOptions),
                            items: LandslideReportController.extentOptions.map((key) => key.tr).toList(),
                                                          onChanged: (String? value) {
                                // Convert translated value back to English key
                                String? englishKey = controller.getEnglishKeyFromTranslatedValue(value, LandslideReportController.extentOptions);
                                controller.railwayBenchesExtentValue.value = englishKey;
                              },
                            primaryColor: primaryColor,
                          ),
                        ] : [],
                        primaryColor: primaryColor,
                        textColor: textColor,
                      )),
                      
                      const SizedBox(height: 12),
                      
                      // Power infrastructure affected
                      Obx(() => _buildHierarchicalCheckbox(
                        title: 'power_infrastructure_telecommunication'.tr,
                        value: controller.powerInfrastructureAffected.value,
                        onChanged: (value) {
                          controller.powerInfrastructureAffected.value = value ?? false;
                          if (!controller.powerInfrastructureAffected.value) {
                            controller.powerExtentValue.value = null;
                          }
                        },
                        subItems: controller.powerInfrastructureAffected.value ? [
                          const SizedBox(height: 8),
                          _buildDropdownDamageField(
                            label: 'extent_of_damage'.tr,
                            value: controller.getTranslatedValueForDisplay(controller.powerExtentValue.value, LandslideReportController.extentOptions),
                            items: LandslideReportController.extentOptions.map((key) => key.tr).toList(),
                                                          onChanged: (String? value) {
                                // Convert translated value back to English key
                                String? englishKey = controller.getEnglishKeyFromTranslatedValue(value, LandslideReportController.extentOptions);
                                controller.powerExtentValue.value = englishKey;
                              },
                            primaryColor: primaryColor,
                          ),
                        ] : [],
                        primaryColor: primaryColor,
                        textColor: textColor,
                      )),
                      const SizedBox(height: 12),
                      
                      // Damages to Agriculture/Barren/Forest
                      Obx(() => _buildSimpleCheckboxListTile(
                        title: 'damages_agriculture_barren_forest'.tr,
                        value: controller.damagesToAgriculturalForestLand.value,
                        onChanged: (value) {
                          controller.damagesToAgriculturalForestLand.value = value ?? false;
                        },
                        primaryColor: primaryColor,
                        textColor: textColor,
                      )),
                      
                      // Other damages
                      Obx(() => _buildHierarchicalCheckbox(
                        title: 'other'.tr,
                        value: controller.other.value,
                        onChanged: (value) {
                          controller.other.value = value ?? false;
                          if (!controller.other.value) {
                            controller.otherDamageDetailsController.clear();
                          }
                        },
                        subItems: controller.other.value ? [
                          const SizedBox(height: 8),
                          _buildSingleDamageField(
                            label: 'mention_details'.tr,
                            controller: controller.otherDamageDetailsController,
                            primaryColor: primaryColor,
                          ),
                        ] : [],
                        primaryColor: primaryColor,
                        textColor: textColor,
                      )),
                      const SizedBox(height: 12),
                      
                      // No damages
                      Obx(() => _buildSimpleCheckboxListTile(
                        title: 'no_damages'.tr,
                        value: controller.noDamages.value,
                        onChanged: (value) {
                          controller.noDamages.value = value ?? false;
                        },
                        primaryColor: primaryColor,
                        textColor: textColor,
                      )),
                      
                      // I don't know
                      Obx(() => _buildSimpleCheckboxListTile(
                        title: 'i_dont_know'.tr,
                        value: controller.iDontKnow.value,
                        onChanged: (value) {
                          controller.iDontKnow.value = value ?? false;
                        },
                        primaryColor: primaryColor,
                        textColor: textColor,
                      )),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Remedial Measures - Complete Section
                  _buildSectionCard(
                    title: 'remedial_measures_required'.tr,
                    primaryColor: primaryColor,
                    cardColor: cardColor,
                    textColor: textColor,
                    children: [
                      // Modification of Slope Geometry
                      Obx(() => _buildHierarchicalCheckbox(
                        title: 'modification_slope_geometry'.tr,
                        value: controller.modificationOfSlopeGeometry.value,
                        onChanged: (value) {
                          controller.modificationOfSlopeGeometry.value = value ?? false;
                          if (!controller.modificationOfSlopeGeometry.value) {
                            controller.removingMaterial.value = false;
                            controller.addingMaterial.value = false;
                            controller.reducingGeneralSlopeAngle.value = false;
                            controller.slopeGeometryOtherController.clear();
                          }
                        },
                        subItems: controller.modificationOfSlopeGeometry.value ? [
                          Obx(() => _buildSubCheckbox(
                            title: 'removing_material_driving'.tr,
                            value: controller.removingMaterial.value,
                            onChanged: (value) {
                              controller.removingMaterial.value = value ?? false;
                            },
                            primaryColor: primaryColor,
                            textColor: textColor,
                          )),
                          Obx(() => _buildSubCheckbox(
                            title: 'adding_material_maintaining'.tr,
                            value: controller.addingMaterial.value,
                            onChanged: (value) {
                              controller.addingMaterial.value = value ?? false;
                            },
                            primaryColor: primaryColor,
                            textColor: textColor,
                          )),
                          Obx(() => _buildSubCheckbox(
                            title: 'reducing_general_slope_angle'.tr,
                            value: controller.reducingGeneralSlopeAngle.value,
                            onChanged: (value) {
                              controller.reducingGeneralSlopeAngle.value = value ?? false;
                            },
                            primaryColor: primaryColor,
                            textColor: textColor,
                          )),
                          const SizedBox(height: 8),
                          _buildOtherTextField(
                            label: 'other'.tr,
                            controller: controller.slopeGeometryOtherController,
                            primaryColor: primaryColor,
                          ),
                        ] : [],
                        primaryColor: primaryColor,
                        textColor: textColor,
                      )),
                      const SizedBox(height: 16),

                      // Drainage
                      Obx(() => _buildHierarchicalCheckbox(
                        title: 'drainage'.tr,
                        value: controller.drainage.value,
                        onChanged: (value) {
                          controller.drainage.value = value ?? false;
                          if (!controller.drainage.value) {
                            controller.surfaceDrains.value = false;
                            controller.shallowDeepTrenchDrains.value = false;
                            controller.buttressCounterfortDrains.value = false;
                            controller.verticalSmallDiameterBoreholes.value = false;
                            controller.verticalLargeDiameterWells.value = false;
                            controller.subHorizontalBoreholes.value = false;
                            controller.drainageTunnels.value = false;
                            controller.vacuumDewatering.value = false;
                            controller.drainageBySiphoning.value = false;
                            controller.electroosmoticDewatering.value = false;
                            controller.vegetationPlanting.value = false;
                            controller.drainageOtherController.clear();
                          }
                        },
                        subItems: controller.drainage.value ? [
                          Obx(() => _buildSubCheckbox(
                            title: 'surface_drains_divert'.tr,
                            value: controller.surfaceDrains.value,
                            onChanged: (value) {
                              controller.surfaceDrains.value = value ?? false;
                            },
                            primaryColor: primaryColor,
                            textColor: textColor,
                          )),
                          Obx(() => _buildSubCheckbox(
                            title: 'shallow_deep_trench_drains'.tr,
                            value: controller.shallowDeepTrenchDrains.value,
                            onChanged: (value) {
                              controller.shallowDeepTrenchDrains.value = value ?? false;
                            },
                            primaryColor: primaryColor,
                            textColor: textColor,
                          )),
                          Obx(() => _buildSubCheckbox(
                            title: 'buttress_counterfort_drains'.tr,
                            value: controller.buttressCounterfortDrains.value,
                            onChanged: (value) {
                              controller.buttressCounterfortDrains.value = value ?? false;
                            },
                            primaryColor: primaryColor,
                            textColor: textColor,
                          )),
                          Obx(() => _buildSubCheckbox(
                            title: 'vertical_small_diameter_boreholes'.tr,
                            value: controller.verticalSmallDiameterBoreholes.value,
                            onChanged: (value) {
                              controller.verticalSmallDiameterBoreholes.value = value ?? false;
                            },
                            primaryColor: primaryColor,
                            textColor: textColor,
                          )),
                          Obx(() => _buildSubCheckbox(
                            title: 'vertical_large_diameter_wells'.tr,
                            value: controller.verticalLargeDiameterWells.value,
                            onChanged: (value) {
                              controller.verticalLargeDiameterWells.value = value ?? false;
                            },
                            primaryColor: primaryColor,
                            textColor: textColor,
                          )),
                          Obx(() => _buildSubCheckbox(
                            title: 'sub_horizontal_boreholes'.tr,
                            value: controller.subHorizontalBoreholes.value,
                            onChanged: (value) {
                              controller.subHorizontalBoreholes.value = value ?? false;
                            },
                            primaryColor: primaryColor,
                            textColor: textColor,
                          )),
                          Obx(() => _buildSubCheckbox(
                            title: 'drainage_tunnels_galleries'.tr,
                            value: controller.drainageTunnels.value,
                            onChanged: (value) {
                              controller.drainageTunnels.value = value ?? false;
                            },
                            primaryColor: primaryColor,
                            textColor: textColor,
                          )),
                          Obx(() => _buildSubCheckbox(
                            title: 'vacuum_dewatering'.tr,
                            value: controller.vacuumDewatering.value,
                            onChanged: (value) {
                              controller.vacuumDewatering.value = value ?? false;
                            },
                            primaryColor: primaryColor,
                            textColor: textColor,
                          )),
                          Obx(() => _buildSubCheckbox(
                            title: 'drainage_by_siphoning'.tr,
                            value: controller.drainageBySiphoning.value,
                            onChanged: (value) {
                              controller.drainageBySiphoning.value = value ?? false;
                            },
                            primaryColor: primaryColor,
                            textColor: textColor,
                          )),
                          Obx(() => _buildSubCheckbox(
                            title: 'electroosmotic_dewatering'.tr,
                            value: controller.electroosmoticDewatering.value,
                            onChanged: (value) {
                              controller.electroosmoticDewatering.value = value ?? false;
                            },
                            primaryColor: primaryColor,
                            textColor: textColor,
                          )),
                          Obx(() => _buildSubCheckbox(
                            title: 'vegetation_planting_hydrological'.tr,
                            value: controller.vegetationPlanting.value,
                            onChanged: (value) {
                              controller.vegetationPlanting.value = value ?? false;
                            },
                            primaryColor: primaryColor,
                            textColor: textColor,
                          )),
                          const SizedBox(height: 8),
                          _buildOtherTextField(
                            label: 'other'.tr,
                            controller: controller.drainageOtherController,
                            primaryColor: primaryColor,
                          ),
                        ] : [],
                        primaryColor: primaryColor,
                        textColor: textColor,
                      )),
                      const SizedBox(height: 16),

                      // Retaining Structures
                      Obx(() => _buildHierarchicalCheckbox(
                        title: 'retaining_structures'.tr,
                        value: controller.retainingStructures.value,
                        onChanged: (value) {
                          controller.retainingStructures.value = value ?? false;
                          if (!controller.retainingStructures.value) {
                            controller.gravityRetainingWalls.value = false;
                            controller.cribBlockWalls.value = false;
                            controller.gabionWalls.value = false;
                            controller.passivePilesPiers.value = false;
                            controller.castInSituWalls.value = false;
                            controller.reinforcedEarthRetaining.value = false;
                            controller.buttressCounterforts.value = false;
                            controller.retentionNets.value = false;
                            controller.rockfallAttenuationSystems.value = false;
                            controller.protectiveRockBlocks.value = false;
                            controller.retainingOtherController.clear();
                          }
                        },
                        subItems: controller.retainingStructures.value ? [
                          Obx(() => _buildSubCheckbox(
                            title: 'gravity_retaining_walls'.tr,
                            value: controller.gravityRetainingWalls.value,
                            onChanged: (value) {
                              controller.gravityRetainingWalls.value = value ?? false;
                            },
                            primaryColor: primaryColor,
                            textColor: textColor,
                          )),
                          Obx(() => _buildSubCheckbox(
                            title: 'crib_block_walls'.tr,
                            value: controller.cribBlockWalls.value,
                            onChanged: (value) {
                              controller.cribBlockWalls.value = value ?? false;
                            },
                            primaryColor: primaryColor,
                            textColor: textColor,
                          )),
                          Obx(() => _buildSubCheckbox(
                            title: 'gabion_walls'.tr,
                            value: controller.gabionWalls.value,
                            onChanged: (value) {
                              controller.gabionWalls.value = value ?? false;
                            },
                            primaryColor: primaryColor,
                            textColor: textColor,
                          )),
                          Obx(() => _buildSubCheckbox(
                            title: 'passive_piles_piers'.tr,
                            value: controller.passivePilesPiers.value,
                            onChanged: (value) {
                              controller.passivePilesPiers.value = value ?? false;
                            },
                            primaryColor: primaryColor,
                            textColor: textColor,
                          )),
                          Obx(() => _buildSubCheckbox(
                            title: 'cast_in_situ_walls'.tr,
                            value: controller.castInSituWalls.value,
                            onChanged: (value) {
                              controller.castInSituWalls.value = value ?? false;
                            },
                            primaryColor: primaryColor,
                            textColor: textColor,
                          )),
                          Obx(() => _buildSubCheckbox(
                            title: 'reinforced_earth_retaining'.tr,
                            value: controller.reinforcedEarthRetaining.value,
                            onChanged: (value) {
                              controller.reinforcedEarthRetaining.value = value ?? false;
                            },
                            primaryColor: primaryColor,
                            textColor: textColor,
                          )),
                          Obx(() => _buildSubCheckbox(
                            title: 'buttress_counterforts_mechanical'.tr,
                            value: controller.buttressCounterforts.value,
                            onChanged: (value) {
                              controller.buttressCounterforts.value = value ?? false;
                            },
                            primaryColor: primaryColor,
                            textColor: textColor,
                          )),
                          
                          // Add Rock-only retaining options
                          Obx(() {
                            if (controller.isRockSelected() && controller.retainingStructures.value) {
                              return Column(
                                children: [
                                  Obx(() => _buildSubCheckbox(
                                    title: 'retention_nets_rock_slope'.tr,
                                    value: controller.retentionNets.value,
                                    onChanged: (value) => controller.retentionNets.value = value ?? false,
                                    primaryColor: primaryColor,
                                    textColor: textColor,
                                  )),
                                  Obx(() => _buildSubCheckbox(
                                    title: 'rockfall_attenuation_systems'.tr,
                                    value: controller.rockfallAttenuationSystems.value,
                                    onChanged: (value) => controller.rockfallAttenuationSystems.value = value ?? false,
                                    primaryColor: primaryColor,
                                    textColor: textColor,
                                  )),
                                  Obx(() => _buildSubCheckbox(
                                    title: 'protective_rock_blocks'.tr,
                                    value: controller.protectiveRockBlocks.value,
                                    onChanged: (value) => controller.protectiveRockBlocks.value = value ?? false,
                                    primaryColor: primaryColor,
                                    textColor: textColor,
                                  )),
                                ],
                              );
                            }
                            return const SizedBox.shrink();
                          }),
                          
                          const SizedBox(height: 8),
                          _buildOtherTextField(
                            label: 'other'.tr,
                            controller: controller.retainingOtherController,
                            primaryColor: primaryColor,
                          ),
                        ] : [],
                        primaryColor: primaryColor,
                        textColor: textColor,
                      )),
                      const SizedBox(height: 16),

                      // Internal Slope Reinforcement
                      Obx(() => _buildHierarchicalCheckbox(
                        title: 'internal_slope_reinforcement'.tr,
                        value: controller.internalSlopeReinforcement.value,
                        onChanged: (value) {
                          controller.internalSlopeReinforcement.value = value ?? false;
                          if (!controller.internalSlopeReinforcement.value) {
                            controller.rockBolts.value = false;
                            controller.micropiles.value = false;
                            controller.soilNailing.value = false;
                            controller.anchors.value = false;
                            controller.grouting.value = false;
                            controller.stoneLimeCementColumns.value = false;
                            controller.heatTreatment.value = false;
                            controller.freezing.value = false;
                            controller.electroosmoticAnchors.value = false;
                            controller.vegetationPlantingMechanical.value = false;
                            controller.internalReinforcementOtherController.clear();
                          }
                        },
                        subItems: controller.internalSlopeReinforcement.value ? [
                          // Rock-only options
                          Obx(() {
                            if (controller.isRockSelected() && controller.internalSlopeReinforcement.value) {
                              return Obx(() => _buildSubCheckbox(
                                title: 'rock_bolts'.tr,
                                value: controller.rockBolts.value,
                                onChanged: (value) => controller.rockBolts.value = value ?? false,
                                primaryColor: primaryColor,
                                textColor: textColor,
                              ));
                            }
                            return const SizedBox.shrink();
                          }),

                          // Soil-only options
                          Obx(() {
                            if (controller.isSoilSelected() && controller.internalSlopeReinforcement.value) {
                              return Column(
                                children: [
                                  Obx(() => _buildSubCheckbox(
                                    title: 'micropiles'.tr,
                                    value: controller.micropiles.value,
                                    onChanged: (value) => controller.micropiles.value = value ?? false,
                                    primaryColor: primaryColor,
                                    textColor: textColor,
                                  )),
                                  Obx(() => _buildSubCheckbox(
                                    title: 'soil_nailing'.tr,
                                    value: controller.soilNailing.value,
                                    onChanged: (value) => controller.soilNailing.value = value ?? false,
                                    primaryColor: primaryColor,
                                    textColor: textColor,
                                  )),
                                  Obx(() => _buildSubCheckbox(
                                    title: 'stone_lime_cement_columns'.tr,
                                    value: controller.stoneLimeCementColumns.value,
                                    onChanged: (value) => controller.stoneLimeCementColumns.value = value ?? false,
                                    primaryColor: primaryColor,
                                    textColor: textColor,
                                  )),
                                  Obx(() => _buildSubCheckbox(
                                    title: 'heat_treatment'.tr,
                                    value: controller.heatTreatment.value,
                                    onChanged: (value) => controller.heatTreatment.value = value ?? false,
                                    primaryColor: primaryColor,
                                    textColor: textColor,
                                  )),
                                  Obx(() => _buildSubCheckbox(
                                    title: 'electroosmotic_anchors'.tr,
                                    value: controller.electroosmoticAnchors.value,
                                    onChanged: (value) => controller.electroosmoticAnchors.value = value ?? false,
                                    primaryColor: primaryColor,
                                    textColor: textColor,
                                  )),
                                ],
                              );
                            }
                            return const SizedBox.shrink();
                          }),

                          // Rock & Soil options
                          Obx(() {
                            if (controller.isRockOrSoilSelected() && controller.internalSlopeReinforcement.value) {
                              return Obx(() => _buildSubCheckbox(
                                title: 'freezing'.tr,
                                value: controller.freezing.value,
                                onChanged: (value) => controller.freezing.value = value ?? false,
                                primaryColor: primaryColor,
                                textColor: textColor,
                              ));
                            }
                            return const SizedBox.shrink();
                          }),

                          // Soil & Debris options
                          Obx(() {
                            if (controller.isSoilOrDebrisSelected() && controller.internalSlopeReinforcement.value) {
                              return Obx(() => _buildSubCheckbox(
                                title: 'vegetation_planting_root_strength_mechanical'.tr,
                                value: controller.vegetationPlantingMechanical.value,
                                onChanged: (value) => controller.vegetationPlantingMechanical.value = value ?? false,
                                primaryColor: primaryColor,
                                textColor: textColor,
                              ));
                            }
                            return const SizedBox.shrink();
                          }),

                          // Options for all material types
                          Obx(() => _buildSubCheckbox(
                            title: 'anchors_prestressed'.tr,
                            value: controller.anchors.value,
                            onChanged: (value) => controller.anchors.value = value ?? false,
                            primaryColor: primaryColor,
                            textColor: textColor,
                          )),
                          Obx(() => _buildSubCheckbox(
                            title: 'grouting'.tr,
                            value: controller.grouting.value,
                            onChanged: (value) => controller.grouting.value = value ?? false,
                            primaryColor: primaryColor,
                            textColor: textColor,
                          )),
                          
                          const SizedBox(height: 8),
                          _buildOtherTextField(
                            label: 'other'.tr,
                            controller: controller.internalReinforcementOtherController,
                            primaryColor: primaryColor,
                          ),
                        ] : [],
                        primaryColor: primaryColor,
                        textColor: textColor,
                      )),
                      const SizedBox(height: 16),

                      // Remedial measures not required
                      Obx(() => _buildHierarchicalCheckbox(
                        title: 'remedial_measures_not_required'.tr,
                        value: controller.remedialMeasuresNotRequired.value,
                        onChanged: (value) {
                          controller.remedialMeasuresNotRequired.value = value ?? false;
                          if (!controller.remedialMeasuresNotRequired.value) {
                            controller.remedialNotRequiredWhyController.clear();
                          }
                        },
                        subItems: controller.remedialMeasuresNotRequired.value ? [
                          const SizedBox(height: 8),
                          _buildOtherTextField(
                            label: 'why'.tr,
                            controller: controller.remedialNotRequiredWhyController,
                            primaryColor: primaryColor,
                          ),
                        ] : [],
                        primaryColor: primaryColor,
                        textColor: textColor,
                      )),
                      const SizedBox(height: 16),

                      // Remedial measures not sufficient to protect the slide
                      Obx(() => _buildHierarchicalCheckbox(
                        title: 'remedial_measures_not_sufficient'.tr,
                        value: controller.remedialMeasuresNotAdequate.value,
                        onChanged: (value) {
                          controller.remedialMeasuresNotAdequate.value = value ?? false;
                          if (!controller.remedialMeasuresNotAdequate.value) {
                            controller.shiftingOfVillage.value = false;
                            controller.evacuationOfInfrastructure.value = false;
                            controller.realignmentOfCommunicationCorridors.value = false;
                            controller.communicationCorridorType.value = null;
                            controller.notAdequateOtherController.clear();
                          }
                        },
                        subItems: controller.remedialMeasuresNotAdequate.value ? [
                          Obx(() => _buildSubCheckbox(
                            title: 'shifting_village_required'.tr,
                            value: controller.shiftingOfVillage.value,
                            onChanged: (value) {
                              controller.shiftingOfVillage.value = value ?? false;
                            },
                            primaryColor: primaryColor,
                            textColor: textColor,
                          )),
                          Obx(() => _buildSubCheckbox(
                            title: 'evacuation_infrastructure'.tr,
                            value: controller.evacuationOfInfrastructure.value,
                            onChanged: (value) {
                              controller.evacuationOfInfrastructure.value = value ?? false;
                            },
                            primaryColor: primaryColor,
                            textColor: textColor,
                          )),
                          
                          // Realignment of communication corridors with dropdown
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(() => _buildSubCheckbox(
                                title: 'realignment_communication_corridors'.tr,
                                value: controller.realignmentOfCommunicationCorridors.value,
                                onChanged: (value) {
                                  controller.realignmentOfCommunicationCorridors.value = value ?? false;
                                  if (!controller.realignmentOfCommunicationCorridors.value) {
                                    controller.communicationCorridorType.value = null;
                                  }
                                },
                                primaryColor: primaryColor,
                                textColor: textColor,
                              )),
                              Obx(() {
                                if (controller.realignmentOfCommunicationCorridors.value) {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 20.0, top: 8.0),
                                    child: _buildDropdownDamageField(
                                      label: 'type_communication_corridor'.tr,
                                      value: controller.communicationCorridorType.value,
                                      items: ['realignment_road', 'bridge', 'tunnel'],
                                      onChanged: (String? value) {
                                        controller.communicationCorridorType.value = value;
                                      },
                                      primaryColor: primaryColor,
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              }),
                            ],
                          ),
                    
                          const SizedBox(height: 8),
                          _buildOtherTextField(
                            label: 'other'.tr,
                            controller: controller.notAdequateOtherController,
                            primaryColor: primaryColor,
                          ),
                        ] : [],
                        primaryColor: primaryColor,
                        textColor: textColor,
                      )),
                      const SizedBox(height: 16),

                      // For any other Information
                      Obx(() => _buildHierarchicalCheckbox(
                        title: 'for_any_other_information'.tr,
                        value: controller.otherInformation.value,
                        onChanged: (value) {
                          controller.otherInformation.value = value ?? false;
                          if (!controller.otherInformation.value) {
                            controller.otherInformationController.clear();
                          }
                        },
                        subItems: controller.otherInformation.value ? [
                          const SizedBox(height: 8),
                          _buildOtherTextField(
                            label: 'other_information'.tr,
                            controller: controller.otherInformationController,
                            primaryColor: primaryColor,
                          ),
                        ] : [],
                        primaryColor: primaryColor,
                        textColor: textColor,
                      )),
                    ],
                  ),      
                  
                  const SizedBox(height: 16),
                  
                  // Alert Category
                  _buildSectionCard(
                    title: 'alert_category'.tr,
                    primaryColor: primaryColor,
                    cardColor: cardColor,
                    textColor: textColor,
                    children: [
                      Obx(() => _buildDropdown(
                        hint: 'select_alert_level'.tr,
                        value: controller.getTranslatedValueForDisplay(
                          controller.alertCategory.value, 
                          ['category_1', 'category_2', 'category_3']
                        ),
                        items: ['category_1', 'category_2', 'category_3'].map((item) => item.tr).toList(),
                        onChanged: (value) => controller.alertCategory.value = controller.getEnglishKeyFromTranslatedValue(
                          value, 
                          ['category_1', 'category_2', 'category_3']
                        ),
                        icon: Icons.trending_up,
                        hasInfoIcon: true,
                        onInfoTap: () => showAlertCategoryDialog(context),
                      )),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Any other relevant information
                  _buildSectionCard(
                    title: 'any_other_relevant_information'.tr,
                    primaryColor: primaryColor,
                    cardColor: cardColor,
                    textColor: textColor,
                    children: [
                      _buildTextField(
                        label: 'enter_other_relevant_information'.tr,
                        controller: controller.otherRelevantInformation,
                        maxLines: 2,
                      ),
                    ],
                  ),
                  
               const SizedBox(height: 16),

// Image Selection Section with Validation
_buildSectionCard(
  title: '${'landslide_images'.tr} *',
  primaryColor: primaryColor,
  cardColor: cardColor,
  textColor: textColor,
  children: [
    // Image status display
    Obx(() => Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: controller.selectedImages.isEmpty ? Colors.red.shade50 : Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: controller.selectedImages.isEmpty ? Colors.red.shade300 : Colors.green.shade300,
        ),
      ),
      child: Row(
        children: [
          Icon(
            controller.selectedImages.isEmpty ? Icons.error_outline : Icons.check_circle_outline,
            color: controller.selectedImages.isEmpty ? Colors.red : Colors.green,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              controller.getImageStatusText(),
              style: TextStyle(
                color: controller.selectedImages.isEmpty ? Colors.red.shade700 : Colors.green.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    )),
    
    const SizedBox(height: 12),
    
    // Image selection instruction
    Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info, color: Colors.blue.shade700, size: 20),
              const SizedBox(width: 8),
              Text(
                'image_requirements'.tr,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('• ${'at_least_1_image_required'.tr}'),
          Text('• ${'up_to_5_images'.tr}'),
          Text('• ${'use_camera_gallery_buttons'.tr}'),
          Text('• ${'good_quality_images_help'.tr}'),
        ],
      ),
    ),
    
    // Show validation error if any
    Obx(() {
      if (controller.imageValidationError.value.isNotEmpty) {
        return Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.shade300),
            ),
            child: Row(
              children: [
                Icon(Icons.warning, color: Colors.red.shade600, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    controller.imageValidationError.value,
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
      return const SizedBox.shrink();
    }),
  ],
),
                  const SizedBox(height: 24),

 const SizedBox(height: 16),

// Enhanced Selected Images Display
Obx(() {
  if (controller.selectedImages.isNotEmpty) {
    return _buildSectionCard(
      title: 'Selected Images (${controller.selectedImages.length}/5)',
      primaryColor: primaryColor,
      cardColor: cardColor,
      textColor: textColor,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green.shade200),
          ),
          child: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green.shade600, size: 20),
              const SizedBox(width: 8),
              Text(
                '${controller.selectedImages.length} image(s) selected',
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.selectedImages.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(right: 8),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        controller.selectedImages[index],
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => controller.removeImage(index),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    // Image number badge
                    Positioned(
                      bottom: 4,
                      left: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        
        // Image captions
        const SizedBox(height: 16),
        ...List.generate(controller.selectedImages.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'caption_for_image_number'.trParams({'number': '${index + 1}'}),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: controller.imageCaptions[index],
                  decoration: InputDecoration(
                    hintText: 'enter_caption_optional'.tr,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
  return const SizedBox.shrink();
}),       
                  
// Enhanced Submit Button with Validation
Container(
  margin: const EdgeInsets.symmetric(horizontal: 8.0),
  child: Column(
    children: [
      // Form completion status
      Obx(() {
        final summary = controller.getValidationSummary();
        return Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: summary['isComplete'] ? Colors.green.shade50 : Colors.orange.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: summary['isComplete'] ? Colors.green.shade200 : Colors.orange.shade200,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    summary['isComplete'] ? Icons.check_circle : Icons.info,
                    color: summary['isComplete'] ? Colors.green : Colors.orange,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      controller.getFormCompletionText(),
                      style: TextStyle(
                        color: summary['isComplete'] ? Colors.green.shade700 : Colors.orange.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              if (!summary['isComplete']) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'tap_view_details_missing'.tr,
                        style: TextStyle(
                          color: Colors.orange.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => controller.showValidationSummary(),
                      child: Text('view_details'.tr),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      }),
      
      // Submit button
      Obx(() => ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: controller.canSubmitForm() ? primaryColor : Colors.grey,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: controller.canSubmitForm() ? 2 : 0,
        ),
        onPressed: () {
          if (controller.selectedImages.isEmpty) {
            controller.showImageRequirementDialog();
          } else {
            controller.submitForm();
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              controller.selectedImages.isEmpty ? Icons.warning : Icons.send,
              size: 20,
            ),
            const SizedBox(width: 8),
            Obx(() => Text(
              controller.isDraftMode.value ? 'submit_draft_report'.tr : 'submit_report_caps'.tr,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            )),
          ],
        ),
      )),
    ],
  ),
),  
                  const SizedBox(height: 24),
                ],
              ),
            )
            ),
              bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.white,
          selectedItemColor: primaryColor,
          unselectedItemColor: hintColor,
          currentIndex: 0,
          onTap: (index) {
            if (index == 0) {
              controller.openCamera();
            } else {
              controller.openGallery();
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt),
              label: 'camera'.tr,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.image),
              label: 'gallery'.tr,
            ),
          ],
        ),
      ),
            );

  }

  // Helper widgets
Widget _buildSectionCard({
  required String title, 
  required List<Widget> children,
  required Color primaryColor,
  required Color cardColor,
  required Color textColor,
}) {
  return Card(
    elevation: 2,
    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    color: cardColor,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: title.contains('*') 
                    ? _buildLabelWithRedAsterisk(title, textColor)
                    : Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    ),
  );
}

Widget _buildCollapsibleSectionCard({
  required String title,
  required Color primaryColor,
  required Color cardColor,
  required Color textColor,
  required List<Widget> children,
  required LandslideReportController controller,
}) {
  return Obx(() => Card(
    elevation: 2,
    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    color: cardColor,
    child: Column(
      children: [
        InkWell(
          onTap: () {
            controller.isImpactSectionExpanded.value = !controller.isImpactSectionExpanded.value;
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
                Icon(
                  controller.isImpactSectionExpanded.value 
                    ? Icons.keyboard_arrow_up 
                    : Icons.keyboard_arrow_down,
                  color: primaryColor,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
        if (controller.isImpactSectionExpanded.value)
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
      ],
    ),
  ));
}

Widget _buildLabelWithRedAsterisk(String text, Color textColor) {
  if (text.contains('*')) {
    List<String> parts = text.split('*');
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: parts[0],
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
          TextSpan(
            text: '*',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.red,
            ),
          ),
          if (parts.length > 1)
            TextSpan(
              text: parts[1],
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
        ],
      ),
    );
  }
  
  return Text(
    text,
    style: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: textColor,
    ),
  );
}

Widget _labelText(String text, Color textColor) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: _buildLabelWithRedAsterisk(text, textColor),
  );
}

Widget _buildTextField({
  required String label,
  required TextEditingController controller,
  TextInputType keyboardType = TextInputType.text,
  bool readOnly = false,
  int maxLines = 1,
  bool hasInfoIcon = false,
  VoidCallback? onInfoTap,
  String? Function(String?)? validator,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          maxLines: maxLines,
          decoration: InputDecoration(
            label: label.contains('*') ? _buildLabelWithRedAsterisk(label, Colors.black87) : null,
            labelText: label.contains('*') ? null : label,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          validator: validator,
        ),
      ),
      
      if (hasInfoIcon)
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 12.0),
          child: InkWell(
            onTap: onInfoTap,
            child: const Icon(
              Icons.info_outline,
              color: Colors.blue,
              size: 24,
            ),
          ),
        ),
    ],
  );
}
  Widget _buildDropdown({
    required String? value,
    required List<String> items,
     required void Function(String?)? onChanged,  // ← Changed this line
    bool hasInfoIcon = false,
    IconData? icon,
    String? hint,
    VoidCallback? onInfoTap,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                if (icon != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(icon, color: const Color(0xFF1976D2)),
                  ),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: value,
                      isExpanded: true,
                      hint: Text(hint ?? ""),
                      items: items.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: onChanged,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (hasInfoIcon)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: InkWell(
              onTap: onInfoTap,
              child: const Icon(
                Icons.info_outline,
                color: Colors.blue,
                size: 24,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStructureCheckboxWithFields({
    required String title,
    required bool value,
    required Function(bool?) onChanged,
    required List<TextEditingController> controllers,
    required VoidCallback onAddField,
    required Function(int) onRemoveField,
    required Color primaryColor,
    required Color textColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Checkbox with custom styling
        Row(
          children: [
            GestureDetector(
              onTap: () => onChanged(!value),
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: value ? primaryColor : Colors.transparent,
                  border: Border.all(
                    color: value ? primaryColor : Colors.grey,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: value
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      )
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: value ? primaryColor : textColor,
                fontWeight: value ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
        
        // Dynamic text fields (shown only when checked)
        if (value) ...[
          const SizedBox(height: 12),
          // Show existing fields
          ...List.generate(controllers.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: TextField(
                        controller: controllers[index],
                        decoration: InputDecoration(
                          hintText: 'Enter ${title.toLowerCase()} details',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => onRemoveField(index),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          
          // Add button
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: onAddField,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

Widget _buildHierarchicalCheckbox({
  required String title,
  required bool value,
  required Function(bool?) onChanged,
  required List<Widget> subItems,
  bool isRequired = false,
  required Color primaryColor,
  required Color textColor,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          GestureDetector(
            onTap: () => onChanged(!value),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: value ? primaryColor : Colors.transparent,
                border: Border.all(
                  color: value ? primaryColor : Colors.grey,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: value
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: title.contains('*') 
              ? _buildLabelWithRedAsterisk(title, value ? primaryColor : textColor)
              : Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: value ? primaryColor : textColor,
                    fontWeight: value ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
          ),
        ],
      ),
      if (value && subItems.isNotEmpty) ...[
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.only(left: 36.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: subItems,
          ),
        ),
      ],
    ],
  );
}

  Widget _buildSubCheckbox({
    required String title,
    required bool value,
    required Function(bool?) onChanged,
    required Color primaryColor,
    required Color textColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => onChanged(!value),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: value ? primaryColor : Colors.transparent,
                border: Border.all(
                  color: value ? primaryColor : Colors.grey,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(3),
              ),
              child: value
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 12,
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: value ? primaryColor : textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtherTextField({
    required String label,
    required TextEditingController controller,
    required Color primaryColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSimpleCheckboxListTile({
    required String title,
    required bool value,
    required Function(bool?) onChanged,
    required Color primaryColor,
    required Color textColor,
  }) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => onChanged(!value),
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: value ? primaryColor : Colors.transparent,
              border: Border.all(
                color: value ? primaryColor : Colors.grey,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: value
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  )
                : null,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: value ? primaryColor : textColor,
              fontWeight: value ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDamageDetailRow({
    required String label1,
    required String label2,
    required TextEditingController controller1,
    required TextEditingController controller2,
    required Color primaryColor,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label1,
                style: TextStyle(
                  fontSize: 12,
                  color: primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: TextField(
                  controller: controller1,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label2,
                style: TextStyle(
                  fontSize: 12,
                  color: primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: TextField(
                  controller: controller2,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSingleDamageField({
    required String label,
    required TextEditingController controller,
    required Color primaryColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(6),
          ),
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 12),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDamageDetailRowMixed({
    required String label1,
    required String label2,
    required TextEditingController controller1,
    String? dropdownValue,
    List<String>? dropdownItems,
    Function(String?)? onDropdownChanged,
    required Color primaryColor,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label1,
                style: TextStyle(
                  fontSize: 12,
                  color: primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: TextField(
                  controller: controller1,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label2,
                style: TextStyle(
                  fontSize: 12,
                  color: primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    isExpanded: true,
                    hint: const Text(
                      '---Select---',
                      style: TextStyle(fontSize: 12),
                    ),
                    items: dropdownItems?.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    }).toList(),
                    onChanged: onDropdownChanged,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownDamageField({
    required String label,
    String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required Color primaryColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(6),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              hint: const Text(
                '---Select---',
                style: TextStyle(fontSize: 12),
              ),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoadDamageFields(LandslideReportController controller, Color primaryColor) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'road_type'.tr,
                style: TextStyle(
                  fontSize: 12,
                  color: primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Obx(() => DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: controller.roadTypeValue.value,
                    isExpanded: true,
                    hint: Text(
                      'select'.tr,
                      style: TextStyle(fontSize: 12),
                    ),
                    items: ['state_highway', 'national_highway', 'local'].map((String item) {
                      return DropdownMenuItem<String>(
                        value: item.tr,
                        child: Text(
                          item.tr,
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      controller.roadTypeValue.value = value;
                    },
                  ),
                )),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'extent_of_damage'.tr,
                style: TextStyle(
                  fontSize: 12,
                  color: primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Obx(() => DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: controller.roadExtentValue.value,
                    isExpanded: true,
                    hint: Text(
                      'select'.tr,
                      style: TextStyle(fontSize: 12),
                    ),
                    items: ['full', 'partial'].map((String item) {
                      return DropdownMenuItem<String>(
                        value: item.tr,
                        child: Text(
                          item.tr,
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      controller.roadExtentValue.value = value;
                    },
                  ),
                )),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showDimensionsDialog(BuildContext context) {
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
                      'Landslide Dimensions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
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
                  child: Center(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/dimension_landslide.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 300,
                              color: Colors.grey[200],
                              child: const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image_not_supported,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Image not found',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'This diagram shows how to measure the key dimensions of a landslide:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '• Length: The distance along the slope from crown to toe\n'
                  '• Width: The maximum width perpendicular to the length\n'
                  '• Height: The vertical distance from crown to toe',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Add this widget method at the bottom of your UI file, before the closing }
Widget _buildLocationModeSwitch(LandslideReportController controller, Color primaryColor) {
  return Obx(() {
    if (controller.isLocationAutoPopulated.value) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton.icon(
              onPressed: () {
                controller.isLocationAutoPopulated.value = false;
                controller.stateController.clear();
                controller.districtController.clear();
              },
              icon: const Icon(Icons.edit, size: 16),
              label: const Text('Manual Selection'),
              style: TextButton.styleFrom(
                foregroundColor: primaryColor,
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  });
}

Widget _buildRainfallDurationOption(
  String title,
  LandslideReportController controller,
  Color primaryColor,
) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: Obx(() => GestureDetector(
      onTap: () => controller.rainfallDurationValue.value = title,
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: controller.rainfallDurationValue.value == title 
                    ? primaryColor 
                    : Colors.grey,
                width: 2,
              ),
              color: controller.rainfallDurationValue.value == title 
                  ? primaryColor 
                  : Colors.transparent,
            ),
            child: controller.rainfallDurationValue.value == title
                ? const Icon(
                    Icons.circle,
                    color: Colors.white,
                    size: 12,
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: controller.rainfallDurationValue.value == title 
                    ? primaryColor 
                    : Colors.black87,
                fontWeight: controller.rainfallDurationValue.value == title 
                    ? FontWeight.w600 
                    : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    )),
  );



  
}