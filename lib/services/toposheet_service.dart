class ToposheetService {
  /// Calculate toposheet number from latitude and longitude coordinates
  /// Based on Survey of India toposheet numbering system
  static String calculateToposheetNumber(double latitude, double longitude) {
    try {
      // Convert to Survey of India grid system
      // India uses 1:50,000 scale toposheets
      
      // Calculate the sheet number based on lat/lng
      // This is a simplified calculation - in practice, you might need more complex logic
      // based on the specific Survey of India grid system
      
      // For 1:50,000 scale sheets in India
      // Each sheet covers approximately 15' x 15' (0.25° x 0.25°)
      
      // Calculate sheet indices
      double latDegrees = latitude;
      double lngDegrees = longitude;
      
      // India's lat range: approximately 6.5°N to 37.5°N
      // India's lng range: approximately 68°E to 97.5°E
      
      // Calculate row number (from north to south)
      int row = ((37.5 - latDegrees) / 0.25).floor() + 1;
      
      // Calculate column number (from west to east)  
      int col = ((lngDegrees - 68.0) / 0.25).floor() + 1;
      
      // Format as toposheet number (e.g., "53H/12", "45D/7", etc.)
      // This is a simplified format - actual SOI format might be different
      String toposheetNumber = "${row.toString().padLeft(2, '0')}H/${col.toString().padLeft(2, '0')}";
      
      // Validate the calculated toposheet number
      if (row < 1 || row > 125 || col < 1 || col > 120) {
        // If outside India's bounds, return a default or error
        return "OUT_OF_BOUNDS";
      }
      
      return toposheetNumber;
      
    } catch (e) {
      print('Error calculating toposheet number: $e');
      return "CALCULATION_ERROR";
    }
  }
  
  /// Alternative method using more precise Survey of India grid calculation
  static String calculateToposheetNumberPrecise(double latitude, double longitude) {
    try {
      // More accurate calculation based on SOI grid system
      // This uses the actual Survey of India grid parameters
      
      // For 1:50,000 scale toposheets
      const double sheetSizeLat = 0.25; // 15 minutes
      const double sheetSizeLng = 0.25; // 15 minutes
      
      // India's reference points
      const double southLat = 6.0;  // Southern boundary
      const double westLng = 68.0;  // Western boundary
      
      // Calculate sheet indices
      int latIndex = ((latitude - southLat) / sheetSizeLat).floor();
      int lngIndex = ((longitude - westLng) / sheetSizeLng).floor();
      
      // Convert to SOI sheet numbering
      // Rows are numbered from south to north (1-125)
      // Columns are numbered from west to east (1-120)
      int row = latIndex + 1;
      int col = lngIndex + 1;
      
      // Validate bounds
      if (row < 1 || row > 125 || col < 1 || col > 120) {
        return "OUT_OF_BOUNDS";
      }
      
      // Format as toposheet number
      // Using a simplified format - actual SOI format includes more details
      String toposheetNumber = "${row.toString().padLeft(3, '0')}H/${col.toString().padLeft(3, '0')}";
      
      return toposheetNumber;
      
    } catch (e) {
      print('Error in precise toposheet calculation: $e');
      return "CALCULATION_ERROR";
    }
  }
  
  /// Validate if coordinates are within India's boundaries
  static bool isWithinIndiaBounds(double latitude, double longitude) {
    return latitude >= 6.0 && latitude <= 37.5 && 
           longitude >= 68.0 && longitude <= 97.5;
  }
  
  /// Get toposheet number with validation
  static String getToposheetNumber(double latitude, double longitude) {
    if (!isWithinIndiaBounds(latitude, longitude)) {
      return "OUT_OF_BOUNDS";
    }
    
    // Try precise calculation first
    String preciseResult = calculateToposheetNumberPrecise(latitude, longitude);
    if (preciseResult != "CALCULATION_ERROR" && preciseResult != "OUT_OF_BOUNDS") {
      return preciseResult;
    }
    
    // Fallback to basic calculation
    return calculateToposheetNumber(latitude, longitude);
  }
}
