import 'package:bhooskhalann/landslide/report_landslide_maps_screen/report_form_getx/draft_report_section/public_report_form_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bhooskhalann/landslide/report_landslide_maps_screen/widgets/show_material_type_dialog.dart';

class PublicLandslideReportingScreen extends StatelessWidget {
  const PublicLandslideReportingScreen({Key? key, required this.latitude,  required this.longitude}) : super(key: key);
  
  final double latitude;
  final double longitude;

  @override
  Widget build(BuildContext context) {
    // Initialize controller with coordinates
    final controller = Get.put(PublicLandslideReportController());
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
            ? 'edit_draft_report'.tr
            : controller.isPendingEditMode.value 
              ? 'edit_pending_report'.tr 
              : controller.isSyncedReportMode.value
                ? 'submitted_report'.tr
                : 'report_landslide_public'.tr,
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
                                'editing_draft_message'.tr,
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
                  _buildSectionCard(
                    title: 'location_information'.tr,
                    primaryColor: primaryColor,
                    cardColor: cardColor,
                    textColor: textColor,
                    children: [
                      _buildTextField(
                        label: '${'latitude'.tr} *',
                        controller: controller.latitudeController,
                        readOnly: true,
                        validator: (value) => controller.validateRequired(value, 'latitude'.tr),
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: '${'longitude'.tr} *',
                        controller: controller.longitudeController,
                        readOnly: true,
                        validator: (value) => controller.validateRequired(value, 'longitude'.tr),
                      ),
                      const SizedBox(height: 16),

                      // Add location mode switch
                      _buildLocationModeSwitch(controller, primaryColor),
                      
                      // State Field - Conditional UI
                      Obx(() {
                        if (controller.isLocationAutoPopulated.value && controller.stateController.text.isNotEmpty) {
                          // Show text field when auto-populated
                          return _buildTextField(
                            label: '${'state'.tr} *',
                            controller: controller.stateController,
                            readOnly: true,
                            validator: (value) => controller.validateRequired(value, 'state'.tr),
                          );
                        } else {
                          // Show dropdown when manual selection needed
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _labelText('${'state'.tr} *', textColor),
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
                            label: '${'district'.tr} *',
                            controller: controller.districtController,
                            readOnly: true,
                            validator: (value) => controller.validateRequired(value, 'district'.tr),
                          );
                        } else {
                          // Show dropdown when manual selection needed
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _labelText('${'district'.tr} *', textColor),
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
                        label: 'other_relevant_location_details'.tr,
                        controller: controller.locationDetailsController,
                        maxLines: 3,
                      ),
                    ],
                  ),     
                  const SizedBox(height: 16),
                  
                  // Occurrence Information Section
                  _buildSectionCard(
                    title: '${'occurrence_of_landslide'.tr} *',
                    primaryColor: primaryColor,
                    cardColor: cardColor,
                    textColor: textColor,
                    children: [
                      Obx(() => _buildDropdown(
                        hint: 'select_occurrence_option'.tr,
                        value: controller.getTranslatedValueForDisplay(controller.landslideOccurrenceValue.value, PublicLandslideReportController.landslideOccurrenceOptions),
                        items: PublicLandslideReportController.landslideOccurrenceOptions.map((key) => key.tr).toList(),
                        onChanged: (value) {
                          // Convert translated value back to English key
                          String? englishKey = controller.getEnglishKeyFromTranslatedValue(value, PublicLandslideReportController.landslideOccurrenceOptions);
                          controller.landslideOccurrenceValue.value = englishKey;
                          controller.dateController.clear();
                          controller.timeController.clear();
                          controller.howDoYouKnowValue.value = null;
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
                                        _labelText('${'date'.tr} *', textColor),
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
                              _labelText('${'how_do_you_know_info'.tr} *', textColor),
                              _buildDropdown(
                                hint: 'select_source'.tr,
                                value: controller.getTranslatedValueForDisplay(controller.howDoYouKnowValue.value, PublicLandslideReportController.howDoYouKnowOptions),
                                items: PublicLandslideReportController.howDoYouKnowOptions.map((key) => key.tr).toList(),
                                onChanged: (value) {
                                  String? englishKey = controller.getEnglishKeyFromTranslatedValue(value, PublicLandslideReportController.howDoYouKnowOptions);
                                  controller.howDoYouKnowValue.value = englishKey;
                                },
                                icon: Icons.info,
                              ),
                            ],
                          );
                        } else if (controller.landslideOccurrenceValue.value == 'approximate_occurrence_date') {
                          return Column(
                            children: [
                              const SizedBox(height: 16),
                              _labelText('${'occurrence_date_range'.tr} *', textColor),
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
                    title: 'where_landslide_occurred'.tr,
                    primaryColor: primaryColor,
                    cardColor: cardColor,
                    textColor: textColor,
                    children: [
                      Obx(() => _buildDropdown(
                        hint: 'select_location_type'.tr,
                        value: controller.getTranslatedValueForDisplay(controller.whereDidLandslideOccurValue.value, PublicLandslideReportController.whereDidLandslideOccurOptions),
                        items: PublicLandslideReportController.whereDidLandslideOccurOptions.map((key) => key.tr).toList(),
                        onChanged: (value) {
                          String? englishKey = controller.getEnglishKeyFromTranslatedValue(value, PublicLandslideReportController.whereDidLandslideOccurOptions);
                          controller.whereDidLandslideOccurValue.value = englishKey;
                        },
                        icon: Icons.landscape,
                      )),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Type of Material
                  _buildSectionCard(
                    title: 'type_of_material'.tr,
                    primaryColor: primaryColor,
                    cardColor: cardColor,
                    textColor: textColor,
                    children: [
                      Obx(() => _buildDropdown(
                        hint: 'select_material_type'.tr,
                        value: controller.getTranslatedValueForDisplay(controller.typeOfMaterialValue.value, PublicLandslideReportController.typeOfMaterialOptions),
                        items: PublicLandslideReportController.typeOfMaterialOptions.map((key) => key.tr).toList(),
                        onChanged: (value) {
                          String? englishKey = controller.getEnglishKeyFromTranslatedValue(value, PublicLandslideReportController.typeOfMaterialOptions);
                          controller.typeOfMaterialValue.value = englishKey;
                        },
                        icon: Icons.terrain,
                        hasInfoIcon: true,
                        onInfoTap: () => showMaterialTypeDialog(context),
                      )),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                             
                  // Landslide Size Section
                  _buildSectionCard(
                    title: 'size_of_landslide'.tr,
                    primaryColor: primaryColor,
                    cardColor: cardColor,
                    textColor: textColor,
                    hasInfoIcon: true,
                    onInfoTap: () => controller.showLandslideSizeInfoDialog(),
                    children: [
                      Obx(() => GestureDetector(
                        onTap: () => controller.showLandslideSizeDialog(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.height, color: primaryColor),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  controller.landslideSize.value ?? 'select_landslide_size'.tr,
                                  style: TextStyle(
                                    color: controller.landslideSize.value != null ? Colors.black : Colors.grey[600],
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                            ],
                          ),
                        ),
                      )),
                    ],
                  ),
                  
                  const SizedBox(height: 16),

                  // Enhanced Impact/Damage Section
                  _buildCollapsibleSectionCard(
                    title: 'impact_damage_caused'.tr,
                    primaryColor: primaryColor,
                    cardColor: cardColor,
                    textColor: textColor,
                    isExpanded: controller.isImpactSectionExpanded,
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
                            label1: 'fully_affected'.tr,
                            label2: 'partially_affected'.tr,
                            controller1: controller.housesFullyController,
                            controller2: controller.housesPartiallyController,
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
                      Obx(() => _buildSimpleCheckboxListTile(
                        title: 'roads_blocked'.tr,
                        value: controller.roadsBlocked.value,
                        onChanged: (value) {
                          controller.roadsBlocked.value = value ?? false;
                        },
                        primaryColor: primaryColor,
                        textColor: textColor,
                      )),
                      
                      // Railway line affected
                      Obx(() => _buildSimpleCheckboxListTile(
                        title: 'railway_line_affected'.tr,
                        value: controller.railwayLineAffected.value,
                        onChanged: (value) {
                          controller.railwayLineAffected.value = value ?? false;
                        },
                        primaryColor: primaryColor,
                        textColor: textColor,
                      )),
                      
                      // Power infrastructure affected
                      Obx(() => _buildSimpleCheckboxListTile(
                        title: 'power_infrastructure_affected'.tr,
                        value: controller.powerInfrastructureAffected.value,
                        onChanged: (value) {
                          controller.powerInfrastructureAffected.value = value ?? false;
                        },
                        primaryColor: primaryColor,
                        textColor: textColor,
                      )),
                      
                      // Damages to Agriculture/Barren/Forest
                      Obx(() => _buildSimpleCheckboxListTile(
                        title: 'damages_agriculture_forest'.tr,
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

                  // Contact Information Section
                  _buildSectionCard(
                    title: 'contact_information'.tr,
                    primaryColor: primaryColor,
                    cardColor: cardColor,
                    textColor: textColor,
                    children: [
                      Obx(() => _buildReadOnlyField(
                        label: 'name'.tr,
                        value: controller.username.value,
                        icon: Icons.person,
                      )),
                      const SizedBox(height: 16),
                      // Make affiliation editable with save functionality
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _labelText('affiliation'.tr, textColor),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  label: 'enter_affiliation'.tr,
                                  controller: controller.affiliationController,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Obx(() => _buildReadOnlyField(
                        label: 'email'.tr,
                        value: controller.email.value,
                        icon: Icons.email,
                      )),
                      const SizedBox(height: 16),
                      Obx(() => _buildReadOnlyField(
                        label: 'mobile'.tr,
                        value: controller.mobile.value,
                        icon: Icons.phone,
                      )),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Image Selection Section with Validation
                  _buildSectionCard(
                    title: '${'landslide_images'.tr} *',
                    primaryColor: primaryColor,
                    cardColor: cardColor,
                    textColor: textColor,
                    hasInfoIcon: true,
                    onInfoTap: () => controller.showImageRequirementDialog(),
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
                      
                      // Camera and Gallery buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () => controller.openCamera(),
                              icon: const Icon(Icons.camera_alt),
                              label: Text('camera'.tr),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: secondaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () => controller.openGallery(),
                              icon: const Icon(Icons.photo_library),
                              label: Text('gallery'.tr),
                            ),
                          ),
                        ],
                      ),
                      

                    ],
                  ),

                  const SizedBox(height: 16),

                  // Enhanced Selected Images Display with Captions
                  Obx(() {
                    if (controller.selectedImages.isNotEmpty) {
                      return _buildSectionCard(
                        title: '${'selected_images'.tr} (${controller.selectedImages.length}/5)',
                        primaryColor: primaryColor,
                        cardColor: cardColor,
                        textColor: textColor,
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.selectedImages.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Image with remove button
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.file(
                                            controller.selectedImages[index],
                                            width: double.infinity,
                                            height: 200,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: GestureDetector(
                                            onTap: () => controller.removeImage(index),
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                color: Colors.red,
                                                shape: BoxShape.circle,
                                              ),
                                              padding: const EdgeInsets.all(4),
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
                                          bottom: 8,
                                          left: 8,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(0.7),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              'Image ${index + 1}',
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
                                    const SizedBox(height: 12),
                                    // Caption text field
                                    Text(
                                      '${'caption_for_image'.tr} ${index + 1}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: textColor,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.grey[300]!),
                                      ),
                                      child: TextField(
                                        controller: controller.imageCaptions[index],
                                        maxLines: 2,
                                        decoration: InputDecoration(
                                          hintText: 'enter_caption_optional'.tr,
                                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  }),

                  const SizedBox(height: 24),

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
                                          'tap_view_details'.tr,
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
                                controller.isDraftMode.value ? 'submit_draft_report'.tr : 'submit_report'.tr,
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
            )),
    );
  }

  // Helper widgets
  Widget _buildSectionCard({
    required String title, 
    required List<Widget> children,
    required Color primaryColor,
    required Color cardColor,
    required Color textColor,
    bool hasInfoIcon = false,
    VoidCallback? onInfoTap,
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
                  if (hasInfoIcon && onInfoTap != null)
                    GestureDetector(
                      onTap: onInfoTap,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.info,
                          size: 16,
                          color: Colors.blue.shade700,
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

  Widget _buildCollapsibleSectionCard({
    required String title, 
    required List<Widget> children,
    required Color primaryColor,
    required Color cardColor,
    required Color textColor,
    required RxBool isExpanded,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: cardColor,
      child: Column(
        children: [
          // Header with expand/collapse button
          InkWell(
            onTap: () => isExpanded.value = !isExpanded.value,
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
                  Obx(() => Icon(
                    isExpanded.value ? Icons.expand_less : Icons.expand_more,
                    color: primaryColor,
                    size: 24,
                  )),
                ],
              ),
            ),
          ),
          // Collapsible content
          Obx(() => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: isExpanded.value ? null : 0,
            child: isExpanded.value 
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: children,
                  ),
                )
              : const SizedBox.shrink(),
          )),
        ],
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
    String? Function(String?)? validator,
  }) {
    return TextFormField(
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
    );
  }

  Widget _buildReadOnlyField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF1976D2), size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required void Function(String?)? onChanged,
    IconData? icon,
    String? hint,
    bool hasInfoIcon = false,
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

  Widget _buildHierarchicalCheckbox({
    required String title,
    required bool value,
    required Function(bool?) onChanged,
    required List<Widget> subItems,
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

  Widget _buildLocationModeSwitch(PublicLandslideReportController controller, Color primaryColor) {
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
                label: Text('manual_selection'.tr),
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

  Widget _buildRoadDamageFields(PublicLandslideReportController controller, Color primaryColor) {
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
                    value: controller.getTranslatedValueForDisplay(controller.roadTypeValue.value, PublicLandslideReportController.roadTypeOptions),
                    isExpanded: true,
                    hint: Text(
                      'select_occurrence_option'.tr,
                      style: const TextStyle(fontSize: 12),
                    ),
                    items: PublicLandslideReportController.roadTypeOptions.map((key) => DropdownMenuItem<String>(
                      value: key.tr,
                      child: Text(
                        key.tr,
                        style: const TextStyle(fontSize: 12),
                      ),
                    )).toList(),
                    onChanged: (String? value) {
                      String? englishKey = controller.getEnglishKeyFromTranslatedValue(value, PublicLandslideReportController.roadTypeOptions);
                      controller.roadTypeValue.value = englishKey;
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
                    value: controller.getTranslatedValueForDisplay(controller.roadExtentValue.value, PublicLandslideReportController.roadExtentOptions),
                    isExpanded: true,
                    hint: Text(
                      'select_occurrence_option'.tr,
                      style: const TextStyle(fontSize: 12),
                    ),
                    items: PublicLandslideReportController.roadExtentOptions.map((key) => DropdownMenuItem<String>(
                      value: key.tr,
                      child: Text(
                        key.tr,
                        style: const TextStyle(fontSize: 12),
                      ),
                    )).toList(),
                    onChanged: (String? value) {
                      String? englishKey = controller.getEnglishKeyFromTranslatedValue(value, PublicLandslideReportController.roadExtentOptions);
                      controller.roadExtentValue.value = englishKey;
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
}