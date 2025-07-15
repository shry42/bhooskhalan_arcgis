// import 'package:arcgis_map_sdk/arcgis_map_sdk.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';

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

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Location Map'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: _fetchLocation,
//           ),
//         ],
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
                    
//                     // Custom Location Marker (centered in the map)
//                     Positioned.fill(
//                       child: Center(
//                         child: Container(
//                           width: 20,
//                           height: 20,
//                           decoration: BoxDecoration(
//                             color: Colors.red,
//                             shape: BoxShape.circle,
//                             border: Border.all(
//                               color: Colors.white,
//                               width: 3,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _centerMapOnLocation,
//         child: const Icon(Icons.my_location),
//       ),
//     );
//   }
// }