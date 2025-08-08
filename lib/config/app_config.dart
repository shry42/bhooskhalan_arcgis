class AppConfig {
  // App Store ID - Replace with your actual App Store ID when you publish
  // You can find this in App Store Connect or by looking at your app's App Store URL
  static const String appStoreId = '6670397794'; // Your actual App Store ID
  
  // App Store URL
  static const String appStoreUrl = 'https://apps.apple.com/app/id$appStoreId';
  
  // App Bundle ID (from pubspec.yaml or package_info)
  static const String bundleId = 'C3LP7V393P.in.gov.gsi.bhooskhalan';
  
  // App Name
  static const String appName = 'Bhooskhalan';
  
  // Update check interval (in days)
  static const int updateCheckIntervalDays = 1;
  
  // Whether to show update dialog on app start
  static const bool showUpdateDialogOnStart = true;
  
  // Whether to check for updates silently on app start
  static const bool checkUpdatesSilentlyOnStart = true;
}
