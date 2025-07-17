import 'package:bhooskhalann/landslide/report_landslide_maps_screen/report_form_getx/draft_report_section/public_report_form_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    ? 'Edit Draft Report'
    : controller.isPendingEditMode.value 
      ? 'Edit Pending Report' 
      : 'Report Landslide (Public)',
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
                  controller.isDraftMode.value ? 'UPDATE' : 'SAVE',
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
                    'Submitting report...',
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
                                'You are editing a draft report. Your changes will be saved automatically.',
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
  title: 'Location Information',
  primaryColor: primaryColor,
  cardColor: cardColor,
  textColor: textColor,
  children: [
    _buildTextField(
      label: 'Latitude *',
      controller: controller.latitudeController,
      readOnly: true,
      validator: (value) => controller.validateRequired(value, 'Latitude'),
    ),
    const SizedBox(height: 16),
    _buildTextField(
      label: 'Longitude *',
      controller: controller.longitudeController,
      readOnly: true,
      validator: (value) => controller.validateRequired(value, 'Longitude'),
    ),
    const SizedBox(height: 16),

    // Add location mode switch
    _buildLocationModeSwitch(controller, primaryColor),
    
    // State Field - Conditional UI
    Obx(() {
      if (controller.isLocationAutoPopulated.value && controller.stateController.text.isNotEmpty) {
        // Show text field when auto-populated
        return _buildTextField(
          label: 'State *',
          controller: controller.stateController,
          readOnly: true,
          validator: (value) => controller.validateRequired(value, 'State'),
        );
      } else {
        // Show dropdown when manual selection needed
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _labelText('State *', textColor),
            _buildDropdown(
              hint: 'Select State',
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
          label: 'District *',
          controller: controller.districtController,
          readOnly: true,
          validator: (value) => controller.validateRequired(value, 'District'),
        );
      } else {
        // Show dropdown when manual selection needed
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _labelText('District *', textColor),
            _buildDropdown(
              hint: controller.selectedStateFromDropdown.value == null 
                  ? 'Select State first' 
                  : 'Select District',
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
      label: 'Subdivision/Taluk',
      controller: controller.subdivisionController,
    ),
    const SizedBox(height: 16),
    _buildTextField(
      label: 'Village',
      controller: controller.villageController,
    ),
    const SizedBox(height: 16),
    _buildTextField(
      label: 'Other relevant location details',
      controller: controller.locationDetailsController,
      maxLines: 3,
    ),
  ],
),     
                  const SizedBox(height: 16),
                  
                  // Occurrence Information Section
                  _buildSectionCard(
                   title: 'Occurrence of Landslide (Date & Time) *',
                    primaryColor: primaryColor,
                    cardColor: cardColor,
                    textColor: textColor,
                    children: [
                      Obx(() => _buildDropdown(
                        hint: '---Select---',
                        value: controller.landslideOccurrenceValue.value,
                        items: [
                          'I know the EXACT occurrence date',
                          'I know the APPROXIMATE occurrence date', 
                          'I DO NOT know the occurrence date'
                        ],
                        onChanged: (value) {
                          controller.landslideOccurrenceValue.value = value;
                          controller.dateController.clear();
                          controller.timeController.clear();
                          controller.howDoYouKnowValue.value = null;
                          // controller.occurrenceDateRangeController.clear();
                        },
                        icon: Icons.event,
                      )),
                      
                      // Conditional fields based on selection
                      Obx(() {
                        if (controller.landslideOccurrenceValue.value == 'I know the EXACT occurrence date') {
                          return Column(
                            children: [
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        _labelText('Date *', textColor),
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
                                                  controller.selectedDateText.value.isEmpty ? 'Select Date' : controller.selectedDateText.value,
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
                                        _labelText('Time', textColor),
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
                                                  controller.selectedTimeText.value.isEmpty ? 'Select Time' : controller.selectedTimeText.value,
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
                              _labelText('How do you know this Information? *', textColor),
                              _buildDropdown(
                                hint: 'Select source',
                                value: controller.howDoYouKnowValue.value,
                                items: [
                                  'I observed it',
                                  'Through a local',
                                  'Social media',
                                  'News',
                                  'I don\'t know',
                                ],
                                onChanged: (value) => controller.howDoYouKnowValue.value = value,
                                icon: Icons.info,
                              ),
                            ],
                          );
                       } else if (controller.landslideOccurrenceValue.value == 'I know the APPROXIMATE occurrence date') {
  return Column(
    children: [
      const SizedBox(height: 16),
      _labelText('Occurrence Date Range *', textColor),
      _buildDropdown(
        hint: '---Select---',
        value: controller.occurrenceDateRange.value.isEmpty ? null : controller.occurrenceDateRange.value,
        items: [
          'In the last 3 days',
          'In the last week', 
          'In the last month',
          'In the last 3 months',
          'In the last year',
          'Older than a year',                        
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
                    title: 'Where did landslide take place (Landuse/Landcover) *',
                    primaryColor: primaryColor,
                    cardColor: cardColor,
                    textColor: textColor,
                    children: [
                      Obx(() => _buildDropdown(
                        hint: 'Select location type',
                        value: controller.whereDidLandslideOccurValue.value,
                        items: ['Near/onroad', 'Next to river', 'Settlement', 'Plantation (tea,rubber .... etc.)', 'Forest Area', 'Cultivation','Barren Land','Other (Specify)'],
                        onChanged: (value) => controller.whereDidLandslideOccurValue.value = value,
                        icon: Icons.landscape,
                      )),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Type of Material
                  _buildSectionCard(
                    title: 'Type of Material *',
                    primaryColor: primaryColor,
                    cardColor: cardColor,
                    textColor: textColor,
                    children: [
                      Obx(() => _buildDropdown(
                        hint: 'Select material type',
                        value: controller.typeOfMaterialValue.value,
                        items: ['Rock', 'Soil', 'Debris (mixture of Rock and Soil)'],
                        onChanged: (value) => controller.typeOfMaterialValue.value = value,
                        icon: Icons.terrain,
                      )),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Type of Movement
                  _buildSectionCard(
                    title: 'Type of Movement *',
                    primaryColor: primaryColor,
                    cardColor: cardColor,
                    textColor: textColor,
                    children: [
                      Obx(() => _buildDropdown(
                        hint: 'Select movement type',
                        value: controller.typeOfMovementValue.value,
                        items: ['Slide','Fall', 'Topple','Subsidence','Creep','Lateral spread', 'Flow','Complex'],
                        onChanged: (value) => controller.typeOfMovementValue.value = value,
                        icon: Icons.move_down,
                      )),
                    ],
                  ),

                  const SizedBox(height: 16),
                  
                  // Landslide Size Section (New for Public Form)
                  _buildSectionCard(
                    title: 'Size of Landslide *',
                    primaryColor: primaryColor,
                    cardColor: cardColor,
                    textColor: textColor,
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
                                  controller.landslideSize.value ?? 'Select landslide size',
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
                      const SizedBox(height: 8),
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
                                const Text(
                                  'Size Categories:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text('• Small: Less than 2 storey building (< 6m)'),
                            const Text('• Medium: 2 to 5 storey building (6-15m)'),
                            const Text('• Large: More than 5 storey building (> 15m)'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // What induced/triggered the landslide
            // What induced/triggered the landslide - REPLACE the existing section with this
                  _buildSectionCard(
                    title: 'What induced landslide? *',
                    primaryColor: primaryColor,
                    cardColor: cardColor,
                    textColor: textColor,
                    children: [
                      Obx(() => _buildDropdown(
                        hint: 'Select trigger',
                        value: controller.whatInducedLandslideValue.value,
                        items: ['Rainfall', 'Earthquake', 'Man made', 'Snow melt', 'Vibration', 'Toe erosion', 'I don\'t know'],
                        onChanged: (value) {
                          controller.whatInducedLandslideValue.value = value;
                          // Clear rainfall fields if not rainfall
                          if (value != 'Rainfall') {
                            controller.rainfallAmountController.clear();
                            controller.rainfallDurationValue.value = null;
                          }
                        },
                        icon: Icons.warning_amber,
                      )),
                      
                      // Conditional rainfall fields
                      Obx(() {
                        if (controller.whatInducedLandslideValue.value == 'Rainfall') {
                          return Column(
                            children: [
                              const SizedBox(height: 20),
                              
                              // Amount of rainfall
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _labelText('Amount of rainfall(in mm), if known', textColor),
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
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                        border: InputBorder.none,
                                        hintText: 'Enter amount (e.g., 25.0, 25-30, 100+)',
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
                                  _labelText('Duration of rainfall *', textColor),
                                  const SizedBox(height: 12),
                                  
                                  // Radio button options
                                  _buildRainfallDurationOption(
                                    'No rainfall on the day of landslide',
                                    controller,
                                    primaryColor,
                                  ),
                                  _buildRainfallDurationOption(
                                    'Half of the day or less',
                                    controller,
                                    primaryColor,
                                  ),
                                  _buildRainfallDurationOption(
                                    'The whole day',
                                    controller,
                                    primaryColor,
                                  ),
                                  _buildRainfallDurationOption(
                                    'The last few days, but less than a week',
                                    controller,
                                    primaryColor,
                                  ),
                                  _buildRainfallDurationOption(
                                    'A week or more',
                                    controller,
                                    primaryColor,
                                  ),
                                  _buildRainfallDurationOption(
                                    'I don\'t know',
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

                  // Enhanced Impact/Damage Section (Same as detailed form)
                  _buildSectionCard(
                    title: 'What is Impact/Damage Caused by Landslide ?',
                    primaryColor: primaryColor,
                    cardColor: cardColor,
                    textColor: textColor,
                    children: [
                      // People affected
                      Obx(() => _buildHierarchicalCheckbox(
                        title: 'People affected',
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
                            label1: 'Dead',
                            label2: 'Injured',
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
                        title: 'Livestock affected',
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
                            label1: 'Dead',
                            label2: 'Injured',
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
                        title: 'Houses and buildings affected',
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
                            label1: 'Fully affected',
                            label2: 'Partially affected',
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
                        title: 'Roads affected',
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
                        title: 'Roads blocked',
                        value: controller.roadsBlocked.value,
                        onChanged: (value) {
                          controller.roadsBlocked.value = value ?? false;
                        },
                        primaryColor: primaryColor,
                        textColor: textColor,
                      )),
                      
                      // Railway line affected
                      Obx(() => _buildSimpleCheckboxListTile(
                        title: 'Railway line affected',
                        value: controller.railwayLineAffected.value,
                        onChanged: (value) {
                          controller.railwayLineAffected.value = value ?? false;
                        },
                        primaryColor: primaryColor,
                        textColor: textColor,
                      )),
                      
                      // Power infrastructure affected
                      Obx(() => _buildSimpleCheckboxListTile(
                        title: 'Power infrastructure affected',
                        value: controller.powerInfrastructureAffected.value,
                        onChanged: (value) {
                          controller.powerInfrastructureAffected.value = value ?? false;
                        },
                        primaryColor: primaryColor,
                        textColor: textColor,
                      )),
                      
                      // Damages to Agriculture/Barren/Forest
                      Obx(() => _buildSimpleCheckboxListTile(
                        title: 'Damages to Agriculture/Barren/Forest',
                        value: controller.damagesToAgriculturalForestLand.value,
                        onChanged: (value) {
                          controller.damagesToAgriculturalForestLand.value = value ?? false;
                        },
                        primaryColor: primaryColor,
                        textColor: textColor,
                      )),
                      
                      // Other damages
                      Obx(() => _buildHierarchicalCheckbox(
                        title: 'Other',
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
                            label: 'Mention details',
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
                        title: 'No damages',
                        value: controller.noDamages.value,
                        onChanged: (value) {
                          controller.noDamages.value = value ?? false;
                        },
                        primaryColor: primaryColor,
                        textColor: textColor,
                      )),
                      
                      // I don't know
                      Obx(() => _buildSimpleCheckboxListTile(
                        title: 'I don\'t know',
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

                  // Any other relevant information
                  _buildSectionCard(
                    title: 'Any other relevant information on the landslide',
                    primaryColor: primaryColor,
                    cardColor: cardColor,
                    textColor: textColor,
                    children: [
                      _buildTextField(
                        label: 'Enter any other relevant information',
                        controller: controller.otherRelevantInformation,
                        maxLines: 3,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                      // Contact Information Section
 // Replace the Contact Information Section in your UI (around line 650)
// Contact Information Section
_buildSectionCard(
  title: 'Contact Information',
  primaryColor: primaryColor,
  cardColor: cardColor,
  textColor: textColor,
  children: [
    Obx(() => _buildReadOnlyField(
      label: 'Name',
      value: controller.username.value,
      icon: Icons.person,
    )),
    const SizedBox(height: 16),
    // Make affiliation editable with save functionality
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _labelText('Affiliation', textColor),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                label: 'Enter your affiliation',
                controller: controller.affiliationController,
              ),
            ),
         
          ],
        ),
      ],
    ),
    const SizedBox(height: 16),
    Obx(() => _buildReadOnlyField(
      label: 'Email',
      value: controller.email.value,
      icon: Icons.email,
    )),
    const SizedBox(height: 16),
    Obx(() => _buildReadOnlyField(
      label: 'Mobile',
      value: controller.mobile.value,
      icon: Icons.phone,
    )),
  ],
),
                  const SizedBox(height: 16),

                  // Image Selection Section with Validation
                  _buildSectionCard(
                    title: 'Landslide Images *',
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
                              label: const Text('CAMERA'),
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
                              label: const Text('GALLERY'),
                            ),
                          ),
                        ],
                      ),
                      
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
                                const Text(
                                  'Image Requirements',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text('• At least 1 image is required to submit the report'),
                            const Text('• You can add up to 5 images'),
                            const Text('• Good quality images help in better assessment'),
                          ],
                        ),
                      ),
                    ],
                  ),

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
                                          'Tap "View Details" to see missing fields',
                                          style: TextStyle(
                                            color: Colors.orange.shade600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () => controller.showValidationSummary(),
                                        child: const Text('View Details'),
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
                                controller.isDraftMode.value ? 'SUBMIT DRAFT REPORT' : 'SUBMIT REPORT',
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
  }) {
    return Container(
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

  // Add this widget method at the bottom of the file, before the closing }
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

  Widget _buildRoadDamageFields(PublicLandslideReportController controller, Color primaryColor) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Road type',
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
                    hint: const Text(
                      '---Select---',
                      style: TextStyle(fontSize: 12),
                    ),
                    items: ['State Highway', 'National Highway', 'Local'].map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
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
                'Extent of damage',
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
                    hint: const Text(
                      '---Select---',
                      style: TextStyle(fontSize: 12),
                    ),
                    items: ['Full', 'Partial'].map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
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

  // Add this helper method at the bottom of PublicLandslideReportingScreen class
Widget _buildRainfallDurationOption(
  String title,
  PublicLandslideReportController controller,
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
}