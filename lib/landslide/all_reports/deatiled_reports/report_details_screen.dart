import 'dart:convert';
import 'dart:typed_data';
import 'package:bhooskhalann/landslide/all_reports/deatiled_reports/detailed_landslide_report_model.dart';
import 'package:bhooskhalann/landslide/all_reports/deatiled_reports/detailed_report_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportDetailsScreen extends StatefulWidget {
  final String reportId;
  final String reportTitle;

  const ReportDetailsScreen({
    Key? key,
    required this.reportId,
    required this.reportTitle,
  }) : super(key: key);

  @override
  State<ReportDetailsScreen> createState() => _ReportDetailsScreenState();
}

class _ReportDetailsScreenState extends State<ReportDetailsScreen> {
  DetailedLandslideReport? _report;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchReportDetails();
  }

  Future<void> _fetchReportDetails() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final report = await DetailedReportService.fetchReportDetails(widget.reportId);
      
      setState(() {
        _report = report;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching report details: $e");
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  String _formatValue(String? value) {
    if (value == null || value.isEmpty || value == 'null') {
      return 'N/A';
    }
    return value;
  }

  String _formatDateTime(String? dateTime) {
    if (dateTime == null || dateTime.isEmpty || dateTime == 'null') {
      return 'N/A';
    }
    
    try {
      final DateTime parsed = DateTime.parse(dateTime);
      return DateFormat('yyyy-MM-dd HH:mm:ss').format(parsed);
    } catch (e) {
      return dateTime;
    }
  }

  Color _getStatusColor() {
    if (_report == null) return Colors.grey;
    
    if (_report!.isApproved) return Colors.green;
    if (_report!.isRejected) return Colors.red;
    if (_report!.isPending) return Colors.orange;
    return Colors.grey;
  }

  Widget _buildDetailRow(String label, String value, {bool isHeader = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: isHeader ? Colors.grey.shade100 : Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: isHeader ? FontWeight.bold : FontWeight.w500,
                fontSize: isHeader ? 16 : 14,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                fontSize: isHeader ? 16 : 14,
                color: isHeader ? Colors.black : Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        border: Border(
          bottom: BorderSide(color: Colors.blue.shade200, width: 1),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.blue.shade700,
        ),
      ),
    );
  }

  Widget _buildPhotographSection() {
    if (_report == null) return const SizedBox.shrink();
    
    final photos = _report!.availablePhotographs;
    
    if (photos.isEmpty) {
      return Column(
        children: [
          _buildSectionHeader('Landslide Photographs'),
          Container(
            padding: const EdgeInsets.all(16),
            child: const Text(
              'No photographs available',
              style: TextStyle(
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        _buildSectionHeader('Landslide Photographs'),
        Container(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemCount: photos.length,
            itemBuilder: (context, index) {
              return _buildPhotoWidget(photos[index], index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoWidget(String photoData, int index) {
    try {
      // Check if it's base64 data
      if (photoData.startsWith('/9j/') || photoData.startsWith('iVBOR') || photoData.startsWith('UklGR')) {
        final Uint8List bytes = base64Decode(photoData);
        return GestureDetector(
          onTap: () => _showFullScreenImage(bytes, index),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.memory(
                bytes,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPhotoPlaceholder('Invalid Image ${index + 1}');
                },
              ),
            ),
          ),
        );
      } else {
        // Treat as URL
        return GestureDetector(
          onTap: () => _showFullScreenImageUrl(photoData, index),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                photoData,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPhotoPlaceholder('Image ${index + 1}');
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / 
                            loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              ),
            ),
          ),
        );
      }
    } catch (e) {
      return _buildPhotoPlaceholder('Photo ${index + 1}');
    }
  }

  Widget _buildPhotoPlaceholder(String label) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported,
              size: 40,
              color: Colors.grey.shade500,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFullScreenImage(Uint8List bytes, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            title: Text('Photo ${index + 1}'),
          ),
          body: Center(
            child: InteractiveViewer(
              child: Image.memory(bytes),
            ),
          ),
        ),
      ),
    );
  }

  void _showFullScreenImageUrl(String url, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            title: Text('Photo ${index + 1}'),
          ),
          body: Center(
            child: InteractiveViewer(
              child: Image.network(url),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('Report Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (!_isLoading && _report != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _fetchReportDetails,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading report details...'),
                ],
              ),
            )
          : _errorMessage != null
              ? Center(
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
                        'Error loading report details',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchReportDetails,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      // Basic Information
                      _buildDetailRow('ID', _report!.id, isHeader: true),
                      _buildDetailRow('Latitude', _formatValue(_report!.latitude)),
                      _buildDetailRow('Longitude', _formatValue(_report!.longitude)),
                      _buildDetailRow('State', _formatValue(_report!.state)),
                      _buildDetailRow('District', _formatValue(_report!.district)),
                      _buildDetailRow('SubdivisionOrTaluk', _formatValue(_report!.subdivisionOrTaluk)),
                      _buildDetailRow('Village', _formatValue(_report!.village)),
                      _buildDetailRow('LocationDetails', _formatValue(_report!.locationDetails)),

                      // Landslide Details
                      _buildSectionHeader('Landslide Information'),
                      _buildDetailRow('DateTimeType', _formatValue(_report!.dateTimeType)),
                      _buildDetailRow('LandslideDate', _formatValue(_report!.landslideDate)),
                      _buildDetailRow('LandslideTime', _formatValue(_report!.landslideTime)),
                      _buildDetailRow('Date_and_time_Range', _formatValue(_report!.dateAndTimeRange)),
                      _buildDetailRow('LanduseOrLandcover', _formatValue(_report!.landuseOrLandcover)),
                      _buildDetailRow('OtherLandUse', _formatValue(_report!.otherLandUse)),
                      _buildDetailRow('MaterialInvolved', _formatValue(_report!.materialInvolved)),
                      _buildDetailRow('InducingFactor', _formatValue(_report!.inducingFactor)),

                      // Measurements
                      _buildSectionHeader('Measurements'),
                      _buildDetailRow('Amount_of_rainfall', _formatValue(_report!.amountOfRainfall)),
                      _buildDetailRow('Duration_of_rainfall', _formatValue(_report!.durationOfRainfall)),
                      _buildDetailRow('ImpactOrDamage', _formatValue(_report!.impactOrDamage)),

                      // Casualties and Damage
                      _buildSectionHeader('Impact Assessment'),
                      _buildDetailRow('PeopleInjured', _formatValue(_report!.peopleInjured)),
                      _buildDetailRow('PeopleDead', _formatValue(_report!.peopleDead)),
                      _buildDetailRow('LivestockDead', _formatValue(_report!.livestockDead)),
                      _buildDetailRow('LivestockInjured', _formatValue(_report!.livestockInjured)),
                      _buildDetailRow('HousesBuildingfullyAffected', _formatValue(_report!.housesBuildingfullyaffected)),
                      _buildDetailRow('HousesBuildingPartialAffected', _formatValue(_report!.housesBuildingpartialaffected)),

                      // Infrastructure Impact
                      _buildSectionHeader('Infrastructure Impact'),
                      _buildDetailRow('DamsBarragesCount', _formatValue(_report!.damsBarragesCount)),
                      _buildDetailRow('DamsBarragesExtentOfDamage', _formatValue(_report!.damsBarragesExtentOfDamage)),
                      _buildDetailRow('RoadsAffectedType', _formatValue(_report!.roadsAffectedType)),
                      _buildDetailRow('RoadsAffectedExtentOfDamage', _formatValue(_report!.roadsAffectedExtentOfDamage)),
                      _buildDetailRow('RoadBlocked', _formatValue(_report!.roadBlocked)),
                      _buildDetailRow('RoadBenchesAffected', _formatValue(_report!.roadBenchesAffected)),
                      _buildDetailRow('RailwayLineAffected', _formatValue(_report!.railwayLineAffected)),
                      _buildDetailRow('RailwayLineBlockage', _formatValue(_report!.railwayLineBlockage)),
                      _buildDetailRow('RailwayBenchesAffected', _formatValue(_report!.railwayBenchesAffected)),
                      _buildDetailRow('PowerInfrastructureAffected', _formatValue(_report!.powerInfrastructureAffected)),
                      _buildDetailRow('OthersAffected', _formatValue(_report!.othersAffected)),
                      _buildDetailRow('OtherInformation', _formatValue(_report!.otherInformation)),

                      // Technical Details
                      _buildSectionHeader('Technical Information'),
                      _buildDetailRow('ExactDateInfo', _formatValue(_report!.exactDateInfo)),
                      _buildDetailRow('RainfallIntensity', _formatValue(_report!.rainfallIntensity)),
                      _buildDetailRow('InternalSlopeReinforcement', _formatValue(_report!.internalSlopeReinforcememt)),
                      _buildDetailRow('RemedialNotRequired', _formatValue(_report!.remedialNotRequired)),
                      _buildDetailRow('RemedialNotSufficient', _formatValue(_report!.remedialNotSufficient)),
                      _buildDetailRow('datacreatedby', _formatValue(_report!.datacreatedby)),
                      _buildDetailRow('datacreated', _formatDateTime(_report!.datacreated)),
                      _buildDetailRow('dataupdated', _formatDateTime(_report!.dataupdated)),
                      _buildDetailRow('dataupdatedby', _formatValue(_report!.dataupdatedby)),

                      // Status Information
                      _buildSectionHeader('Review Status'),
                      _buildDetailRow('check_Status', _formatValue(_report!.checkStatus)),
                      _buildDetailRow('LandslideSize', _formatValue(_report!.landslideSize)),
                      _buildDetailRow('ContactName', _formatValue(_report!.contactName)),
                      _buildDetailRow('ContactAffiliation', _formatValue(_report!.contactAffiliation)),
                      _buildDetailRow('ContactEmailId', _formatValue(_report!.contactEmailId)),
                      _buildDetailRow('ContactMobile', _formatValue(_report!.contactMobile)),
                      _buildDetailRow('UserType', _formatValue(_report!.userType)),
                      _buildDetailRow('u_lat', _formatValue(_report!.uLat)),
                      _buildDetailRow('u_long', _formatValue(_report!.uLong)),
                      _buildDetailRow('Toposheet_No', _formatValue(_report!.toposheetNo)),
                      _buildDetailRow('ImageCaptions', _formatValue(_report!.imageCaptions)),

                      // Photographs
                      _buildPhotographSection(),

                      // Bottom padding
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
    );
  }
}