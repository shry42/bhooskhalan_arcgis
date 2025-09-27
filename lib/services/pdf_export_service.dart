import 'dart:io';
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
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.blue, width: 2),
        borderRadius: pw.BorderRadius.circular(10),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          // Header with logo/icon
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Container(
                width: 40,
                height: 40,
                decoration: pw.BoxDecoration(
                  color: PdfColors.blue,
                  shape: pw.BoxShape.circle,
                ),
                child: pw.Center(
                  child: pw.Text(
                    'L',
                    style: pw.TextStyle(fontSize: 20, color: PdfColors.white),
                  ),
                ),
              ),
              pw.SizedBox(width: 15),
              pw.Text(
                'LANDSLIDE REPORT',
                style: pw.TextStyle(
                  fontSize: 28,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 30),
          
          // Report metadata
          pw.Container(
            padding: const pw.EdgeInsets.all(20),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey,
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              children: [
                _buildMetadataRow('Report Type', formType.toUpperCase()),
                _buildMetadataRow('Report ID', 'LR-${DateTime.now().millisecondsSinceEpoch}'),
                _buildMetadataRow('Generated On', DateTime.now().toString().split('.')[0]),
                _buildMetadataRow('Location', '${draftData['state'] ?? 'N/A'}, ${draftData['district'] ?? 'N/A'}'),
              ],
            ),
          ),
          
          pw.SizedBox(height: 30),
          
          // Official header
          pw.Container(
            padding: const pw.EdgeInsets.all(15),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.blue),
              borderRadius: pw.BorderRadius.circular(5),
            ),
            child: pw.Text(
              'This report has been generated by the Bhooskhalann Landslide Reporting System',
              style: pw.TextStyle(
                fontSize: 12,
                fontStyle: pw.FontStyle.italic,
                color: PdfColors.grey,
              ),
              textAlign: pw.TextAlign.center,
            ),
          ),
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
            'LANDSLIDE REPORTS',
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
            'Total Reports: $draftCount',
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
      padding: const pw.EdgeInsets.all(30),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Executive Summary
          _buildSectionHeader('EXECUTIVE SUMMARY', PdfColors.blue),
          pw.SizedBox(height: 15),
          _buildExecutiveSummary(draftData, formType),
          pw.SizedBox(height: 30),
          
          // Location Information
          _buildSectionHeader('LOCATION DETAILS', PdfColors.blue),
          pw.SizedBox(height: 15),
          _buildLocationInfo(draftData),
          pw.SizedBox(height: 30),
          
          // Incident Details
          _buildSectionHeader('INCIDENT DETAILS', PdfColors.blue),
          pw.SizedBox(height: 15),
          _buildBasicInfo(draftData, formType),
          pw.SizedBox(height: 30),
          
          // Technical Assessment (Expert form only)
          if (formType == 'expert') ...[
            _buildSectionHeader('TECHNICAL ASSESSMENT', PdfColors.blue),
            pw.SizedBox(height: 15),
            _buildDetailedInfo(draftData, formType),
            pw.SizedBox(height: 30),
          ],
          
          // Impact Assessment
          _buildSectionHeader('IMPACT ASSESSMENT', PdfColors.blue),
          pw.SizedBox(height: 15),
          _buildImpactInfo(draftData),
          pw.SizedBox(height: 30),
          
          // Contact Information
          _buildSectionHeader('REPORTER INFORMATION', PdfColors.blue),
          pw.SizedBox(height: 15),
          _buildContactInfo(draftData),
          pw.SizedBox(height: 30),
          
          // Footer
          _buildFooter(),
        ],
      ),
    );
  }

  // Build location information
  pw.Widget _buildLocationInfo(Map<String, dynamic> draftData) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.blue, width: 1),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
                                  pw.Text(
              'GEOGRAPHICAL LOCATION',
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue,
              ),
            ),
          pw.SizedBox(height: 12),
          _buildInfoRow('State', draftData['state'] ?? 'N/A'),
          _buildInfoRow('District', draftData['district'] ?? 'N/A'),
          _buildInfoRow('Subdivision/Taluk', draftData['subdivision'] ?? 'N/A'),
          _buildInfoRow('Village', draftData['village'] ?? 'N/A'),
          _buildInfoRow('Location Details', draftData['locationDetails'] ?? 'N/A'),
          pw.Divider(color: PdfColors.grey),
          pw.SizedBox(height: 8),
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
            'Reporter Information',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          _buildInfoRow('Name', draftData['username'] ?? draftData['name'] ?? 'N/A'),
          _buildInfoRow('Email', draftData['email'] ?? 'N/A'),
          _buildInfoRow('Mobile', draftData['mobile'] ?? 'N/A'),
          _buildInfoRow('Affiliation', draftData['affiliation'] ?? 'N/A'),
          _buildInfoRow('User Type', draftData['userType'] ?? draftData['formType'] ?? 'N/A'),
          if (draftData['createdAt'] != null)
            _buildInfoRow('Report Date', draftData['createdAt'] ?? 'N/A'),
        ],
      ),
    );
  }

  // Build metadata row helper
  pw.Widget _buildMetadataRow(String label, dynamic value) {
    // Convert any value to string safely
    String stringValue;
    if (value == null) {
      stringValue = 'N/A';
    } else {
      stringValue = value.toString();
    }
    
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 100,
            child: pw.Text(
              '$label:',
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              stringValue,
              style: pw.TextStyle(fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  // Build info row
  pw.Widget _buildInfoRow(String label, dynamic value) {
    // Convert any value to string safely
    String stringValue;
    if (value == null) {
      stringValue = 'N/A';
    } else {
      stringValue = value.toString();
    }
    
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
              stringValue,
              style: pw.TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  // Build section header
  pw.Widget _buildSectionHeader(String title, PdfColor color) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: pw.BoxDecoration(
        color: color,
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 14,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.white,
        ),
      ),
    );
  }

  // Build executive summary
  pw.Widget _buildExecutiveSummary(Map<String, dynamic> draftData, String formType) {
    final location = '${draftData['state'] ?? 'N/A'}, ${draftData['district'] ?? 'N/A'}';
    final date = draftData['date'] ?? 'N/A';
    final materialType = draftData['typeOfMaterial'] ?? 'N/A';
    final peopleAffected = draftData['peopleAffected'] == true ? 'Yes' : 'No';
    final housesAffected = draftData['housesBuildingAffected'] == true ? 'Yes' : 'No';
    
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey),
        borderRadius: pw.BorderRadius.circular(8),
        color: PdfColors.grey,
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'A landslide incident was reported on $date in $location. The landslide involved $materialType material. Human casualties: $peopleAffected, Property damage: $housesAffected.',
            style: pw.TextStyle(
              fontSize: 12,
              fontStyle: pw.FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  // Build footer
  pw.Widget _buildFooter() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            'Bhooskhalann Landslide Reporting System',
            style: pw.TextStyle(
              fontSize: 12,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue,
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            'Generated on ${DateTime.now().toString().split('.')[0]}',
            style: pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey,
            ),
          ),
        ],
      ),
    );
  }

  // Get downloads directory using modern scoped storage
  Future<Directory> _getDownloadsDirectory() async {
    if (Platform.isAndroid) {
      // For Android 10+ (API 29+), use scoped storage - no special permissions needed
      // PDFs will be saved in app's external files directory, accessible to users
      try {
        // Get external storage directory for the app
        final directory = await getExternalStorageDirectory();
        if (directory != null) {
          // Create a Documents/PDFs folder within app's external storage
          final pdfDirectory = Directory('${directory.path}/Documents/PDFs');
          if (!await pdfDirectory.exists()) {
            await pdfDirectory.create(recursive: true);
          }
          return pdfDirectory;
        }
      } catch (e) {
        print('External storage not accessible: $e');
      }
      
      // Fallback to app documents directory
      final directory = await getApplicationDocumentsDirectory();
      final pdfDirectory = Directory('${directory.path}/PDFs');
      if (!await pdfDirectory.exists()) {
        await pdfDirectory.create(recursive: true);
      }
      return pdfDirectory;
    } else if (Platform.isIOS) {
      // Use documents directory for iOS
      final directory = await getApplicationDocumentsDirectory();
      final pdfDirectory = Directory('${directory.path}/PDFs');
      if (!await pdfDirectory.exists()) {
        await pdfDirectory.create(recursive: true);
      }
      return pdfDirectory;
    } else {
      // Use documents directory for other platforms
      final directory = await getApplicationDocumentsDirectory();
      final pdfDirectory = Directory('${directory.path}/PDFs');
      if (!await pdfDirectory.exists()) {
        await pdfDirectory.create(recursive: true);
      }
      return pdfDirectory;
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
    // Show notification with option to open
    Get.snackbar(
      'pdf_downloaded'.tr,
      'File saved as: $fileName',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 8),
      mainButton: TextButton(
        onPressed: () => _openPdfFile(file),
        child: Text(
          'open_pdf'.tr,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      icon: Icon(Icons.picture_as_pdf, color: Colors.white),
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
            Icon(Icons.picture_as_pdf, color: Colors.green, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'PDF Downloaded',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${'file_name'.tr}: $fileName'),
              const SizedBox(height: 8),
              Text('${'file_size'.tr}: ${(file.lengthSync() / 1024).toStringAsFixed(1)} KB'),
              const SizedBox(height: 8),
              Text('${'location'.tr}:'),
              const SizedBox(height: 4),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  file.path,
                  style: TextStyle(fontSize: 10, fontFamily: 'monospace'),
                  softWrap: true,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('close'.tr),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _openPdfFile(file);
            },
            child: Text('open_pdf'.tr),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // Open PDF file
  void _openPdfFile(File file) {
    try {
      OpenFile.open(file.path);
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'Could not open PDF file: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
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