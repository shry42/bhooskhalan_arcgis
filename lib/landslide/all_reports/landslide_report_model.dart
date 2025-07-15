class LandslideReport {
  final String id;
  final double latitude;
  final double longitude;
  final String district;
  final String userType;
  final String checkStatus;

  LandslideReport({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.district,
    required this.userType,
    required this.checkStatus,
  });

  factory LandslideReport.fromJson(Map<String, dynamic> json) {
    return LandslideReport(
      id: json['ID']?.toString() ?? '',
      latitude: double.tryParse(json['Latitude']?.toString() ?? '0') ?? 0.0,
      longitude: double.tryParse(json['Longitude']?.toString() ?? '0') ?? 0.0,
      district: json['District']?.toString() ?? '',
      userType: json['UserType']?.toString() ?? '',
      checkStatus: json['check_Status']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'Latitude': latitude.toString(),
      'Longitude': longitude.toString(),
      'District': district,
      'UserType': userType,
      'check_Status': checkStatus,
    };
  }

  // Helper methods for UI
  bool get isApproved => checkStatus.toLowerCase() == 'approved';
  bool get isRejected => checkStatus.toLowerCase() == 'rejected';
  bool get isPending => checkStatus.toLowerCase() == 'pending';
  
  bool get isGeoScientist => userType.toLowerCase() == 'geo-scientist';
  bool get isPublic => userType.toLowerCase() == 'public';

  String get statusDisplayName {
    switch (checkStatus.toLowerCase()) {
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      case 'pending':
        return 'Pending';
      default:
        return checkStatus;
    }
  }

  String get userTypeDisplayName {
    switch (userType.toLowerCase()) {
      case 'geo-scientist':
        return 'Geo-Scientist';
      case 'public':
        return 'Public';
      default:
        return userType;
    }
  }
}