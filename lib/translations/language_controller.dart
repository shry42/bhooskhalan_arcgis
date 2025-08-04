import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {
  static const String _languageKey = 'selected_language';
  static const String _countryKey = 'selected_country';

  // Supported locales
  static const Locale englishLocale = Locale('en', 'US');
  static const Locale hindiLocale = Locale('hi', 'IN');

  static List<Locale> get supportedLocales => [englishLocale, hindiLocale];

  // Reactive variable to track current locale
  final Rx<Locale> currentLocale = englishLocale.obs;

  /// Called in `main.dart` before `runApp()` to set saved locale
  Future<void> loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString(_languageKey);
    final savedCountry = prefs.getString(_countryKey);

    if (savedLanguage != null && savedCountry != null) {
      final locale = Locale(savedLanguage, savedCountry);
      currentLocale.value = locale;
      Get.updateLocale(locale);
    } else {
      await changeToEnglish(); // default fallback
    }
  }

  /// General method to change and persist language
  Future<void> changeLanguage(String languageCode, String countryCode) async {
    final locale = Locale(languageCode, countryCode);
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_languageKey, languageCode);
    await prefs.setString(_countryKey, countryCode);

    currentLocale.value = locale;
    Get.updateLocale(locale);
    update(); // Notify any GetBuilder/Obx widgets
  }

  /// English language shortcut
  Future<void> changeToEnglish() async {
    await changeLanguage('en', 'US');
  }

  /// Hindi language shortcut
  Future<void> changeToHindi() async {
    await changeLanguage('hi', 'IN');
  }

  /// Language status flags
  bool get isEnglish => currentLocale.value.languageCode == 'en';
  bool get isHindi => currentLocale.value.languageCode == 'hi';

  /// For displaying current language in UI
  String get currentLanguageName {
    if (isHindi) return 'हिन्दी';
    return 'English';
  }
}
