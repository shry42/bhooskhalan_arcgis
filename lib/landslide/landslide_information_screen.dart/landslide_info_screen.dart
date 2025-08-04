import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';

class LandslideInfoScreen extends StatefulWidget {
  const LandslideInfoScreen({Key? key}) : super(key: key);

  @override
  State<LandslideInfoScreen> createState() => _LandslideInfoScreenState();
}

class _LandslideInfoScreenState extends State<LandslideInfoScreen> {
  bool _isExpanded = false;
  String _pdfPath = '';
  bool _pdfLoaded = false;

  @override
  void initState() {
    super.initState();
    _preparePdf();
  }

  Future<void> _preparePdf() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/basic_info.pdf';
      final file = File(filePath);

      if (!file.existsSync()) {
        final byteData = await rootBundle.load('assets/pdfs/basic_info.pdf');
        final buffer = byteData.buffer;
        await file.writeAsBytes(
            buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      }

      setState(() {
        _pdfPath = filePath;
        _pdfLoaded = true;
      });
    } catch (e) {
      print('Error preparing PDF: $e');
    }
  }

  void _openPdf() {
    if (_pdfLoaded) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFViewerScreen(filePath: _pdfPath),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('pdf_loading_msg'.tr)),
      );
    }
  }

  void _openYoutubeVideo() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewScreen(
          url: 'https://youtu.be/VFakz8MmCwg?si=iKKuQWT7HO62fTmA',
          title: 'landslide_video',
        ),
      ),
    );
  }

  void _openWebLink(String url, String titleKey) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebViewScreen(
          url: url,
          title: titleKey,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Color(0xFF1976D2),
        foregroundColor: Colors.white,
        title: Text(
          'basic_info_title'.tr,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Color(0xFFF5F5DC),
              padding: EdgeInsets.all(16),
              child: InkWell(
                onTap: _openPdf,
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/pdf_icon.png',
                      width: 80,
                      height: 80,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 80,
                        height: 90,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'PDF',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              width: 40,
                              child: Divider(color: Colors.white, thickness: 2),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 3),
                              width: 30,
                              child: Divider(color: Colors.white, thickness: 2),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 3),
                              width: 20,
                              child: Divider(color: Colors.white, thickness: 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Text(
                        'pdf_file_name'.tr,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: ElevatedButton.icon(
                onPressed: _openYoutubeVideo,
                icon: Icon(Icons.play_circle_filled),
                label: Text('watch_video'.tr),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'further_info'.tr,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                          size: 32,
                        ),
                      ],
                    ),
                  ),
                  Divider(color: Colors.grey),
                  if (_isExpanded) ...[
                    _buildLinkItem(
                        'https://pubs.usgs.gov/fs/2004/3072/fs-2004-3072.html',
                        'usgs_landslide'),
                    _buildLinkItem(
                        'https://ndma.gov.in/Natural-Hazards/Landslide',
                        'ndma_landslide'),
                    _buildLinkItem(
                        'https://www.nrsc.gov.in/sites/default/files/pdf/ebooks/Chap_14_Landslide.pdf',
                        'nrsc_landslide'),
                    _buildLinkItem(
                        'https://nerdrr.gov.in/landslide.php#:~:text=In%20India%2C%20Geological%20Survey%20of',
                        'nerdrr_landslide'),
                    _buildLinkItem(
                        'https://www.landslip.org/',
                        'landslip_org'),
                    _buildLinkItem(
                        'https://pubs.usgs.gov/fs/2004/3072/fs-2004-3072.html',
                        'usgs_factsheet'),
                    _buildLinkItem(
                        'https://www.bgs.ac.uk/discovering-geology/earth-hazards/landslides/how-to-classify-a-landslide/',
                        'bgs_classify'),
                  ],
                ],
              ),
            ),
            Container(
              color: Colors.grey[800],
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Image.asset(
                      'assets/images/gsi_logo.png',
                      width: 45,
                      height: 45,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.public,
                        size: 30,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'history_gsi'.tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'gsi_headquarters'.tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinkItem(String url, String titleKey) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () => _openWebLink(url, titleKey),
        child: Text(
          url,
          style: TextStyle(
            color: Colors.blue,
            decoration: TextDecoration.underline,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class PDFViewerScreen extends StatelessWidget {
  final String filePath;

  const PDFViewerScreen({Key? key, required this.filePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1976D2),
        title: Text('basic_info_title'.tr),
        centerTitle: true,
      ),
      body: PDFView(
        filePath: filePath,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: true,
        pageSnap: true,
        pageFling: true,
        onError: (error) {
          print('Error rendering PDF: $error');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not load PDF: $error')),
          );
        },
        onPageError: (page, error) {
          print('Error rendering page $page: $error');
        },
      ),
    );
  }
}

class WebViewScreen extends StatefulWidget {
  final String url;
  final String title;

  const WebViewScreen({Key? key, required this.url, required this.title}) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            print('Web resource error: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1976D2),
        title: Text(widget.title.tr),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              controller.reload();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading)
            Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
