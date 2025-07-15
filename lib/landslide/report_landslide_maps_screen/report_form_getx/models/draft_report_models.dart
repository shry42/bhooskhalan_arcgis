import 'dart:convert';

class DraftReport {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic> formData;
  final String title;
  final String? description;
  final int version;
  final List<String> tags;
  final String formType; // Added: 'expert' or 'public'

  DraftReport({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.formData,
    required this.title,
    this.description,
    this.version = 1,
    this.tags = const [],
    required this.formType, // Added
  });

  // Convert to JSON for SharedPreferences storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'formData': formData,
      'title': title,
      'description': description,
      'version': version,
      'tags': tags,
      'formType': formType, // Added
    };
  }

  // Create from JSON
  factory DraftReport.fromJson(Map<String, dynamic> json) {
    return DraftReport(
      id: json['id'] ?? '',
      createdAt: _parseDateTime(json['createdAt']),
      updatedAt: _parseDateTime(json['updatedAt']),
      formData: Map<String, dynamic>.from(json['formData'] ?? {}),
      title: json['title'] ?? 'Untitled Draft',
      description: json['description'],
      version: json['version'] ?? 1,
      tags: List<String>.from(json['tags'] ?? []),
      formType: json['formType'] ?? 'public', // Default to public for backward compatibility
    );
  }

  // Helper method to safely parse DateTime
  static DateTime _parseDateTime(dynamic dateValue) {
    if (dateValue == null) return DateTime.now();
    
    try {
      if (dateValue is String) {
        return DateTime.parse(dateValue);
      } else if (dateValue is int) {
        return DateTime.fromMillisecondsSinceEpoch(dateValue);
      }
    } catch (e) {
      print('Error parsing date: $e');
    }
    
    return DateTime.now();
  }

  // Convert to JSON string
  String toJsonString() {
    try {
      return jsonEncode(toJson());
    } catch (e) {
      print('Error converting to JSON string: $e');
      // Return minimal valid JSON
      return jsonEncode({
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'formData': {},
        'title': title,
        'version': version,
        'formType': formType,
      });
    }
  }

  // Create from JSON string
  factory DraftReport.fromJsonString(String jsonString) {
    try {
      final Map<String, dynamic> json = jsonDecode(jsonString);
      return DraftReport.fromJson(json);
    } catch (e) {
      print('Error parsing JSON string: $e');
      throw FormatException('Invalid draft report JSON: $e');
    }
  }

  // Create a copy with updated fields
  DraftReport copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? formData,
    String? title,
    String? description,
    int? version,
    List<String>? tags,
    String? formType,
  }) {
    return DraftReport(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      formData: formData ?? Map<String, dynamic>.from(this.formData),
      title: title ?? this.title,
      description: description ?? this.description,
      version: version ?? this.version,
      tags: tags ?? List<String>.from(this.tags),
      formType: formType ?? this.formType,
    );
  }

  // Helper properties for form type checking
  bool get isPublicForm => formType.toLowerCase() == 'public';
  bool get isExpertForm => formType.toLowerCase() == 'expert';

  // Get form type display name
  String get formTypeDisplayName {
    switch (formType.toLowerCase()) {
      case 'public':
        return 'Public Form';
      case 'expert':
        return 'Expert Form';
      default:
        return 'Unknown Form';
    }
  }

  // Generate title from form data
  static String generateTitle(Map<String, dynamic> formData) {
    try {
      String state = (formData['state'] ?? '').toString().trim();
      String district = (formData['district'] ?? '').toString().trim();
      String village = (formData['village'] ?? '').toString().trim();
      
      List<String> titleParts = [];
      
      if (village.isNotEmpty) {
        titleParts.add(village);
      }
      
      if (district.isNotEmpty && district != village) {
        titleParts.add(district);
      }
      
      if (state.isNotEmpty && state != district) {
        titleParts.add(state);
      }
      
      if (titleParts.isNotEmpty) {
        String title = titleParts.join(', ');
        // Limit title length
        if (title.length > 50) {
          return '${title.substring(0, 47)}...';
        }
        return title;
      }
      
      // Fallback to coordinates if available
      String latitude = (formData['latitude'] ?? '').toString().trim();
      String longitude = (formData['longitude'] ?? '').toString().trim();
      
      if (latitude.isNotEmpty && longitude.isNotEmpty) {
        try {
          double lat = double.parse(latitude);
          double lng = double.parse(longitude);
          return 'Location ${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}';
        } catch (e) {
          // Ignore parsing errors
        }
      }
      
      return 'Untitled Draft';
    } catch (e) {
      print('Error generating title: $e');
      return 'Untitled Draft';
    }
  }

  // Generate description from form data (form-type aware)
  static String generateDescription(Map<String, dynamic> formData) {
    try {
      List<String> descriptionParts = [];
      
      // Add material type if available
      String materialType = (formData['typeOfMaterial'] ?? '').toString().trim();
      if (materialType.isNotEmpty) {
        descriptionParts.add('Material: $materialType');
      }
      
      // Add movement type if available
      String movementType = (formData['typeOfMovement'] ?? '').toString().trim();
      if (movementType.isNotEmpty) {
        descriptionParts.add('Movement: $movementType');
      }
      
      // Add landslide size for public form
      String landslideSize = (formData['landslideSize'] ?? '').toString().trim();
      if (landslideSize.isNotEmpty) {
        descriptionParts.add('Size: $landslideSize');
      }
      
      // Add dimensions for expert form if available
      String length = (formData['length'] ?? '').toString().trim();
      String width = (formData['width'] ?? '').toString().trim();
      if (length.isNotEmpty && width.isNotEmpty) {
        descriptionParts.add('Dimensions: ${length}m × ${width}m');
      }
      
      return descriptionParts.join(' • ');
    } catch (e) {
      print('Error generating description: $e');
      return '';
    }
  }

  // Calculate completion percentage (form-type aware)
  double getCompletionPercentage() {
    try {
      if (isPublicForm) {
        return _calculatePublicFormCompletion();
      } else {
        return _calculateExpertFormCompletion();
      }
    } catch (e) {
      print('Error calculating completion: $e');
      return 0.0;
    }
  }

  // Calculate completion for PUBLIC form
  double _calculatePublicFormCompletion() {
    int totalRequiredFields = 8; // Public form required fields
    int filledRequiredFields = 0;
    
    // Required fields for public form
    if (_isFieldFilled('state')) filledRequiredFields++;
    if (_isFieldFilled('district')) filledRequiredFields++;
    if (formData['landslideOccurrence'] != null) filledRequiredFields++;
    if (formData['whereDidLandslideOccur'] != null) filledRequiredFields++;
    if (formData['typeOfMaterial'] != null) filledRequiredFields++;
    if (formData['typeOfMovement'] != null) filledRequiredFields++;
    if (formData['landslideSize'] != null) filledRequiredFields++;
    if ((formData['hasImages'] == true) || (formData['imageCount'] ?? 0) > 0) filledRequiredFields++;
    
    if (totalRequiredFields == 0) return 0.0;
    
    double percentage = (filledRequiredFields / totalRequiredFields) * 100;
    return percentage.clamp(0.0, 100.0);
  }

  // Calculate completion for EXPERT form
  double _calculateExpertFormCompletion() {
    int totalRequiredFields = 18; // Expert form required fields
    int filledRequiredFields = 0;
    
    // Location fields
    if (_isFieldFilled('state')) filledRequiredFields++;
    if (_isFieldFilled('district')) filledRequiredFields++;
    
    // Occurrence fields
    if (formData['landslideOccurrence'] != null) filledRequiredFields++;
    
    // Basic landslide data
    if (formData['whereDidLandslideOccur'] != null) filledRequiredFields++;
    if (formData['typeOfMaterial'] != null) filledRequiredFields++;
    if (formData['typeOfMovement'] != null) filledRequiredFields++;
    
    // Dimensions
    if (_isFieldFilled('length')) filledRequiredFields++;
    if (_isFieldFilled('width')) filledRequiredFields++;
    if (_isFieldFilled('height')) filledRequiredFields++;
    if (_isFieldFilled('area')) filledRequiredFields++;
    if (_isFieldFilled('depth')) filledRequiredFields++;
    if (_isFieldFilled('volume')) filledRequiredFields++;
    
    // Other required fields
    if (formData['activity'] != null) filledRequiredFields++;
    if (formData['style'] != null) filledRequiredFields++;
    if (formData['failureMechanism'] != null) filledRequiredFields++;
    if (formData['whatInducedLandslide'] != null) filledRequiredFields++;
    
    // Check at least one geo-scientific cause
    if (_hasAnyGeoScientificCause()) filledRequiredFields++;
    
    // Check images
    if ((formData['hasImages'] == true) || (formData['imageCount'] ?? 0) > 0) filledRequiredFields++;
    
    if (totalRequiredFields == 0) return 0.0;
    
    double percentage = (filledRequiredFields / totalRequiredFields) * 100;
    return percentage.clamp(0.0, 100.0);
  }

  // Check if a field is filled
  bool _isFieldFilled(String fieldName) {
    final value = formData[fieldName];
    return value != null && value.toString().trim().isNotEmpty;
  }

  // Check if any geo-scientific cause is selected (Expert form only)
  bool _hasAnyGeoScientificCause() {
    if (isPublicForm) return true; // Not applicable for public form
    
    return (formData['geologicalCauses'] == true) ||
           (formData['morphologicalCauses'] == true) ||
           (formData['humanCauses'] == true) ||
           (formData['otherCauses'] == true);
  }

  // Check if any remedial measure is selected (Expert form only)
  bool _hasAnyRemedialMeasure() {
    if (isPublicForm) return true; // Not applicable for public form
    
    return (formData['modificationOfSlopeGeometry'] == true) ||
           (formData['drainage'] == true) ||
           (formData['retainingStructures'] == true) ||
           (formData['internalSlopeReinforcement'] == true) ||
           (formData['remedialMeasuresNotRequired'] == true) ||
           (formData['remedialMeasuresNotAdequate'] == true) ||
           (formData['otherInformationChecked'] == true);
  }

  // Get completion status
  String getCompletionStatus() {
    double percentage = getCompletionPercentage();
    
    if (percentage == 0) return 'Not Started';
    if (percentage < 25) return 'Just Started';
    if (percentage < 50) return 'In Progress';
    if (percentage < 75) return 'Mostly Complete';
    if (percentage < 100) return 'Almost Done';
    return 'Complete';
  }

  // Get priority level based on content
  String getPriority() {
    try {
      // Check if it mentions people affected
      if (formData['peopleAffected'] == true) {
        return 'High';
      }
      
      // Check if it's recent
      if (DateTime.now().difference(updatedAt).inHours < 24) {
        return 'Medium';
      }
      
      return 'Normal';
    } catch (e) {
      return 'Normal';
    }
  }

  // Check if draft is valid for submission (form-type aware)
  bool isValidForSubmission() {
    if (isPublicForm) {
      return getCompletionPercentage() >= 75.0; // 75% for public form
    } else {
      return getCompletionPercentage() >= 80.0; // 80% for expert form
    }
  }

  // Get estimated time to complete (in minutes)
  int getEstimatedTimeToComplete() {
    double percentage = getCompletionPercentage();
    
    if (isPublicForm) {
      int remainingFields = ((100 - percentage) / 12.5).ceil(); // 8 fields = 100%, so 12.5% per field
      return remainingFields * 1; // 1 minute per field for public form
    } else {
      int remainingFields = ((100 - percentage) / 5.5).ceil(); // 18 fields = 100%, so ~5.5% per field
      return remainingFields * 2; // 2 minutes per field for expert form
    }
  }

  // Get field summary for quick view
  Map<String, dynamic> getFieldSummary() {
    return {
      'location': generateTitle(formData),
      'description': generateDescription(formData),
      'completion': getCompletionPercentage(),
      'status': getCompletionStatus(),
      'priority': getPriority(),
      'timeToComplete': getEstimatedTimeToComplete(),
      'isValidForSubmission': isValidForSubmission(),
      'lastModified': updatedAt,
      'hasImages': (formData['selectedImages']?.length ?? 0) > 0 || (formData['imageCount'] ?? 0) > 0,
      'formType': formType,
      'formTypeDisplay': formTypeDisplayName,
    };
  }

  // Export to simplified format for sharing
  Map<String, dynamic> toSimplifiedJson() {
    return {
      'id': id,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'completion': getCompletionPercentage(),
      'status': getCompletionStatus(),
      'formType': formType,
      'location': {
        'state': formData['state'],
        'district': formData['district'],
        'village': formData['village'],
        'latitude': formData['latitude'],
        'longitude': formData['longitude'],
      },
      'basicInfo': {
        'materialType': formData['typeOfMaterial'],
        'movementType': formData['typeOfMovement'],
        'landslideSize': formData['landslideSize'], // For public form
        'activity': formData['activity'], // For expert form
      },
      'version': version,
    };
  }

  // Validate form data integrity (form-type aware)
  bool validateDataIntegrity() {
    try {
      // Check if required structure exists
      if (formData is! Map<String, dynamic>) return false;
      
      // Check if essential fields are valid types
      if (formData['latitude'] != null) {
        final lat = formData['latitude'].toString();
        if (lat.isNotEmpty && double.tryParse(lat) == null) return false;
      }
      
      if (formData['longitude'] != null) {
        final lng = formData['longitude'].toString();
        if (lng.isNotEmpty && double.tryParse(lng) == null) return false;
      }
      
      // Check numeric fields for expert form
      if (isExpertForm) {
        final numericFields = ['length', 'width', 'height', 'area', 'depth', 'volume'];
        for (String field in numericFields) {
          final value = formData[field];
          if (value != null && value.toString().isNotEmpty) {
            if (double.tryParse(value.toString()) == null) return false;
          }
        }
      }
      
      return true;
    } catch (e) {
      print('Error validating data integrity: $e');
      return false;
    }
  }

  // Get data size in bytes (approximate)
  int getDataSize() {
    try {
      return toJsonString().length;
    } catch (e) {
      return 0;
    }
  }

  // Check if draft has been modified recently
  bool isRecentlyModified({int hoursThreshold = 24}) {
    return DateTime.now().difference(updatedAt).inHours < hoursThreshold;
  }

  // Override equality operator
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DraftReport && other.id == id;
  }

  // Override hashCode
  @override
  int get hashCode => id.hashCode;

  // Override toString for debugging
  @override
  String toString() {
    return 'DraftReport(id: $id, title: $title, formType: $formType, completion: ${getCompletionPercentage().toStringAsFixed(1)}%, updated: $updatedAt)';
  }

  // Create empty draft with basic structure
  factory DraftReport.createEmpty({
    required double latitude,
    required double longitude,
    required String formType,
  }) {
    final now = DateTime.now();
    return DraftReport(
      id: 'draft_${now.millisecondsSinceEpoch}',
      createdAt: now,
      updatedAt: now,
      title: 'New Draft',
      formType: formType,
      formData: {
        'latitude': latitude.toStringAsFixed(7),
        'longitude': longitude.toStringAsFixed(7),
      },
    );
  }

  // Create from existing report data (for editing)
  factory DraftReport.fromReportData({
    required String id,
    required Map<String, dynamic> reportData,
    required String formType,
    String? title,
  }) {
    final now = DateTime.now();
    return DraftReport(
      id: id,
      createdAt: now,
      updatedAt: now,
      title: title ?? generateTitle(reportData),
      formType: formType,
      formData: Map<String, dynamic>.from(reportData),
    );
  }
}