import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class BulletinWebViewScreen extends StatefulWidget {
  final String bulletinDate;
  final String endpoint;
  final String state;
  final String district;

  const BulletinWebViewScreen({
    Key? key,
    required this.bulletinDate,
    required this.endpoint,
    required this.state,
    required this.district,
  }) : super(key: key);

  @override
  State<BulletinWebViewScreen> createState() => _BulletinWebViewScreenState();
}

class _BulletinWebViewScreenState extends State<BulletinWebViewScreen> {
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';
  String? fullUrl;
  String? localPdfPath;
  PDFViewController? pdfController;
  int currentPage = 0;
  int totalPages = 0;

  @override
  void initState() {
    super.initState();
    _loadPDF();
  }

  Future<void> _loadPDF() async {
    // Construct the full URL
    const String baseUrl = 'https://bhusanket.gsi.gov.in/webapi';
    fullUrl = '$baseUrl${widget.endpoint}';
    
    await _downloadAndDisplayPDF();
  }

  Future<void> _downloadAndDisplayPDF() async {
    try {
      setState(() {
        isLoading = true;
        hasError = false;
        errorMessage = '';
      });

      // Download PDF with proper headers
      final response = await http.get(
        Uri.parse(fullUrl!),
        headers: {
          'Referer': 'https://bhusanket.gsi.gov.in/',
          'Accept': '*/*',
          'Accept-Encoding': 'gzip, deflate, br',
          'Connection': 'keep-alive',
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
        },
      );

      if (response.statusCode == 200) {
        // Save PDF to temporary directory
        final tempDir = await getTemporaryDirectory();
        final fileName = 'bulletin_${widget.bulletinDate}_${DateTime.now().millisecondsSinceEpoch}.pdf';
        final file = File('${tempDir.path}/$fileName');
        await file.writeAsBytes(response.bodyBytes);
        
        setState(() {
          localPdfPath = file.path;
          isLoading = false;
        });
        
      } else {
        throw Exception('Server returned ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage = '${'something_went_wrong'.tr}$e';
      });
    }
  }

  String _formatDisplayDate(String bulletinDate) {
    // Convert YYYYMMDD to readable format
    if (bulletinDate.length == 8) {
      final year = bulletinDate.substring(0, 4);
      final month = bulletinDate.substring(4, 6);
      final day = bulletinDate.substring(6, 8);
      return '$day-$month-$year';
    }
    return bulletinDate;
  }

  void _goToPreviousPage() {
    if (currentPage > 0) {
      pdfController?.setPage(currentPage - 1);
    }
  }

  void _goToNextPage() {
    if (currentPage < totalPages - 1) {
      pdfController?.setPage(currentPage + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${'bulletin_title'.tr}${_formatDisplayDate(widget.bulletinDate)}',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            Text(
              '${widget.state} - ${widget.district}',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        backgroundColor: const Color(0xFF2196F3),
        elevation: 0,
        actions: [
          if (localPdfPath != null && totalPages > 0) ...[
            IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: currentPage > 0 ? _goToPreviousPage : null,
              tooltip: 'previous_page'.tr,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${currentPage + 1}/$totalPages',
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
              onPressed: currentPage < totalPages - 1 ? _goToNextPage : null,
              tooltip: 'next_page'.tr,
            ),
          ],
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              _downloadAndDisplayPDF();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          if (hasError)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'failed_to_load_bulletin'.tr,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${'bulletin_for'.tr}${widget.state} - ${widget.district}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      errorMessage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _downloadAndDisplayPDF();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: Text(
                        'retry'.tr,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (localPdfPath != null)
            PDFView(
              filePath: localPdfPath!,
              enableSwipe: true,
              swipeHorizontal: false,
              autoSpacing: false,
              pageSnap: true,
              pageFling: true,
              onRender: (pages) {
                setState(() {
                  totalPages = pages ?? 0;
                });
              },
              onError: (error) {
                setState(() {
                  hasError = true;
                  errorMessage = '${'error_displaying_pdf'.tr}$error';
                  isLoading = false;
                });
              },
              onPageError: (page, error) {
                setState(() {
                  hasError = true;
                  errorMessage = '${'error_loading_page'.tr}$page: $error';
                });
              },
              onViewCreated: (PDFViewController pdfViewController) {
                pdfController = pdfViewController;
              },
              onPageChanged: (int? page, int? total) {
                setState(() {
                  currentPage = page ?? 0;
                  totalPages = total ?? 0;
                });
              },
            )
          else
            Container(
              color: Colors.grey.shade50,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      color: Color(0xFF2196F3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'loading_bulletin'.tr,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
          // Loading overlay
          if (isLoading)
            Container(
              color: Colors.white.withOpacity(0.9),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      color: Color(0xFF2196F3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'downloading_bulletin'.tr,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${widget.state} - ${widget.district}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      // Bottom navigation for PDF
      bottomNavigationBar: localPdfPath != null && totalPages > 1
          ? Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: currentPage > 0 ? _goToPreviousPage : null,
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: currentPage > 0 ? const Color(0xFF2196F3) : Colors.grey,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: LinearProgressIndicator(
                        value: totalPages > 0 ? (currentPage + 1) / totalPages : 0,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2196F3)),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: currentPage < totalPages - 1 ? _goToNextPage : null,
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: currentPage < totalPages - 1 ? const Color(0xFF2196F3) : Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}