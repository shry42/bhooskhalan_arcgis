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

