import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

class PdfExportService {
  static final PdfExportService _instance = PdfExportService._internal();
  factory PdfExportService() => _instance;
  PdfExportService._internal();

  // Generate PDF from draft report data
  Future<File> generateDraftPdf(Map<String, dynamic> draftData, String formType) async {
    try {
      final pdf = pw.Document();
      
      // Add title page
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (context) => [
            _buildTitlePage(draftData, formType),
            _buildReportContent(draftData, formType),
          ],
        ),
      );

      // Get downloads directory
      final directory = await _getDownloadsDirectory();
      final fileName = 'landslide_report_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File('${directory.path}/$fileName');
      
      // Save PDF
      final bytes = await pdf.save();
      await file.writeAsBytes(bytes);
      
      return file;
    } catch (e) {
      print('Error generating PDF: $e');
      if (e.toString().contains('permission')) {
        showPermissionRequestDialog();
      }
      throw Exception('Failed to generate PDF: $e');
    }
  }

  // Generate PDF from multiple drafts
  Future<File> generateDraftsPdf(List<Map<String, dynamic>> draftsData, String formType) async {
    try {
      final pdf = pw.Document();
      
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (context) => [
            _buildDraftsTitlePage(formType, draftsData.length),
            ...draftsData.map((draft) => _buildReportContent(draft, formType)).toList(),
          ],
        ),
      );

      // Get downloads directory
      final directory = await _getDownloadsDirectory();
      final fileName = 'landslide_drafts_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File('${directory.path}/$fileName');
      
      // Save PDF
      final bytes = await pdf.save();
      await file.writeAsBytes(bytes);
      
      return file;
    } catch (e) {
      print('Error generating PDF: $e');
      if (e.toString().contains('permission')) {
        showPermissionRequestDialog();
      }
      throw Exception('Failed to generate PDF: $e');
    }
  }

  // Build title page
  pw.Widget _buildTitlePage(Map<String, dynamic> draftData, String formType) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(40),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'LANDSLIDE REPORT',
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue,
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            'Form Type: ${formType.toUpperCase()}',
            style: pw.TextStyle(fontSize: 16),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            'Generated: ${DateTime.now().toString().split('.')[0]}',
            style: pw.TextStyle(fontSize: 12, color: PdfColors.grey),
          ),
          pw.SizedBox(height: 30),
          pw.Divider(),
          pw.SizedBox(height: 20),
          _buildLocationInfo(draftData),
        ],
      ),
    );
  }

  // Build drafts title page
  pw.Widget _buildDraftsTitlePage(String formType, int draftCount) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(40),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'LANDSLIDE DRAFTS REPORT',
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue,
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            'Form Type: ${formType.toUpperCase()}',
            style: pw.TextStyle(fontSize: 16),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            'Total Drafts: $draftCount',
            style: pw.TextStyle(fontSize: 16),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            'Generated: ${DateTime.now().toString().split('.')[0]}',
            style: pw.TextStyle(fontSize: 12, color: PdfColors.grey),
          ),
          pw.SizedBox(height: 30),
          pw.Divider(),
        ],
      ),
    );
  }

  // Build report content
  pw.Widget _buildReportContent(Map<String, dynamic> draftData, String formType) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Report Details',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue,
            ),
          ),
          pw.SizedBox(height: 20),
          _buildLocationInfo(draftData),
          pw.SizedBox(height: 20),
          _buildBasicInfo(draftData, formType),
          pw.SizedBox(height: 20),
          _buildDetailedInfo(draftData, formType),
          pw.SizedBox(height: 20),
          _buildImpactInfo(draftData),
          pw.SizedBox(height: 20),
          _buildContactInfo(draftData),
        ],
      ),
    );
  }

  // Build location information
  pw.Widget _buildLocationInfo(Map<String, dynamic> draftData) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Location Information',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          _buildInfoRow('State', draftData['state'] ?? 'N/A'),
          _buildInfoRow('District', draftData['district'] ?? 'N/A'),
          _buildInfoRow('Subdivision/Taluk', draftData['subdivision'] ?? 'N/A'),
          _buildInfoRow('Village', draftData['village'] ?? 'N/A'),
          _buildInfoRow('Location Details', draftData['locationDetails'] ?? 'N/A'),
          _buildInfoRow('Latitude', draftData['latitude'] ?? 'N/A'),
          _buildInfoRow('Longitude', draftData['longitude'] ?? 'N/A'),
        ],
      ),
    );
  }

  // Build basic information
  pw.Widget _buildBasicInfo(Map<String, dynamic> draftData, String formType) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Basic Information',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          _buildInfoRow('Landslide Occurrence', draftData['landslideOccurrence'] ?? 'N/A'),
          _buildInfoRow('Date', draftData['date'] ?? 'N/A'),
          _buildInfoRow('Time', draftData['time'] ?? 'N/A'),
          _buildInfoRow('How Do You Know', draftData['howDoYouKnow'] ?? 'N/A'),
          _buildInfoRow('Occurrence Date Range', draftData['occurrenceDateRange'] ?? 'N/A'),
          _buildInfoRow('Where Did Landslide Occur', draftData['whereDidLandslideOccur'] ?? 'N/A'),
          _buildInfoRow('Material Type', draftData['typeOfMaterial'] ?? 'N/A'),
          if (formType == 'expert') ...[
            _buildInfoRow('Movement Type', draftData['typeOfMovement'] ?? 'N/A'),
            _buildInfoRow('Activity', draftData['activity'] ?? 'N/A'),
            _buildInfoRow('Style', draftData['style'] ?? 'N/A'),
          ] else ...[
            _buildInfoRow('Landslide Size', draftData['landslideSize'] ?? 'N/A'),
          ],
          _buildInfoRow('Images Count', '${draftData['imageCount'] ?? 0}'),
        ],
      ),
    );
  }

  // Build detailed information (for expert form)
  pw.Widget _buildDetailedInfo(Map<String, dynamic> draftData, String formType) {
    if (formType != 'expert') {
      return pw.SizedBox.shrink();
    }

    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Detailed Information',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          _buildInfoRow('Length', draftData['length'] ?? 'N/A'),
          _buildInfoRow('Width', draftData['width'] ?? 'N/A'),
          _buildInfoRow('Height', draftData['height'] ?? 'N/A'),
          _buildInfoRow('Area', draftData['area'] ?? 'N/A'),
          _buildInfoRow('Depth', draftData['depth'] ?? 'N/A'),
          _buildInfoRow('Volume', draftData['volume'] ?? 'N/A'),
          _buildInfoRow('Runout Distance', draftData['runoutDistance'] ?? 'N/A'),
          _buildInfoRow('Rate of Movement', draftData['rateOfMovement'] ?? 'N/A'),
          _buildInfoRow('Distribution', draftData['distribution'] ?? 'N/A'),
          _buildInfoRow('Failure Mechanism', draftData['failureMechanism'] ?? 'N/A'),
          _buildInfoRow('Hydrological Condition', draftData['hydrologicalCondition'] ?? 'N/A'),
          _buildInfoRow('What Induced Landslide', draftData['whatInducedLandslide'] ?? 'N/A'),
          _buildInfoRow('Geology', draftData['geology'] ?? 'N/A'),
          _buildInfoRow('Geomorphology', draftData['geomorphology'] ?? 'N/A'),
          _buildInfoRow('Rainfall Amount', draftData['rainfallAmount'] ?? 'N/A'),
          _buildInfoRow('Rainfall Duration', draftData['rainfallDuration'] ?? 'N/A'),
          _buildInfoRow('Other Relevant Info', draftData['otherRelevantInfo'] ?? 'N/A'),
        ],
      ),
    );
  }

  // Build impact information
  pw.Widget _buildImpactInfo(Map<String, dynamic> draftData) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Impact/Damage Assessment',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          _buildInfoRow('People Affected', draftData['peopleAffected'] == true ? 'Yes' : 'No'),
          _buildInfoRow('People Dead', draftData['peopleDead'] ?? 'N/A'),
          _buildInfoRow('People Injured', draftData['peopleInjured'] ?? 'N/A'),
          _buildInfoRow('Livestock Affected', draftData['livestockAffected'] == true ? 'Yes' : 'No'),
          _buildInfoRow('Livestock Dead', draftData['livestockDead'] ?? 'N/A'),
          _buildInfoRow('Livestock Injured', draftData['livestockInjured'] ?? 'N/A'),
          _buildInfoRow('Houses/Buildings Affected', draftData['housesBuildingAffected'] == true ? 'Yes' : 'No'),
          _buildInfoRow('Houses Fully Affected', draftData['housesFully'] ?? 'N/A'),
          _buildInfoRow('Houses Partially Affected', draftData['housesPartially'] ?? 'N/A'),
          _buildInfoRow('Roads Affected', draftData['roadsAffected'] == true ? 'Yes' : 'No'),
          _buildInfoRow('Road Type', draftData['roadType'] ?? 'N/A'),
          _buildInfoRow('Road Extent', draftData['roadExtent'] ?? 'N/A'),
          _buildInfoRow('Roads Blocked', draftData['roadsBlocked'] == true ? 'Yes' : 'No'),
          _buildInfoRow('Railway Line Affected', draftData['railwayLineAffected'] == true ? 'Yes' : 'No'),
          _buildInfoRow('Power Infrastructure Affected', draftData['powerInfrastructureAffected'] == true ? 'Yes' : 'No'),
          _buildInfoRow('Dams/Barrages Affected', draftData['damsBarragesAffected'] == true ? 'Yes' : 'No'),
          _buildInfoRow('Agricultural/Forest Land Damaged', draftData['damagesToAgriculturalForestLand'] == true ? 'Yes' : 'No'),
          _buildInfoRow('Other Damages', draftData['other'] == true ? 'Yes' : 'No'),
          _buildInfoRow('Other Damage Details', draftData['otherDamageDetails'] ?? 'N/A'),
          _buildInfoRow('No Damages', draftData['noDamages'] == true ? 'Yes' : 'No'),
          _buildInfoRow('I Don\'t Know', draftData['iDontKnow'] == true ? 'Yes' : 'No'),
        ],
      ),
    );
  }

  // Build contact information
  pw.Widget _buildContactInfo(Map<String, dynamic> draftData) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Contact Information',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          _buildInfoRow('Username', draftData['username'] ?? 'N/A'),
          _buildInfoRow('Email', draftData['email'] ?? 'N/A'),
          _buildInfoRow('Mobile', draftData['mobile'] ?? 'N/A'),
          _buildInfoRow('Affiliation', draftData['affiliation'] ?? 'N/A'),
          _buildInfoRow('Form Type', draftData['formType'] ?? 'N/A'),
          _buildInfoRow('Created At', draftData['createdAt'] ?? 'N/A'),
          _buildInfoRow('Updated At', draftData['updatedAt'] ?? 'N/A'),
        ],
      ),
    );
  }

  // Build info row
  pw.Widget _buildInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 120,
            child: pw.Text(
              '$label:',
              style: pw.TextStyle(
                fontSize: 12,
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: pw.TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  // Get downloads directory
  Future<Directory> _getDownloadsDirectory() async {
    if (Platform.isAndroid) {
      // Request storage permissions
      final storageStatus = await Permission.storage.request();
      final manageStorageStatus = await Permission.manageExternalStorage.request();
      
      if (storageStatus.isDenied && manageStorageStatus.isDenied) {
        throw Exception('Storage permissions required to save PDF. Please grant storage access in app settings.');
      }
      
      // Try to use external storage for Android
      try {
        final directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
        return directory;
      } catch (e) {
        // Fallback to app documents directory if external storage fails
        print('External storage not accessible, using app documents directory: $e');
        return await getApplicationDocumentsDirectory();
      }
    } else if (Platform.isIOS) {
      // Use documents directory for iOS
      return await getApplicationDocumentsDirectory();
    } else {
      // Use documents directory for other platforms
      return await getApplicationDocumentsDirectory();
    }
  }

  // Open PDF file
  Future<void> openPdfFile(File file) async {
    try {
      await OpenFile.open(file.path);
    } catch (e) {
      print('Error opening PDF file: $e');
      throw Exception('Failed to open PDF file: $e');
    }
  }

  // Show download notification
  void showDownloadNotification(File file, String fileName) {
    // Show detailed snackbar with file path
    Get.snackbar(
      'pdf_downloaded'.tr,
      'File saved as: $fileName\nPath: ${file.path}',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 6),
    );
    
    // Also show a more prominent notification
    _showDetailedNotification(file, fileName);
  }

  // Show detailed notification with file info
  void _showDetailedNotification(File file, String fileName) {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(Icons.picture_as_pdf, color: Colors.green, size: 24),
            const SizedBox(width: 8),
            Text('pdf_downloaded_successfully'.tr),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${'file_name'.tr}: $fileName'),
            const SizedBox(height: 8),
            Text('${'file_size'.tr}: ${(file.lengthSync() / 1024).toStringAsFixed(1)} KB'),
            const SizedBox(height: 8),
            Text('${'location'.tr}: ${file.path}'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info, color: Colors.green.shade700, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'pdf_saved_info'.tr,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Get.back(),
            child: Text('close'.tr),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // Show permission request dialog
  void showPermissionRequestDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('storage_permission_required'.tr),
        content: Text('storage_permission_message'.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              // Open app settings
              openAppSettings();
            },
            child: Text('open_settings'.tr),
          ),
        ],
      ),
    );
  }
} 