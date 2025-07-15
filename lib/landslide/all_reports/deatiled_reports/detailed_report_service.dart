import 'package:bhooskhalann/landslide/all_reports/deatiled_reports/detailed_landslide_report_model.dart';
import 'package:bhooskhalann/services/api_service.dart';

class DetailedReportService {
  static Future<DetailedLandslideReport> fetchReportDetails(String reportId) async {
    try {
      // Use the same endpoint structure as your news API
      // Adjust the endpoint based on your actual API structure
      final data = await ApiService.get('/Landslide/get/$reportId');

      if (data.containsKey('result') && data['result'] is List && (data['result'] as List).isNotEmpty) {
        final reportData = (data['result'] as List).first;
        return DetailedLandslideReport.fromJson(reportData);
      } else {
        throw Exception("Report not found or unexpected response format.");
      }
    } catch (e) {
      print("DetailedReportService error: $e");
      rethrow;
    }
  }

  // Alternative method if you need to use POST request
  static Future<DetailedLandslideReport> fetchReportDetailsPost(String reportId) async {
    try {
      final data = await ApiService.post('/Landslide/GetDetail', {
        'id': reportId,
      });

      if (data.containsKey('result') && data['result'] is List && (data['result'] as List).isNotEmpty) {
        final reportData = (data['result'] as List).first;
        return DetailedLandslideReport.fromJson(reportData);
      } else {
        throw Exception("Report not found or unexpected response format.");
      }
    } catch (e) {
      print("DetailedReportService error: $e");
      rethrow;
    }
  }
}