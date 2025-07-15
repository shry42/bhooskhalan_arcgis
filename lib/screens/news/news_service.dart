import 'package:bhooskhalann/screens/news/models/news_item_model.dart';

import '../../services/api_service.dart';

class NewsService {
  static Future<List<NewsItem>> fetchNews() async {
    try {
      final data = await ApiService.get('/News/datalist');

      if (data.containsKey('result') && data['result'] is List) {
        List<NewsItem> newsList = (data['result'] as List)
            .map((item) => NewsItem.fromJson(item))
            .toList()
            .reversed
            .toList(); // Latest first
        return newsList;
      } else {
        throw Exception("Unexpected response format: 'result' not found.");
      }
    } catch (e) {
      print("NewsService error: $e");
      rethrow;
    }
  }
}
