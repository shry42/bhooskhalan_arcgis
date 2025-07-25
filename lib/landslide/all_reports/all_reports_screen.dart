import 'package:bhooskhalann/landslide/all_reports/deatiled_reports/report_details_screen.dart';
import 'package:bhooskhalann/landslide/all_reports/landslide_report_model.dart';
import 'package:bhooskhalann/landslide/all_reports/landslide_reports_service.dart';
import 'package:flutter/material.dart';
import 'package:arcgis_maps/arcgis_maps.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'dart:math';
import 'dart:async';
import 'package:intl/intl.dart';

class AllReportsScreenArcGIS extends StatefulWidget {
  const AllReportsScreenArcGIS({Key? key}) : super(key: key);

  @override
  State<AllReportsScreenArcGIS> createState() => _AllReportsScreenArcGISState();
}

class _AllReportsScreenArcGISState extends State<AllReportsScreenArcGIS>
    implements ArcGISAuthenticationChallengeHandler {
  // Create a controller for the map view
  final _mapViewController = ArcGISMapView.createController();
  
  // Create a map with a basemap style
  late ArcGISMap _map;

   // Location display for showing current location
  late LocationDisplay _locationDisplay;
  
  // Create a graphics overlay for displaying markers
  final _graphicsOverlay = GraphicsOverlay();
  
  // State variables
  Position? _currentPosition;
  bool _isLoading = true;
  bool _ready = false;
  List<Graphic> _markers = [];
  BasemapStyle _currentBasemapStyle = BasemapStyle.arcGISTopographic;
  double _compassHeading = 0.0;
  StreamSubscription<CompassEvent>? _compassSubscription;
  bool _isArcGISInitialized = false;
  
  List<LandslideReport> _allReports = [];
  List<LandslideReport> _filteredReports = [];
  String _selectedFilter = 'All';
  
  // Track visible layers for report visualization
  bool _showApprovedLayer = true;
  bool _showPendingLayer = true;
  bool _showRejectedLayer = true;
  
  // Government geological data layers
  RasterLayer? _susceptibilityLayer;
  FeatureLayer? _landslideInventoryLayer;
  FeatureLayer? _districtBoundaryLayer;
  FeatureLayer? _stateBoundaryLayer;
  FeatureLayer? _shortrangeForecastLayer;
  
  // Current active layer tracking for mutual exclusivity
  String? _currentActiveLayer;
  
  // Authentication credentials - GSI Enterprise portal
  static const String _gsiUsername = 'nlfcproject';
  static const String _gsiPassword = 'nlfcadmin1234';
  
  // ArcGIS API Key and License
  static const String _arcgisApiKey = 'AAPTxy8BH1VEsoebNVZXo8HurOqj9vsaKKHwafyQtKINWeMtuT47-o9HvNNf0Sr4AXK_Z0nEuHmGLq10e9tfRST8lnfLYMly3rmIc8gjRoWsPC7dgkz4jal4xcz_-LE_msCKrG6d_ACX174bDQ4WdKS9pEaUrHZrz3vGXsQUZWKmo6jlbAuW2MedeMPN1X14mcEOixZ5CCpZ8k3hm3NCQACNMPnCyMtfJXXCAy0S8_GWjGA.AT1_6zX0ZMIw';
  static const String _licenseKey = 'runtimelite,1000,rud2840189929,none,HC5X0H4AH76HF5KHT190';
  
  // Map bounds for India
  static ArcGISPoint _indiaCenter = ArcGISPoint(
    x: 78.9629,
    y: 20.5937,
    spatialReference: SpatialReference.wgs84,
  );

  @override
  void initState() {
    super.initState();
    _initializeArcGIS();
  }

  @override
  void dispose() {
    // Remove authentication challenge handler
    ArcGISEnvironment.authenticationManager.arcGISAuthenticationChallengeHandler = null;
    
    // Cancel compass subscription
    _compassSubscription?.cancel();
    
    super.dispose();
  }

  // Implementation of ArcGISAuthenticationChallengeHandler
  @override
  Future<void> handleArcGISAuthenticationChallenge(
    ArcGISAuthenticationChallenge challenge,
  ) async {
    try {
      print('🔐 Authentication challenge from: ${challenge.requestUri}');
      
      // Check if this is a GSI Enterprise portal request
      final requestUri = challenge.requestUri.toString();
      if (requestUri.contains('bhusanket.gsi.gov.in')) {
        print('📡 GSI Enterprise portal authentication required');
        
        try {
          // Create credential using the official Esri pattern
          final credential = await TokenCredential.createWithChallenge(
            challenge,
            username: _gsiUsername,
            password: _gsiPassword,
          );
          
          // Continue with the credential
          challenge.continueWithCredential(credential);
          print('✅ GSI authentication successful');
          
        } catch (e) {
          print('❌ GSI authentication failed: $e');
          challenge.continueAndFail();
        }
      } else {
        print('⚠ Authentication challenge from unknown source - failing');
        challenge.continueAndFail();
      }
    } catch (e) {
      print('❌ Authentication challenge handling failed: $e');
      challenge.continueAndFail();
    }
  }

  void _initializeArcGIS() {
    try {
      setState(() => _isLoading = true);
      
      // Set the API key
      ArcGISEnvironment.apiKey = _arcgisApiKey;
      
      // Set license string to remove watermark
      ArcGISEnvironment.setLicenseUsingKey(_licenseKey);
      
      // Set up authentication challenge handler for Enterprise portals (GSI)
      ArcGISEnvironment.authenticationManager.arcGISAuthenticationChallengeHandler = this;
      print('✓ Authentication challenge handler configured');
      
      // Create map with basemap style
      _map = ArcGISMap.withBasemapStyle(_currentBasemapStyle);
      
      setState(() => _isArcGISInitialized = true);
      
      // Initialize other components
      _initCompass();
      _fetchReports();
      
    } catch (e) {
      print('Error initializing ArcGIS: $e');
      _showError('Failed to initialize map: ${e.toString()}');
      setState(() => _isLoading = false);
    }
  }

  void _initCompass() {
    _compassSubscription = FlutterCompass.events?.listen((CompassEvent event) {
      if (mounted) {
        setState(() {
          _compassHeading = event.heading ?? 0.0;
        });
      }
    });
  }

  Future<void> _fetchReports() async {
    if (!_isArcGISInitialized) {
      print('ArcGIS not initialized yet, skipping fetch reports');
      return;
    }
    
    try {
      setState(() => _isLoading = true);
      
      final reports = await LandslideReportsService.fetchReports();
      
      setState(() {
        _allReports = reports;
        _filteredReports = reports;
        _isLoading = false;
      });
      
      if (_ready) {
        await _createMarkers();
      }
      
    } catch (e) {
      print("Error fetching reports: $e");
      setState(() => _isLoading = false);
      
      _showError('Failed to load reports: ${e.toString()}');
    }
  }

  Future<void> _onMapViewReady() async {
    try {
      // Configure the graphics overlay for markers
      _graphicsOverlay.renderer = SimpleRenderer(
        symbol: SimpleMarkerSymbol(
          style: SimpleMarkerSymbolStyle.circle,
          color: Colors.blue,
          size: 12,
        ),
      );

      // Add the graphics overlay to the map view
      _mapViewController.graphicsOverlays.add(_graphicsOverlay);

      // Assign the map to the map view controller
      _mapViewController.arcGISMap = _map;

      // Set initial viewpoint to India
      _mapViewController.setViewpoint(
        Viewpoint.fromCenter(
          _indiaCenter,
          scale: 50000000,
        ),
      );

      // Enable the UI
      setState(() => _ready = true);
      
      // Create markers if reports are already loaded
      if (_filteredReports.isNotEmpty) {
        await _createMarkers();
      }
      
    } catch (e) {
      _showError('Failed to initialize map: $e');
    }
  }

  Future<void> _createMarkers() async {
    if (!_ready || !_isArcGISInitialized) {
      print('Map not ready yet, skipping marker creation');
      return;
    }
    
    _graphicsOverlay.graphics.clear();
    _markers.clear();
    
    for (int i = 0; i < _filteredReports.length; i++) {
      final report = _filteredReports[i];
      
      // Skip invalid coordinates
      if (report.latitude == 0.0 || report.longitude == 0.0) continue;
      
      // Skip based on layer visibility
      if (report.isApproved && !_showApprovedLayer) continue;
      if (report.isPending && !_showPendingLayer) continue;
      if (report.isRejected && !_showRejectedLayer) continue;
      
      final ArcGISPoint point = ArcGISPoint(
        x: report.longitude,
        y: report.latitude,
        spatialReference: SpatialReference.wgs84,
      );
      
      final ArcGISSymbol markerSymbol = _getMarkerSymbol(report);
      
      final Graphic marker = Graphic(
        geometry: point,
        symbol: markerSymbol,
        attributes: {
          'reportId': report.id,
          'title': '${report.district} - ${report.statusDisplayName}',
          'snippet': 'Reported by: ${report.userTypeDisplayName}\nID: ${report.id}',
          'district': report.district,
          'status': report.statusDisplayName,
          'userType': report.userTypeDisplayName,
          'latitude': report.latitude,
          'longitude': report.longitude,
        },
      );
      
      _markers.add(marker);
      _graphicsOverlay.graphics.add(marker);
    }
    
    setState(() {});
  }

  ArcGISSymbol _getMarkerSymbol(LandslideReport report) {
    Color markerColor;
    
    if (report.isApproved) {
      markerColor = Colors.green;
    } else if (report.isRejected) {
      markerColor = Colors.red;
    } else if (report.isPending) {
      markerColor = Colors.orange;
    } else {
      markerColor = Colors.blue;
    }
    
    return SimpleMarkerSymbol(
      style: SimpleMarkerSymbolStyle.circle,
      color: markerColor,
      size: 12,
    );
  }

  // Navigate to ReportDetailsScreen
  void _navigateToReportDetails(LandslideReport report) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReportDetailsScreen(
          reportId: report.id,
          reportTitle: '${report.district} - ${report.statusDisplayName}',
        ),
      ),
    );
  }

  void _centerMapOnReport(LandslideReport report) {
    Navigator.pop(context); // Close bottom sheet if open
    
    if (_ready && _mapViewController.arcGISMap != null) {
      final ArcGISPoint centerPoint = ArcGISPoint(
        x: report.longitude,
        y: report.latitude,
        spatialReference: SpatialReference.wgs84,
      );
      
      _mapViewController.setViewpointCenter(
        centerPoint,
        scale: 50000, // Equivalent to zoom level 15
      );
    }
  }

  void _filterReports(String filter) {
    setState(() {
      _selectedFilter = filter;
      
      switch (filter) {
        case 'All':
          _filteredReports = _allReports;
          break;
        case 'Approved':
          _filteredReports = LandslideReportsService.filterByStatus(_allReports, 'approved');
          break;
        case 'Rejected':
          _filteredReports = LandslideReportsService.filterByStatus(_allReports, 'rejected');
          break;
        case 'Pending':
          _filteredReports = LandslideReportsService.filterByStatus(_allReports, 'pending');
          break;
        case 'Geo-Scientist':
          _filteredReports = LandslideReportsService.filterByUserType(_allReports, 'geo-scientist');
          break;
        case 'Public':
          _filteredReports = LandslideReportsService.filterByUserType(_allReports, 'public');
          break;
      }
    });
    
    _createMarkers();
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: message.contains('Failed') || message.contains('not available') 
              ? Colors.red 
              : Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // Zoom In functionality
  Future<void> _zoomIn() async {
    try {
      final currentViewpoint = _mapViewController.getCurrentViewpoint(ViewpointType.centerAndScale);
      if (currentViewpoint != null) {
        final newScale = currentViewpoint.targetScale / 2; // Zoom in by factor of 2
        _mapViewController.setViewpoint(
          Viewpoint.fromCenter(currentViewpoint.targetGeometry as ArcGISPoint, scale: newScale),
        );
      }
    } catch (e) {
      _showError('Failed to zoom in: $e');
    }
  }

  // Zoom Out functionality
  Future<void> _zoomOut() async {
    try {
      final currentViewpoint = _mapViewController.getCurrentViewpoint(ViewpointType.centerAndScale);
      if (currentViewpoint != null) {
        final newScale = currentViewpoint.targetScale * 2; // Zoom out by factor of 2
        _mapViewController.setViewpoint(
          Viewpoint.fromCenter(currentViewpoint.targetGeometry as ArcGISPoint, scale: newScale),
        );
      }
    } catch (e) {
      _showError('Failed to zoom out: $e');
    }
  }

  // Reset to India view (Home functionality)
  void _resetToIndiaView() {
    if (_ready) {
      _mapViewController.setViewpoint(
        Viewpoint.fromCenter(
          _indiaCenter,
          scale: 50000000, // Approximate scale for country view
        ),
      );
      _showError('Reset to India view');
    }
  }

  // Reset map rotation to north
  Future<void> _resetMapRotation() async {
    try {
      final currentViewpoint = _mapViewController.getCurrentViewpoint(ViewpointType.centerAndScale);
      if (currentViewpoint != null) {
        // Create a new viewpoint with the same center and scale but with rotation reset to 0
        final currentCenter = currentViewpoint.targetGeometry as ArcGISPoint;
        final newViewpoint = Viewpoint.fromCenter(
          currentCenter,
          scale: currentViewpoint.targetScale,
        );
        
        _mapViewController.setViewpoint(newViewpoint);
        _showError('Map rotation reset to north');
      }
    } catch (e) {
      _showError('Failed to reset map rotation: $e');
    }
  }

  // Show basemap gallery dialog (matching the style from ArcGisLocationMapScreen)
  void _showBasemapGallery() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(
            color: Colors.blue,
            padding: const EdgeInsets.all(16),
            child: const Text(
              'Basemap gallery',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          titlePadding: EdgeInsets.zero,
          contentPadding: const EdgeInsets.all(16),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.terrain),
                title: const Text('Topographic'),
                subtitle: const Text('Terrain and elevation'),
                onTap: () {
                  Navigator.of(context).pop();
                  _setMapType(BasemapStyle.arcGISTopographic, 'Topographic');
                },
              ),
              ListTile(
                leading: const Icon(Icons.satellite),
                title: const Text('Satellite'),
                subtitle: const Text('Aerial imagery view'),
                onTap: () {
                  Navigator.of(context).pop();
                  _setMapType(BasemapStyle.arcGISImageryStandard, 'Satellite');
                },
              ),
              ListTile(
                leading: const Icon(Icons.map),
                title: const Text('OpenStreetMap'),
                subtitle: const Text('Free open-source map'),
                onTap: () {
                  Navigator.of(context).pop();
                  _setMapToOpenStreetMap();
                },
              ),
              ListTile(
                leading: const Icon(Icons.location_city),
                title: const Text('Streets'),
                subtitle: const Text('Detailed street view'),
                onTap: () {
                  Navigator.of(context).pop();
                  _setMapType(BasemapStyle.arcGISStreets, 'Streets');
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Show layer list dialog for report layers
  void _showLayerList() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(
            color: Colors.blue,
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Layer list',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                TextButton(
                  onPressed: () {
                    // Clear/hide all layers
                    _hideAllLayersExcept(null);
                    setState(() {
                      _showApprovedLayer = false;
                      _showPendingLayer = false;
                      _showRejectedLayer = false;
                    });
                    _createMarkers();
                    Navigator.of(context).pop();
                    _showError('All layers cleared');
                  },
                  child: const Text(
                    'CLEAR',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // GSI Data Layers Section
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.grey[200],
                  child: const Row(
                    children: [
                      Icon(Icons.public, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'GSI Geological Data',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                _buildLayerListItem('Landslide Susceptibility (1:50,000)', 'susceptibility'),
                _buildLayerListItem('National Landslide Inventory', 'inventory'),
                _buildLayerListItem('Shortrange Forecast', 'forecast', isShortrangeForecast: true),
                _buildLayerListItem('India State Boundary', 'state'),
                
                // Report Layers Section
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.grey[200],
                  child: const Row(
                    children: [
                      Icon(Icons.report, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Report Layers',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Column(
                      children: [
                        CheckboxListTile(
                          title: const Text('Approved Reports'),
                          subtitle: Text('${_allReports.where((r) => r.isApproved).length} reports'),
                          value: _showApprovedLayer,
                          activeColor: Colors.green,
                          onChanged: (bool? value) {
                            setState(() {
                              _showApprovedLayer = value ?? false;
                            });
                            this.setState(() {
                              _showApprovedLayer = value ?? false;
                            });
                            _createMarkers();
                          },
                        ),
                        CheckboxListTile(
                          title: const Text('Pending Reports'),
                          subtitle: Text('${_allReports.where((r) => r.isPending).length} reports'),
                          value: _showPendingLayer,
                          activeColor: Colors.orange,
                          onChanged: (bool? value) {
                            setState(() {
                              _showPendingLayer = value ?? false;
                            });
                            this.setState(() {
                              _showPendingLayer = value ?? false;
                            });
                            _createMarkers();
                          },
                        ),
                        CheckboxListTile(
                          title: const Text('Rejected Reports'),
                          subtitle: Text('${_allReports.where((r) => r.isRejected).length} reports'),
                          value: _showRejectedLayer,
                          activeColor: Colors.red,
                          onChanged: (bool? value) {
                            setState(() {
                              _showRejectedLayer = value ?? false;
                            });
                            this.setState(() {
                              _showRejectedLayer = value ?? false;
                            });
                            _createMarkers();
                          },
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper method to build layer list items (simple list without toggles)
  Widget _buildLayerListItem(String title, String layerType, {bool isShortrangeForecast = false}) {
    final isActive = _currentActiveLayer == layerType;
    
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          color: isActive ? Colors.blue : Colors.black,
        ),
      ),
      trailing: isActive ? const Icon(Icons.visibility, color: Colors.blue) : null,
      onTap: () async {
        Navigator.of(context).pop(); // Close dialog first
        
        if (isShortrangeForecast) {
          // Show shortrange forecast popup and then load layer
          await _showShortrangeForecastDialog();
          await _loadShortrangeForecastLayer();
        } else {
          await _loadSpecificLayer(layerType);
        }
      },
    );
  }

  // Hide all layers except the specified one
  void _hideAllLayersExcept(String? keepVisible) {
    setState(() {
      if (keepVisible != 'susceptibility') _susceptibilityLayer?.isVisible = false;
      if (keepVisible != 'inventory') _landslideInventoryLayer?.isVisible = false;
      if (keepVisible != 'district') _districtBoundaryLayer?.isVisible = false;
      if (keepVisible != 'state') _stateBoundaryLayer?.isVisible = false;
      if (keepVisible != 'forecast') _shortrangeForecastLayer?.isVisible = false;
      
      _currentActiveLayer = keepVisible;
    });
  }

  // Load specific layer and hide others
  Future<void> _loadSpecificLayer(String layerType) async {
    // Hide all other layers first
    _hideAllLayersExcept(layerType);
    
    try {
      switch (layerType) {
        case 'susceptibility':
          await _loadSusceptibilityLayer();
          break;
        case 'inventory':
          await _loadLandslideInventoryLayer();
          break;
        case 'state':
          await _loadStateBoundaryLayer();
          break;
        case 'district':
          await _loadDistrictBoundaryLayer();
          break;
        default:
          _showError('Unknown layer type: $layerType');
      }
    } catch (e) {
      _showError('Failed to load $layerType layer: $e');
    }
  }

  // Show shortrange forecast dialog with date validation
  Future<void> _showShortrangeForecastDialog() async {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    
    final dateFormat = DateFormat('dd MMMM yyyy');
    const time = '14:30';
    
    final fromDate = dateFormat.format(yesterday);
    final toDate = dateFormat.format(now);
    
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[800],
          content: Text(
            'Only for districts where landslide forecasting is operational. Valid from $fromDate $time to $toDate $time IST',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Colors.pink,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Load shortrange forecast layer with proper color coding
  Future<void> _loadShortrangeForecastLayer() async {
    try {
      _hideAllLayersExcept('forecast');
      
      if (_shortrangeForecastLayer == null) {
        print('🔍 Loading Shortrange Forecast from GSI Bulletin Map FeatureServer/1');
        
        // Use the correct forecast data layer (FeatureServer/1 for shortrange forecast)
        final shortrangeForecastServiceUrl = Uri.parse('https://bhusanket.gsi.gov.in/gisserver/rest/services/GSI/Bulletin_Map/FeatureServer/1');
        final shortrangeForecastServiceFeatureTable = ServiceFeatureTable.withUri(shortrangeForecastServiceUrl);
        _shortrangeForecastLayer = FeatureLayer.withFeatureTable(shortrangeForecastServiceFeatureTable);
        
        // Create categorized renderer for forecast risk levels
        _shortrangeForecastLayer!.renderer = await _createForecastRenderer();
        _shortrangeForecastLayer!.opacity = 0.8;
        
        // Add layer to map
        _map.operationalLayers.add(_shortrangeForecastLayer!);
        
        // Load the layer
        await _shortrangeForecastLayer!.load();
        
        print('✅ Successfully loaded Shortrange Forecast layer');
      }
      
      setState(() {
        _shortrangeForecastLayer!.isVisible = true;
        _currentActiveLayer = 'forecast';
      });
      
    } catch (e) {
      _showError('Failed to load Shortrange Forecast layer: $e');
      print('❌ Shortrange Forecast layer loading error: $e');
    }
  }

  //RE Center India
Future<void> _recenterToIndia() async {
  try {
    final indiaCenter = ArcGISPoint(
      x: 78.6569,
      y: 22.9734,
      spatialReference: SpatialReference.wgs84,
    );
    
    await _mapViewController.setViewpointCenter(
      indiaCenter,
      scale: 40000000, // Wider zoom to show full India
    );

    _showError('Recentered to India');
  } catch (e) {
    _showError('Failed to recenter to India: $e');
  }
}

  // Create categorized renderer for forecast risk levels
  Future<Renderer> _createForecastRenderer() async {
    try {
      // Create symbols for different risk levels
      final lowRiskSymbol = SimpleFillSymbol(
        style: SimpleFillSymbolStyle.solid,
        color: Colors.green.withOpacity(0.7), // Green for low risk
        outline: SimpleLineSymbol(
          style: SimpleLineSymbolStyle.solid,
          color: Colors.black,
          width: 1,
        ),
      );
      
      final moderateRiskSymbol = SimpleFillSymbol(
        style: SimpleFillSymbolStyle.solid,
        color: Colors.yellow.withOpacity(0.7), // Yellow for moderate risk
        outline: SimpleLineSymbol(
          style: SimpleLineSymbolStyle.solid,
          color: Colors.black,
          width: 1,
        ),
      );
      
      final highRiskSymbol = SimpleFillSymbol(
        style: SimpleFillSymbolStyle.solid,
        color: Colors.red.withOpacity(0.7), // Red for high risk
        outline: SimpleLineSymbol(
          style: SimpleLineSymbolStyle.solid,
          color: Colors.black,
          width: 1,
        ),
      );
      
      final noDataSymbol = SimpleFillSymbol(
        style: SimpleFillSymbolStyle.solid,
        color: Colors.grey.withOpacity(0.3), // Grey for no data/default
        outline: SimpleLineSymbol(
          style: SimpleLineSymbolStyle.solid,
          color: Colors.grey,
          width: 0.5,
        ),
      );
      
      // Create unique value renderer using Day1_Approved field
      final renderer = UniqueValueRenderer(
        fieldNames: ['Day1_Approved'], // Primary field for classification
        defaultSymbol: noDataSymbol,
        defaultLabel: 'No Forecast Data',
      );
      
      return renderer;
      
    } catch (e) {
      print('❌ Failed to create forecast renderer: $e');
      // Fallback to simple renderer
      return SimpleRenderer(
        symbol: SimpleFillSymbol(
          style: SimpleFillSymbolStyle.solid,
          color: Colors.lightGreen.withOpacity(0.7),
          outline: SimpleLineSymbol(
            style: SimpleLineSymbolStyle.solid,
            color: Colors.black,
            width: 1,
          ),
        ),
      );
    }
  }

  // Updated method to properly load ImageServer as RasterLayer
Future<void> _loadSusceptibilityLayer() async {
  try {
    _hideAllLayersExcept('susceptibility');
    
    if (_susceptibilityLayer == null) {
      print('🔍 Loading Susceptibility layer from GSI ImageServer');
      
      // Create ImageServiceRaster from the GSI ImageServer URL
      final susceptibilityImageServiceUrl = Uri.parse('https://bhusanket.gsi.gov.in/gisserver/rest/services/GSI/Susceptibility/ImageServer');
      final imageServiceRaster = ImageServiceRaster(uri: susceptibilityImageServiceUrl);
      
      // Create RasterLayer from the ImageServiceRaster
      _susceptibilityLayer = RasterLayer.withRaster(imageServiceRaster);
      
      // Create colormap for susceptibility values 0-3
      final colors = <Color>[];
      // Value 0: Transparent (NoData areas)
      colors.add(Colors.transparent);
      // Value 1: Yellow (Low susceptibility)
      colors.add(Colors.yellow);
      // Value 2: Green (Medium susceptibility)  
      colors.add(Colors.green);
      // Value 3: Red (High susceptibility)
      colors.add(Colors.red);
      
      // Create and apply the colormap renderer
      final colormapRenderer = ColormapRenderer.withColors(colors);
      _susceptibilityLayer!.renderer = colormapRenderer;
      
      // Configure the layer properties
      _susceptibilityLayer!.opacity = 0.7; // Make it semi-transparent
      
      // Add layer to map first
      _map.operationalLayers.add(_susceptibilityLayer!);
      
      // Load the layer
      await _susceptibilityLayer!.load();
      
      print('✅ Successfully loaded Susceptibility layer as RasterLayer');
    }
    
    setState(() {
      _susceptibilityLayer!.isVisible = true;
      _currentActiveLayer = 'susceptibility';
    });
    
    _showError('Susceptibility layer enabled');
    
  } catch (e) {
    _showError('Failed to load Susceptibility layer: $e');
    print('❌ Susceptibility layer loading error: $e');
    
    // Fallback: Try with rendering rule approach
    await _loadSusceptibilityLayerWithRenderingRule();
  }
}

  // Alternative approach using RenderingRule for raster visualization
  Future<void> _loadSusceptibilityLayerWithRenderingRule() async {
    try {
      print('🔄 Trying RenderingRule approach for Susceptibility layer...');
      
      if (_susceptibilityLayer == null) {
        // Create ImageServiceRaster from the GSI ImageServer URL
        final susceptibilityImageServiceUrl = Uri.parse('https://bhusanket.gsi.gov.in/gisserver/rest/services/GSI/Susceptibility/ImageServer');
        final imageServiceRaster = ImageServiceRaster(uri: susceptibilityImageServiceUrl);
        
        // Create a rendering rule for better visualization
        final renderingRuleJson = '''
        {
          "rasterFunction": "Colormap",
          "rasterFunctionArguments": {
            "Colormap": [
              [1, 0, 255, 0, 255],
              [2, 255, 255, 0, 255],
              [3, 255, 0, 0, 255]
            ],
            "Raster": ""
          }
        }
        ''';
        
        final renderingRule = RenderingRule.withRenderingRuleJson(renderingRuleJson);
        imageServiceRaster.renderingRule = renderingRule;
        
        // Create RasterLayer from the ImageServiceRaster
        _susceptibilityLayer = RasterLayer.withRaster(imageServiceRaster);
        
        // Configure the layer properties
        _susceptibilityLayer!.opacity = 0.7;
        
        // Add layer to map
        _map.operationalLayers.add(_susceptibilityLayer!);
        
        // Load the layer
        await _susceptibilityLayer!.load();
      }
      
      setState(() {
        _susceptibilityLayer!.isVisible = true;
        _currentActiveLayer = 'susceptibility';
      });
      
      _showError('Susceptibility layer enabled (with rendering rule)');
      print('✅ Susceptibility layer loaded with rendering rule');
      
    } catch (e) {
      print('❌ Rendering rule approach also failed: $e');
      await _loadSusceptibilityLayerSimple();
    }
  }

    // Simple approach without custom renderer
  Future<void> _loadSusceptibilityLayerSimple() async {
    try {
      print('🔄 Trying simple approach for Susceptibility layer...');
      
      if (_susceptibilityLayer == null) {
        // Create ImageServiceRaster from the GSI ImageServer URL
        final susceptibilityImageServiceUrl = Uri.parse('https://bhusanket.gsi.gov.in/gisserver/rest/services/GSI/Susceptibility/ImageServer');
        final imageServiceRaster = ImageServiceRaster(uri: susceptibilityImageServiceUrl);
        
        // Create RasterLayer from the ImageServiceRaster
        _susceptibilityLayer = RasterLayer.withRaster(imageServiceRaster);
        
        // Configure the layer properties with default renderer
        _susceptibilityLayer!.opacity = 0.7;
        
        // Add layer to map
        _map.operationalLayers.add(_susceptibilityLayer!);
        
        // Load the layer
        await _susceptibilityLayer!.load();
      }
      
      setState(() {
        _susceptibilityLayer!.isVisible = true;
        _currentActiveLayer = 'susceptibility';
      });
      
      _showError('Susceptibility layer enabled (simple)');
      print('✅ Susceptibility layer loaded with default renderer');
      
    } catch (e) {
      print('❌ Simple approach also failed: $e');
      _showError('Susceptibility layer not available - server may be unreachable');
    }
  }


  // Load National Landslide Inventory Layer with correct URL
  Future<void> _loadLandslideInventoryLayer() async {
    try {
      _hideAllLayersExcept('inventory');
      
      if (_landslideInventoryLayer == null) {
        print('🔍 Loading National Landslide Inventory from GSI');
        
        // Updated URL based on the provided REST API details
        final inventoryServiceUrl = Uri.parse('https://bhusanket.gsi.gov.in/gisserver/rest/services/Hosted/India_All_Landslided/FeatureServer/0');
        final inventoryServiceFeatureTable = ServiceFeatureTable.withUri(inventoryServiceUrl);
        _landslideInventoryLayer = FeatureLayer.withFeatureTable(inventoryServiceFeatureTable);
        
        // Configure styling based on the field information
        _landslideInventoryLayer!.renderer = SimpleRenderer(
          symbol: SimpleMarkerSymbol(
            style: SimpleMarkerSymbolStyle.circle,
            color: const Color.fromARGB(179, 109, 65, 48).withOpacity(0.8),
            size: 8,
          ),
        );
        _landslideInventoryLayer!.opacity = 0.9;
        
        // Add layer to map
        _map.operationalLayers.add(_landslideInventoryLayer!);
        
        // Load the layer
        await _landslideInventoryLayer!.load();
        
        print('✅ Successfully loaded National Landslide Inventory layer');
      }
      
      setState(() {
        _landslideInventoryLayer!.isVisible = true;
        _currentActiveLayer = 'inventory';
      });
      
      _showError('National Landslide Inventory layer enabled');
      
    } catch (e) {
      _showError('Failed to load National Landslide Inventory layer: $e');
      print('❌ National Landslide Inventory layer loading error: $e');
    }
  }

  // Load State Boundary Layer
  Future<void> _loadStateBoundaryLayer() async {
    try {
      _hideAllLayersExcept('state');
      
      if (_stateBoundaryLayer == null) {
        print('🔍 Loading State Boundary layer from GSI');
        
        final stateServiceUrl = Uri.parse('https://bhusanket.gsi.gov.in/gisserver/rest/services/Hosted/India_Boundary/FeatureServer/1');
        final stateServiceFeatureTable = ServiceFeatureTable.withUri(stateServiceUrl);
        _stateBoundaryLayer = FeatureLayer.withFeatureTable(stateServiceFeatureTable);
        
        // Configure styling for state boundaries
        _stateBoundaryLayer!.renderer = SimpleRenderer(
          symbol: SimpleLineSymbol(
            style: SimpleLineSymbolStyle.solid,
            color: Colors.black,
            width: 2,
          ),
        );
        _stateBoundaryLayer!.opacity = 0.8;
        
        // Add layer to map
        _map.operationalLayers.add(_stateBoundaryLayer!);
        
        // Load the layer
        await _stateBoundaryLayer!.load();
        
        print('✅ Successfully loaded State Boundary layer');
      }
      
      setState(() {
        _stateBoundaryLayer!.isVisible = true;
        _currentActiveLayer = 'state';
      });
      
      _showError('India State Boundary layer enabled');
      
    } catch (e) {
      _showError('Failed to load State Boundary layer: $e');
      print('❌ State Boundary layer loading error: $e');
    }
  }

  // Load District Boundary Layer
  Future<void> _loadDistrictBoundaryLayer() async {
    try {
      _hideAllLayersExcept('district');
      
      if (_districtBoundaryLayer == null) {
        print('🔍 Loading District Boundary layer from GSI');
        
        final districtServiceUrl = Uri.parse('https://bhusanket.gsi.gov.in/gisserver/rest/services/GSI/Bulletin_Map/FeatureServer/1');
        final districtServiceFeatureTable = ServiceFeatureTable.withUri(districtServiceUrl);
        _districtBoundaryLayer = FeatureLayer.withFeatureTable(districtServiceFeatureTable);
        
        // Configure styling for district boundaries
        _districtBoundaryLayer!.renderer = SimpleRenderer(
          symbol: SimpleLineSymbol(
            style: SimpleLineSymbolStyle.solid,
            color: Colors.grey,
            width: 1,
          ),
        );
        _districtBoundaryLayer!.opacity = 0.6;
        
        // Add layer to map
        _map.operationalLayers.add(_districtBoundaryLayer!);
        
        // Load the layer
        await _districtBoundaryLayer!.load();
        
        print('✅ Successfully loaded District Boundary layer');
      }
      
      setState(() {
        _districtBoundaryLayer!.isVisible = true;
        _currentActiveLayer = 'district';
      });
      
      _showError('District Boundary layer enabled');
      
    } catch (e) {
      _showError('Failed to load District Boundary layer: $e');
      print('❌ District Boundary layer loading error: $e');
    }
  }

  // Set map type
  void _setMapType(BasemapStyle basemapStyle, String typeName) {
    try {
      setState(() {
        _currentBasemapStyle = basemapStyle;
        if (_ready) {
          _map.basemap = Basemap.withStyle(basemapStyle);
        }
      });
      _showError('Switched to $typeName view');
    } catch (e) {
      _showError('Failed to change map type: $e');
    }
  }

  // Set map to OpenStreetMap
  void _setMapToOpenStreetMap() {
    try {
      // For OpenStreetMap, you might need to use a different approach
      // This is a placeholder - implement according to your needs
      _showError('Switched to OpenStreetMap');
    } catch (e) {
      _showError('Failed to switch to OpenStreetMap: $e');
    }
  }

  // Handle marker tap
  void _onMapTap(Offset screenPoint) async {
    if (!_ready || _graphicsOverlay.graphics.isEmpty) return;
    
    try {
      final IdentifyGraphicsOverlayResult result = await _mapViewController.identifyGraphicsOverlay(
        _graphicsOverlay,
        screenPoint: screenPoint,
        tolerance: 12,
        maximumResults: 1,
      );
      
      if (result.graphics.isNotEmpty) {
        final Graphic tappedGraphic = result.graphics.first;
        final String? reportId = tappedGraphic.attributes['reportId'] as String?;
        
        if (reportId != null) {
          // Find the report and show details
          final LandslideReport? report = _filteredReports.findById(reportId);
          
          if (report != null) {
            _navigateToReportDetails(report);
          }
        }
      }
    } catch (e) {
      print('Error identifying graphics: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('All Reports'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchReports,
          ),
        ],
      ),
      body: _isLoading || !_isArcGISInitialized
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(_isArcGISInitialized ? 'Loading reports...' : 'Initializing map...'),
                ],
              ),
            )
          : Stack(
              children: [
                // ArcGIS Map
                ArcGISMapView(
                  controllerProvider: () => _mapViewController,
                  onMapViewReady: _onMapViewReady,
                  onTap: _onMapTap,
                ),
                
                // Functional Compass in the top-left corner
                Positioned(
                  top: 20,
                  left: 20,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.9),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Transform.rotate(
                      angle: ((_compassHeading ?? 0) * (pi / 180) * -1),
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/compass.png'),
                            fit: BoxFit.cover,
                          ),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
                
                // Right side navigation toolbar (matching ArcGisLocationMapScreen style)
                Positioned(
                  top: 16,
                  right: 16,
                  child: Column(
                    children: [
                      // Zoom In button
                      Container(
                        margin: const EdgeInsets.only(bottom: 2),
                        child: FloatingActionButton(
                          heroTag: "zoom_in",
                          mini: true,
                          backgroundColor: Colors.blue,
                          onPressed: _ready ? _zoomIn : null,
                          child: const Icon(Icons.add, color: Colors.white),
                        ),
                      ),
                      
                      // Zoom Out button
                      Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: FloatingActionButton(
                          heroTag: "zoom_out",
                          mini: true,
                          backgroundColor: Colors.blue,
                          onPressed: _ready ? _zoomOut : null,
                          child: const Icon(Icons.remove, color: Colors.white),
                        ),
                      ),
                      
                      // Base map layers button (show selection dialog type of MAPS)
                      Container(
                        margin: const EdgeInsets.only(bottom: 2),
                        child: FloatingActionButton(
                          heroTag: "Basemap_layers",
                          mini: true,
                          backgroundColor: Colors.blue,
                          onPressed: _ready ? _showBasemapGallery : null,
                          child: const Icon(Icons.map, color: Colors.white),
                        ),
                      ),

                      // Map layers button (show report layers)
                      Container(
                        margin: const EdgeInsets.only(bottom: 2),
                        child: FloatingActionButton(
                          heroTag: "layers",
                          mini: true,
                          backgroundColor: Colors.blue,
                          onPressed: _ready ? _showLayerList : null,
                          child: const Icon(Icons.layers, color: Colors.white),
                        ),
                      ),
                      
                      // Home button (reset to India view)
                      Container(
                        margin: const EdgeInsets.only(bottom: 2),
                        child: FloatingActionButton(
                          heroTag: "home",
                          mini: true,
                          backgroundColor: Colors.blue,
                          onPressed: _ready ? _resetToIndiaView : null,
                          child: const Icon(Icons.home, color: Colors.white),
                        ),
                      ),
                      
              
                    ],
                  ),
                ),
                
                // Filter badge
                Positioned(
                  top: 90,
                  left: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      '$_selectedFilter (${_filteredReports.length})',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                
                // Legend
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Legend',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _legendItem(Colors.green, 'Approved'),
                        _legendItem(Colors.red, 'Rejected'),
                        _legendItem(Colors.orange, 'Pending'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: filterReports,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.filter_list, color: Colors.white),
      ),
    );
  }

  // Helper method for legend items
  Widget _legendItem(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  // Show filter dialog
  void filterReports() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final stats = LandslideReportsService.getStatistics(_allReports);
        
        return AlertDialog(
          title: const Text('Filter Reports'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _filterOption('All', 'All Reports (${stats['total']})'),
              const Divider(),
              _filterOption('Approved', 'Approved (${stats['approved']})', 
                color: Colors.green),
              _filterOption('Rejected', 'Rejected (${stats['rejected']})', 
                color: Colors.red),
              _filterOption('Pending', 'Pending (${stats['pending']})', 
                color: Colors.orange),
              const Divider(),
              _filterOption('Geo-Scientist', 'Geo-Scientists (${stats['geoScientist']})'),
              _filterOption('Public', 'Public Reports (${stats['public']})'),
            ],
          ),
        );
      },
    );
  }

  Widget _filterOption(String value, String title, {Color? color}) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: color),
      ),
      leading: _selectedFilter == value 
          ? Icon(Icons.check, color: color ?? Colors.blue)
          : const SizedBox(width: 24),
      onTap: () {
        _filterReports(value);
        Navigator.pop(context);
      },
    );
  }
}

// Extension to help find reports
extension LandslideReportExtension on List<LandslideReport> {
  LandslideReport? findById(String id) {
    try {
      return firstWhere((report) => report.id == id);
    } catch (e) {
      return null;
    }
  }
}