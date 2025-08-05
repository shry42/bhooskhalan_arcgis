# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Essential Flutter Commands
- `flutter pub get` - Install dependencies after modifying pubspec.yaml
- `flutter clean` - Clean build cache and generated files
- `flutter pub upgrade` - Upgrade all dependencies to latest compatible versions

### Building and Testing
- `flutter run` - Run the app in debug mode on connected device/emulator
- `flutter run --release` - Run optimized release build
- `flutter build apk` - Build Android APK
- `flutter build ios` - Build iOS app (requires macOS and Xcode)
- `flutter test` - Run unit and widget tests
- `flutter analyze` - Run static code analysis

### Platform-Specific Development
- `flutter run -d android` - Run on Android device specifically
- `flutter run -d ios` - Run on iOS device specifically
- `flutter doctor` - Check Flutter environment setup
- `flutter doctor --android-licenses` - Accept Android SDK licenses

## Project Architecture

### App Structure
This is a Flutter application called "Bhooskhalann" - a landslide reporting and information system. The app follows a modular architecture with clear separation of concerns:

**Core Technologies:**
- Flutter 3.29.3 with Dart 3.7.2
- GetX for state management, routing, and dependency injection
- Multilingual support (English/Hindi) with GetX translations
- Secure API communication with SSL certificate pinning

### Key Directories and Their Purpose

**`lib/landslide/`** - Core landslide-related functionality
- `all_reports/` - View all landslide reports with detailed report screens
- `forecast/` - Weather and landslide forecast bulletins with date controllers
- `report_landslide_maps_screen/` - Main reporting interface with map integration
  - `maps/` - ArcGIS and Google Maps implementations
  - `report_form_getx/` - Form controllers and screens with draft support
  - `widgets/` - Reusable form components for landslide reporting

**`lib/screens/`** - Authentication and core UI screens
- `login_register_pages/` - User authentication flows
- `expert_login_screens/` & `public_login_screens/` - Role-based login
- `register_screens/` - Separate registration flows for experts and public users
- `news/` - News viewing with PDF support and webview integration
- `forgot_password_screens/` - Password recovery flow

**`lib/services/`** - Backend and utility services
- `api_service.dart` - Secure API client with SSL pinning to `bhusanket.gsi.gov.in`
- `pdf_export_service.dart` - PDF generation and export functionality
- `security_service.dart` - Security checks and device verification

**`lib/translations/`** - Internationalization
- Uses GetX translations for English/Hindi support
- `language_controller.dart` manages locale persistence

### State Management Pattern
The app uses GetX throughout for:
- Controllers for business logic (suffix: `_controller.dart`)
- Reactive state management with `.obs` variables
- Dependency injection with `Get.put()` and `Get.find()`
- Navigation with `Get.to()`, `Get.off()`, etc.

### Security Implementation
- SSL certificate pinning for API calls
- Device security checks (emulator detection, root detection)
- Secure storage for authentication tokens
- Security warning screens for compromised devices

### Map Integration
Dual map provider support:
- ArcGIS Maps for professional GIS functionality
- Google Maps as alternative mapping solution
- Location services with permission handling

### Important Dependencies
- `arcgis_maps: ^200.7.0+4560` - Professional GIS mapping
- `google_maps_flutter: ^2.12.3` - Google Maps integration
- `get: ^4.7.2` - State management and routing
- `http_certificate_pinning: ^3.0.1` - API security
- `syncfusion_flutter_pdfviewer: ^29.2.8` - PDF viewing capabilities
- `location: ^8.0.0` & `geolocator: ^13.0.2` - Location services

### Testing
- Widget tests are currently commented out in `test/widget_test.dart`
- Use `flutter test` to run tests when implemented
- `flutter analyze` for static analysis using rules from `analysis_options.yaml`

### Authentication Flow
The app supports two user types:
1. **Public Users** - General landslide reporting
2. **Expert Users** - Advanced features and validation

Token-based authentication with SharedPreferences persistence determines the initial app route (HomeScreen vs LoginRegisterScreen).