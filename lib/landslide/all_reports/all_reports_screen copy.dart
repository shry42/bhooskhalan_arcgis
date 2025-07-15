// import 'package:bhooskhalann/landslide/all_reports/deatiled_reports/report_details_screen.dart';
// import 'package:bhooskhalann/landslide/all_reports/landslide_report_model.dart';
// import 'package:bhooskhalann/landslide/all_reports/landslide_reports_service.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:flutter_compass/flutter_compass.dart';
// import 'dart:math';

// class AllReportsScreen extends StatefulWidget {
//   const AllReportsScreen({Key? key}) : super(key: key);

//   @override
//   State<AllReportsScreen> createState() => _AllReportsScreenState();
// }

// class _AllReportsScreenState extends State<AllReportsScreen> {
//   GoogleMapController? _mapController;
//   Position? _currentPosition;
//   bool _isLoading = true;
//   Set<Marker> _markers = {};
//   MapType _currentMapType = MapType.normal;
//   double _compassHeading = 0.0;
  
//   List<LandslideReport> _allReports = [];
//   List<LandslideReport> _filteredReports = [];
//   String _selectedFilter = 'All';
  
//   // Map bounds for India
//   static const LatLng _indiaCenter = LatLng(20.5937, 78.9629);
//   static const double _indiaZoom = 5.0;

//   @override
//   void initState() {
//     super.initState();
//     _initCompass();
//     _fetchReports();
//   }

//   void _initCompass() {
//     FlutterCompass.events!.listen((CompassEvent event) {
//       if (mounted) {
//         setState(() {
//           _compassHeading = event.heading ?? 0.0;
//         });
//       }
//     });
//   }

//   Future<void> _fetchReports() async {
//     try {
//       setState(() => _isLoading = true);
      
//       final reports = await LandslideReportsService.fetchReports();
      
//       setState(() {
//         _allReports = reports;
//         _filteredReports = reports;
//         _isLoading = false;
//       });
      
//       await _createMarkers();
      
//     } catch (e) {
//       print("Error fetching reports: $e");
//       setState(() => _isLoading = false);
      
//       _showErrorSnackBar('Failed to load reports: ${e.toString()}');
//     }
//   }

//   Future<void> _createMarkers() async {
//     final Set<Marker> markers = {};
    
//     for (int i = 0; i < _filteredReports.length; i++) {
//       final report = _filteredReports[i];
      
//       // Skip invalid coordinates
//       if (report.latitude == 0.0 || report.longitude == 0.0) continue;
      
//       final BitmapDescriptor markerIcon = await _getMarkerIcon(report);
      
//       markers.add(
//         Marker(
//           markerId: MarkerId(report.id),
//           position: LatLng(report.latitude, report.longitude),
//           icon: markerIcon,
//           infoWindow: InfoWindow(
//             title: '${report.district} - ${report.statusDisplayName}',
//             snippet: 'Reported by: ${report.userTypeDisplayName}\nID: ${report.id}',
//           ),
//           onTap: () => _navigateToReportDetails(report),
//         ),
//       );
//     }
    
//     setState(() {
//       _markers = markers;
//     });
//   }

//   Future<BitmapDescriptor> _getMarkerIcon(LandslideReport report) async {
//     if (report.isApproved) {
//       return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
//     } else if (report.isRejected) {
//       return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
//     } else if (report.isPending) {
//       return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
//     } else {
//       return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
//     }
//   }

//   // Updated method to navigate to ReportDetailsScreen
//   void _navigateToReportDetails(LandslideReport report) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ReportDetailsScreen(
//           reportId: report.id,
//           reportTitle: '${report.district} - ${report.statusDisplayName}',
//         ),
//       ),
//     );
//   }

//   // Optional: Keep the modal as a quick preview option
//   void _showQuickReportPreview(LandslideReport report) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Container(
//         height: MediaQuery.of(context).size.height * 0.5,
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Handle bar
//             Center(
//               child: Container(
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade300,
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
            
//             // Title
//             Text(
//               'Report Preview',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey.shade800,
//               ),
//             ),
//             const SizedBox(height: 20),
            
//             // Details
//             _buildDetailRow('Report ID', report.id),
//             _buildDetailRow('District', report.district),
//             _buildDetailRow('Status', report.statusDisplayName, 
//               statusColor: _getStatusColor(report)),
//             _buildDetailRow('Reported by', report.userTypeDisplayName),
//             _buildDetailRow('Coordinates', 
//               '${report.latitude.toStringAsFixed(4)}, ${report.longitude.toStringAsFixed(4)}'),
            
//             const Spacer(),
            
//             // Action buttons
//             Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       Navigator.pop(context); // Close modal
//                       _navigateToReportDetails(report); // Open detailed screen
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                     ),
//                     child: const Text('View Details'),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () => _centerMapOnReport(report),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.green,
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                     ),
//                     child: const Text('Center on Map'),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: OutlinedButton(
//                     onPressed: () => Navigator.pop(context),
//                     style: OutlinedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                     ),
//                     child: const Text('Close'),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value, {Color? statusColor}) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 5),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 100,
//             child: Text(
//               label,
//               style: TextStyle(
//                 fontWeight: FontWeight.w500,
//                 color: Colors.grey.shade600,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: TextStyle(
//                 fontWeight: FontWeight.w600,
//                 color: statusColor ?? Colors.grey.shade800,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Color _getStatusColor(LandslideReport report) {
//     if (report.isApproved) return Colors.green;
//     if (report.isRejected) return Colors.red;
//     if (report.isPending) return Colors.orange;
//     return Colors.grey;
//   }

//   void _centerMapOnReport(LandslideReport report) {
//     Navigator.pop(context); // Close bottom sheet if open
    
//     if (_mapController != null) {
//       _mapController!.animateCamera(
//         CameraUpdate.newCameraPosition(
//           CameraPosition(
//             target: LatLng(report.latitude, report.longitude),
//             zoom: 15,
//           ),
//         ),
//       );
//     }
//   }

//   void _filterReports(String filter) {
//     setState(() {
//       _selectedFilter = filter;
      
//       switch (filter) {
//         case 'All':
//           _filteredReports = _allReports;
//           break;
//         case 'Approved':
//           _filteredReports = LandslideReportsService.filterByStatus(_allReports, 'approved');
//           break;
//         case 'Rejected':
//           _filteredReports = LandslideReportsService.filterByStatus(_allReports, 'rejected');
//           break;
//         case 'Pending':
//           _filteredReports = LandslideReportsService.filterByStatus(_allReports, 'pending');
//           break;
//         case 'Geo-Scientist':
//           _filteredReports = LandslideReportsService.filterByUserType(_allReports, 'geo-scientist');
//           break;
//         case 'Public':
//           _filteredReports = LandslideReportsService.filterByUserType(_allReports, 'public');
//           break;
//       }
//     });
    
//     _createMarkers();
//   }

//   void _showErrorSnackBar(String message) {
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(message),
//           backgroundColor: Colors.red,
//           action: SnackBarAction(
//             label: 'Retry',
//             textColor: Colors.white,
//             onPressed: _fetchReports,
//           ),
//         ),
//       );
//     }
//   }

//   void _zoomIn() {
//     if (_mapController != null) {
//       _mapController!.animateCamera(CameraUpdate.zoomIn());
//     }
//   }

//   void _zoomOut() {
//     if (_mapController != null) {
//       _mapController!.animateCamera(CameraUpdate.zoomOut());
//     }
//   }

//   void _resetToIndiaView() {
//     if (_mapController != null) {
//       _mapController!.animateCamera(
//         CameraUpdate.newCameraPosition(
//           const CameraPosition(
//             target: _indiaCenter,
//             zoom: _indiaZoom,
//             bearing: 0,
//           ),
//         ),
//       );
//     }
//   }

//   void _showMapTypeDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Select Map Type'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               _mapTypeOption('Normal', MapType.normal),
//               _mapTypeOption('Satellite', MapType.satellite),
//               _mapTypeOption('Terrain', MapType.terrain),
//               _mapTypeOption('Hybrid', MapType.hybrid),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _mapTypeOption(String title, MapType mapType) {
//     return ListTile(
//       title: Text(title),
//       leading: _currentMapType == mapType 
//           ? const Icon(Icons.check, color: Colors.blue)
//           : const SizedBox(width: 24),
//       onTap: () {
//         setState(() {
//           _currentMapType = mapType;
//         });
//         Navigator.pop(context);
//       },
//     );
//   }

//   void _showFilterDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         final stats = LandslideReportsService.getStatistics(_allReports);
        
//         return AlertDialog(
//           title: const Text('Filter Reports'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               _filterOption('All', 'All Reports (${stats['total']})'),
//               const Divider(),
//               _filterOption('Approved', 'Approved (${stats['approved']})', 
//                 color: Colors.green),
//               _filterOption('Rejected', 'Rejected (${stats['rejected']})', 
//                 color: Colors.red),
//               _filterOption('Pending', 'Pending (${stats['pending']})', 
//                 color: Colors.orange),
//               const Divider(),
//               _filterOption('Geo-Scientist', 'Geo-Scientists (${stats['geoScientist']})'),
//               _filterOption('Public', 'Public Reports (${stats['public']})'),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _filterOption(String value, String title, {Color? color}) {
//     return ListTile(
//       title: Text(
//         title,
//         style: TextStyle(color: color),
//       ),
//       leading: _selectedFilter == value 
//           ? Icon(Icons.check, color: color ?? Colors.blue)
//           : const SizedBox(width: 24),
//       onTap: () {
//         _filterReports(value);
//         Navigator.pop(context);
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//         title: const Text('All Reports'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.filter_list),
//             onPressed: _showFilterDialog,
//           ),
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: _fetchReports,
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? const Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(),
//                   SizedBox(height: 16),
//                   Text('Loading reports...'),
//                 ],
//               ),
//             )
//           : Stack(
//               children: [
//                 // Google Map
//                 GoogleMap(
//                   initialCameraPosition: const CameraPosition(
//                     target: _indiaCenter,
//                     zoom: _indiaZoom,
//                   ),
//                   mapType: _currentMapType,
//                   markers: _markers,
//                   myLocationEnabled: false,
//                   myLocationButtonEnabled: false,
//                   compassEnabled: false,
//                   zoomControlsEnabled: false,
//                   onMapCreated: (GoogleMapController controller) {
//                     setState(() {
//                       _mapController = controller;
//                     });
//                   },
//                 ),
                
//                 // Compass
//                 Positioned(
//                   top: 20,
//                   left: 20,
//                   child: Container(
//                     width: 60,
//                     height: 60,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.white.withOpacity(0.9),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.2),
//                           blurRadius: 4,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Transform.rotate(
//                       angle: ((_compassHeading ?? 0) * (pi / 180) * -1),
//                       child: const Icon(
//                         Icons.navigation,
//                         size: 30,
//                         color: Colors.blue,
//                       ),
//                     ),
//                   ),
//                 ),
                
//                 // Filter badge
//                 Positioned(
//                   top: 20,
//                   right: 80,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: Colors.blue,
//                       borderRadius: BorderRadius.circular(16),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.2),
//                           blurRadius: 4,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Text(
//                       '$_selectedFilter (${_filteredReports.length})',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 ),
                
//                 // Control buttons
//                 Positioned(
//                   right: 15,
//                   top: 150,
//                   child: Column(
//                     children: [
//                       _mapControlButton(
//                         icon: Icons.add,
//                         onPressed: _zoomIn,
//                       ),
//                       const SizedBox(height: 10),
//                       _mapControlButton(
//                         icon: Icons.remove,
//                         onPressed: _zoomOut,
//                       ),
//                       const SizedBox(height: 10),
//                       _mapControlButton(
//                         icon: Icons.layers,
//                         onPressed: _showMapTypeDialog,
//                       ),
//                       const SizedBox(height: 10),
//                       _mapControlButton(
//                         icon: Icons.home,
//                         onPressed: _resetToIndiaView,
//                       ),
//                       const SizedBox(height: 10),
//                       _mapControlButton(
//                         icon: Icons.filter_list,
//                         onPressed: _showFilterDialog,
//                       ),
//                     ],
//                   ),
//                 ),
                
//                 // Legend
//                 Positioned(
//                   bottom: 20,
//                   left: 20,
//                   child: Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.9),
//                       borderRadius: BorderRadius.circular(8),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.2),
//                           blurRadius: 4,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           'Legend',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 12,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         _legendItem(Colors.green, 'Approved'),
//                         _legendItem(Colors.red, 'Rejected'),
//                         _legendItem(Colors.orange, 'Pending'),
//                       ],
//                     ),
//                   ),
//                 ),

//                 // Instruction overlay (shows for first 3 seconds)
//                 // if (_allReports.isNotEmpty)
//                 //   Positioned(
//                 //     top: 100,
//                 //     left: 20,
//                 //     right: 20,
//                 //     child: Container(
//                 //       padding: const EdgeInsets.all(12),
//                 //       decoration: BoxDecoration(
//                 //         color: Colors.blue.shade700.withOpacity(0.9),
//                 //         borderRadius: BorderRadius.circular(8),
//                 //         boxShadow: [
//                 //           BoxShadow(
//                 //             color: Colors.black.withOpacity(0.2),
//                 //             blurRadius: 4,
//                 //             offset: const Offset(0, 2),
//                 //           ),
//                 //         ],
//                 //       ),
//                 //       child: Row(
//                 //         children: [
//                 //           Icon(
//                 //             Icons.touch_app,
//                 //             color: Colors.white,
//                 //             size: 20,
//                 //           ),
//                 //           const SizedBox(width: 8),
//                 //           Expanded(
//                 //             child: Text(
//                 //               'Tap on any marker to view detailed report',
//                 //               style: TextStyle(
//                 //                 color: Colors.white,
//                 //                 fontSize: 12,
//                 //                 fontWeight: FontWeight.w500,
//                 //               ),
//                 //             ),
//                 //           ),
//                 //         ],
//                 //       ),
//                 //     ),
//                 //   ),
             
//               ],
//             ),
//     );
//   }

//   Widget _mapControlButton({
//     required IconData icon,
//     required VoidCallback onPressed,
//   }) {
//     return Container(
//       width: 50,
//       height: 50,
//       decoration: BoxDecoration(
//         color: Colors.blue,
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.2),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: IconButton(
//         icon: Icon(icon, color: Colors.white),
//         onPressed: onPressed,
//       ),
//     );
//   }

//   Widget _legendItem(Color color, String label) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 4),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 12,
//             height: 12,
//             decoration: BoxDecoration(
//               color: color,
//               shape: BoxShape.circle,
//             ),
//           ),
//           const SizedBox(width: 6),
//           Text(
//             label,
//             style: const TextStyle(fontSize: 10),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _mapController?.dispose();
//     super.dispose();
//   }
// }