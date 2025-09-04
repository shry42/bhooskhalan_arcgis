import 'package:arcgis_maps/arcgis_maps.dart';
import 'package:bhooskhalann/landslide/report_landslide_maps_screen/report_form_getx/draft_report_section/draft_report_form.dart';
import 'package:bhooskhalann/landslide/report_landslide_maps_screen/report_form_getx/draft_report_section/public_report_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'dart:math';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ArcGisLocationMapScreen extends StatefulWidget {
  const ArcGisLocationMapScreen({super.key});

  @override
  State<ArcGisLocationMapScreen> createState() => _ArcGisLocationMapScreenState();
}

class _ArcGisLocationMapScreenState extends State<ArcGisLocationMapScreen>
    implements ArcGISAuthenticationChallengeHandler {
  
  // Create a controller for the map view
  final _mapViewController = ArcGISMapView.createController();
  
  // Create a map without basemap initially
  late ArcGISMap _map;
  
  // Create a graphics overlay for displaying landslide location marker
  final _graphicsOverlay = GraphicsOverlay();
  
  // Location display for showing current location
  late LocationDisplay _locationDisplay;
  
  // Flag to track if the map is ready
  var _ready = false;
  
  // Landslide location selection
  ArcGISPoint? _selectedLandslideLocation;
  bool _isSelectingLocation = false;
  
  // Text controllers for coordinate input
  late TextEditingController _latController;
  late TextEditingController _longController;

  // Government geological data layers - Updated for proper ImageServer support
  RasterLayer? _susceptibilityLayer;  // Changed from ArcGISMapImageLayer to RasterLayer
  FeatureLayer? _landslideInventoryLayer;
  FeatureLayer? _districtBoundaryLayer;
  FeatureLayer? _stateBoundaryLayer;
  FeatureLayer? _shortrangeForecastLayer;

  
  
  // Flag to track if susceptibility layers are loaded
  bool _susceptibilityLayersLoaded = false;

  // Current active layer tracking for mutual exclusivity
  String? _currentActiveLayer;

  // Compass functionality
  double _compassHeading = 0.0;
  StreamSubscription<CompassEvent>? _compassSubscription;

  // Authentication credentials - GSI Enterprise portal
  static const String _gsiUsername = 'nlfcproject';
  static const String _gsiPassword = 'nlfcadmin1234';
  static const String _apiKey = 'AAPTxy8BH1VEsoebNVZXo8HurOqj9vsaKKHwafyQtKINWeMtuT47-o9HvNNf0Sr4AXK_Z0nEuHmGLq10e9tfRST8lnfLYMly3rmIc8gjRoWsPC7dgkz4jal4xcz_-LE_msCKrG6d_ACX174bDQ4WdKS9pEaUrHZrz3vGXsQUZWKmo6jlbAuW2MedeMPN1X14mcEOixZ5CCpZ8k3hm3NCQACNMPnCyMtfJXXCAy0S8_GWjGA.AT1_6zX0ZMIw'; // For ArcGIS Online services

  @override
  void initState() {
    super.initState();
    _latController = TextEditingController();
    _longController = TextEditingController();
    _initializeArcGIS();
    _initCompass();
  }

  @override
  void dispose() {
    // Remove authentication challenge handler
    ArcGISEnvironment.authenticationManager.arcGISAuthenticationChallengeHandler = null;
    
    // Clean up controllers
    _latController.dispose();
    _longController.dispose();
    
    // Cancel compass subscription
    _compassSubscription?.cancel();
    
    super.dispose();
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

  void _initializeArcGIS() {
    ArcGISEnvironment.setLicenseUsingKey(
      'runtimelite,1000,rud2840189929,none,HC5X0H4AH76HF5KHT190',
    );
    // Set up API key for ArcGIS Online services (optional)
    // if (_apiKey != 'YOUR_API_KEY_HERE' && _apiKey.isNotEmpty) {
    //   ArcGISEnvironment.apiKey = _apiKey;
    //   print('api_key_configured'.tr);
    // } else {
    //   print('no_api_key'.tr);
    // }

    // Using GSI proxy - no API key needed
    print('using_gsi_proxy'.tr);
    
    // Set up authentication challenge handler for Enterprise portals (GSI)
    ArcGISEnvironment.authenticationManager.arcGISAuthenticationChallengeHandler = this;
    print('auth_handler_configured'.tr);
    
    // Create map with Streets view by default
    _createMapWithStreetsView();
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

Future<void> _createMapWithStreetsView() async {
  try {
    // Create portal pointing to GSI portal using the correct constructor
    final gsiPortal = Portal(
      Uri.parse('https://bhusanket.gsi.gov.in/gisportal/sharing/rest'),
      connection: PortalConnection.authenticated
    );
    
    // Create portal item for topographic map using named parameters
    final topographicItem = PortalItem.withPortalAndItemId(
      portal: gsiPortal, 
      itemId: '79873351c4c1462cba9af947be2fdf4c'
    );
    
    // Create map from portal item
    _map = ArcGISMap.withItem(topographicItem);
    print('map_configured'.tr);
  } catch (e) {
    print('Failed to create map with GSI Topographic view: $e');
    // Fallback: create empty map with default basemap
    _map = ArcGISMap.withBasemap(Basemap.withStyle(BasemapStyle.arcGISTopographic));
  }
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

  // Show layer list dialog
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
                Text(
                  'layer_list'.tr,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                TextButton(
                  onPressed: () {
                    // Clear/hide all layers
                    _hideAllLayersExcept(null);
                    Navigator.of(context).pop();
                    _showError('all_layers_cleared'.tr);
                  },
                  child: Text(
                    'clear'.tr,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLayerListItem('landslide_susceptibility'.tr, 'susceptibility'),
              _buildLayerListItem('national_landslide_inventory'.tr, 'inventory'),
              _buildLayerListItem('shortrange_forecast'.tr, 'forecast', isShortrangeForecast: true),
              _buildLayerListItem('india_state_boundary'.tr, 'state'),
            ],
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
          _showError('unknown_layer_type'.trParams({'type': layerType}));
      }
    } catch (e) {
      _showError('failed_to_load_layer'.trParams({'layer': layerType, 'error': e.toString()}));
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
            'forecast_dialog_prefix'.trParams({
              'fromDate': fromDate,
              'fromTime': time,
              'toDate': toDate,
              'toTime': time,
            }),
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
              child: Text(
                'ok'.tr,
                style: const TextStyle(
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
    _showError('failed_to_load_layer'.trParams({'layer': 'Shortrange Forecast', 'error': e.toString()}));
    print('❌ Shortrange Forecast layer loading error: $e');
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
    
    // Create unique value infos for different forecast statuses
    final uniqueValueInfos = [
     (
        values: ['Low'],
        symbol: lowRiskSymbol,
        label: 'low_risk'.tr,
        description: 'low_risk_desc'.tr,
      ),
     (
        values: ['Moderate'],
        symbol: moderateRiskSymbol,
        label: 'moderate_risk'.tr,
        description: 'moderate_risk_desc'.tr,
      ),
      (
        values: ['High'],
        symbol: highRiskSymbol,
        label: 'high_risk'.tr,
        description: 'high_risk_desc'.tr,
      ),
    ];
    
    // Create unique value renderer using Day1_Approved field
    // You can change this to Day2_Approved, Day1_status, or Day2_status as needed
    final renderer = UniqueValueRenderer(
      fieldNames: ['Day1_Approved'], // Primary field for classification
      // uniqueValueInfos: uniqueValueInfos,
      defaultSymbol: noDataSymbol,
      defaultLabel: 'no_forecast_data'.tr,
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
    
    _showError('susceptibility_layer_enabled'.tr);
    
  } catch (e) {
    _showError('failed_to_load_layer'.trParams({'layer': 'Susceptibility', 'error': e.toString()}));
    print('❌ Susceptibility layer loading error: $e');
    
    // Fallback: Try with rendering rule approach
    await _loadSusceptibilityLayerWithRenderingRule();
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
            // outline: SimpleLineSymbol(
            //   style: SimpleLineSymbolStyle.solid,
            //   color: Colors.red,
            //   width: 1,
            // ),
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
      
      _showError('inventory_layer_enabled'.tr);
      
    } catch (e) {
      _showError('failed_to_load_layer'.trParams({'layer': 'National Landslide Inventory', 'error': e.toString()}));
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
      
      _showError('state_boundary_enabled'.tr);
      
    } catch (e) {
      _showError('failed_to_load_layer'.trParams({'layer': 'State Boundary', 'error': e.toString()}));
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
      
      _showError('district_boundary_enabled'.tr);
      
    } catch (e) {
      _showError('failed_to_load_layer'.trParams({'layer': 'District Boundary', 'error': e.toString()}));
      print('❌ District Boundary layer loading error: $e');
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
      
      _showError('${'susceptibility_layer_enabled'.tr} (with rendering rule)');
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
      
      _showError('${'susceptibility_layer_enabled'.tr} (simple)');
      print('✅ Susceptibility layer loaded with default renderer');
      
    } catch (e) {
      print('❌ Simple approach also failed: $e');
      _showError('susceptibility_not_available'.tr);
    }
  }

  // Show basemap gallery dialog (renamed from _showMapTypeDialog)
  void _showBasemapGallery() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(
            color: Colors.blue,
            padding: const EdgeInsets.all(16),
            child: Text(
              'basemap_gallery'.tr,
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          titlePadding: EdgeInsets.zero,
          contentPadding: const EdgeInsets.all(16),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.map),
                title: Text('openstreetmap'.tr),
                subtitle: Text('free_opensource_map'.tr),
                onTap: () {
                  Navigator.of(context).pop();
                  _setMapToOpenStreetMap();
                },
              ),
              
              // if (_apiKey != 'YOUR_API_KEY_HERE') ...[
              //   ListTile(
              //     leading: const Icon(Icons.location_city),
              //     title: const Text('Streets'),
              //     subtitle: const Text('Detailed street view'),
              //     onTap: () {
              //       Navigator.of(context).pop();
              //       _setMapType(BasemapStyle.arcGISStreets, 'Streets');
              //     },
              //   ),
              // ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('close'.tr),
            ),
          ],
        );
      },
    );
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

    _showError('recentered_to_india'.tr);
  } catch (e) {
    _showError('failed_to_recenter'.trParams({'error': e.toString()}));
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text('location'.tr),
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Map view
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
          
          // Right side navigation toolbar
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

                // Map layers button (show selection dialog)
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
                
                // Home/Center button (re-center to current location)
                Container(
                  margin: const EdgeInsets.only(bottom: 2),
                  child: FloatingActionButton(
                    heroTag: "home",
                    mini: true,
                    backgroundColor: Colors.blue,
                    onPressed: _ready ? _recenterToIndia : null,

                    child: const Icon(Icons.home, color: Colors.white),
                  ),
                ),
                
                // Compass/Navigation button (reset map rotation)
                Container(
                  margin: const EdgeInsets.only(bottom: 2),
                  child: FloatingActionButton(
                    heroTag: "navigation",
                    mini: true,
                    backgroundColor: Colors.blue,
                    onPressed: _ready ? _zoomToCurrentLocation : null,
                    child: const Icon(
                      Icons.my_location,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 80,
        color: Colors.grey.shade900,
        child: _isSelectingLocation
            ? // Show coordinate input boxes and tick button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    // Latitude input box
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade700,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'lat'.tr,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextField(
                              controller: _latController,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                                isDense: true,
                              ),
                              onChanged: (value) => _onCoordinateChanged(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Longitude input box
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade700,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'long'.tr,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextField(
                              controller: _longController,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                                isDense: true,
                              ),
                              onChanged: (value) => _onCoordinateChanged(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Confirm button
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.green.shade600,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: _proceedToReportForm,
                        icon: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : // Show REPORT LANDSLIDE button
              Center(
                child: TextButton(
                  onPressed: _startLandslideReporting,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Text('report_landslide'.tr),
                ),
              ),
      ),
    );
  }

  Future<void> _onMapViewReady() async {
    try {
      // Configure the graphics overlay for landslide location marker
      _graphicsOverlay.renderer = SimpleRenderer(
        symbol: SimpleMarkerSymbol(
          style: SimpleMarkerSymbolStyle.circle,
          color: Colors.red,
          size: 15,
        ),
      );

      // Add the graphics overlay to the map view
      _mapViewController.graphicsOverlays.add(_graphicsOverlay);

      // Assign the map to the map view controller
      _mapViewController.arcGISMap = _map;

      // Set up location display AFTER map is assigned
      _locationDisplay = _mapViewController.locationDisplay;
      
      // Configure location display properties
      _locationDisplay.autoPanMode = LocationDisplayAutoPanMode.recenter;
      _locationDisplay.initialZoomScale = 10000;

      // Create and configure a system location data source
      final locationDataSource = SystemLocationDataSource();
      _locationDisplay.dataSource = locationDataSource;

      // Set an initial viewpoint (Mumbai coordinates)
      _mapViewController.setViewpoint(
        Viewpoint.fromCenter(
          ArcGISPoint(x: 72.8777, y: 19.0760, spatialReference: SpatialReference.wgs84),
          scale: 100000,
        ),
      );

      // Enable the UI
      setState(() => _ready = true);
      
      // Automatically start location services to show current location
      await _startLocationAutomatically();
      
    } catch (e) {
      _showError('failed_initialize_map'.trParams({'error': e.toString()}));
    }
  }

  // MODIFIED: Handle map tap - always show marker regardless of selection mode
void _onMapTap(Offset screenPoint) async {
  try {
    final mapPoint = _mapViewController.screenToLocation(screen: screenPoint);
    if (mapPoint == null) {
      _showError('failed_to_get_coordinates'.tr);
      return;
    }

    print('🗺️ Raw map point: Lat=${mapPoint.y}, Lng=${mapPoint.x}, WKID=${mapPoint.spatialReference?.wkid}');
    
    // Check what coordinate system we're working with
    final currentWkid = mapPoint.spatialReference?.wkid;
    ArcGISPoint wgs84Point;
    
    if (currentWkid == 4326) {
      // Already in WGS84 (latitude/longitude)
      wgs84Point = mapPoint;
      print('✅ Point already in WGS84: Lat=${wgs84Point.y}, Lng=${wgs84Point.x}');
    } else if (currentWkid == 3857 || currentWkid == 102100) {
      // Web Mercator - need to convert to WGS84
      print('🔄 Converting from Web Mercator (${currentWkid}) to WGS84...');
      try {
        final projectedGeometry = await GeometryEngine.project(
          mapPoint,
          outputSpatialReference: SpatialReference.wgs84,
        );
        
        if (projectedGeometry is ArcGISPoint) {
          wgs84Point = projectedGeometry;
          print('✅ Successfully converted to WGS84: Lat=${wgs84Point.y}, Lng=${wgs84Point.x}');
        } else {
          throw Exception('Projection result is not a point');
        }
      } catch (projectionError) {
        print('❌ Projection failed: $projectionError');
        // Manual conversion from Web Mercator to WGS84 as fallback
        wgs84Point = _manualWebMercatorToWgs84(mapPoint);
        print('🔧 Manual conversion result: Lat=${wgs84Point.y}, Lng=${wgs84Point.x}');
      }
    } else {
      // Unknown coordinate system - try to project to WGS84
      print('⚠️ Unknown coordinate system (${currentWkid}), attempting projection...');
      try {
        final projectedGeometry = await GeometryEngine.project(
          mapPoint,
          outputSpatialReference: SpatialReference.wgs84,
        );
        
        if (projectedGeometry is ArcGISPoint) {
          wgs84Point = projectedGeometry;
          print('✅ Successfully projected unknown CRS to WGS84: Lat=${wgs84Point.y}, Lng=${wgs84Point.x}');
        } else {
          throw Exception('Projection result is not a point');
        }
      } catch (e) {
        print('❌ Projection failed for unknown CRS: $e');
        // Assume it's already in decimal degrees and create WGS84 point
        wgs84Point = ArcGISPoint(
          x: mapPoint.x,
          y: mapPoint.y,
          spatialReference: SpatialReference.wgs84,
        );
        print('🤷 Assuming decimal degrees: Lat=${wgs84Point.y}, Lng=${wgs84Point.x}');
      }
    }
    
    // Validate coordinates
    print('🔍 Validating coordinates: Lat=${wgs84Point.y}, Lng=${wgs84Point.x}');
    if (_isValidIndianCoordinate(wgs84Point.y, wgs84Point.x)) {
      setState(() {
        _selectedLandslideLocation = wgs84Point;
      });
      _updateLandslideLocationMarker();
      
      if (_isSelectingLocation) {
        _updateCoordinateFields();
      }
      
      print('✅ Valid coordinates selected: Lat=${wgs84Point.y}, Lng=${wgs84Point.x}');
      _showError('location_selected'.trParams({
        'lat': wgs84Point.y.toStringAsFixed(4),
        'lng': wgs84Point.x.toStringAsFixed(4),
      }));
    } else {
      _showError('invalid_location_bounds'.trParams({
        'lat': wgs84Point.y.toStringAsFixed(4),
        'lng': wgs84Point.x.toStringAsFixed(4),
      }));
      print('❌ Invalid coordinates: Lat=${wgs84Point.y}, Lng=${wgs84Point.x}');
    }
  } catch (e) {
    _showError('failed_map_coordinates'.trParams({'error': e.toString()}));
    print('❌ Map tap error: $e');
  }
}

// 2. MANUAL WEB MERCATOR TO WGS84 CONVERSION (fallback)
ArcGISPoint _manualWebMercatorToWgs84(ArcGISPoint webMercatorPoint) {
  // Web Mercator to WGS84 conversion formulas
  const double earthRadius = 6378137.0; // Earth radius in meters
  
  // Convert X (longitude)
  double longitude = webMercatorPoint.x / earthRadius;
  longitude = longitude * (180.0 / pi); // Convert radians to degrees
  
  // Convert Y (latitude)  
  double latitude = webMercatorPoint.y / earthRadius;
  latitude = atan(exp(latitude)) * 2.0 - (pi / 2.0);
  latitude = latitude * (180.0 / pi); // Convert radians to degrees
  
  return ArcGISPoint(
    x: longitude,
    y: latitude,
    spatialReference: SpatialReference.wgs84,
  );
}

// 3. IMPROVED VALIDATION with better bounds and logging
bool _isValidIndianCoordinate(double lat, double lng) {
  // India's actual bounds with some buffer:
  // Southernmost: Indira Point (Nicobar) ~6.45°N
  // Northernmost: Siachen Glacier ~35.7°N  
  // Westernmost: Sir Creek (Gujarat) ~68.1°E
  // Easternmost: Kibithu (Arunachal Pradesh) ~97.4°E
  
  const double minLat = 6.0;   // Below Indira Point
  const double maxLat = 38.0;  // Above Siachen
  const double minLng = 68.0;  // West of Sir Creek
  const double maxLng = 98.0;  // East of Kibithu
  
  bool latValid = lat >= minLat && lat <= maxLat;
  bool lngValid = lng >= minLng && lng <= maxLng;
  bool isValid = latValid && lngValid;
  
  print('🔍 Coordinate validation:');
  print('   Lat: $lat ${latValid ? "✅" : "❌"} (range: $minLat to $maxLat)');
  print('   Lng: $lng ${lngValid ? "✅" : "❌"} (range: $minLng to $maxLng)');
  print('   Result: ${isValid ? "VALID" : "INVALID"}');
  
  return isValid;
}

// 4. ENHANCED COORDINATE FIELD UPDATES
void _updateCoordinateFields() {
  if (_selectedLandslideLocation != null) {
    double lat = _selectedLandslideLocation!.y;
    double lng = _selectedLandslideLocation!.x;
    
    print('📍 Updating coordinate fields:');
    print('   Selected location: Lat=$lat, Lng=$lng');
    print('   Spatial reference: ${_selectedLandslideLocation!.spatialReference?.wkid}');
    
    // Ensure we have WGS84 coordinates
    if (_selectedLandslideLocation!.spatialReference?.wkid != 4326) {
      print('⚠️ Selected location is not in WGS84! Converting...');
      // This shouldn't happen with the improved _onMapTap, but just in case
      try {
        final converted = _manualWebMercatorToWgs84(_selectedLandslideLocation!);
        lat = converted.y;
        lng = converted.x;
        print('🔧 Converted coordinates: Lat=$lat, Lng=$lng');
      } catch (e) {
        print('❌ Conversion failed: $e');
      }
    }
    
    if (_isValidIndianCoordinate(lat, lng)) {
      _latController.text = lat.toStringAsFixed(6);
      _longController.text = lng.toStringAsFixed(6);
      print('✅ Coordinate fields updated successfully');
    } else {
      _showError('Invalid coordinates detected during field update');
      print('❌ Invalid coordinates during field update: Lat=$lat, Lng=$lng');
    }
  } else {
    // Fallback to current location
    final location = _locationDisplay.location;
    final lat = location?.position?.y ?? 0.0;
    final lng = location?.position?.x ?? 0.0;
    
    print('📍 Using current location fallback: Lat=$lat, Lng=$lng');
    
    if (lat != 0.0 && lng != 0.0 && _isValidIndianCoordinate(lat, lng)) {
      _latController.text = lat.toStringAsFixed(6);
      _longController.text = lng.toStringAsFixed(6);
      print('✅ Used current location for coordinate fields');
    } else {
      print('❌ Current location is invalid or unavailable');
    }
  }
}


  // Handle coordinate input changes
  void _onCoordinateChanged() {
    final lat = double.tryParse(_latController.text);
    final long = double.tryParse(_longController.text);
    
    if (lat != null && long != null && lat >= -90 && lat <= 90 && long >= -180 && long <= 180) {
      setState(() {
        _selectedLandslideLocation = ArcGISPoint(
          x: long, 
          y: lat, 
          spatialReference: SpatialReference.wgs84,
        );
      });
      _updateLandslideLocationMarker();
      
      // Move map to new location
      _mapViewController.setViewpointCenter(
        _selectedLandslideLocation!,
        scale: 10000,
      );
    }
  }

  // 6. ADD THE MISSING _updateLandslideLocationMarker METHOD
void _updateLandslideLocationMarker() {
  _graphicsOverlay.graphics.clear();
  
  if (_selectedLandslideLocation != null) {
    final graphic = Graphic(
      geometry: _selectedLandslideLocation!,
      symbol: SimpleMarkerSymbol(
        style: SimpleMarkerSymbolStyle.circle,
        color: Colors.red,
        size: 15,
      ),
    );
    _graphicsOverlay.graphics.add(graphic);
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
        _showError('map_rotation_reset'.tr);
      }
    } catch (e) {
      _showError('failed_to_reset_rotation'.trParams({'error': e.toString()}));
    }
  }

  // Start the landslide reporting flow
  void _startLandslideReporting() {
    _showLocationInfoDialog();
  }

  // Step 1: Location Info Dialog
  void _showLocationInfoDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'location'.tr,
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: Text(
            'location_info_dialog'.tr,
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showAttentionDialog();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: Text('ok'.tr),
            ),
          ],
        );
      },
    );
  }

  // Step 2: Attention Dialog
  void _showAttentionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'attention'.tr,
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          content: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 16, color: Colors.black),
              children: [
                TextSpan(text: 'attention_dialog'.tr),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue,
              ),
              child: Text('back'.tr),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showSusceptibilityDialog();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: Text('ok'.tr),
            ),
          ],
        );
      },
    );
  }

  //   // Step 3: Susceptibility Dialog
  void _showSusceptibilityDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'message'.tr,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content: Text(
            'susceptibility_dialog'.tr,
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // User clicked NO - stay on map and enable location selection
                _enableLocationSelection();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: Text('no'.tr),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();

                // User clicked YES - load susceptibility data and enable location selection
                _loadSusceptibilityDataAndEnableSelection();

              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: Text('yes'.tr),
            ),
          ],
        );
      },
    );
  }


  // Load susceptibility data and enable location selection
  Future<void> _loadSusceptibilityDataAndEnableSelection() async {
    // Load the government geological data layers
    _loadSusceptibilityLayer();
    
    // Enable location selection
    _enableLocationSelection();
  }

  // MODIFIED: Enable location selection and show coordinate fields with selected location
  void _enableLocationSelection() {
    setState(() {
      _isSelectingLocation = true;
    });
    
    // Initialize coordinate fields with selected location or current location
    _updateCoordinateFields();
    
    // Show instruction toast that disappears after 1 second
    ScaffoldMessenger.of(context).clearSnackBars();
    _showError('tap_to_select'.tr);
  }

  // Step 4: Proceed to Report Form
// 5. ENHANCED REPORT FORM PROCESSING
Future<void> _proceedToReportForm() async {
  setState(() {
    _isSelectingLocation = false;
  });

  print('🚀 Starting report form process...');
  
  // Get coordinates from text fields
  double? reportLat = double.tryParse(_latController.text);
  double? reportLng = double.tryParse(_longController.text);
  
  print('📝 Coordinates from text fields:');
  print('   Lat field: "${_latController.text}" → parsed: $reportLat');
  print('   Lng field: "${_longController.text}" → parsed: $reportLng');
  
  // Fallback logic
  if (reportLat == null || reportLng == null || reportLat == 0.0 || reportLng == 0.0) {
    print('🔄 Using fallback coordinate sources...');
    
    if (_selectedLandslideLocation != null) {
      // Ensure selected location is in WGS84
      if (_selectedLandslideLocation!.spatialReference?.wkid == 4326) {
        reportLat = _selectedLandslideLocation!.y;
        reportLng = _selectedLandslideLocation!.x;
        print('✅ Using selected location: Lat=$reportLat, Lng=$reportLng');
      } else {
        // Convert if needed
        final converted = _manualWebMercatorToWgs84(_selectedLandslideLocation!);
        reportLat = converted.y;
        reportLng = converted.x;
        print('🔧 Using converted selected location: Lat=$reportLat, Lng=$reportLng');
      }
    } else {
      // Use current location
      final currentLocation = _locationDisplay.location?.position;
      reportLat = currentLocation?.y ?? 19.0760; // Mumbai fallback
      reportLng = currentLocation?.x ?? 72.8777;
      print('📍 Using current location: Lat=$reportLat, Lng=$reportLng');
    }
  }
  
  print('🎯 Final coordinates for validation: Lat=$reportLat, Lng=$reportLng');
  
  // Final validation
  if (!_isValidIndianCoordinate(reportLat!, reportLng!)) {
    _showError('invalid_location_validation'.trParams({
      'lat': reportLat.toStringAsFixed(4),
      'lng': reportLng.toStringAsFixed(4),
    }));
    print('❌ Final validation failed');
    return;
  }

  print('✅ Validation passed! Proceeding to report form...');

  try {
    final prefs = await SharedPreferences.getInstance();
    final userType = prefs.getString('userType') ?? 'Public';
    
    // ✅ FIX: Use Get.arguments instead of constructor parameters
    final arguments = {
      'latitude': reportLat,
      'longitude': reportLng,
    };
    
    print('📦 Passing arguments to form: $arguments');
    
    if (userType == 'Public') {
      // ✅ CORRECTED: Pass arguments using Get.arguments
      Get.to(() => PublicLandslideReportingScreen(latitude: reportLat as double,
    longitude: reportLng as double,), arguments: arguments);
    } else {
      // ✅ CORRECTED: Pass arguments using Get.arguments  
      Get.to(() => LandslideReportingScreen(latitude: reportLat as double,
    longitude: reportLng as double,), arguments: arguments);
    }
    print('✅ Successfully navigated to report form with arguments');
  } catch (e) {
    print('❌ Error during navigation: $e');
    // Fallback to public form with arguments
    Get.to(() => PublicLandslideReportingScreen(latitude: reportLat as double,
    longitude: reportLng as double,), arguments: {
      'latitude': reportLat!,
      'longitude': reportLng!,
    });
  }
}
  // Automatically start location services when map is ready
  Future<void> _startLocationAutomatically() async {
    try {
      _locationDisplay.start();
      _showError('current_location_loaded'.tr);
    } catch (e) {
      _showError('failed_current_location'.trParams({'error': e.toString()}));
    }
  }

  Future<void> _zoomToCurrentLocation() async {
    try {
      // Ensure location display is running
      if (!_locationDisplay.started) {
        _locationDisplay.start();
      }
      
      final location = _locationDisplay.location;
      if (location?.position != null) {
        await _mapViewController.setViewpointCenter(
          location!.position!,
          scale: 10000,
        );
        _showError('recentered_to_current'.tr);
      } else {
        // If location is not immediately available, wait a moment and try again
        await Future.delayed(const Duration(milliseconds: 1000));
        final updatedLocation = _locationDisplay.location;
        if (updatedLocation?.position != null) {
          await _mapViewController.setViewpointCenter(
            updatedLocation!.position!,
            scale: 10000,
          );
          _showError('recentered_to_current'.tr);
        } else {
          _showError('location_not_available'.tr);
        }
      }
    } catch (e) {
      _showError('failed_to_recenter'.trParams({'error': e.toString()}));
    }
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
      _showError('failed_to_zoom_in'.trParams({'error': e.toString()}));
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
      _showError('failed_to_zoom_out'.trParams({'error': e.toString()}));
    }
  }

  // Set map back to OpenStreetMap
  void _setMapToOpenStreetMap() {
    try { 
      _showError('switched_to_osm'.tr);
    } catch (e) {
      _showError('failed_to_change_map'.trParams({'error': e.toString()}));
    }
  }


}