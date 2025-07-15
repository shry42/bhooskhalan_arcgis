// import 'package:arcgis_map_sdk/arcgis_map_sdk.dart';
// import 'package:bhooskhalan/landslide/report_form.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';

// class ArcGisMapScreen extends StatefulWidget {
//   const ArcGisMapScreen({Key? key}) : super(key: key);

//   @override
//   State<ArcGisMapScreen> createState() => _ArcGisMapScreenState();
// }

// class _ArcGisMapScreenState extends State<ArcGisMapScreen> {
//   ArcgisMapController? _mapController;
//   Position? _currentPosition;
//   bool _isLoading = true;
  
//   // Use a GlobalKey to access the map's position in the widget tree
//   final GlobalKey _mapKey = GlobalKey();

//   @override
//   void initState() {
//     super.initState();
//     _fetchLocation();
//   }

//   Future<void> _fetchLocation() async {
//     print("Fetching location...");
//     final serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       setState(() => _isLoading = false);
//       return;
//     }

//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         setState(() => _isLoading = false);
//         return;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       setState(() => _isLoading = false);
//       return;
//     }

//     try {
//       final position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//       print("Position obtained: ${position.latitude}, ${position.longitude}");
//       setState(() {
//         _currentPosition = position;
//         _isLoading = false;
//       });
//     } catch (e) {
//       print("Error getting position: $e");
//       // Fallback to Mumbai location
//       setState(() {
//         _currentPosition = Position(
//           latitude: 19.0760,
//           longitude: 72.8777,
//           timestamp: DateTime.now(),
//           accuracy: 0,
//           altitude: 0,
//           altitudeAccuracy: 0,
//           heading: 0,
//           headingAccuracy: 0,
//           speed: 0,
//           speedAccuracy: 0,
//           floor: 0,
//           isMocked: true,
//         );
//         _isLoading = false;
//       });
//       print("Using Mumbai location as fallback");
//     }
//   }

//   void _centerMapOnLocation() {
//     if (_mapController != null && _currentPosition != null) {
//       _mapController!.moveCamera(
//         point: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
//         zoomLevel: 15,
//       );
//     }
//   }

//   void _zoomIn() {
//     if (_mapController != null) {
//       _mapController!.zoomIn(lodFactor: 5);
//     }
//   }

//   void _zoomOut() {
//     if (_mapController != null) {
//       _mapController!.zoomOut(lodFactor: 5);
//     }
//   }

//   void _resetMapRotation() {
//     if (_mapController != null) {
//       // _mapController!.resetRotation();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//         title: const Text('Location'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : _currentPosition == null
//               ? const Center(child: Text('Unable to fetch location'))
//               : Stack(
//                   children: [
//                     // The ArcGIS Map
//                     ArcgisMap(
//                       key: _mapKey,
//                       apiKey: 'AAPTxy8BH1VEsoebNVZXo8HurOqj9vsaKKHwafyQtKINWeMtuT47-o9HvNNf0Sr4AXK_Z0nEuHmGLq10e9tfRST8lnfLYMly3rmIc8gjRoWsPC7dgkz4jal4xcz_-LE_msCKrG6d_ACX174bDQ4WdKS9pEaUrHZrz3vGXsQUZWKmo6jlbAuW2MedeMPN1X14mcEOixZ5CCpZ8k3hm3NCQACNMPnCyMtfJXXCAy0S8_GWjGA.AT1_6zX0ZMIw',
//                       initialCenter: LatLng(
//                         _currentPosition!.latitude, 
//                         _currentPosition!.longitude
//                       ),
//                       zoom: 15,
//                       mapStyle: MapStyle.twoD,
//                       basemap: BaseMap.arcgisNavigation,
//                       onMapCreated: (controller) {
//                         print("Map controller created");
//                         setState(() {
//                           _mapController = controller;
//                         });
                        
//                         // Center the map on the current location
//                         Future.delayed(const Duration(milliseconds: 1000), () {
//                           _centerMapOnLocation();
//                         });
//                       },
//                     ),
                    
//                     // Compass in the top-left corner
//                     Positioned(
//                       top: 20,
//                       left: 20,
//                       child: Container(
//                         width: 60,
//                         height: 60,
//                         decoration: const BoxDecoration(
//                           image: DecorationImage(
//                             image: AssetImage('assets/compass.png'),
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                     ),
                    
//                     // Control buttons on the right side
//                     Positioned(
//                       right: 15,
//                       top: 150,
//                       child: Column(
//                         children: [
//                           // Zoom in button
//                           _mapControlButton(
//                             icon: Icons.add,
//                             onPressed: _zoomIn,
//                           ),
//                           const SizedBox(height: 10),
                          
//                           // Zoom out button
//                           _mapControlButton(
//                             icon: Icons.remove,
//                             onPressed: _zoomOut,
//                           ),
//                           const SizedBox(height: 10),
                          
//                           // Map layers button
//                           _mapControlButton(
//                             icon: Icons.layers,
//                             onPressed: () {
//                               // Implementation for map layers
//                             },
//                           ),
//                           const SizedBox(height: 10),
                          
//                           // Home button
//                           _mapControlButton(
//                             icon: Icons.home,
//                             onPressed: _centerMapOnLocation,
//                           ),
//                           const SizedBox(height: 10),
                          
//                           // Compass button
//                           _mapControlButton(
//                             icon: Icons.navigation,
//                             onPressed: _resetMapRotation,
//                           ),
//                         ],
//                       ),
//                     ),
                    
//                     // Blue location marker (centered pin)
//                     Positioned.fill(
//                       child: Center(
//                         child: Container(
//                           width: 30,
//                           height: 30,
//                           decoration: BoxDecoration(
//                             color: Colors.blue.shade700,
//                             shape: BoxShape.circle,
//                             border: Border.all(
//                               color: Colors.white,
//                               width: 3,
//                             ),
//                           ),
//                           child: const Center(
//                             child: Icon(
//                               Icons.circle,
//                               color: Colors.white,
//                               size: 12,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//       bottomNavigationBar: Container(
//         height: 80,
//         color: Colors.grey.shade900,
//         child: Center(
//           child: TextButton(
//             onPressed: () {
//               // Implementation for reporting landslide
//               Get.to(()=>LandslideReportingScreen());
//             },
//             style: TextButton.styleFrom(
//               backgroundColor: Colors.blue,
//               foregroundColor: Colors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(5),
//               ),
//               padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//               textStyle: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             child: const Text('REPORT LANDSLIDE'),
//           ),
//         ),
//       ),
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
//       ),
//       child: IconButton(
//         icon: Icon(icon, color: Colors.white),
//         onPressed: onPressed,
//       ),
//     );
//   }
// }