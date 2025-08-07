// DEVELOPMENT VERSION - COMMENTED OUT FOR PRODUCTION
import 'package:bhooskhalann/services/api_service.dart';
import 'package:bhooskhalann/services/native_in_app_update_service.dart';
import 'package:bhooskhalann/translations/language_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bhooskhalann/screens/homescreen.dart';
import 'package:bhooskhalann/screens/login_register_pages/login_register_screen.dart';
import 'package:bhooskhalann/translations/app_translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  ApiService.initialize();

  // Initialize Language Controller
  final languageController = Get.put(LanguageController());
  await languageController.loadSavedLanguage(); // <-- Load saved locale

  // Check if user is logged in
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');

  runApp(MyApp(
    isLoggedIn: token != null && token.isNotEmpty,
  ));

  // Check for app updates after a delay (to not interfere with app startup)
  Future.delayed(Duration(seconds: 3), () {
    NativeInAppUpdateService.checkForUpdatesSilently();
  });
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'app_title'.tr,

      // GetX Translations
      translations: AppTranslations(),
      locale: Get.locale ?? const Locale('en', 'US'), // <-- Use loaded locale
      fallbackLocale: const Locale('en', 'US'),

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),

      home: isLoggedIn ? HomeScreen() : LoginRegisterScreen(),
    );
  }
}







//VAPT TEST - PRODUCTION VERSION

// import 'package:bhooskhalann/services/api_service.dart';
// import 'package:bhooskhalann/services/security_service.dart';
// import 'package:bhooskhalann/services/native_in_app_update_service.dart';
// import 'package:bhooskhalann/translations/language_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:bhooskhalann/screens/homescreen.dart';
// import 'package:bhooskhalann/screens/login_register_pages/login_register_screen.dart';
// import 'package:bhooskhalann/translations/app_translations.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   ApiService.initialize();
  
//   // Initialize Language Controller with persistence
//   final languageController = Get.put(LanguageController());
//   await languageController.loadSavedLanguage(); // Load saved language preference
  
//   // Check if user is logged in
//   final prefs = await SharedPreferences.getInstance();
//   final String? token = prefs.getString('token');
  
//   runApp(MyApp(isLoggedIn: token != null && token.isNotEmpty));

//   // Check for app updates after a delay (to not interfere with app startup)
//   Future.delayed(Duration(seconds: 3), () {
//     NativeInAppUpdateService.checkForUpdatesSilently();
//   });
// }

// class MyApp extends StatelessWidget {
//   final bool isLoggedIn;
  
//   const MyApp({super.key, required this.isLoggedIn});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'app_title'.tr,
      
//       // GetX Translations with language persistence
//       translations: AppTranslations(),
//       locale: Get.locale ?? const Locale('en', 'US'), // Use loaded locale
//       fallbackLocale: const Locale('en', 'US'),
      
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
//         useMaterial3: true,
//         fontFamily: 'Roboto',
//       ),
      
//       home: SecurityCheckScreen(isLoggedIn: isLoggedIn),
//     );
//   }
// }

// class SecurityCheckScreen extends StatefulWidget {
//   final bool isLoggedIn;
  
//   const SecurityCheckScreen({super.key, required this.isLoggedIn});
  
//   @override
//   _SecurityCheckScreenState createState() => _SecurityCheckScreenState();
// }

// class _SecurityCheckScreenState extends State<SecurityCheckScreen> {
//   bool _isLoading = true;
//   bool _isSecure = false;
//   String _errorMessage = '';
//   Map<String, bool> _detailedChecks = {};
  
//   @override
//   void initState() {
//     super.initState();
//     _performSecurityCheck();
//   }
  
//   Future<void> _performSecurityCheck() async {
//     try {
//       // ✅ Get comprehensive security analysis
//       SecurityCheckResult result = await SecurityService.performComprehensiveSecurityCheck();
      
//       setState(() {
//         _isSecure = result.isSecure;
//         _isLoading = false;
//         _detailedChecks = result.detailedChecks;
        
//         if (!result.isSecure) {
//           if (result.isEmulator) {
//             _errorMessage = 'EMULATOR DETECTED: This application cannot run on emulator devices for security compliance. VAPT Test Status: EMULATOR DETECTION WORKING ✓';
//           } else if (result.isRooted) {
//             _errorMessage = 'SECURITY RISK DETECTED: This application cannot run on rooted/compromised devices for security reasons.';
//           } else {
//             _errorMessage = 'SECURITY CHECK FAILED: Unknown security issue detected.';
//           }
//         }
//       });
//     } catch (e) {
//       setState(() {
//         _isSecure = false;
//         _isLoading = false;
//         _errorMessage = 'SECURITY CHECK ERROR: Failed to verify device security. Contact support.';
//       });
//     }
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return Scaffold(
//         backgroundColor: Theme.of(context).colorScheme.surface,
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               CircularProgressIndicator(
//                 color: Theme.of(context).colorScheme.primary,
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 'vapt_security_checks'.tr,
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Theme.of(context).colorScheme.onSurface,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
    
//     if (!_isSecure) {
//       return VAPTSecurityWarningScreen(
//         errorMessage: _errorMessage,
//         detailedChecks: _detailedChecks,
//       );
//     }
    
//     // Security check passed, proceed to original app flow
//     return widget.isLoggedIn ? HomeScreen() : LoginRegisterScreen();
//   }
// }

// class VAPTSecurityWarningScreen extends StatelessWidget {
//   final String errorMessage;
//   final Map<String, bool> detailedChecks;
  
//   const VAPTSecurityWarningScreen({
//     super.key, 
//     required this.errorMessage,
//     required this.detailedChecks,
//   });
  
//   @override
//   Widget build(BuildContext context) {
//     bool isEmulatorDetected = detailedChecks['emulator'] == true || 
//                               detailedChecks['enhancedEmulator'] == true;
    
//     return Scaffold(
//       backgroundColor: isEmulatorDetected ? Colors.orange[50] : Colors.red[50],
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // ✅ VAPT Testing Status Indicator
//               Container(
//                 padding: EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: isEmulatorDetected ? Colors.orange[100] : Colors.red[100],
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(
//                     color: isEmulatorDetected ? Colors.orange[300]! : Colors.red[300]!,
//                     width: 2,
//                   ),
//                 ),
//                 child: Column(
//                   children: [
//                     Text(
//                       '🔒 VAPT SECURITY TEST',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: isEmulatorDetected ? Colors.orange[800] : Colors.red[800],
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     Text(
//                       isEmulatorDetected 
//                         ? '✅ EMULATOR DETECTION: WORKING'
//                         : '❌ SECURITY VIOLATION DETECTED',
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                         color: isEmulatorDetected ? Colors.orange[700] : Colors.red[700],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
              
//               SizedBox(height: 30),
              
//               Icon(
//                 Icons.security,
//                 size: 100,
//                 color: isEmulatorDetected ? Colors.orange[600] : Colors.red[600],
//               ),
//               const SizedBox(height: 30),
//               Text(
//                 'security_warning'.tr,
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                   color: isEmulatorDetected ? Colors.orange[700] : Colors.red[700],
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 errorMessage,
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: isEmulatorDetected ? Colors.orange[600] : Colors.red[600],
//                 ),
//                 textAlign: TextAlign.center,
//               ),
              
//               // ✅ Detailed Check Results for VAPT
//               if (detailedChecks.isNotEmpty) ...[
//                 const SizedBox(height: 30),
//                 Container(
//                   padding: EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.grey[100],
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'security_check_results'.tr,
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.grey[700],
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       ...detailedChecks.entries.map((entry) {
//                         return Padding(
//                           padding: EdgeInsets.symmetric(vertical: 2),
//                           child: Text(
//                             '• ${_getCheckDisplayName(entry.key)}: ${entry.value ? "DETECTED" : "SAFE"}',
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: entry.value ? Colors.red[600] : Colors.green[600],
//                               fontFamily: 'monospace',
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                     ],
//                   ),
//                 ),
//               ],
              
//               const SizedBox(height: 40),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {
//                       // Retry security check
//                       Get.off(() => SecurityCheckScreen(isLoggedIn: false));
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.orange[600],
//                       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                     ),
//                     child: Text(
//                       'retry_check'.tr,
//                       style: const TextStyle(color: Colors.white),
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       SystemNavigator.pop();
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: isEmulatorDetected ? Colors.orange[600] : Colors.red[600],
//                       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                     ),
//                     child: Text(
//                       'exit_app'.tr,
//                       style: const TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
  
//   String _getCheckDisplayName(String checkKey) {
//     switch (checkKey) {
//       case 'developerMode': return 'Developer Mode';
//       case 'debugging': return 'ADB Debugging';
//       case 'rootFiles': return 'Root Files';
//       case 'rootApps': return 'Root Apps';
//       case 'systemProperties': return 'System Properties';
//       case 'emulator': return 'Basic Emulator';
//       case 'enhancedEmulator': return 'Enhanced Emulator';
//       case 'jailbreak': return 'Jailbreak';
//       case 'simulator': return 'iOS Simulator';
//       default: return checkKey;
//     }
//   }
// }