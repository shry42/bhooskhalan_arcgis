import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {
  static const String _languageKey = 'selected_language';
  static const String _countryKey = 'selected_country';
  
  // Available locales
  static const Locale englishLocale = Locale('en', 'US');
  static const Locale hindiLocale = Locale('hi', 'IN');
  
  static List<Locale> get supportedLocales => [englishLocale, hindiLocale];
  
  @override
  void onInit() {
    super.onInit();
    _loadSavedLanguage();
  }
  
  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString(_languageKey);
    final savedCountry = prefs.getString(_countryKey);
    
    if (savedLanguage != null && savedCountry != null) {
      final locale = Locale(savedLanguage, savedCountry);
      Get.updateLocale(locale);
    }
  }
  
  Future<void> changeLanguage(String languageCode, String countryCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
    await prefs.setString(_countryKey, countryCode);
    
    final locale = Locale(languageCode, countryCode);
    Get.updateLocale(locale);
  }
  
  Future<void> changeToEnglish() async {
    await changeLanguage('en', 'US');
  }
  
  Future<void> changeToHindi() async {
    await changeLanguage('hi', 'IN');
  }
  
  bool get isEnglish => Get.locale?.languageCode == 'en';
  bool get isHindi => Get.locale?.languageCode == 'hi';
  
  String get currentLanguageName {
    if (isHindi) return 'हिन्दी';
    return 'English';
  }
}