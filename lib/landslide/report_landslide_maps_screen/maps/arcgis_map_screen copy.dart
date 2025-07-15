// import 'package:arcgis_maps/arcgis_maps.dart';
// import 'package:bhooskhalann/landslide/report_landslide_maps_screen/report_form_getx/draft_report_section/draft_report_form.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class ArcGisLocationMapScreen extends StatefulWidget {
//   const ArcGisLocationMapScreen({super.key});

//   @override
//   State<ArcGisLocationMapScreen> createState() => _ArcGisLocationMapScreenState();
// }

// class _ArcGisLocationMapScreenState extends State<ArcGisLocationMapScreen> {
//   // Create a controller for the map view
//   final _mapViewController = ArcGISMapView.createController();
  
//   // Create a map with a basemap style
//   final _map = ArcGISMap.withBasemapStyle(BasemapStyle.arcGISStreets);
  
//   // Create a graphics overlay for displaying landslide location marker
//   final _graphicsOverlay = GraphicsOverlay();
  
//   // Location display for showing current location
//   late LocationDisplay _locationDisplay;
  
//   // Flag to track if the map is ready
//   var _ready = false;
  
//   // Landslide location selection
//   ArcGISPoint? _selectedLandslideLocation;
//   bool _isSelectingLocation = false;
  
//   // Text controllers for coordinate input
//   late TextEditingController _latController;
//   late TextEditingController _longController;

//   @override
//   void initState() {
//     super.initState();
//     _latController = TextEditingController();
//     _longController = TextEditingController();
//     _initializeArcGIS();
//   }

//   void _initializeArcGIS() {
//     // Set the API key
//     ArcGISEnvironment.apiKey = 'AAPTxy8BH1VEsoebNVZXo8HurOqj9vsaKKHwafyQtKINWeMtuT47-o9HvNNf0Sr4AXK_Z0nEuHmGLq10e9tfRST8lnfLYMly3rmIc8gjRoWsPC7dgkz4jal4xcz_-LE_msCKrG6d_ACX174bDQ4WdKS9pEaUrHZrz3vGXsQUZWKmo6jlbAuW2MedeMPN1X14mcEOixZ5CCpZ8k3hm3NCQACNMPnCyMtfJXXCAy0S8_GWjGA.AT1_6zX0ZMIw';
    
//     // Set license string to remove watermark
//     ArcGISEnvironment.setLicenseUsingKey(
//       'runtimelite,1000,rud2840189929,none,HC5X0H4AH76HF5KHT190',
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//         title: const Text('Location'),
//         elevation: 0,
//       ),
//       body: Stack(
//         children: [
//           // Map view
//           ArcGISMapView(
//             controllerProvider: () => _mapViewController,
//             onMapViewReady: _onMapViewReady,
//             onTap: _onMapTap,
//           ),
          
//           // Right side navigation toolbar
//           Positioned(
//             top: 16,
//             right: 16,
//             child: Column(
//               children: [
//                 // Zoom In button
//                 Container(
//                   margin: const EdgeInsets.only(bottom: 2),
//                   child: FloatingActionButton(
//                     heroTag: "zoom_in",
//                     mini: true,
//                     backgroundColor: Colors.blue,
//                     onPressed: _ready ? _zoomIn : null,
//                     child: const Icon(Icons.add, color: Colors.white),
//                   ),
//                 ),
                
//                 // Zoom Out button
//                 Container(
//                   margin: const EdgeInsets.only(bottom: 8),
//                   child: FloatingActionButton(
//                     heroTag: "zoom_out",
//                     mini: true,
//                     backgroundColor: Colors.blue,
//                     onPressed: _ready ? _zoomOut : null,
//                     child: const Icon(Icons.remove, color: Colors.white),
//                   ),
//                 ),
                
//                 // Map layers button (show selection dialog)
//                 Container(
//                   margin: const EdgeInsets.only(bottom: 2),
//                   child: FloatingActionButton(
//                     heroTag: "layers",
//                     mini: true,
//                     backgroundColor: Colors.blue,
//                     onPressed: _ready ? _showMapTypeDialog : null,
//                     child: const Icon(Icons.layers, color: Colors.white),
//                   ),
//                 ),
                
//                 // Home/Center button (re-center to current location)
//                 Container(
//                   margin: const EdgeInsets.only(bottom: 2),
//                   child: FloatingActionButton(
//                     heroTag: "home",
//                     mini: true,
//                     backgroundColor: Colors.blue,
//                     onPressed: _ready ? _zoomToCurrentLocation : null,
//                     child: const Icon(Icons.home, color: Colors.white),
//                   ),
//                 ),
                
//                 // My Location button (relocate/recenter to current location)
//                 Container(
//                   margin: const EdgeInsets.only(bottom: 2),
//                   child: FloatingActionButton(
//                     heroTag: "location",
//                     mini: true,
//                     backgroundColor: Colors.blue,
//                     onPressed: _ready ? _zoomToCurrentLocation : null,
//                     child: const Icon(
//                       Icons.my_location,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
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

//   Future<void> _onMapViewReady() async {
//     try {
//       // Configure the graphics overlay for landslide location marker
//       _graphicsOverlay.renderer = SimpleRenderer(
//         symbol: SimpleMarkerSymbol(
//           style: SimpleMarkerSymbolStyle.circle,
//           color: Colors.red,
//           size: 15,
//         ),
//       );

//       // Add the graphics overlay to the map view
//       _mapViewController.graphicsOverlays.add(_graphicsOverlay);

//       // Assign the map to the map view controller
//       _mapViewController.arcGISMap = _map;

//       // Set up location display AFTER map is assigned
//       _locationDisplay = _mapViewController.locationDisplay;
      
//       // Configure location display properties
//       _locationDisplay.autoPanMode = LocationDisplayAutoPanMode.recenter;
//       _locationDisplay.initialZoomScale = 10000;

//       // Create and configure a system location data source
//       final locationDataSource = SystemLocationDataSource();
//       _locationDisplay.dataSource = locationDataSource;

//       // Set an initial viewpoint (will be overridden when location is found)
//       _mapViewController.setViewpoint(
//         Viewpoint.fromCenter(
//           ArcGISPoint(x: 72.8777, y: 19.0760, spatialReference: SpatialReference.wgs84), // Mumbai coordinates
//           scale: 100000,
//         ),
//       );

//       // Enable the UI
//       setState(() => _ready = true);
      
//       // Automatically start location services to show current location
//       await _startLocationAutomatically();
      
//     } catch (e) {
//       _showError('Failed to initialize map: $e');
//     }
//   }

//   // Handle map tap for landslide location selection
//   void _onMapTap(Offset screenPoint) {
//     if (_isSelectingLocation) {
//       try {
//         final mapPoint = _mapViewController.screenToLocation(screen: screenPoint);
//         if (mapPoint != null) {
//           setState(() {
//             _selectedLandslideLocation = mapPoint;
//           });
//           _updateLandslideLocationMarker();
//           _updateCoordinateFields();
//         }
//       } catch (e) {
//         _showError('Failed to get map coordinates: $e');
//       }
//     }
//   }

//   // Update landslide location marker on map
//   void _updateLandslideLocationMarker() {
//     _graphicsOverlay.graphics.clear();
    
//     if (_selectedLandslideLocation != null) {
//       final graphic = Graphic(
//         geometry: _selectedLandslideLocation!,
//         symbol: SimpleMarkerSymbol(
//           style: SimpleMarkerSymbolStyle.circle,
//           color: Colors.red,
//           size: 15,
//         ),
//       );
//       _graphicsOverlay.graphics.add(graphic);
//     }
//   }

//   // Update coordinate input fields
//   void _updateCoordinateFields() {
//     final location = _locationDisplay.location;
//     final lat = _selectedLandslideLocation?.y ?? location?.position?.y ?? 0.0;
//     final long = _selectedLandslideLocation?.x ?? location?.position?.x ?? 0.0;
    
//     _latController.text = lat.toStringAsFixed(7);
//     _longController.text = long.toStringAsFixed(7);
//   }

//   // Handle coordinate input changes
//   void _onCoordinateChanged() {
//     final lat = double.tryParse(_latController.text);
//     final long = double.tryParse(_longController.text);
    
//     if (lat != null && long != null && lat >= -90 && lat <= 90 && long >= -180 && long <= 180) {
//       setState(() {
//         _selectedLandslideLocation = ArcGISPoint(
//           x: long, 
//           y: lat, 
//           spatialReference: SpatialReference.wgs84,
//         );
//       });
//       _updateLandslideLocationMarker();
      
//       // Move map to new location
//       _mapViewController.setViewpointCenter(
//         _selectedLandslideLocation!,
//         scale: 10000,
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

//     // Get current location from location display
//     final currentLocation = _locationDisplay.location?.position;
    
//     // Use selected location or current location
//     final reportLat = _selectedLandslideLocation?.y ?? currentLocation?.y ?? 19.0760;
//     final reportLong = _selectedLandslideLocation?.x ?? currentLocation?.x ?? 72.8777;

//     // Navigate to report form with coordinates
//     Get.to(() => LandslideReportingScreen(
//       latitude: reportLat,
//       longitude: reportLong,
//     ));
//   }

//   // Automatically start location services when map is ready
//   Future<void> _startLocationAutomatically() async {
//     try {
//       _locationDisplay.start();
//       _showError('Current location loaded');
//     } catch (e) {
//       _showError('Failed to get current location: $e');
//     }
//   }

//   Future<void> _zoomToCurrentLocation() async {
//     try {
//       // Ensure location display is running
//       if (!_locationDisplay.started) {
//         _locationDisplay.start();
//       }
      
//       final location = _locationDisplay.location;
//       if (location?.position != null) {
//         await _mapViewController.setViewpointCenter(
//           location!.position!,
//           scale: 10000,
//         );
//         _showError('Recentered to current location');
//       } else {
//         // If location is not immediately available, wait a moment and try again
//         await Future.delayed(const Duration(milliseconds: 1000));
//         final updatedLocation = _locationDisplay.location;
//         if (updatedLocation?.position != null) {
//           await _mapViewController.setViewpointCenter(
//             updatedLocation!.position!,
//             scale: 10000,
//           );
//           _showError('Recentered to current location');
//         } else {
//           _showError('Current location not available');
//         }
//       }
//     } catch (e) {
//       _showError('Failed to recenter to location: $e');
//     }
//   }

//   void _showError(String message) {
//     if (mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(message),
//           backgroundColor: message.contains('Failed') || message.contains('not available') 
//               ? Colors.red 
//               : Colors.green,
//           duration: const Duration(seconds: 2),
//         ),
//       );
//     }
//   }

//   // Zoom In functionality
//   Future<void> _zoomIn() async {
//     try {
//       final currentViewpoint = _mapViewController.getCurrentViewpoint(ViewpointType.centerAndScale);
//       if (currentViewpoint != null) {
//         final newScale = currentViewpoint.targetScale / 2; // Zoom in by factor of 2
//         _mapViewController.setViewpoint(
//           Viewpoint.fromCenter(currentViewpoint.targetGeometry as ArcGISPoint, scale: newScale),
//         );
//       }
//     } catch (e) {
//       _showError('Failed to zoom in: $e');
//     }
//   }

//   // Zoom Out functionality
//   Future<void> _zoomOut() async {
//     try {
//       final currentViewpoint = _mapViewController.getCurrentViewpoint(ViewpointType.centerAndScale);
//       if (currentViewpoint != null) {
//         final newScale = currentViewpoint.targetScale * 2; // Zoom out by factor of 2
//         _mapViewController.setViewpoint(
//           Viewpoint.fromCenter(currentViewpoint.targetGeometry as ArcGISPoint, scale: newScale),
//         );
//       }
//     } catch (e) {
//       _showError('Failed to zoom out: $e');
//     }
//   }

//   // Show map type selection dialog
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
//                 leading: const Icon(Icons.map),
//                 title: const Text('Street Map'),
//                 subtitle: const Text('Detailed street view'),
//                 onTap: () {
//                   Navigator.of(context).pop();
//                   _setMapType(BasemapStyle.arcGISStreets, 'Street Map');
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.satellite),
//                 title: const Text('Satellite'),
//                 subtitle: const Text('Aerial imagery view'),
//                 onTap: () {
//                   Navigator.of(context).pop();
//                   _setMapType(BasemapStyle.arcGISImageryStandard, 'Satellite');
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.terrain),
//                 title: const Text('Topographic'),
//                 subtitle: const Text('Terrain and elevation'),
//                 onTap: () {
//                   Navigator.of(context).pop();
//                   _setMapType(BasemapStyle.arcGISTopographic, 'Topographic');
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   // Set specific map type
//   void _setMapType(BasemapStyle basemapStyle, String typeName) {
//     try {
//       _map.basemap = Basemap.withStyle(basemapStyle);
//       _showError('Switched to $typeName view');
//     } catch (e) {
//       _showError('Failed to change map type: $e');
//     }
//   }

//   @override
//   void dispose() {
//     _latController.dispose();
//     _longController.dispose();
//     super.dispose();
//   }
// }

