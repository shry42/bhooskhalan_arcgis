import 'package:bhooskhalann/landslide/report_landslide_maps_screen/report_form_getx/draft_report_section/draft_report_form.dart';
import 'package:bhooskhalann/landslide/report_landslide_maps_screen/report_form_getx/draft_report_section/public_report_form_screen.dart';
import 'package:bhooskhalann/landslide/report_landslide_maps_screen/report_form_getx/draft_report_section/recent_report_screen/recent_reports_controller.dart';
import 'package:bhooskhalann/user_profile/profile_controller.dart';
import 'package:bhooskhalann/screens/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bhooskhalann/landslide/report_landslide_maps_screen/report_form_getx/models/draft_report_models.dart';

class RecentReportsPage extends StatefulWidget {
  const RecentReportsPage({super.key});

  @override
  State<RecentReportsPage> createState() => _RecentReportsPageState();
}

class _RecentReportsPageState extends State<RecentReportsPage> {

  ProfileController pc = Get.put(ProfileController());
  late RecentReportsController controller;
  String currentUserType = 'Public'; // Default to Public
  bool isLoadingUserType = true;

  @override
  void initState() {
    super.initState();
    controller = Get.put(RecentReportsController());
    _loadUserType();
  }

  Future<void> _loadUserType() async {
    pc.fetchUserProfile();
    try {
      final prefs = await SharedPreferences.getInstance();
      final userType = prefs.getString('userType') ?? 'Public';
      setState(() {
        currentUserType = userType;
        isLoadingUserType = false;
      });
      
      // Filter reports based on user type after loading
      controller.setUserTypeFilter(userType);
    } catch (e) {
      print('Error loading user type: $e');
      setState(() {
        currentUserType = 'Public';
        isLoadingUserType = false;
      });
      controller.setUserTypeFilter('Public');
    }
  }

  // Added missing methods for _RecentReportsPageState
  String _getFormTypeText() {
    return currentUserType == 'Public' ? 'public'.tr : 'expert'.tr;
  }

  void _handleAction(String value, BuildContext context) {
    // This seems to be meant for the menu actions
    _handleMenuAction(value, controller);
  }

// Replace the existing build method in _RecentReportsPageState class (around line 47-150)
@override
Widget build(BuildContext context) {
  if (isLoadingUserType) {
    return Scaffold(
      appBar: AppBar(
        title: Text('recent_reports'.tr),
        backgroundColor: Colors.blue,
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  // Check if user is Public - show only Draft tab
  if (currentUserType == 'Public') {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'my_draft_reports'.tr,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              '$currentUserType ${'user_dashboard'.tr}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            print('Back button pressed - Public user');
            try {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else if (Get.isDialogOpen == true) {
                Get.back();
              } else {
                // Fallback: try to go back to home screen
                Get.offAll(() => HomeScreen());
              }
            } catch (e) {
              print('Navigation error: $e');
              // Final fallback
              Get.offAll(() => HomeScreen());
            }
          },
        ),
        backgroundColor: _getUserTypeColor(),
        elevation: 0,
        actions: [
          // User type indicator
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getUserTypeIcon(),
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  currentUserType.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(value, controller),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'refresh',
                child: Row(
                  children: [
                    const Icon(Icons.refresh, size: 18, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text('refresh'.tr),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'storage_info',
                child: Row(
                  children: [
                    const Icon(Icons.storage, size: 18, color: Colors.green),
                    const SizedBox(width: 8),
                    Text('storage_info'.tr),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'user_stats',
                child: Row(
                  children: [
                    const Icon(Icons.analytics, size: 18, color: Colors.orange),
                    const SizedBox(width: 8),
                    Text('user_stats'.tr),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'cleanup',
                child: Row(
                  children: [
                    const Icon(Icons.cleaning_services, size: 18, color: Colors.red),
                    const SizedBox(width: 8),
                    Text('cleanup'.tr),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    const Icon(Icons.download, size: 18, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text('export'.tr),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: DraftReportsTab(controller: controller, userType: currentUserType),
    );
  }

  // For Expert users - show all tabs (existing tabbed interface)
  return DefaultTabController(
    length: 3,
    child: Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'recent_reports'.tr,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              '$currentUserType ${'user_dashboard'.tr}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            print('Back button pressed - Expert user');
            try {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else if (Get.isDialogOpen == true) {
                Get.back();
              } else {
                // Fallback: try to go back to home screen
                Get.offAll(() => HomeScreen());
              }
            } catch (e) {
              print('Navigation error: $e');
              // Final fallback
              Get.offAll(() => HomeScreen());
            }
          },
        ),
        backgroundColor: _getUserTypeColor(),
        elevation: 0,
        actions: [
          // User type indicator
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getUserTypeIcon(),
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  currentUserType.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(value, controller),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'refresh',
                child: Row(
                  children: [
                    const Icon(Icons.refresh, size: 18, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text('refresh'.tr),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'storage_info',
                child: Row(
                  children: [
                    const Icon(Icons.storage, size: 18, color: Colors.green),
                    const SizedBox(width: 8),
                    Text('storage_info'.tr),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'user_stats',
                child: Row(
                  children: [
                    const Icon(Icons.analytics, size: 18, color: Colors.orange),
                    const SizedBox(width: 8),
                    Text('user_stats'.tr),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'cleanup',
                child: Row(
                  children: [
                    const Icon(Icons.cleaning_services, size: 18, color: Colors.red),
                    const SizedBox(width: 8),
                    Text('cleanup'.tr),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    const Icon(Icons.download, size: 18, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text('export'.tr),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          isScrollable: true,
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(width: 2.0, color: Colors.white),
            insets: EdgeInsets.symmetric(horizontal: 30.0),
          ),
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            color: Colors.white70,
          ),
          tabs: [
            Tab(
              child: Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('draft'.tr.toUpperCase()),
                  const SizedBox(width: 2),
                  if (controller.filteredDraftReports.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${controller.filteredDraftReports.length}',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              )),
            ),
            Tab(
              child: Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('to_be_synced'.tr.toUpperCase()),
                  const SizedBox(width: 2),
                  if (controller.filteredToBeSyncedReports.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        // Navigate to the "To Be Synced" tab (index 1)
                        DefaultTabController.of(context)?.animateTo(1);
                        
                        // Optional: Show a snackbar to guide user
                        Get.snackbar(
                          'pending_reports'.tr,
                          'tap_report_to_edit'.tr,
                          backgroundColor: Colors.orange,
                          colorText: Colors.white,
                          snackPosition: SnackPosition.BOTTOM,
                          duration: const Duration(seconds: 2),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${controller.filteredToBeSyncedReports.length}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              )),
            ),
            Tab(
              child: Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('synced'.tr.toUpperCase()),
                  const SizedBox(width: 2),
                  if (controller.filteredSyncedReports.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${controller.filteredSyncedReports.length}',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              )),
            ),
          ],
        ),
      ),
      body: TabBarView(
        children: [
          DraftReportsTab(controller: controller, userType: currentUserType),
          ToBeSyncedReportsTab(controller: controller, userType: currentUserType),
          SyncedReportsTab(controller: controller, userType: currentUserType),
        ],
      ),
    ),
  );
}

  Color _getUserTypeColor() {
    return currentUserType == 'Public' ? Colors.blue : Colors.green;
  }

  IconData _getUserTypeIcon() {
    return currentUserType == 'Public' ? Icons.person : Icons.engineering;
  }

  void _handleMenuAction(String action, RecentReportsController controller) {
    switch (action) {
      case 'refresh':
        controller.refreshAllReports();
        Get.snackbar(
          'refreshing'.tr,
          'reports_being_refreshed'.tr,
          backgroundColor: _getUserTypeColor(),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        break;
      case 'storage_info':
        _showStorageInfo(controller);
        break;
      case 'user_stats':
        _showUserStats(controller);
        break;
      case 'cleanup':
        _showCleanupDialog(controller);
        break;
      case 'export':
        _exportDrafts(controller);
        break;
    }
  }

  void _showStorageInfo(RecentReportsController controller) async {
    final storageInfo = await controller.getStorageInfo();
    final stats = controller.getUserTypeStatistics(currentUserType);
    
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(_getUserTypeIcon(), color: _getUserTypeColor()),
            const SizedBox(width: 8),
            Text('$currentUserType ${'user_storage'.tr}'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInfoRow('your_drafts'.tr, '${stats['userDrafts']}'),
              _buildInfoRow('your_to_be_synced'.tr, '${stats['userToBeSynced']}'),
              _buildInfoRow('your_synced_reports'.tr, '${stats['userSynced']}'),
              const Divider(),
              _buildInfoRow('total_drafts_all_users'.tr, '${stats['totalDrafts']}'),
              _buildInfoRow('total_synced_all_users'.tr, '${stats['totalSynced']}'),
              const Divider(),
              _buildInfoRow('storage_used'.tr, '${(storageInfo['totalSize'] / 1024).toStringAsFixed(2)} KB'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('close'.tr),
          ),
        ],
      ),
    );
  }

  void _showUserStats(RecentReportsController controller) {
    final stats = controller.getUserTypeStatistics(currentUserType);
    
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(_getUserTypeIcon(), color: _getUserTypeColor()),
            const SizedBox(width: 8),
            Text('$currentUserType ${'user_statistics'.tr}'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInfoRow('your_draft_reports'.tr, '${stats['userDrafts']}'),
              _buildInfoRow('your_pending_reports'.tr, '${stats['userToBeSynced']}'),
              _buildInfoRow('your_synced_reports'.tr, '${stats['userSynced']}'),
              _buildInfoRow('your_total_reports'.tr, '${stats['userTotal']}'),
              const Divider(),
              _buildInfoRow('drafts_this_week'.tr, '${stats['draftsThisWeek']}'),
              _buildInfoRow('synced_this_week'.tr, '${stats['syncedThisWeek']}'),
              const Divider(),
              _buildInfoRow('completion_rate'.tr, '${stats['completionRate']}%'),
              _buildInfoRow('average_completion'.tr, '${stats['avgCompletion']}%'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('close'.tr),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: TextStyle(color: _getUserTypeColor())),
        ],
      ),
    );
  }

  void _showCleanupDialog(RecentReportsController controller) {
    Get.dialog(
      AlertDialog(
        title: Text('cleanup_old_reports'.tr),
        content: Text('cleanup_confirmation'.tr.replaceAll('{userType}', currentUserType)),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.cleanupOldReports();
            },
            child: Text('cleanup'.tr),
          ),
        ],
      ),
    );
  }

  void _exportDrafts(RecentReportsController controller) async {
    try {
      // Show loading indicator
      Get.snackbar(
        'generating_pdf'.tr,
        'Please wait while generating PDF...',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      
      // Export as PDF instead of JSON
      await controller.exportDraftsAsPdf(userType: currentUserType);
      
    } catch (e) {
      Get.snackbar(
        'export_failed'.tr,
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}

class DraftReportsTab extends StatelessWidget {
  final RecentReportsController controller;
  final String userType;

  const DraftReportsTab({super.key, required this.controller, required this.userType});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // User type info banner
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _getUserTypeColor().withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _getUserTypeColor().withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(_getUserTypeIcon(), color: _getUserTypeColor(), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'showing_form_drafts_only'.tr.replaceAll('{userType}', userType),
                  style: TextStyle(
                    color: _getUserTypeColor(),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Obx(() => Text(
                '${controller.filteredDraftReports.length} ${'drafts'.tr}',
                style: TextStyle(
                  color: _getUserTypeColor(),
                  fontWeight: FontWeight.bold,
                ),
              )),
            ],
          ),
        ),
        // Search Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'search_drafts'.tr.replaceAll('{userType}', userType),
              prefixIcon: Icon(Icons.search, color: _getUserTypeColor()),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: _getUserTypeColor()),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onChanged: (value) {
              controller.searchFilteredDrafts(value);
            },
          ),
        ),
        const SizedBox(height: 16),
        // Reports List
        Expanded(
          child: Obx(() {
            if (controller.isLoadingDrafts.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (controller.filteredDraftReports.isEmpty) {
              return EmptyReportTab(
                message: 'no_draft_reports_found'.tr.replaceAll('{userType}', userType),
                icon: _getUserTypeIcon(),
                userType: userType,
              );
            }

            return RefreshIndicator(
              onRefresh: controller.loadDraftReports,
              color: _getUserTypeColor(),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.filteredDraftReports.length,
                itemBuilder: (context, index) {
                  final draft = controller.filteredDraftReports[index];
                  return DraftReportCard(
                    draft: draft,
                    controller: controller,
                    index: index,
                    userType: userType,
                  );
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  Color _getUserTypeColor() {
    return userType == 'Public' ? Colors.blue : Colors.green;
  }

  IconData _getUserTypeIcon() {
    return userType == 'Public' ? Icons.person : Icons.engineering;
  }
}

class ToBeSyncedReportsTab extends StatelessWidget {
  final RecentReportsController controller;
  final String userType;

  const ToBeSyncedReportsTab({super.key, required this.controller, required this.userType});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // User type info banner
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.orange.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.sync, color: Colors.orange, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'reports_pending_sync'.tr.replaceAll('{userType}', userType),
                  style: const TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Obx(() => Text(
                '${controller.filteredToBeSyncedReports.length} ${'pending_count'.tr}',
                style: const TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              )),
            ],
          ),
        ),
        Expanded(
          child: Obx(() {
            if (controller.isLoadingToBeSynced.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (controller.filteredToBeSyncedReports.isEmpty) {
              return EmptyReportTab(
                message: 'no_reports_pending_sync'.tr.replaceAll('{userType}', userType),
                icon: Icons.sync,
                userType: userType,
              );
            }

            return RefreshIndicator(
              onRefresh: controller.loadToBeSyncedReports,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.filteredToBeSyncedReports.length,
                itemBuilder: (context, index) {
                  final report = controller.filteredToBeSyncedReports[index];
                  return ToBeSyncedReportCard(
                    report: report,
                    controller: controller,
                    userType: userType,
                  );
                },
              ),
            );
          }),
        ),
      ],
    );
  }
}

class SyncedReportsTab extends StatelessWidget {
  final RecentReportsController controller;
  final String userType;

  const SyncedReportsTab({super.key, required this.controller, required this.userType});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // User type info banner
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              const Icon(Icons.cloud_done, color: Colors.green, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'successfully_synced_reports'.tr.replaceAll('{userType}', userType),
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Obx(() => Text(
                '${controller.filteredSyncedReports.length} ${'synced_count'.tr}',
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              )),
            ],
          ),
        ),
        Expanded(
          child: Obx(() {
            if (controller.isLoadingSynced.value) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (controller.filteredSyncedReports.isEmpty) {
              return EmptyReportTab(
                message: 'no_synced_reports_found'.tr.replaceAll('{userType}', userType),
                icon: Icons.cloud_done,
                userType: userType,
              );
            }

            return RefreshIndicator(
              onRefresh: controller.loadSyncedReports,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.filteredSyncedReports.length,
                itemBuilder: (context, index) {
                  final report = controller.filteredSyncedReports[index];
                  return SyncedReportCard(
                    report: report,
                    controller: controller,
                    userType: userType,
                  );
                },
              ),
            );
          }),
        ),
      ],
    );
  }
}

class EmptyReportTab extends StatelessWidget {
  final String message;
  final IconData icon;
  final String userType;

  const EmptyReportTab({
    super.key,
    this.message = '',
    this.icon = Icons.insert_drive_file_rounded,
    required this.userType,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 60,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          Text(
            message.isEmpty ? 'no_reports_found'.tr : message,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'create_first_report'.tr.replaceAll('{userType}', userType),
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class DraftReportCard extends StatelessWidget {
  final DraftReport draft;
  final RecentReportsController controller;
  final int index;
  final String userType;

  const DraftReportCard({
    super.key,
    required this.draft,
    required this.controller,
    required this.index,
    required this.userType,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _onTapDraft(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '#${index + 1}',
                      style: TextStyle(
                        color: Colors.orange.shade800,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getUserTypeColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      draft.formType.toUpperCase(),
                      style: TextStyle(
                        color: _getUserTypeColor(),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getCompletionColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${draft.getCompletionPercentage().toInt()}%',
                      style: TextStyle(
                        color: _getCompletionColor(),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (draft.isValidForSubmission())
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle, size: 12, color: Colors.green.shade700),
                          const SizedBox(width: 4),
                          Text(
                            'ready'.tr.toUpperCase(),
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(width: 8),
                  PopupMenuButton<String>(
                    onSelected: (value) => _handleAction(value, context),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(_getUserTypeIcon(), size: 18, color: _getUserTypeColor()),
                            const SizedBox(width: 8),
                            Text('edit_form'.tr.replaceAll('{formType}', draft.formTypeDisplayName)),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'export',
                        child: Row(
                          children: [
                            const Icon(Icons.picture_as_pdf, size: 18, color: Colors.orange),
                            const SizedBox(width: 8),
                            Text('Export PDF', style: const TextStyle(color: Colors.orange)),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            const Icon(Icons.delete, size: 18, color: Colors.red),
                            const SizedBox(width: 8),
                            Text('delete'.tr, style: const TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                draft.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      _getLocationText(),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.assessment, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    '${draft.getCompletionStatus()} • ${draft.formTypeDisplayName}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    'updated_time_ago'.tr.replaceAll('{time}', controller.getTimeAgo(draft.updatedAt)),
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getUserTypeColor() {
    return userType == 'Public' ? Colors.blue : Colors.green;
  }

  IconData _getUserTypeIcon() {
    return userType == 'Public' ? Icons.person : Icons.engineering;
  }

  Color _getCompletionColor() {
    final percentage = draft.getCompletionPercentage();
    if (percentage < 25) return Colors.red;
    if (percentage < 50) return Colors.orange;
    if (percentage < 75) return Colors.blue;
    return Colors.green;
  }

  String _getLocationText() {
    final formData = draft.formData;
    final parts = <String>[];
    
    if (formData['village'] != null && formData['village'].toString().isNotEmpty) {
      parts.add(formData['village'].toString());
    }
    if (formData['district'] != null && formData['district'].toString().isNotEmpty) {
      parts.add(formData['district'].toString());
    }
    if (formData['state'] != null && formData['state'].toString().isNotEmpty) {
      parts.add(formData['state'].toString());
    }
    
    return parts.isEmpty ? 'location_not_specified'.tr : parts.join(', ');
  }

  void _onTapDraft(BuildContext context) {
    final latitude = double.tryParse(draft.formData['latitude']?.toString() ?? '0') ?? 0.0;
    final longitude = double.tryParse(draft.formData['longitude']?.toString() ?? '0') ?? 0.0;
    
    final arguments = {
      'draftId': draft.id,
      'draftData': draft.formData,
      'latitude': latitude,
      'longitude': longitude,
    };
    
    // Navigate based on the current user type
    if (userType == 'Public') {
      Get.to(() => PublicLandslideReportingScreen(
        latitude: latitude,
        longitude: longitude,
      ), arguments: arguments);
    } else {
      Get.to(() => LandslideReportingScreen(
        latitude: latitude,
        longitude: longitude,
      ), arguments: arguments);
    }
  }

  void _handleAction(String action, BuildContext context) {
    switch (action) {
      case 'edit':
        _onTapDraft(context); // For drafts, edit means opening the draft
        break;
      case 'export':
        _exportDraft(context);
        break;
      case 'details':
        _showDetailsDialog(context);
        break;
      case 'delete':
        _showDeleteDialog(context);
        break;
    }
  }

  void _exportDraft(BuildContext context) async {
    try {
      // Show loading indicator
      Get.snackbar(
        'generating_pdf'.tr,
        'Please wait while generating PDF...',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      
      // Export single draft as PDF
      await controller.exportDraftAsPdf(draft);
      
    } catch (e) {
      Get.snackbar(
        'export_failed'.tr,
        'Failed to export draft as PDF: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _showDetailsDialog(BuildContext context) {
    final summary = draft.getFieldSummary();
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(_getUserTypeIcon(), color: _getUserTypeColor()),
            const SizedBox(width: 8),
            Text('draft_details'.tr),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('form_type'.tr, draft.formTypeDisplayName),
              _buildDetailRow('title'.tr, draft.title),
              _buildDetailRow('completion'.tr, '${summary['completion'].toInt()}%'),
              _buildDetailRow('status'.tr, summary['status']),
              _buildDetailRow('location'.tr, summary['location']),
              if (summary['description'].toString().isNotEmpty)
                _buildDetailRow('description'.tr, summary['description']),
              _buildDetailRow('created'.tr, controller.getTimeAgo(draft.createdAt)),
              _buildDetailRow('last_modified'.tr, controller.getTimeAgo(draft.updatedAt)),
              _buildDetailRow('ready_to_submit'.tr, summary['isValidForSubmission'] ? 'yes'.tr : 'no'.tr),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('close'.tr),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _onTapDraft(context);
            },
            child: Text('edit_draft'.tr),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning, color: Colors.red),
            const SizedBox(width: 8),
            Text('delete_draft'.tr),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('delete_draft_confirmation'.tr.replaceAll('{formType}', draft.formTypeDisplayName)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    draft.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text('${'form_type'.tr}: ${draft.formTypeDisplayName}'),
                  Text('${'completion'.tr}: ${draft.getCompletionPercentage().toInt()}%'),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'action_cannot_be_undone'.tr,
              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deleteDraftReport(draft.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('delete'.tr),
          ),
        ],
      ),
    );
  }
}

class ToBeSyncedReportCard extends StatelessWidget {
  final Map<String, dynamic> report;
  final RecentReportsController controller;
  final String userType;

  const ToBeSyncedReportCard({
    super.key,
    required this.report,
    required this.controller,
    required this.userType,
  });

  @override
  Widget build(BuildContext context) {
    final createdAt = DateTime.parse(report['createdAt']);
    final retryCount = report['retryCount'] ?? 0;
    final reportData = report['data'] ?? report;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.sync, size: 12, color: Colors.orange.shade800),
                      const SizedBox(width: 4),
                      Text(
                        'pending'.tr.toUpperCase(),
                        style: TextStyle(
                          color: Colors.orange.shade800,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getUserTypeColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getFormTypeText().toUpperCase(),
                    style: TextStyle(
                      color: _getUserTypeColor(),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                if (retryCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'retry_count'.tr.replaceAll('{count}', retryCount.toString()),
                      style: TextStyle(
                        color: Colors.red.shade800,
                        fontSize: 10,
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  onSelected: (value) => _handleAction(value, context),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          const Icon(Icons.edit, size: 18, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text('edit_report'.tr),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'retry',
                      child: Row(
                        children: [
                          const Icon(Icons.sync, size: 18, color: Colors.orange),
                          const SizedBox(width: 8),
                          Text('retry_submission'.tr),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'download',
                      child: Row(
                        children: [
                          const Icon(Icons.download, size: 18, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text('download_report'.tr),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'export',
                      child: Row(
                        children: [
                          const Icon(Icons.picture_as_pdf, size: 18, color: Colors.orange),
                          const SizedBox(width: 8),
                          Text('Export PDF', style: const TextStyle(color: Colors.orange)),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(Icons.delete, size: 18, color: Colors.red),
                          const SizedBox(width: 8),
                          Text('delete'.tr, style: const TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              report['title'] ?? 'landslide_report'.tr.replaceAll('{formType}', _getFormTypeText()),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    _getLocationText(),
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.assessment, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  'form_awaiting_sync'.tr.replaceAll('{formType}', _getFormTypeText()).replaceAll('{status}', _getFormStatus()),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  'created_time_ago'.tr.replaceAll('{time}', controller.getTimeAgo(createdAt)),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            if (retryCount > 0) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.error_outline, size: 16, color: Colors.red.shade600),
                  const SizedBox(width: 4),
                  Text(
                    'failed_attempts'.tr.replaceAll('{count}', retryCount.toString()).replaceAll('{plural}', retryCount > 1 ? 's' : ''),
                    style: TextStyle(
                      color: Colors.red.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: () => controller.resubmitPendingReport(report),
                    icon: const Icon(Icons.sync, size: 16),
                    label: Text('sync'.tr.toUpperCase()),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: () => _downloadReport(),
                    icon: const Icon(Icons.download, size: 16),
                    label: Text('download'.tr.toUpperCase()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods for ToBeSyncedReportCard
  String _getFormTypeText() {
    String formType = report['formType']?.toString().toLowerCase() ?? 'public';
    return formType == 'expert' ? 'expert'.tr : 'public'.tr;
  }

  Color _getUserTypeColor() {
    String formType = report['formType']?.toString().toLowerCase() ?? 'public';
    return formType == 'expert' ? Colors.green : Colors.blue;
  }

  String _getFormStatus() {
    final retryCount = report['retryCount'] ?? 0;
    String formType = _getFormTypeText();
    if (retryCount > 0) {
      return 'retry_pending'.tr.replaceAll('{formType}', formType);
    }
    return 'awaiting_sync'.tr.replaceAll('{formType}', formType);
  }

  String _getLocationText() {
    final reportData = report['data'] ?? report;
    final parts = <String>[];
    
    if (reportData['village'] != null && reportData['village'].toString().isNotEmpty) {
      parts.add(reportData['village'].toString());
    }
    if (reportData['district'] != null && reportData['district'].toString().isNotEmpty) {
      parts.add(reportData['district'].toString());
    }
    if (reportData['state'] != null && reportData['state'].toString().isNotEmpty) {
      parts.add(reportData['state'].toString());
    }
    
    return parts.isEmpty ? 'location_not_specified'.tr : parts.join(', ');
  }

  void _handleAction(String action, BuildContext context) {
    switch (action) {
      case 'edit':
        _editPendingReport();
        break;
      case 'export':
        _exportPendingReport(context);
        break;
      case 'retry':
        controller.resubmitPendingReport(report);
        break;
      case 'details':
        _showDetailsDialog(context);
        break;
      case 'download':
        _downloadReport();
        break;
      case 'delete':
        _showDeleteDialog(context);
        break;
    }
  }

  void _exportPendingReport(BuildContext context) async {
    try {
      // Show loading indicator
      Get.snackbar(
        'generating_pdf'.tr,
        'Please wait while generating PDF...',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      
      // Get report data
      final reportData = report['data'] ?? report;
      final formType = _getFormTypeText().toLowerCase();
      
      // Export pending report as PDF
      await controller.exportDraftAsPdf(DraftReport(
        id: report['id'] ?? '',
        title: report['title'] ?? 'Landslide Report',
        formType: formType,
        formData: reportData,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));
      
    } catch (e) {
      Get.snackbar(
        'export_failed'.tr,
        'Failed to export pending report as PDF: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _editPendingReport() {
    try {
      // Extract the report data
      final reportData = report['data'] ?? report;
      final formType = _getFormTypeText().toLowerCase(); // 'expert' or 'public'
      
      // Get coordinates
      final latitude = double.tryParse(reportData['Latitude']?.toString() ?? '0') ?? 0.0;
      final longitude = double.tryParse(reportData['Longitude']?.toString() ?? '0') ?? 0.0;
      
      // Convert pending report data to format suitable for form loading
      final formattedData = _convertPendingToFormData(reportData);
      
      final arguments = {
        'pendingReportId': report['id'], // Use pendingReportId instead of draftId
        'pendingReportData': formattedData, // Use pendingReportData instead of draftData
        'latitude': latitude,
        'longitude': longitude,
        'isFromPending': true, // Flag to indicate this is from pending reports
      };
      
      // Navigate based on form type
      if (formType == 'public') {
        Get.to(() => PublicLandslideReportingScreen(
          latitude: latitude,
          longitude: longitude,
        ), arguments: arguments);
      } else {
        Get.to(() => LandslideReportingScreen(
          latitude: latitude,
          longitude: longitude,
        ), arguments: arguments);
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'unable_to_edit_report'.tr.replaceAll('{error}', e.toString()),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Helper method to convert pending report data to form data format
  Map<String, dynamic> _convertPendingToFormData(Map<String, dynamic> reportData) {
    return {
      // Location data
      'latitude': reportData['Latitude'],
      'longitude': reportData['Longitude'],
      'state': reportData['State'],
      'district': reportData['District'],
      'subdivision': reportData['SubdivisionOrTaluk'],
      'village': reportData['Village'],
      'locationDetails': reportData['LocationDetails'],
      
      // Occurrence data
      'landslideOccurrence': reportData['DateTimeType'],
      'date': _convertApiDateToDisplayDate(reportData['LandslideDate']),
      'time': _convertApiTimeToDisplayTime(reportData['LandslideTime']),
      'howDoYouKnow': reportData['ExactDateInfo'],
      'occurrenceDateRange': reportData['Date_and_time_Range'],
      
      // Basic landslide data
      'whereDidLandslideOccur': reportData['LanduseOrLandcover'],
      'typeOfMaterial': reportData['MaterialInvolved'],
      'typeOfMovement': reportData['MovementType'],
      'landslideSize': reportData['LandslideSize'], // For public form
      'whatInducedLandslide': reportData['InducingFactor'],
      'otherRelevantInfo': reportData['OtherInformation'],
      
      // Rainfall data
      'rainfallAmount': reportData['Amount_of_rainfall'],
      'rainfallDuration': reportData['Duration_of_rainfall'],
      
      // Impact/Damage data (parse from string if needed)
      'peopleAffected': _extractImpactValue(reportData['ImpactOrDamage'], 'People affected'),
      'livestockAffected': _extractImpactValue(reportData['ImpactOrDamage'], 'Livestock affected'),
      'housesBuildingAffected': _extractImpactValue(reportData['ImpactOrDamage'], 'Houses and buildings affected'),
      'roadsAffected': _extractImpactValue(reportData['ImpactOrDamage'], 'Roads affected'),
      'roadsBlocked': _extractImpactValue(reportData['ImpactOrDamage'], 'Roads blocked'),
      'railwayLineAffected': _extractImpactValue(reportData['ImpactOrDamage'], 'Railway line affected'),
      'powerInfrastructureAffected': _extractImpactValue(reportData['ImpactOrDamage'], 'Power infrastructure'),
      'damagesToAgriculturalForestLand': _extractImpactValue(reportData['ImpactOrDamage'], 'Agriculture'),
      'other': _extractImpactValue(reportData['ImpactOrDamage'], 'Other'),
      'noDamages': _extractImpactValue(reportData['ImpactOrDamage'], 'No damages'),
      'iDontKnow': _extractImpactValue(reportData['ImpactOrDamage'], 'I don\'t know'),
      
      // Damage details
      'peopleDead': reportData['PeopleDead'],
      'peopleInjured': reportData['PeopleInjured'],
      'livestockDead': reportData['LivestockDead'],
      'livestockInjured': reportData['LivestockInjured'],
      'housesFullyAffected': reportData['HousesBuildingfullyaffected'],
      'housesPartiallyAffected': reportData['HousesBuildingpartialaffected'],
      'damsName': reportData['DamsBarragesName'],
      'damsExtent': reportData['DamsBarragesExtentOfDamage'],
      'roadType': reportData['RoadsAffectedType'],
      'roadExtent': reportData['RoadsAffectedExtentOfDamage'],
      'railwayDetails': reportData['RailwayLineAffected'],
      'otherDamageDetails': reportData['OthersAffected'],
      
      // Contact information (for public form)
      'username': reportData['ContactName'],
      'email': reportData['ContactEmailId'],
      'mobile': reportData['ContactMobile'],
      'affiliation': reportData['ContactAffiliation'],
      
      // Images metadata
      'imageCount': _countImages(reportData),
      'hasImages': _hasImages(reportData),
    };
  }

  // Helper methods for data conversion
  String _convertApiDateToDisplayDate(dynamic apiDate) {
    if (apiDate == null || apiDate.toString().isEmpty) return '';
    try {
      DateTime dateTime = DateTime.parse(apiDate.toString());
      return "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}";
    } catch (e) {
      return '';
    }
  }

  String _convertApiTimeToDisplayTime(dynamic apiTime) {
    if (apiTime == null || apiTime.toString().isEmpty) return '';
    try {
      String timeStr = apiTime.toString();
      if (timeStr.length >= 5) {
        return timeStr.substring(0, 5); // Extract HH:MM
      }
      return timeStr;
    } catch (e) {
      return '';
    }
  }

  bool _extractImpactValue(dynamic impactString, String searchTerm) {
    if (impactString == null) return false;
    return impactString.toString().toLowerCase().contains(searchTerm.toLowerCase());
  }

  int _countImages(Map<String, dynamic> reportData) {
    int count = 0;
    if (reportData['LandslidePhotographs'] != null && reportData['LandslidePhotographs'].toString().isNotEmpty) count++;
    if (reportData['LandslidePhotograph1'] != null && reportData['LandslidePhotograph1'].toString().isNotEmpty) count++;
    if (reportData['LandslidePhotograph2'] != null && reportData['LandslidePhotograph2'].toString().isNotEmpty) count++;
    if (reportData['LandslidePhotograph3'] != null && reportData['LandslidePhotograph3'].toString().isNotEmpty) count++;
    if (reportData['LandslidePhotograph4'] != null && reportData['LandslidePhotograph4'].toString().isNotEmpty) count++;
    return count;
  }

  bool _hasImages(Map<String, dynamic> reportData) {
    return _countImages(reportData) > 0;
  }

  void _downloadReport() async {
    try {
      final jsonData = await controller.exportPendingReportAsJson(report);
      Get.snackbar(
        'download_ready'.tr,
        'report_exported_successfully'.tr.replaceAll('{formType}', _getFormTypeText()),
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      
      // Here you could integrate with a file sharing plugin to actually save/share the file
      print('📄 Report JSON: $jsonData');
      
    } catch (e) {
      Get.snackbar(
        'download_failed'.tr,
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _showDetailsDialog(BuildContext context) {
    final reportData = report['data'] ?? report;
    final retryCount = report['retryCount'] ?? 0;
    final formType = _getFormTypeText();
    
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.sync, color: Colors.orange),
            const SizedBox(width: 8),
            Text('pending_report_title'.tr.replaceAll('{formType}', formType)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('form_type'.tr, 'landslide_report'.tr.replaceAll('{formType}', formType)),
              _buildDetailRow('status'.tr, 'pending_sync'.tr),
              _buildDetailRow('location'.tr, _getLocationText()),
              _buildDetailRow('material_type'.tr, reportData['MaterialInvolved'] ?? reportData['typeOfMaterial'] ?? 'not_specified'.tr),
              _buildDetailRow('movement_type'.tr, reportData['MovementType'] ?? reportData['typeOfMovement'] ?? 'not_specified'.tr),
              if (formType == 'expert'.tr) ...[
                _buildDetailRow('length_meters'.tr, '${reportData['LengthInMeters'] ?? reportData['length'] ?? 'not_specified'.tr}m'),
                _buildDetailRow('activity'.tr, reportData['Activity'] ?? reportData['activity'] ?? 'not_specified'.tr),
              ],
              _buildDetailRow('images'.tr, reportData['hasImages'] == true ? '${'yes'.tr} (${reportData['imageCount'] ?? 0})' : 'no'.tr),
              _buildDetailRow('created'.tr, controller.getTimeAgo(DateTime.parse(report['createdAt']))),
              if (retryCount > 0)
                _buildDetailRow('retry_count_label'.tr, retryCount.toString()),
              if (report['lastRetryAt'] != null)
                _buildDetailRow('last_retry'.tr, controller.getTimeAgo(DateTime.parse(report['lastRetryAt']))),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('close'.tr),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.resubmitPendingReport(report);
            },
            child: Text('retry_now'.tr),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning, color: Colors.red),
            const SizedBox(width: 8),
            Text('delete_pending_report'.tr),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('delete_pending_confirmation'.tr),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    report['title'] ?? 'landslide_report'.tr.replaceAll('{formType}', _getFormTypeText()),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 4),
                  Text('${'type'.tr}: ${_getFormTypeText()} Form'),
                  Text('${'status'.tr}: ${'pending_sync'.tr}'),
                  if ((report['retryCount'] ?? 0) > 0)
                    Text('failed_attempts_count'.tr.replaceAll('{count}', '${report['retryCount']}')),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'delete_report_warning'.tr,
              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _downloadReport(); // Download before deleting
            },
            child: Text('download_first'.tr),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.removeToBeSyncedReport(report['id']);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('delete'.tr),
          ),
        ],
      ),
    );
  }
}

class SyncedReportCard extends StatelessWidget {
  final Map<String, dynamic> report;
  final RecentReportsController controller;
  final String userType;

  const SyncedReportCard({
    super.key,
    required this.report,
    required this.controller,
    required this.userType,
  });

  @override
  Widget build(BuildContext context) {
    final syncedAt = DateTime.parse(report['syncedAt']);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.cloud_done, size: 12, color: Colors.green.shade800),
                      const SizedBox(width: 4),
                      Text(
                        'synced'.tr.toUpperCase(),
                        style: TextStyle(
                          color: Colors.green.shade800,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getUserTypeColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    userType.toUpperCase(),
                    style: TextStyle(
                      color: _getUserTypeColor(),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(Icons.check_circle, size: 20, color: Colors.green.shade600),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              report['title'] ?? 'untitled_report'.tr,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.cloud_upload, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  'synced_time_ago'.tr.replaceAll('{time}', controller.getTimeAgo(syncedAt)),
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getUserTypeColor() {
    return userType == 'Public' ? Colors.blue : Colors.green;
  }
}