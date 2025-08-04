import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'news_webview_screen.dart';

class EnhancedPdfViewerScreen extends StatefulWidget {
  final String url;
  final String title;

  const EnhancedPdfViewerScreen({
    Key? key,
    required this.url,
    required this.title,
  }) : super(key: key);

  @override
  State<EnhancedPdfViewerScreen> createState() => _EnhancedPdfViewerScreenState();
}

class _EnhancedPdfViewerScreenState extends State<EnhancedPdfViewerScreen> {
  late PdfViewerController _pdfViewerController;
  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;
  bool _showFallbackOptions = false;

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
  }

  Future<void> _openInExternalApp() async {
    try {
      final Uri url = Uri.parse(widget.url);
      if (await canLaunchUrl(url)) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      } else {
        _showErrorSnackBar('cannotOpenPdfExternalApp'.tr);
      }
    } catch (e) {
      _showErrorSnackBar('${'errorOpeningExternalApp'.tr} $e');
    }
  }

  Future<void> _openInWebView() async {
    try {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NewsWebViewScreen(
            url: widget.url,
            title: widget.title,
          ),
        ),
      );
    } catch (e) {
      _showErrorSnackBar('${'errorOpeningWebView'.tr} $e');
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'retry'.tr,
            textColor: Colors.white,
            onPressed: () {
              setState(() {
                _isLoading = true;
                _hasError = false;
                _errorMessage = null;
                _showFallbackOptions = false;
              });
            },
          ),
        ),
      );
    }
  }

  Widget _buildFallbackOptions() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.orange.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'pdfLoadingFailed'.tr,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'tryAlternatives'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            
            // Option 1: Open in WebView
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _openInWebView,
                icon: const Icon(Icons.web),
                label: Text('openInWebView'.tr),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Option 2: Open in External App
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _openInExternalApp,
                icon: const Icon(Icons.open_in_new),
                label: Text('openInExternalApp'.tr),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Option 3: Retry
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _hasError = false;
                    _errorMessage = null;
                    _showFallbackOptions = false;
                  });
                },
                icon: const Icon(Icons.refresh),
                label: Text('retryPdfViewer'.tr),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ),
            
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Text(
                  '${'errorDetails'.tr} $_errorMessage',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          if (!_hasError && !_showFallbackOptions) ...[
            IconButton(
              icon: const Icon(Icons.zoom_in),
              onPressed: () {
                _pdfViewerController.zoomLevel = _pdfViewerController.zoomLevel + 0.25;
              },
            ),
            IconButton(
              icon: const Icon(Icons.zoom_out),
              onPressed: () {
                _pdfViewerController.zoomLevel = _pdfViewerController.zoomLevel - 0.25;
              },
            ),
          ],
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'external':
                  _openInExternalApp();
                  break;
                case 'webview':
                  _openInWebView();
                  break;
                case 'fit_width':
                  _pdfViewerController.zoomLevel = 1.0;
                  break;
                case 'fit_page':
                  _pdfViewerController.zoomLevel = 0.75;
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'external',
                child: Row(
                  children: [
                    const Icon(Icons.open_in_new),
                    const SizedBox(width: 8),
                    Text('openExternally'.tr),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'webview',
                child: Row(
                  children: [
                    const Icon(Icons.web),
                    const SizedBox(width: 8),
                    Text('openInWebView'.tr),
                  ],
                ),
              ),
              if (!_hasError) ...[
                const PopupMenuDivider(),
                PopupMenuItem(
                  value: 'fit_width',
                  child: Text('fitWidth'.tr),
                ),
                PopupMenuItem(
                  value: 'fit_page',
                  child: Text('fitPage'.tr),
                ),
              ],
            ],
          ),
        ],
      ),
      body: _showFallbackOptions 
        ? _buildFallbackOptions()
        : Stack(
            children: [
              if (!_hasError)
                SfPdfViewer.network(
                  widget.url,
                  controller: _pdfViewerController,
                  canShowScrollHead: true,
                  canShowScrollStatus: true,
                  enableDoubleTapZooming: true,
                  enableTextSelection: true,
                  onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                    setState(() {
                      _isLoading = false;
                      _hasError = false;
                    });
                  },
                  onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
                    setState(() {
                      _isLoading = false;
                      _hasError = true;
                      _errorMessage = details.description;
                    });
                    
                    // Auto-show fallback options after 2 seconds
                    Future.delayed(const Duration(seconds: 2), () {
                      if (mounted && _hasError) {
                        setState(() {
                          _showFallbackOptions = true;
                        });
                      }
                    });
                  },
                ),
                
              // Loading indicator
              if (_isLoading)
                Container(
                  color: Colors.white.withOpacity(0.9),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text('loadingPdf'.tr),
                        const SizedBox(height: 8),
                        Text(
                          'loadingPdfSubtitle'.tr,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
              // Error state (before showing fallback options)
              if (_hasError && !_showFallbackOptions)
                Container(
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'pdfLoadingFailed'.tr,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Text('preparingAlternatives'.tr),
                        const SizedBox(height: 16),
                        const CircularProgressIndicator(),
                      ],
                    ),
                  ),
                ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }
}