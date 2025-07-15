// // import 'package:bhooskhalann/landslide/report_landslide_g_maps_screen/report_form.dart';
// import 'package:bhooskhalann/landslide/report_landslide_maps_screen/report_form_getx/report_form_screen.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:flutter_compass/flutter_compass.dart';
// import 'dart:math';
// import 'dart:async';

// class GoogleMapScreen extends StatefulWidget {
//   const GoogleMapScreen({Key? key}) : super(key: key);

//   @override
//   State<GoogleMapScreen> createState() => _GoogleMapScreenState();
// }

// class _GoogleMapScreenState extends State<GoogleMapScreen> {
//   GoogleMapController? _mapController;
//   Position? _currentPosition;
//   bool _isLoading = true;
//   Set<Marker> _markers = {};
//   MapType _currentMapType = MapType.normal;
//   double _compassHeading = 0.0;
//   StreamSubscription<CompassEvent>? _compassSubscription;
  
//   // Landslide location selection
//   LatLng? _selectedLandslideLocation;
//   bool _isSelectingLocation = false;
  
//   // Text controllers for coordinate input
//   late TextEditingController _latController;
//   late TextEditingController _longController;
  
//   // Use a GlobalKey to access the map's position in the widget tree
//   final GlobalKey _mapKey = GlobalKey();

//   @override
//   void initState() {
//     super.initState();
//     _latController = TextEditingController();
//     _longController = TextEditingController();
//     _fetchLocation();
//     _initCompass();
//   }

//   void _initCompass() {
//     _compassSubscription = FlutterCompass.events?.listen((CompassEvent event) {
//       if (mounted) {
//         setState(() {
//           _compassHeading = event.heading ?? 0.0;
//         });
//       }
//     });
//   }

//   Future<void> _fetchLocation() async {
//     print("Fetching location...");
//     final serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//       return;
//     }

//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         if (mounted) {
//           setState(() => _isLoading = false);
//         }
//         return;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//       return;
//     }

//     try {
//       final position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//       print("Position obtained: ${position.latitude}, ${position.longitude}");
//       if (mounted) {
//         setState(() {
//           _currentPosition = position;
//           _isLoading = false;
//         });
//         _updateLocationMarker();
//         _updateCoordinateFields();
//       }
//     } catch (e) {
//       print("Error getting position: $e");
//       // Fallback to Mumbai location
//       if (mounted) {
//         setState(() {
//           _currentPosition = Position(
//             latitude: 19.0760,
//             longitude: 72.8777,
//             timestamp: DateTime.now(),
//             accuracy: 0,
//             altitude: 0,
//             altitudeAccuracy: 0,
//             heading: 0,
//             headingAccuracy: 0,
//             speed: 0,
//             speedAccuracy: 0,
//             floor: 0,
//             isMocked: true,
//           );
//           _isLoading = false;
//         });
//         _updateLocationMarker();
//         _updateCoordinateFields();
//         print("Using Mumbai location as fallback");
//       }
//     }
//   }

//   void _updateLocationMarker() {
//     if (_currentPosition != null && mounted) {
//       setState(() {
//         _markers = {
//           Marker(
//             markerId: const MarkerId('current_location'),
//             position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
//             icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//             infoWindow: const InfoWindow(title: 'Your Location'),
//           ),
//           // Add landslide location marker if selected
//           if (_selectedLandslideLocation != null)
//             Marker(
//               markerId: const MarkerId('landslide_location'),
//               position: _selectedLandslideLocation!,
//               icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//               infoWindow: const InfoWindow(title: 'Landslide Location'),
//             ),
//         };
//       });
//     }
//   }

//   void _updateCoordinateFields() {
//     final lat = _selectedLandslideLocation?.latitude ?? _currentPosition?.latitude ?? 0.0;
//     final long = _selectedLandslideLocation?.longitude ?? _currentPosition?.longitude ?? 0.0;
    
//     _latController.text = lat.toStringAsFixed(7);
//     _longController.text = long.toStringAsFixed(7);
//   }

//   void _onCoordinateChanged() {
//     final lat = double.tryParse(_latController.text);
//     final long = double.tryParse(_longController.text);
    
//     if (lat != null && long != null && lat >= -90 && lat <= 90 && long >= -180 && long <= 180) {
//       setState(() {
//         _selectedLandslideLocation = LatLng(lat, long);
//       });
//       _updateLocationMarker();
      
//       // Move map to new location
//       if (_mapController != null) {
//         _mapController!.animateCamera(
//           CameraUpdate.newLatLng(LatLng(lat, long)),
//         );
//       }
//     }
//   }

//   void _onMapTap(LatLng position) {
//     if (_isSelectingLocation) {
//       setState(() {
//         _selectedLandslideLocation = position;
//       });
//       _updateLocationMarker();
//       _updateCoordinateFields();
//     }
//   }

//   void _centerMapOnLocation() {
//     if (_mapController != null && _currentPosition != null) {
//       _mapController!.animateCamera(
//         CameraUpdate.newCameraPosition(
//           CameraPosition(
//             target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
//             zoom: 15,
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

//   void _resetMapRotation() {
//     if (_mapController != null && _currentPosition != null) {
//       _mapController!.animateCamera(
//         CameraUpdate.newCameraPosition(
//           CameraPosition(
//             target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
//             zoom: 15,
//             bearing: 0, // Reset rotation
//           ),
//         ),
//       );
//     }
//   }

//   // Start the landslide reporting flow
//   void _startLandslideReporting() {
//     _showLocationInfoDialog();
//   }

//   // Step 1: Location Info Dialog
//   void _showLocationInfoDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text(
//             'Location',
//             style: TextStyle(
//               color: Colors.red,
//               fontWeight: FontWeight.bold,
//               fontSize: 20,
//             ),
//           ),
//           content: const Text(
//             'If the landslide location is not your current location (for example, landslide occurring on the other side of the slope, above or below the road or across the valley), tap on the map to choose the correct location. A new red colour location symbol will appear.',
//             style: TextStyle(fontSize: 16),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _showAttentionDialog();
//               },
//               style: TextButton.styleFrom(
//                 backgroundColor: Colors.blue,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               ),
//               child: const Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // Step 2: Attention Dialog
//   void _showAttentionDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text(
//             'ATTENTION !',
//             style: TextStyle(
//               color: Colors.red,
//               fontWeight: FontWeight.bold,
//               fontSize: 20,
//             ),
//           ),
//           content: RichText(
//             text: const TextSpan(
//               style: TextStyle(fontSize: 16, color: Colors.black),
//               children: [
//                 TextSpan(text: 'Are you certain this is the correct landslide location?\n\nPlease '),
//                 TextSpan(
//                   text: 'click on the map to select correct location if needed.',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 TextSpan(text: 'Your accurate input is crucial for precise reporting. Thank you!'),
//               ],
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 // Don't set _isSelectingLocation here - wait for susceptibility dialog
//               },
//               style: TextButton.styleFrom(
//                 foregroundColor: Colors.blue,
//               ),
//               child: const Text('BACK'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 _showSusceptibilityDialog();
//               },
//               style: TextButton.styleFrom(
//                 backgroundColor: Colors.blue,
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               ),
//               child: const Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // Step 3: Susceptibility Dialog
//   void _showSusceptibilityDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text(
//             'Message',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 18,
//             ),
//           ),
//           content: const Text(
//             'Would you like to explore the susceptibility conditions in your surroundings?',
//             style: TextStyle(fontSize: 16),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 // User clicked NO - stay on map and enable location selection
//                 _enableLocationSelection();
//               },
//               style: TextButton.styleFrom(
//                 foregroundColor: Colors.red,
//               ),
//               child: const Text('NO'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 // User clicked YES - stay on map and enable location selection
//                 // You can add susceptibility exploration functionality here later
//                 _enableLocationSelection();
//               },
//               style: TextButton.styleFrom(
//                 foregroundColor: Colors.red,
//               ),
//               child: const Text('YES'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // Enable location selection and show instruction toast
//   void _enableLocationSelection() {
//     setState(() {
//       _isSelectingLocation = true;
//     });
    
//     // Initialize coordinate fields with current location
//     _updateCoordinateFields();
    
//     // Show instruction toast that disappears after 1 second
//     ScaffoldMessenger.of(context).clearSnackBars();
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: const Text(
//           'Tap anywhere on the map to select landslide location',
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.orange.shade700,
//         behavior: SnackBarBehavior.floating,
//         duration: const Duration(seconds: 1),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         margin: const EdgeInsets.all(20),
//       ),
//     );
//   }

//   // Step 4: Proceed to Report Form
//   void _proceedToReportForm() {
//     setState(() {
//       _isSelectingLocation = false;
//     });

//     // Use selected location or current location
//     final LatLng reportLocation = _selectedLandslideLocation ?? 
//         LatLng(_currentPosition!.latitude, _currentPosition!.longitude);

//     // Navigate to report form with coordinates
//     Get.to(() => LandslideReportingScreen(
//       latitude: reportLocation.latitude,
//       longitude: reportLocation.longitude,
//     ));
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
//               ? const Center(child: Text('           Unable to fetch location\n please turn on location and try again'))
//               : Stack(
//                   children: [
//                     // The Google Map
//                     GoogleMap(
//                       key: _mapKey,
//                       initialCameraPosition: CameraPosition(
//                         target: LatLng(
//                           _currentPosition!.latitude, 
//                           _currentPosition!.longitude
//                         ),
//                         zoom: 15,
//                       ),
//                       mapType: _currentMapType,
//                       myLocationEnabled: true,
//                       myLocationButtonEnabled: false,
//                       compassEnabled: false,
//                       zoomControlsEnabled: false,
//                       markers: _markers,
//                       onTap: _onMapTap,
//                       onMapCreated: (GoogleMapController controller) {
//                         print("Map controller created");
//                         if (mounted) {
//                           setState(() {
//                             _mapController = controller;
//                           });
                          
//                           // Center the map on the current location
//                           Future.delayed(const Duration(milliseconds: 1000), () {
//                             _centerMapOnLocation();
//                           });
//                         }
//                       },
//                     ),
                    
//                     // Functional Compass in the top-left corner (restored original)
//                     Positioned(
//                       top: 20,
//                       left: 20,
//                       child: Container(
//                         width: 60,
//                         height: 60,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Colors.white.withOpacity(0.9),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.2),
//                               blurRadius: 4,
//                               offset: const Offset(0, 2),
//                             ),
//                           ],
//                         ),
//                         child: Transform.rotate(
//                           angle: ((_compassHeading ?? 0) * (pi / 180) * -1),
//                           child: Container(
//                             decoration: const BoxDecoration(
//                               image: DecorationImage(
//                                 image: AssetImage('assets/compass.png'),
//                                 fit: BoxFit.cover,
//                               ),
//                               shape: BoxShape.circle,
//                             ),
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
//                               _showMapTypeDialog();
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
//                   ],
//                 ),
//       bottomNavigationBar: Container(
//         height: 80,
//         color: Colors.grey.shade900,
//         child: _isSelectingLocation
//             ? // Show coordinate input boxes and tick button
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                 child: Row(
//                   children: [
//                     // Latitude input box
//                     Expanded(
//                       child: Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: Colors.blue.shade700,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Column(
//                           children: [
//                             const Text(
//                               'LAT',
//                               style: TextStyle(
//                                 color: Colors.white70,
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             TextField(
//                               controller: _latController,
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 14,
//                               ),
//                               textAlign: TextAlign.center,
//                               keyboardType: const TextInputType.numberWithOptions(decimal: true),
//                               decoration: const InputDecoration(
//                                 border: InputBorder.none,
//                                 contentPadding: EdgeInsets.zero,
//                                 isDense: true,
//                               ),
//                               onChanged: (value) => _onCoordinateChanged(),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     // Longitude input box
//                     Expanded(
//                       child: Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: Colors.blue.shade700,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Column(
//                           children: [
//                             const Text(
//                               'LONG',
//                               style: TextStyle(
//                                 color: Colors.white70,
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             TextField(
//                               controller: _longController,
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 14,
//                               ),
//                               textAlign: TextAlign.center,
//                               keyboardType: const TextInputType.numberWithOptions(decimal: true),
//                               decoration: const InputDecoration(
//                                 border: InputBorder.none,
//                                 contentPadding: EdgeInsets.zero,
//                                 isDense: true,
//                               ),
//                               onChanged: (value) => _onCoordinateChanged(),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     // Confirm button
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.green.shade600,
//                         borderRadius: BorderRadius.circular(8),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.2),
//                             blurRadius: 4,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: IconButton(
//                         onPressed: _proceedToReportForm,
//                         icon: const Icon(
//                           Icons.check,
//                           color: Colors.white,
//                           size: 24,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             : // Show REPORT LANDSLIDE button
//               Center(
//                 child: TextButton(
//                   onPressed: _startLandslideReporting,
//                   style: TextButton.styleFrom(
//                     backgroundColor: Colors.blue,
//                     foregroundColor: Colors.white,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                     padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
//                     textStyle: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   child: const Text('REPORT LANDSLIDE'),
//                 ),
//               ),
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

//   void _showMapTypeDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Select Map Type'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 title: const Text('Normal'),
//                 leading: _currentMapType == MapType.normal 
//                     ? const Icon(Icons.check, color: Colors.blue)
//                     : const SizedBox(width: 24),
//                 onTap: () {
//                   if (mounted) {
//                     setState(() {
//                       _currentMapType = MapType.normal;
//                     });
//                   }
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 title: const Text('Satellite'),
//                 leading: _currentMapType == MapType.satellite 
//                     ? const Icon(Icons.check, color: Colors.blue)
//                     : const SizedBox(width: 24),
//                 onTap: () {
//                   if (mounted) {
//                     setState(() {
//                       _currentMapType = MapType.satellite;
//                     });
//                   }
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 title: const Text('Terrain'),
//                 leading: _currentMapType == MapType.terrain 
//                     ? const Icon(Icons.check, color: Colors.blue)
//                     : const SizedBox(width: 24),
//                 onTap: () {
//                   if (mounted) {
//                     setState(() {
//                       _currentMapType = MapType.terrain;
//                     });
//                   }
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 title: const Text('Hybrid'),
//                 leading: _currentMapType == MapType.hybrid 
//                     ? const Icon(Icons.check, color: Colors.blue)
//                     : const SizedBox(width: 24),
//                 onTap: () {
//                   if (mounted) {
//                     setState(() {
//                       _currentMapType = MapType.hybrid;
//                     });
//                   }
//                   Navigator.pop(context);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _latController.dispose();
//     _longController.dispose();
//     _mapController?.dispose();
//     _compassSubscription?.cancel();
//     super.dispose();
//   }
// }