import 'package:bhooskhalann/services/api_service.dart';
import 'package:bhooskhalann/translations/language_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bhooskhalann/screens/homescreen.dart';
import 'package:bhooskhalann/screens/login_register_pages/login_register_screen.dart';
import 'package:bhooskhalann/translations/app_translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ApiService.initialize();
  
  // Initialize Language Controller
  Get.put(LanguageController());
  
  // Check if user is logged in
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');
  
  runApp(MyApp(isLoggedIn: token != null && token.isNotEmpty));
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
      locale: const Locale('en', 'US'), // Default locale
      fallbackLocale: const Locale('en', 'US'), // Fallback if locale not found
      
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        // Support for Devanagari fonts
        fontFamily: 'Roboto',
      ),
      
      home: isLoggedIn ? HomeScreen() : LoginRegisterScreen(),
    );
  }
}






//VAPT TEST

// import 'package:bhooskhalann/services/api_service.dart';
// import 'package:bhooskhalann/services/security_service.dart';
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
  
//   // Initialize Language Controller
//   Get.put(LanguageController());
  
//   // Check if user is logged in
//   final prefs = await SharedPreferences.getInstance();
//   final String? token = prefs.getString('token');
  
//   runApp(MyApp(isLoggedIn: token != null && token.isNotEmpty));
// }

// class MyApp extends StatelessWidget {
//   final bool isLoggedIn;
  
//   const MyApp({super.key, required this.isLoggedIn});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'app_title'.tr,
      
//       // GetX Translations
//       translations: AppTranslations(),
//       locale: const Locale('en', 'US'), // Default locale
//       fallbackLocale: const Locale('en', 'US'), // Fallback if locale not found
      
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
//         useMaterial3: true,
//         // Support for Devanagari fonts
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
  
//   @override
//   void initState() {
//     super.initState();
//     _performSecurityCheck();
//   }
  
//   Future<void> _performSecurityCheck() async {
//     try {
//       bool isCompromised = await SecurityService.isDeviceCompromised();
      
//       setState(() {
//         _isSecure = !isCompromised;
//         _isLoading = false;
//         if (isCompromised) {
//           _errorMessage = 'security_warning_message'.tr.isNotEmpty 
//               ? 'security_warning_message'.tr 
//               : 'This application cannot run on rooted devices or devices with developer mode enabled for security reasons.';
//         }
//       });
//     } catch (e) {
//       setState(() {
//         _isSecure = false; // Fail secure
//         _isLoading = false;
//         _errorMessage = 'security_check_failed'.tr.isNotEmpty 
//             ? 'security_check_failed'.tr 
//             : 'Security check failed. Please ensure you are using a standard device configuration.';
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
//                 'security_check_progress'.tr.isNotEmpty 
//                     ? 'security_check_progress'.tr 
//                     : 'Performing security checks...',
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
//       return SecurityWarningScreen(errorMessage: _errorMessage);
//     }
    
//     // Security check passed, proceed to original app flow
//     return widget.isLoggedIn ? HomeScreen() : LoginRegisterScreen();
//   }
// }

// class SecurityWarningScreen extends StatelessWidget {
//   final String errorMessage;
  
//   const SecurityWarningScreen({super.key, required this.errorMessage});
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.red[50],
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons.security,
//                 size: 100,
//                 color: Colors.red[600],
//               ),
//               const SizedBox(height: 30),
//               Text(
//                 'security_warning_title'.tr.isNotEmpty 
//                     ? 'security_warning_title'.tr 
//                     : 'Security Warning',
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.red[700],
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 errorMessage,
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.red[600],
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 30),
//               Text(
//                 'security_instruction'.tr.isNotEmpty 
//                     ? 'security_instruction'.tr 
//                     : 'Please use this application on a standard device configuration.',
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.red[500],
//                 ),
//                 textAlign: TextAlign.center,
//               ),
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
//                       'retry_button'.tr.isNotEmpty 
//                           ? 'retry_button'.tr 
//                           : 'Retry',
//                       style: const TextStyle(color: Colors.white),
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       SystemNavigator.pop(); // Close the app
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.red[600],
//                       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                     ),
//                     child: Text(
//                       'exit_button'.tr.isNotEmpty 
//                           ? 'exit_button'.tr 
//                           : 'Exit Application',
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
// }