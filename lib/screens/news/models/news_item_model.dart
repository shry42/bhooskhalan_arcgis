class NewsItem {
  final String id;
  final String content;
  final String newsUrl;
  final String date;
  final bool isRecent;

  NewsItem({
    required this.id,
    required this.content,
    required this.newsUrl,
    required this.date,
    required this.isRecent,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      id: json['ID'] ?? '',
      content: json['News_Content'] ?? '',
      newsUrl: json['News_url'] ?? '',
      date: json['DateColumn'] ?? '',
      isRecent: json['Recent'] == 'true',
    );
  }

  // Helper method to check if URL is valid
  bool get hasValidUrl => newsUrl.isNotEmpty && newsUrl.trim() != '' && newsUrl.trim() != ' ';
  
  // Helper method to check if URL is a PDF
  bool get isPdfUrl => hasValidUrl && newsUrl.toLowerCase().endsWith('.pdf');
  
  // Helper method to check if URL is a web link
  bool get isWebUrl => hasValidUrl && !isPdfUrl;
  
  // Helper method to get URL type for display
  String get urlType {
    if (isPdfUrl) return 'PDF';
    if (isWebUrl) return 'Web';
    return 'No Link';
  }
}