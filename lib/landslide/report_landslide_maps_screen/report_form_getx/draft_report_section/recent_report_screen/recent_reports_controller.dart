import 'dart:convert';
import 'package:bhooskhalann/landslide/report_landslide_maps_screen/report_form_getx/models/draft_report_models.dart';
import 'package:bhooskhalann/services/api_service.dart';
import 'package:bhooskhalann/services/pdf_export_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecentReportsController extends GetxController {
  static const String _draftReportsKey = 'draft_reports';
  static const String _toBeSyncedReportsKey = 'to_be_synced_reports';
  static const String _syncedReportsKey = 'synced_reports';
  
  // Observable lists for different report types
  var draftReports = <DraftReport>[].obs;
  var toBeSyncedReports = <Map<String, dynamic>>[].obs;
  var syncedReports = <Map<String, dynamic>>[].obs;
  
  // Filtered lists based on user type
  var filteredDraftReports = <DraftReport>[].obs;
  var filteredToBeSyncedReports = <Map<String, dynamic>>[].obs;
  var filteredSyncedReports = <Map<String, dynamic>>[].obs;

  // Current user type filter
  var currentUserTypeFilter = 'Public'.obs;

  // Search functionality
  var searchQuery = ''.obs;
  
  // Loading states
  var isLoadingDrafts = false.obs;
  var isLoadingToBeSynced = false.obs;
  var isLoadingSynced = false.obs;

  // Add this method to RecentReportsController
  Future<void> updateDraftSubmissionStatus(String draftId, String status) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final draftsJson = prefs.getStringList(_draftReportsKey) ?? [];
      
      for (int i = 0; i < draftsJson.length; i++) {
        final draft = DraftReport.fromJsonString(draftsJson[i]);
        if (draft.id == draftId) {
          // Create updated draft with new status
          final updatedDraft = DraftReport(
            id: draft.id,
            createdAt: draft.createdAt,
            updatedAt: DateTime.now(),
            formData: draft.formData,
            title: draft.title,
            description: draft.description,
            version: draft.version,
            tags: draft.tags,
            formType: draft.formType,
            submissionStatus: status,
          );
          
          // Replace the draft in the list
          draftsJson[i] = updatedDraft.toJsonString();
          await prefs.setStringList(_draftReportsKey, draftsJson);
          
          // Update the observable list
          await loadDraftReports();
          break;
        }
      }
    } catch (e) {
      print('Error updating draft submission status: $e');
    }
  }

// Replace the existing resubmitPendingReport method in RecentReportsController
Future<void> resubmitPendingReport(Map<String, dynamic> report) async {
  try {
    // Check connectivity
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      Get.snackbar(
        'error'.tr,
        'Please check your internet connection and try again', // Could add this to translations if needed
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Extract the actual form data
    Map<String, dynamic> submissionData;
    if (report.containsKey('data')) {
      submissionData = Map<String, dynamic>.from(report['data']);
    } else {
      submissionData = Map<String, dynamic>.from(report);
    }

    // Get mobile number and user type for API call
    String mobileNumber = submissionData['ContactMobile'] ?? 
                         submissionData['datacreatedby'] ?? 
                         submissionData['mobile'] ?? '';
    
    String userType = submissionData['UserType'] ?? 'Public';
    String formType = report['formType'] ?? 'public';
    
    if (mobileNumber.isEmpty) {
      throw Exception('Mobile number not found in report data');
    }

    print('🔄 Retrying submission for mobile: $mobileNumber, UserType: $userType, FormType: $formType');
    print('📋 Data keys: ${submissionData.keys.toList()}');

    // Try to submit based on form type
    if (formType.toLowerCase() == 'expert') {
      await ApiService.postLandslide('/Landslide/create/$mobileNumber/$userType', [submissionData]);
    } else {
      await ApiService.postLandslide('/Landslide/create/$mobileNumber/Public', [submissionData]);
    }
    
    // If successful, move to synced and remove from pending
    final syncedReport = {
      'id': report['id'],
      'originalToBeSyncedId': report['id'],
      'syncedAt': DateTime.now().toIso8601String(),
      'submittedData': submissionData,
      'status': 'synced',
      'title': report['title'] ?? 'untitled_report'.tr,
      'formType': formType,
    };
    
    await addSyncedReport(syncedReport);
    await removeToBeSyncedReport(report['id']);
    
    String formTypeText = formType.toLowerCase() == 'expert' ? 'expert'.tr : 'public'.tr;
    Get.snackbar(
      'export_ready'.tr, // Using existing translation key for "Success"
      '$formTypeText landslide report submitted successfully!', // Could add specific key if needed
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
    
  } catch (e) {
    print('❌ Resubmission failed: $e');
    
    // Update retry count
    final prefs = await SharedPreferences.getInstance();
    final reportsJson = prefs.getStringList(_toBeSyncedReportsKey) ?? [];
    
    for (int i = 0; i < reportsJson.length; i++) {
      try {
        final reportData = Map<String, dynamic>.from(jsonDecode(reportsJson[i]));
        if (reportData['id'] == report['id']) {
          reportData['retryCount'] = (reportData['retryCount'] ?? 0) + 1;
          reportData['lastRetryAt'] = DateTime.now().toIso8601String();
          reportsJson[i] = jsonEncode(reportData);
          break;
        }
      } catch (parseError) {
        print('Error updating retry count: $parseError');
      }
    }
    
    await prefs.setStringList(_toBeSyncedReportsKey, reportsJson);
    await loadToBeSyncedReports(); // Reload to update UI
    
    String formTypeText = (report['formType'] ?? 'public').toLowerCase() == 'expert' ? 'expert'.tr : 'public'.tr;
    Get.snackbar(
      'export_failed'.tr, // Using existing translation key for "Failed"
      'Failed to submit $formTypeText report: ${e.toString()}',
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
    );
  }
}

// Add method to download/export pending report
Future<String> exportPendingReportAsJson(Map<String, dynamic> report) async {
  try {
    String formTypeText = (report['formType'] ?? 'public').toLowerCase() == 'expert' ? 'expert'.tr : 'public'.tr;
    final exportData = {
      'exportedAt': DateTime.now().toIso8601String(),
      'reportType': 'To Be Synced $formTypeText Report',
      'formType': report['formType'] ?? 'public',
      'reportId': report['id'],
      'status': 'pending_sync',
      'retryCount': report['retryCount'] ?? 0,
      'createdAt': report['createdAt'],
      'reportData': report['data'] ?? report,
    };
    
    return jsonEncode(exportData);
  } catch (e) {
    throw Exception('${'export_failed'.tr}: $e');
  }
}

  @override
  void onInit() {
    super.onInit();
    loadDraftReports();
    loadToBeSyncedReports();
    loadSyncedReports();
  }

  // Set user type filter and update filtered lists
  void setUserTypeFilter(String userType) {
    currentUserTypeFilter.value = userType;
    _applyFilters();
  }

  // Apply filters to all lists
  void _applyFilters() {
    // Filter drafts by user type
    final userFormType = currentUserTypeFilter.value.toLowerCase() == 'public' ? 'public' : 'expert';
    
    filteredDraftReports.value = draftReports.where((draft) => 
      draft.formType.toLowerCase() == userFormType).toList();
    
    // Filter to-be-synced reports by user type
    filteredToBeSyncedReports.value = toBeSyncedReports.where((report) => 
      (report['formType']?.toString().toLowerCase() ?? 'public') == userFormType).toList();
    
    // Filter synced reports by user type
    filteredSyncedReports.value = syncedReports.where((report) => 
      (report['formType']?.toString().toLowerCase() ?? 'public') == userFormType).toList();
    
    // Apply search filter if there's a query
    if (searchQuery.value.isNotEmpty) {
      _applySearchFilter();
    }
  }

  // Apply search filter to filtered lists
  void _applySearchFilter() {
    if (searchQuery.value.isEmpty) {
      _applyFilters(); // Reset to user type filter only
      return;
    }
    
    final query = searchQuery.value.toLowerCase();
    
    // Filter drafts by search query
    final userFormType = currentUserTypeFilter.value.toLowerCase() == 'public' ? 'public' : 'expert';
    
    filteredDraftReports.value = draftReports.where((draft) {
      if (draft.formType.toLowerCase() != userFormType) return false;
      
      return draft.title.toLowerCase().contains(query) ||
             draft.formData['state']?.toString().toLowerCase().contains(query) == true ||
             draft.formData['district']?.toString().toLowerCase().contains(query) == true ||
             draft.formData['village']?.toString().toLowerCase().contains(query) == true;
    }).toList();
    
    // Filter other lists similarly
    filteredToBeSyncedReports.value = toBeSyncedReports.where((report) {
      if ((report['formType']?.toString().toLowerCase() ?? 'public') != userFormType) return false;
      
      return (report['title']?.toString().toLowerCase().contains(query) ?? false);
    }).toList();
    
    filteredSyncedReports.value = syncedReports.where((report) {
      if ((report['formType']?.toString().toLowerCase() ?? 'public') != userFormType) return false;
      
      return (report['title']?.toString().toLowerCase().contains(query) ?? false);
    }).toList();
  }

  // Search filtered drafts
  void searchFilteredDrafts(String query) {
    searchQuery.value = query;
    _applySearchFilter();
  }

  // Get user-specific statistics
  Map<String, dynamic> getUserTypeStatistics(String userType) {
    final now = DateTime.now();
    final thisWeek = now.subtract(const Duration(days: 7));
    final userFormType = userType.toLowerCase() == 'public' ? 'public' : 'expert';
    
    // User-specific counts
    final userDrafts = draftReports.where((draft) => 
      draft.formType.toLowerCase() == userFormType).length;
    
    final userToBeSynced = toBeSyncedReports.where((report) => 
      (report['formType']?.toString().toLowerCase() ?? 'public') == userFormType).length;
    
    final userSynced = syncedReports.where((report) => 
      (report['formType']?.toString().toLowerCase() ?? 'public') == userFormType).length;
    
    // Weekly stats for user
    final userDraftsThisWeek = draftReports.where((draft) => 
      draft.formType.toLowerCase() == userFormType && 
      draft.updatedAt.isAfter(thisWeek)).length;
    
    final userSyncedThisWeek = syncedReports.where((report) {
      if ((report['formType']?.toString().toLowerCase() ?? 'public') != userFormType) return false;
      final syncedAt = DateTime.parse(report['syncedAt']);
      return syncedAt.isAfter(thisWeek);
    }).length;
    
    // Completion statistics
    final userDraftsWithCompletion = draftReports.where((draft) => 
      draft.formType.toLowerCase() == userFormType).toList();
    
    double avgCompletion = 0.0;
    double completionRate = 0.0;
    
    if (userDraftsWithCompletion.isNotEmpty) {
      final totalCompletion = userDraftsWithCompletion.fold<double>(0.0, 
        (sum, draft) => sum + draft.getCompletionPercentage());
      avgCompletion = totalCompletion / userDraftsWithCompletion.length;
      
      final completedDrafts = userDraftsWithCompletion.where((draft) => 
        draft.isValidForSubmission()).length;
      completionRate = (completedDrafts / userDraftsWithCompletion.length) * 100;
    }
    
    return {
      'userDrafts': userDrafts,
      'userToBeSynced': userToBeSynced,
      'userSynced': userSynced,
      'userTotal': userDrafts + userToBeSynced + userSynced,
      'totalDrafts': draftReports.length,
      'totalToBeSynced': toBeSyncedReports.length,
      'totalSynced': syncedReports.length,
      'draftsThisWeek': userDraftsThisWeek,
      'syncedThisWeek': userSyncedThisWeek,
      'avgCompletion': avgCompletion.toInt(),
      'completionRate': completionRate.toInt(),
    };
  }

  // Get filtered drafts for current user type
  List<DraftReport> getCurrentUserDrafts() {
    return filteredDraftReports;
  }

  // Check if user has any reports
  bool hasAnyReports() {
    return filteredDraftReports.isNotEmpty || 
           filteredToBeSyncedReports.isNotEmpty || 
           filteredSyncedReports.isNotEmpty;
  }

  // Get completion summary for current user
  Map<String, dynamic> getUserCompletionSummary() {
    final drafts = filteredDraftReports;
    
    if (drafts.isEmpty) {
      return {
        'totalDrafts': 0,
        'avgCompletion': 0,
        'readyToSubmit': 0,
        'needsWork': 0,
      };
    }
    
    final totalCompletion = drafts.fold<double>(0.0, 
      (sum, draft) => sum + draft.getCompletionPercentage());
    
    final readyToSubmit = drafts.where((draft) => draft.isValidForSubmission()).length;
    final needsWork = drafts.length - readyToSubmit;
    
    return {
      'totalDrafts': drafts.length,
      'avgCompletion': (totalCompletion / drafts.length).toInt(),
      'readyToSubmit': readyToSubmit,
      'needsWork': needsWork,
    };
  }

  // Priority-based filtering
  List<DraftReport> getDraftsByPriority(String priority) {
    return filteredDraftReports.where((draft) => 
      draft.getPriority().toLowerCase() == priority.toLowerCase()).toList();
  }

  // Get recent activity for current user
  List<Map<String, dynamic>> getRecentActivity({int limit = 10}) {
    final activities = <Map<String, dynamic>>[];
    
    // Add recent drafts
    for (final draft in filteredDraftReports.take(limit ~/ 2)) {
      activities.add({
        'type': 'draft_updated',
        'title': draft.title,
        'time': draft.updatedAt,
        'formType': draft.formType,
      });
    }
    
    // Add recent synced reports
    for (final report in filteredSyncedReports.take(limit ~/ 2)) {
      activities.add({
        'type': 'report_synced',
        'title': report['title'],
        'time': DateTime.parse(report['syncedAt']),
        'formType': report['formType'],
      });
    }
    
    // Sort by time and return limited results
    activities.sort((a, b) => (b['time'] as DateTime).compareTo(a['time'] as DateTime));
    return activities.take(limit).toList();
  }

  // Load draft reports from SharedPreferences
  Future<void> loadDraftReports() async {
    try {
      isLoadingDrafts.value = true;
      final prefs = await SharedPreferences.getInstance();
      final draftsJson = prefs.getStringList(_draftReportsKey) ?? [];
      
      draftReports.clear();
      for (String draftJson in draftsJson) {
        try {
          final draft = DraftReport.fromJsonString(draftJson);
          draftReports.add(draft);
        } catch (e) {
          print('Error parsing draft: $e');
          // Remove corrupted draft
          draftsJson.remove(draftJson);
        }
      }
      
      // Clean up corrupted data if any were removed
      if (draftsJson.length != draftReports.length) {
        await prefs.setStringList(_draftReportsKey, 
          draftReports.map((draft) => draft.toJsonString()).toList());
      }
      
      // Sort by updated date (newest first)
      draftReports.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      
      // Apply filters after loading
      _applyFilters();
    } catch (e) {
      print('Error loading draft reports: $e');
      Get.snackbar(
        'error'.tr,
        'Failed to load draft reports', // Could add translation key if needed
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingDrafts.value = false;
    }
  }

  // Updated saveDraftReport method - ADD formType parameter
  Future<String> saveDraftReport(Map<String, dynamic> formData, String formType) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final draftsJson = prefs.getStringList(_draftReportsKey) ?? [];
      
      // Generate unique ID
      final String draftId = 'draft_${DateTime.now().millisecondsSinceEpoch}';
      final now = DateTime.now();
      
      final draft = DraftReport(
        id: draftId,
        createdAt: now,
        updatedAt: now,
        formData: formData,
        title: DraftReport.generateTitle(formData),
        formType: formType, // ADD this required parameter
      );
      
      // Add to list
      draftsJson.add(draft.toJsonString());
      
      // Save to SharedPreferences
      await prefs.setStringList(_draftReportsKey, draftsJson);
      
      // Update observable list
      draftReports.insert(0, draft);
      
      // Apply filters after adding new draft
      _applyFilters();
      
      print('Draft saved successfully with ID: $draftId, FormType: $formType');
      return draftId;
    } catch (e) {
      print('Error saving draft: $e');
      throw Exception('${'export_failed'.tr}: $e');
    }
  }

  // Updated updateDraftReport method - ADD formType parameter
  Future<void> updateDraftReport(String draftId, Map<String, dynamic> formData, String formType) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final draftsJson = prefs.getStringList(_draftReportsKey) ?? [];
      
      bool found = false;
      // Find and update the draft
      for (int i = 0; i < draftsJson.length; i++) {
        try {
          final draft = DraftReport.fromJsonString(draftsJson[i]);
          if (draft.id == draftId) {
            final updatedDraft = draft.copyWith(
              formData: formData,
              updatedAt: DateTime.now(),
              title: DraftReport.generateTitle(formData),
              formType: formType, // ADD this parameter
            );
            
            draftsJson[i] = updatedDraft.toJsonString();
            found = true;
            break;
          }
        } catch (e) {
          print('Error parsing draft during update: $e');
          // Remove corrupted draft
          draftsJson.removeAt(i);
          i--; // Adjust index after removal
        }
      }
      
      if (!found) {
        throw Exception('Draft with ID $draftId not found');
      }
      
      // Save to SharedPreferences
      await prefs.setStringList(_draftReportsKey, draftsJson);
      
      // Reload drafts to update UI
      await loadDraftReports();
      
      print('Draft updated successfully: $draftId, FormType: $formType');
    } catch (e) {
      print('Error updating draft: $e');
      throw Exception('${'export_failed'.tr}: $e');
    }
  }

  // Delete a draft report
  Future<void> deleteDraftReport(String draftId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final draftsJson = prefs.getStringList(_draftReportsKey) ?? [];
      
      // Remove the draft
      bool removed = false;
      draftsJson.removeWhere((draftJson) {
        try {
          final draft = DraftReport.fromJsonString(draftJson);
          if (draft.id == draftId) {
            removed = true;
            return true;
          }
          return false;
        } catch (e) {
          print('Error parsing draft during deletion: $e');
          // Remove corrupted drafts too
          return true;
        }
      });
      
      if (!removed) {
        throw Exception('Draft with ID $draftId not found');
      }
      
      // Save to SharedPreferences
      await prefs.setStringList(_draftReportsKey, draftsJson);
      
      // Update observable list
      draftReports.removeWhere((draft) => draft.id == draftId);
      
      // Apply filters after deletion
      _applyFilters();
      
      Get.snackbar(
        'export_ready'.tr, // Using existing key for "Success"
        'Draft deleted successfully', // Could add specific translation key
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      
      print('Draft deleted successfully: $draftId');
    } catch (e) {
      print('Error deleting draft: $e');
      Get.snackbar(
        'error'.tr,
        '${'export_failed'.tr}: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Get a specific draft by ID
  DraftReport? getDraftById(String draftId) {
    try {
      return draftReports.firstWhere((draft) => draft.id == draftId);
    } catch (e) {
      print('Draft not found: $draftId');
      return null;
    }
  }

  // Get all drafts matching a pattern
  List<DraftReport> getDraftsByTitle(String searchTitle) {
    return draftReports.where((draft) => 
      draft.title.toLowerCase().contains(searchTitle.toLowerCase())
    ).toList();
  }

  // Updated moveDraftToSynced method
  Future<void> moveDraftToSynced(String draftId, Map<String, dynamic> syncedData) async {
    try {
      // Get the original draft to preserve formType
      final originalDraft = getDraftById(draftId);
      final formType = originalDraft?.formType ?? 'public'; // Fallback to public
      
      // Create synced report entry
      final syncedReport = {
        'id': draftId,
        'originalDraftId': draftId,
        'syncedAt': DateTime.now().toIso8601String(),
        'submittedData': syncedData,
        'status': 'synced',
        'title': DraftReport.generateTitle(syncedData),
        'formType': formType, // Include formType in synced data
      };
      
      // Add to synced reports
      await addSyncedReport(syncedReport);
      
      // Remove from drafts
      await deleteDraftReport(draftId);
      
      print('Draft moved to synced successfully: $draftId, FormType: $formType');
    } catch (e) {
      print('Error moving draft to synced: $e');
    }
  }

  // Helper method to get statistics by form type
  Map<String, dynamic> getStatisticsByFormType() {
    final publicDrafts = draftReports.where((draft) => draft.isPublicForm).length;
    final expertDrafts = draftReports.where((draft) => draft.isExpertForm).length;
    
    final publicSynced = syncedReports.where((report) => 
      report['formType']?.toString().toLowerCase() == 'public').length;
    final expertSynced = syncedReports.where((report) => 
      report['formType']?.toString().toLowerCase() == 'expert').length;
    
    return {
      'publicDrafts': publicDrafts,
      'expertDrafts': expertDrafts,
      'publicSynced': publicSynced,
      'expertSynced': expertSynced,
      'totalPublic': publicDrafts + publicSynced,
      'totalExpert': expertDrafts + expertSynced,
    };
  }

  // Add a report to "To Be Synced" list
 // Replace the existing addToBeSyncedReport method in RecentReportsController
Future<void> addToBeSyncedReport(Map<String, dynamic> reportData) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final reportsJson = prefs.getStringList(_toBeSyncedReportsKey) ?? [];
    
    final report = {
      'id': 'pending_${DateTime.now().millisecondsSinceEpoch}',
      'createdAt': DateTime.now().toIso8601String(),
      'data': reportData, // Store the complete form data here
      'status': 'pending_sync',
      'retryCount': 0,
      'title': reportData['title'] ?? _generateTitleFromData(reportData),
      'formType': reportData['formType'] ?? 'public', // Ensure formType is set
    };
    
    reportsJson.add(jsonEncode(report));
    await prefs.setStringList(_toBeSyncedReportsKey, reportsJson);
    
    // Update observable list
    toBeSyncedReports.insert(0, report);
    
    // Apply filters after adding
    _applyFilters();
    
    print('✅ Report added to sync queue with ID: ${report['id']}');
  } catch (e) {
    print('❌ Error adding to sync queue: $e');
  }
}

// Update an existing pending report
Future<void> updatePendingReport(String reportId, Map<String, dynamic> updatedData) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final reportsJson = prefs.getStringList(_toBeSyncedReportsKey) ?? [];
    
    bool found = false;
    for (int i = 0; i < reportsJson.length; i++) {
      try {
        final report = Map<String, dynamic>.from(jsonDecode(reportsJson[i]));
        if (report['id'] == reportId) {
          // Update the report data
          report['data'] = updatedData;
          report['updatedAt'] = DateTime.now().toIso8601String();
          report['title'] = _generateTitleFromData(updatedData);
          
          reportsJson[i] = jsonEncode(report);
          found = true;
          break;
        }
      } catch (e) {
        print('Error updating pending report: $e');
      }
    }
    
    if (!found) {
      throw Exception('Pending report with ID $reportId not found');
    }
    
    await prefs.setStringList(_toBeSyncedReportsKey, reportsJson);
    await loadToBeSyncedReports(); // Reload to update UI
    
    print('✅ Pending report updated successfully: $reportId');
  } catch (e) {
    print('❌ Error updating pending report: $e');
    throw e;
  }
}

// Add helper method to generate title from form data
String _generateTitleFromData(Map<String, dynamic> data) {
  final state = data['State'] ?? data['state'] ?? '';
  final district = data['District'] ?? data['district'] ?? '';
  
  if (state.isNotEmpty && district.isNotEmpty) {
    return 'Landslide Report - $district, $state';
  } else if (state.isNotEmpty) {
    return 'Landslide Report - $state';
  } else {
    return 'public'.tr + ' Landslide Report';
  }
}

  // Load "To Be Synced" reports
  Future<void> loadToBeSyncedReports() async {
    try {
      isLoadingToBeSynced.value = true;
      final prefs = await SharedPreferences.getInstance();
      final reportsJson = prefs.getStringList(_toBeSyncedReportsKey) ?? [];
      
      toBeSyncedReports.clear();
      for (String reportJson in reportsJson) {
        try {
          final report = Map<String, dynamic>.from(jsonDecode(reportJson));
          toBeSyncedReports.add(report);
        } catch (e) {
          print('Error parsing to-be-synced report: $e');
          // Remove corrupted data
          reportsJson.remove(reportJson);
        }
      }
      
      // Clean up corrupted data if any were removed
      if (reportsJson.length != toBeSyncedReports.length) {
        await prefs.setStringList(_toBeSyncedReportsKey, 
          toBeSyncedReports.map((report) => jsonEncode(report)).toList());
      }
      
      // Sort by created date (newest first)
      toBeSyncedReports.sort((a, b) {
        final dateA = DateTime.parse(a['createdAt']);
        final dateB = DateTime.parse(b['createdAt']);
        return dateB.compareTo(dateA);
      });
      
      // Apply filters after loading
      _applyFilters();
    } catch (e) {
      print('Error loading to-be-synced reports: $e');
    } finally {
      isLoadingToBeSynced.value = false;
    }
  }

  // Remove a report from "To Be Synced" list
  Future<void> removeToBeSyncedReport(String reportId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reportsJson = prefs.getStringList(_toBeSyncedReportsKey) ?? [];
      
      reportsJson.removeWhere((reportJson) {
        try {
          final report = jsonDecode(reportJson);
          return report['id'] == reportId;
        } catch (e) {
          return true; // Remove corrupted data
        }
      });
      
      await prefs.setStringList(_toBeSyncedReportsKey, reportsJson);
      toBeSyncedReports.removeWhere((report) => report['id'] == reportId);
      
      // Apply filters after removal
      _applyFilters();
    } catch (e) {
      print('Error removing from sync queue: $e');
    }
  }

  // Add a report to synced list
  Future<void> addSyncedReport(Map<String, dynamic> syncedReport) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reportsJson = prefs.getStringList(_syncedReportsKey) ?? [];
      
      reportsJson.add(jsonEncode(syncedReport));
      await prefs.setStringList(_syncedReportsKey, reportsJson);
      
      // Update observable list
      syncedReports.insert(0, syncedReport);
      
      // Apply filters after adding
      _applyFilters();
      
      print('Report added to synced list');
    } catch (e) {
      print('Error adding to synced list: $e');
    }
  }

  // Load "Synced" reports
  Future<void> loadSyncedReports() async {
    try {
      isLoadingSynced.value = true;
      final prefs = await SharedPreferences.getInstance();
      final reportsJson = prefs.getStringList(_syncedReportsKey) ?? [];
      
      syncedReports.clear();
      for (String reportJson in reportsJson) {
        try {
          final report = Map<String, dynamic>.from(jsonDecode(reportJson));
          syncedReports.add(report);
        } catch (e) {
          print('Error parsing synced report: $e');
          // Remove corrupted data
          reportsJson.remove(reportJson);
        }
      }
      
      // Clean up corrupted data if any were removed
      if (reportsJson.length != syncedReports.length) {
        await prefs.setStringList(_syncedReportsKey, 
          syncedReports.map((report) => jsonEncode(report)).toList());
      }
      
      // Sort by synced date (newest first)
      syncedReports.sort((a, b) {
        final dateA = DateTime.parse(a['syncedAt']);
        final dateB = DateTime.parse(b['syncedAt']);
        return dateB.compareTo(dateA);
      });
      
      // Apply filters after loading
      _applyFilters();
    } catch (e) {
      print('Error loading synced reports: $e');
    } finally {
      isLoadingSynced.value = false;
    }
  }

  // Clear all synced reports (for maintenance)
  Future<void> clearSyncedReports() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_syncedReportsKey);
      syncedReports.clear();
      
      // Apply filters after clearing
      _applyFilters();
      
      Get.snackbar(
        'export_ready'.tr, // Using existing key for "Success"
        'Synced reports cleared', // Could add translation key if needed
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('Error clearing synced reports: $e');
    }
  }

  // Refresh all reports
  Future<void> refreshAllReports() async {
    await Future.wait([
      loadDraftReports(),
      loadToBeSyncedReports(),
      loadSyncedReports(),
    ]);
  }

  // Get formatted display number for draft
  String getDraftDisplayNumber(int index) {
    return (index + 1).toString();
  }

  // Get time ago string
  String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years year${years == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months == 1 ? '' : 's'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  // Get storage usage information
  Future<Map<String, dynamic>> getStorageInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final draftsSize = (prefs.getStringList(_draftReportsKey) ?? [])
          .fold<int>(0, (sum, item) => sum + item.length);
      
      final toBeSyncedSize = (prefs.getStringList(_toBeSyncedReportsKey) ?? [])
          .fold<int>(0, (sum, item) => sum + item.length);
      
      final syncedSize = (prefs.getStringList(_syncedReportsKey) ?? [])
          .fold<int>(0, (sum, item) => sum + item.length);
      
      return {
        'draftsCount': draftReports.length,
        'toBeSyncedCount': toBeSyncedReports.length,
        'syncedCount': syncedReports.length,
        'draftsSize': draftsSize,
        'toBeSyncedSize': toBeSyncedSize,
        'syncedSize': syncedSize,
        'totalSize': draftsSize + toBeSyncedSize + syncedSize,
      };
    } catch (e) {
      print('Error getting storage info: $e');
      return {};
    }
  }

  // Export drafts as JSON (for backup) - Updated with user type support
  Future<String> exportDraftsAsJson({String? userType}) async {
    try {
      List<DraftReport> draftsToExport;
      
      if (userType != null) {
        final formType = userType.toLowerCase() == 'public' ? 'public' : 'expert';
        draftsToExport = draftReports.where((draft) => 
          draft.formType.toLowerCase() == formType).toList();
      } else {
        draftsToExport = draftReports;
      }
      
      final exportData = {
        'exportedAt': DateTime.now().toIso8601String(),
        'version': '1.0',
        'userType': userType,
        'draftsCount': draftsToExport.length,
        'drafts': draftsToExport.map((draft) => draft.toJson()).toList(),
      };
      
      return jsonEncode(exportData);
    } catch (e) {
      print('Error exporting drafts: $e');
      throw Exception('${'export_failed'.tr}');
    }
  }

  // Export drafts as PDF - New method
  Future<void> exportDraftsAsPdf({String? userType}) async {
    try {
      List<DraftReport> draftsToExport;
      
      if (userType != null) {
        final formType = userType.toLowerCase() == 'public' ? 'public' : 'expert';
        draftsToExport = draftReports.where((draft) => 
          draft.formType.toLowerCase() == formType).toList();
      } else {
        draftsToExport = draftReports;
      }

      if (draftsToExport.isEmpty) {
        Get.snackbar(
          'No Drafts',
          'No drafts available to export',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Convert drafts to map format for PDF generation
      final List<Map<String, dynamic>> draftsData = draftsToExport
          .map((draft) => draft.formData)
          .toList();

      final formType = userType?.toLowerCase() ?? 'public';
      final pdfService = PdfExportService();
      
      // Generate PDF
      final file = await pdfService.generateDraftsPdf(draftsData, formType);
      
      // Show success notification
      pdfService.showDownloadNotification(file, file.path.split('/').last);
      
    } catch (e) {
      print('Error exporting drafts as PDF: $e');
      Get.snackbar(
        'Export Failed',
        'Failed to export drafts as PDF: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Export single draft as PDF
  Future<void> exportDraftAsPdf(DraftReport draft) async {
    try {
      final pdfService = PdfExportService();
      
      // Generate PDF
      final file = await pdfService.generateDraftPdf(draft.formData, draft.formType);
      
      // Show success notification
      pdfService.showDownloadNotification(file, file.path.split('/').last);
      
    } catch (e) {
      print('Error exporting draft as PDF: $e');
      Get.snackbar(
        'Export Failed',
        'Failed to export draft as PDF: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Import drafts from JSON (for restore)
  Future<void> importDraftsFromJson(String jsonData) async {
    try {
      final importData = jsonDecode(jsonData);
      final List<dynamic> draftsData = importData['drafts'] ?? [];
      
      for (var draftData in draftsData) {
        final draft = DraftReport.fromJson(draftData);
        
        // Check if draft already exists
        if (!draftReports.any((existingDraft) => existingDraft.id == draft.id)) {
          draftReports.add(draft);
        }
      }
      
      // Save imported drafts
      final prefs = await SharedPreferences.getInstance();
      final draftsJson = draftReports.map((draft) => draft.toJsonString()).toList();
      await prefs.setStringList(_draftReportsKey, draftsJson);
      
      // Sort by updated date
      draftReports.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      
      // Apply filters after import
      _applyFilters();
      
      Get.snackbar(
        'export_ready'.tr, // Using existing key for "Success"
        '${draftsData.length} drafts imported successfully', // Could add translation key
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('Error importing drafts: $e');
      Get.snackbar(
        'error'.tr,
        '${'export_failed'.tr}: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Clean up old reports (maintenance function)
  Future<void> cleanupOldReports({int maxAgeInDays = 90}) async {
    try {
      final cutoffDate = DateTime.now().subtract(Duration(days: maxAgeInDays));
      
      // Clean up old synced reports
      final oldSyncedCount = syncedReports.length;
      syncedReports.removeWhere((report) {
        final syncedAt = DateTime.parse(report['syncedAt']);
        return syncedAt.isBefore(cutoffDate);
      });
      
      if (syncedReports.length < oldSyncedCount) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setStringList(_syncedReportsKey, 
          syncedReports.map((report) => jsonEncode(report)).toList());
        
        // Apply filters after cleanup
        _applyFilters();
        
        final cleanedCount = oldSyncedCount - syncedReports.length;
        Get.snackbar(
          'cleanup'.tr + ' Complete', // Using existing translation key
          '$cleanedCount old reports cleaned up',
          backgroundColor: Colors.blue,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('Error during cleanup: $e');
    }
  }

  // Get statistics for dashboard
  Map<String, dynamic> getStatistics() {
    final now = DateTime.now();
    final thisWeek = now.subtract(const Duration(days: 7));
    final thisMonth = now.subtract(const Duration(days: 30));
    
    final draftsThisWeek = draftReports.where((draft) => 
      draft.updatedAt.isAfter(thisWeek)).length;
    
    final draftsThisMonth = draftReports.where((draft) => 
      draft.updatedAt.isAfter(thisMonth)).length;
    
    final syncedThisWeek = syncedReports.where((report) {
      final syncedAt = DateTime.parse(report['syncedAt']);
      return syncedAt.isAfter(thisWeek);
    }).length;
    
    final syncedThisMonth = syncedReports.where((report) {
      final syncedAt = DateTime.parse(report['syncedAt']);
      return syncedAt.isAfter(thisMonth);
    }).length;
    
    return {
      'totalDrafts': draftReports.length,
      'totalToBeSynced': toBeSyncedReports.length,
      'totalSynced': syncedReports.length,
      'draftsThisWeek': draftsThisWeek,
      'draftsThisMonth': draftsThisMonth,
      'syncedThisWeek': syncedThisWeek,
      'syncedThisMonth': syncedThisMonth,
    };
  }

  // Updated search functionality to include form type filtering
  List<DraftReport> searchDrafts(String query, {String? formTypeFilter}) {
    var results = draftReports;
    
    // Filter by form type if specified
    // if (formTypeFilter != null && formTypeFilter.isNotEmpty) {
    //   results = results.where((draft) => 
    //     draft.formType.toLowerCase() == formTypeFilter.toLowerCase()).toList();
    // }
    
    // Filter by search query
    if (query.isEmpty) return results;
    
    final lowercaseQuery = query.toLowerCase();
    return results.where((draft) {
      return draft.title.toLowerCase().contains(lowercaseQuery) ||
             draft.formData['state']?.toString().toLowerCase().contains(lowercaseQuery) == true ||
             draft.formData['district']?.toString().toLowerCase().contains(lowercaseQuery) == true ||
             draft.formData['village']?.toString().toLowerCase().contains(lowercaseQuery) == true;
    }).toList();
  }

  // Add method to get drafts by form type
  List<DraftReport> getDraftsByFormType(String formType) {
    return draftReports.where((draft) => 
      draft.formType.toLowerCase() == formType.toLowerCase()).toList();
  }

  // Count drafts by form type - Updated to match existing method
  int countDraftsByFormType(String formType) {
    return draftReports.where((draft) => 
      draft.formType.toLowerCase() == formType.toLowerCase()).length;
  }

  @override
  void onClose() {
    // Clean up any resources if needed
    super.onClose();
  }
}