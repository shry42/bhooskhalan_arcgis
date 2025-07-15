import 'package:bhooskhalann/screens/news/models/news_item_model.dart';
import 'package:bhooskhalann/screens/news/news_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'news_webview_screen.dart';
import 'enhanced_pdf_viewer_screen.dart'; // Use the enhanced PDF viewer

class RecentNewsScreen extends StatefulWidget {
  @override
  _RecentNewsScreenState createState() => _RecentNewsScreenState();
}

class _RecentNewsScreenState extends State<RecentNewsScreen> {
  late Future<List<NewsItem>> _newsList;

  @override
  void initState() {
    super.initState();
    _newsList = NewsService.fetchNews();
  }

  String formatDate(String rawDate) {
    try {
      final parsedDate = DateTime.parse(rawDate);
      return DateFormat('dd MMMM yyyy').format(parsedDate);
    } catch (e) {
      return rawDate;
    }
  }

  void _openNewsContent(BuildContext context, NewsItem news) {
    if (!news.hasValidUrl) {
      // Show a message if URL is not available
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.white),
              SizedBox(width: 8),
              Expanded(
                child: Text('No web link available for this news item'),
              ),
            ],
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final String title = news.content.length > 50 
        ? '${news.content.substring(0, 50)}...' 
        : news.content;

    if (news.isPdfUrl) {
      // Navigate to Enhanced PDF viewer for PDF files
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EnhancedPdfViewerScreen(
            url: news.newsUrl,
            title: title,
          ),
        ),
      );
    } else if (news.isWebUrl) {
      // Navigate to WebView for regular web links
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewsWebViewScreen(
            url: news.newsUrl,
            title: title,
          ),
        ),
      );
    }
  }

  Widget _buildNewsStats(List<NewsItem> newsList) {
    final pdfCount = newsList.where((news) => news.isPdfUrl).length;
    final webCount = newsList.where((news) => news.isWebUrl).length;
    final textOnlyCount = newsList.where((news) => !news.hasValidUrl).length;

    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(Icons.picture_as_pdf, 'PDF', pdfCount, Colors.red),
          _buildStatItem(Icons.open_in_browser, 'Web', webCount, Colors.blue),
          _buildStatItem(Icons.article_outlined, 'Text', textOnlyCount, Colors.grey),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, int count, MaterialColor color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color.shade600, size: 20),
        const SizedBox(height: 4),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color.shade700,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildNewsCard(NewsItem news) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          news.content,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  formatDate(news.date),
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
              // Show appropriate icon based on URL type
              if (news.isPdfUrl) ...[
                Icon(
                  Icons.picture_as_pdf,
                  size: 16,
                  color: Colors.red.shade600,
                ),
                const SizedBox(width: 4),
                Text(
                  'PDF',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ] else if (news.isWebUrl) ...[
                Icon(
                  Icons.open_in_browser,
                  size: 16,
                  color: Colors.blue.shade600,
                ),
                const SizedBox(width: 4),
                Text(
                  'Web',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ] else ...[
                Icon(
                  Icons.article_outlined,
                  size: 16,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(width: 4),
                Text(
                  'Text Only',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
        onTap: news.hasValidUrl ? () => _openNewsContent(context, news) : null,
        // Add visual feedback that the item is clickable
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        // Add subtle hover effect
        hoverColor: news.hasValidUrl ? Colors.grey.shade100 : null,
        // Add splash effect on tap
        splashColor: news.hasValidUrl ? Colors.blue.shade50 : null,
        // Show disabled state for items without links
        enabled: news.hasValidUrl,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recent News'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<NewsItem>>(
        future: _newsList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.shade400,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Error fetching news",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _newsList = NewsService.fetchNews();
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.article_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "No news found",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _newsList = NewsService.fetchNews();
              });
              await _newsList;
            },
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 10),
              itemCount: snapshot.data!.length + 1, // +1 for stats widget
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Show statistics at the top
                  return _buildNewsStats(snapshot.data!);
                }
                final news = snapshot.data![index - 1]; // -1 because of stats widget
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: _buildNewsCard(news),
                );
              },
            ),
          );
        },
      ),
    );
  }
}