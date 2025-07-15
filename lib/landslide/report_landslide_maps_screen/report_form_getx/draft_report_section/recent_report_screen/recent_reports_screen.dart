import 'package:bhooskhalann/landslide/report_landslide_maps_screen/report_form_getx/draft_report_section/draft_report_form.dart';
import 'package:bhooskhalann/landslide/report_landslide_maps_screen/report_form_getx/draft_report_section/public_report_form_screen.dart';
import 'package:bhooskhalann/landslide/report_landslide_maps_screen/report_form_getx/draft_report_section/recent_report_screen/recent_reports_controller.dart';
import 'package:bhooskhalann/user_profile/profile_controller.dart';
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
    return currentUserType == 'Public' ? 'Public' : 'Expert';
  }

  void _handleAction(String value, BuildContext context) {
    // This seems to be meant for the menu actions
    _handleMenuAction(value, controller);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingUserType) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Recent Reports'),
          backgroundColor: Colors.blue,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Recent Reports',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                '$currentUserType User Dashboard',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
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
              onSelected: (value) => _handleMenuAction(value, controller), // Fixed this call
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'refresh',
                  child: Row(
                    children: [
                      Icon(Icons.refresh, size: 18, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('Refresh'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'storage_info',
                  child: Row(
                    children: [
                      Icon(Icons.storage, size: 18, color: Colors.green),
                      SizedBox(width: 8),
                      Text('Storage Info'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'user_stats',
                  child: Row(
                    children: [
                      Icon(Icons.analytics, size: 18, color: Colors.orange),
                      SizedBox(width: 8),
                      Text('User Stats'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'cleanup',
                  child: Row(
                    children: [
                      Icon(Icons.cleaning_services, size: 18, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Cleanup'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'export',
                  child: Row(
                    children: [
                      Icon(Icons.download, size: 18, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('Export'),
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
                    const Text('DRAFT'),
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
      const Text('TO BE SYNCED'),
      const SizedBox(width: 2),
      if (controller.filteredToBeSyncedReports.isNotEmpty)
        GestureDetector(
          onTap: () {
            // Navigate to the "To Be Synced" tab (index 1)
            DefaultTabController.of(context)?.animateTo(1);
            
            // Optional: Show a snackbar to guide user
            Get.snackbar(
              'Pending Reports',
              'Tap any report to edit it',
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
                    const Text('SYNCED'),
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
          'Refreshing',
          'Reports are being refreshed...',
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
            Text('$currentUserType User Storage'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInfoRow('Your Drafts', '${stats['userDrafts']}'),
              _buildInfoRow('Your To Be Synced', '${stats['userToBeSynced']}'),
              _buildInfoRow('Your Synced Reports', '${stats['userSynced']}'),
              const Divider(),
              _buildInfoRow('Total Drafts (All Users)', '${stats['totalDrafts']}'),
              _buildInfoRow('Total Synced (All Users)', '${stats['totalSynced']}'),
              const Divider(),
              _buildInfoRow('Storage Used', '${(storageInfo['totalSize'] / 1024).toStringAsFixed(2)} KB'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
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
            Text('$currentUserType User \nStatistics'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInfoRow('Your Draft Reports', '${stats['userDrafts']}'),
              _buildInfoRow('Your Pending Reports', '${stats['userToBeSynced']}'),
              _buildInfoRow('Your Synced Reports', '${stats['userSynced']}'),
              _buildInfoRow('Your Total Reports', '${stats['userTotal']}'),
              const Divider(),
              _buildInfoRow('Drafts This Week', '${stats['draftsThisWeek']}'),
              _buildInfoRow('Synced This Week', '${stats['syncedThisWeek']}'),
              const Divider(),
              _buildInfoRow('Completion Rate', '${stats['completionRate']}%'),
              _buildInfoRow('Average Completion', '${stats['avgCompletion']}%'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
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
        title: const Text('Cleanup Old Reports'),
        content: Text('This will remove your synced $currentUserType reports older than 90 days. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.cleanupOldReports();
            },
            child: const Text('Cleanup'),
          ),
        ],
      ),
    );
  }

  void _exportDrafts(RecentReportsController controller) async {
    try {
      final jsonData = await controller.exportDraftsAsJson(userType: currentUserType);
      Get.snackbar(
        'Export Ready',
        'Your $currentUserType drafts exported successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Export Failed',
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
                  'Showing your $userType form drafts only',
                  style: TextStyle(
                    color: _getUserTypeColor(),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Obx(() => Text(
                '${controller.filteredDraftReports.length} drafts',
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
              hintText: 'Search your $userType drafts...',
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
                message: 'No $userType draft reports found',
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
                  'Your $userType reports pending sync',
                  style: const TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Obx(() => Text(
                '${controller.filteredToBeSyncedReports.length} pending',
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
                message: 'No $userType reports pending sync',
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
                  'Your successfully synced $userType reports',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Obx(() => Text(
                '${controller.filteredSyncedReports.length} synced',
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
                message: 'No $userType synced reports found',
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
    this.message = 'No reports found',
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
            message,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first $userType report to see it here',
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
                            'READY',
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
                            Text('Edit ${draft.formTypeDisplayName}'),
                          ],
                        ),
                      ),
                      // const PopupMenuItem(
                      //   value: 'details',
                      //   child: Row(
                      //     children: [
                      //       Icon(Icons.info_outline, size: 18),
                      //       SizedBox(width: 8),
                      //       Text('View Details'),
                      //     ],
                      //   ),
                      // ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 18, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
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
                    'Updated ${controller.getTimeAgo(draft.updatedAt)}',
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
    
    return parts.isEmpty ? 'Location not specified' : parts.join(', ');
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
      case 'details':
        _showDetailsDialog(context);
        break;
      case 'delete':
        _showDeleteDialog(context);
        break;
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
            const Text('Draft Details'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Form Type', draft.formTypeDisplayName),
              _buildDetailRow('Title', draft.title),
              _buildDetailRow('Completion', '${summary['completion'].toInt()}%'),
              _buildDetailRow('Status', summary['status']),
              _buildDetailRow('Location', summary['location']),
              if (summary['description'].toString().isNotEmpty)
                _buildDetailRow('Description', summary['description']),
              _buildDetailRow('Created', controller.getTimeAgo(draft.createdAt)),
              _buildDetailRow('Last Modified', controller.getTimeAgo(draft.updatedAt)),
              _buildDetailRow('Ready to Submit', summary['isValidForSubmission'] ? 'Yes' : 'No'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _onTapDraft(context);
            },
            child: const Text('Edit Draft'),
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
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 8),
            Text('Delete Draft'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to delete this ${draft.formTypeDisplayName} draft?'),
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
                  Text('Form Type: ${draft.formTypeDisplayName}'),
                  Text('Completion: ${draft.getCompletionPercentage().toInt()}%'),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'This action cannot be undone.',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
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
            child: const Text('Delete'),
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
                        'PENDING',
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
                      'Retry: $retryCount',
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
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 18, color: Colors.blue),
                          SizedBox(width: 8),
                          Text('Edit Report'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'retry',
                      child: Row(
                        children: [
                          Icon(Icons.sync, size: 18, color: Colors.orange),
                          SizedBox(width: 8),
                          Text('Retry Submission'),
                        ],
                      ),
                    ),
                    // const PopupMenuItem(
                    //   value: 'details',
                    //   child: Row(
                    //     children: [
                    //       Icon(Icons.info_outline, size: 18),
                    //       SizedBox(width: 8),
                    //       Text('View Details'),
                    //     ],
                    //   ),
                    // ),
                    const PopupMenuItem(
                      value: 'download',
                      child: Row(
                        children: [
                          Icon(Icons.download, size: 18, color: Colors.blue),
                          SizedBox(width: 8),
                          Text('Download Report'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 18, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              report['title'] ?? '${_getFormTypeText()} Landslide Report',
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
                  '${_getFormTypeText()} Form • ${_getFormStatus()}',
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
                  'Created ${controller.getTimeAgo(createdAt)}',
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
                    'Failed $retryCount time${retryCount > 1 ? 's' : ''}',
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
                    label: const Text('SYNC'),
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
                    label: const Text('DOWNLOAD'),
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
    return formType == 'expert' ? 'Expert' : 'Public';
  }

  Color _getUserTypeColor() {
    String formType = report['formType']?.toString().toLowerCase() ?? 'public';
    return formType == 'expert' ? Colors.green : Colors.blue;
  }

  String _getFormStatus() {
    final retryCount = report['retryCount'] ?? 0;
    String formType = _getFormTypeText();
    if (retryCount > 0) {
      return '$formType retry pending';
    }
    return '$formType awaiting sync';
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
    
    return parts.isEmpty ? 'Location not specified' : parts.join(', ');
  }

  void _handleAction(String action, BuildContext context) {
    switch (action) {
      case 'edit':
        _editPendingReport();
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
        'Error',
        'Unable to edit this report: $e',
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
        'Download Ready',
        '${_getFormTypeText()} landslide report data exported successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      
      // Here you could integrate with a file sharing plugin to actually save/share the file
      print('📄 Report JSON: $jsonData');
      
    } catch (e) {
      Get.snackbar(
        'Download Failed',
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
            Text('Pending $formType Report'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Form Type', '$formType Landslide Report'),
              _buildDetailRow('Status', 'Pending Sync'),
              _buildDetailRow('Location', _getLocationText()),
              _buildDetailRow('Material Type', reportData['MaterialInvolved'] ?? reportData['typeOfMaterial'] ?? 'Not specified'),
              _buildDetailRow('Movement Type', reportData['MovementType'] ?? reportData['typeOfMovement'] ?? 'Not specified'),
              if (formType == 'Expert') ...[
                _buildDetailRow('Length', '${reportData['LengthInMeters'] ?? reportData['length'] ?? 'Not specified'}m'),
                _buildDetailRow('Activity', reportData['Activity'] ?? reportData['activity'] ?? 'Not specified'),
              ],
              _buildDetailRow('Images', reportData['hasImages'] == true ? 'Yes (${reportData['imageCount'] ?? 0})' : 'No'),
              _buildDetailRow('Created', controller.getTimeAgo(DateTime.parse(report['createdAt']))),
              if (retryCount > 0)
                _buildDetailRow('Retry Count', retryCount.toString()),
              if (report['lastRetryAt'] != null)
                _buildDetailRow('Last Retry', controller.getTimeAgo(DateTime.parse(report['lastRetryAt']))),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.resubmitPendingReport(report);
            },
            child: const Text('Retry Now'),
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
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 8),
            Text('Delete Pending \nReport'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Are you sure you want to delete this pending report?'),
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
                    report['title'] ?? '${_getFormTypeText()} Landslide Report',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text('Type: ${_getFormTypeText()} Form'),
                  Text('Status: Pending Sync'),
                  if ((report['retryCount'] ?? 0) > 0)
                    Text('Failed attempts: ${report['retryCount']}'),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'This will permanently delete the report. Consider downloading it first.',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _downloadReport(); // Download before deleting
            },
            child: const Text('Download First'),
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
            child: const Text('Delete'),
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
                        'SYNCED',
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
              report['title'] ?? 'Untitled Report',
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
                  'Synced ${controller.getTimeAgo(syncedAt)}',
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