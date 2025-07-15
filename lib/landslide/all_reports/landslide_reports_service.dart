import 'package:bhooskhalann/landslide/all_reports/landslide_report_model.dart';
import 'package:bhooskhalann/services/api_service.dart';

class LandslideReportsService {
  static Future<List<LandslideReport>> fetchReports() async {
    try {
      final data = await ApiService.get('/Landslide/datalist');

      if (data.containsKey('result') && data['result'] is List) {
        List<LandslideReport> reportsList = (data['result'] as List)
            .map((item) => LandslideReport.fromJson(item))
            .toList();
        return reportsList;
      } else {
        throw Exception("Unexpected response format: 'result' not found.");
      }
    } catch (e) {
      print("LandslideReportsService error: $e");
      rethrow;
    }
  }

  // Filter reports by status
  static List<LandslideReport> filterByStatus(
    List<LandslideReport> reports, 
    String status
  ) {
    return reports.where((report) => 
      report.checkStatus.toLowerCase() == status.toLowerCase()
    ).toList();
  }

  // Filter reports by user type
  static List<LandslideReport> filterByUserType(
    List<LandslideReport> reports, 
    String userType
  ) {
    return reports.where((report) => 
      report.userType.toLowerCase() == userType.toLowerCase()
    ).toList();
  }

  // Get reports by district
  static List<LandslideReport> filterByDistrict(
    List<LandslideReport> reports, 
    String district
  ) {
    return reports.where((report) => 
      report.district.toLowerCase().contains(district.toLowerCase())
    ).toList();
  }

  // Get statistics
  static Map<String, int> getStatistics(List<LandslideReport> reports) {
    return {
      'total': reports.length,
      'approved': reports.where((r) => r.isApproved).length,
      'rejected': reports.where((r) => r.isRejected).length,
      'pending': reports.where((r) => r.isPending).length,
      'geoScientist': reports.where((r) => r.isGeoScientist).length,
      'public': reports.where((r) => r.isPublic).length,
    };
  }
}