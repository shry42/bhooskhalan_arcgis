# 🏔️ Bhooskhalan - Landslide Reporting & Management System

[![Flutter](https://img.shields.io/badge/Flutter-3.7.2-blue.svg)](https://flutter.dev/)
[![Android](https://img.shields.io/badge/Android-15+-green.svg)](https://developer.android.com/)
[![iOS](https://img.shields.io/badge/iOS-12+-lightgrey.svg)](https://developer.apple.com/ios/)
[![License](https://img.shields.io/badge/License-Govt%20of%20India-red.svg)](https://www.gsi.gov.in/)

> **Bhooskhalan** is a comprehensive landslide reporting and management system developed for the Geological Survey of India (GSI). The app enables citizens and experts to report landslide incidents, view real-time data, and access critical geological information.

## 📱 Features

### 🚨 **Landslide Reporting**
- **Expert Reports**: Comprehensive geological data collection
- **Public Reports**: Simplified citizen reporting interface
- **Real-time GPS**: Automatic location detection
- **Photo Documentation**: Multiple image capture with captions
- **Offline Support**: Report submission even without internet

### 🗺️ **Interactive Maps**
- **ArcGIS Integration**: Professional mapping capabilities
- **Google Maps**: Alternative mapping solution
- **Real-time Data**: Live landslide reports visualization
- **Geographic Analysis**: Location-based insights

### 📊 **Data Management**
- **Draft Reports**: Save and edit reports offline
- **Report History**: Track all submitted reports
- **Data Export**: PDF generation and sharing
- **Cloud Sync**: Automatic data synchronization

### 🔄 **Smart Updates**
- **In-App Updates**: Seamless app updates via Google Play
- **Background Sync**: Automatic data synchronization
- **Version Management**: Smart update notifications

### 🌐 **Multi-Language Support**
- **English**: Primary language
- **Hindi**: भारतीय भाषा समर्थन
- **Bengali**: বাংলা ভাষা সমর্থন
- **Dynamic Switching**: Runtime language changes

## 🏗️ **Architecture**

### **Frontend (Flutter)**
- **State Management**: GetX for reactive programming
- **UI Framework**: Material Design 3
- **Navigation**: GetX routing
- **Localization**: Multi-language support

### **Backend Integration**
- **REST API**: HTTP-based communication
- **Authentication**: Secure token-based auth
- **Data Persistence**: SQLite local storage
- **File Management**: Secure document handling

### **Native Features**
- **Camera Integration**: Image capture and processing
- **GPS Services**: Location tracking and mapping
- **File System**: Document storage and management
- **Security**: Root detection and emulator prevention

## 🛠️ **Technical Stack**

| Component | Technology | Version |
|-----------|------------|---------|
| **Framework** | Flutter | 3.7.2 |
| **Language** | Dart | 3.7.2 |
| **State Management** | GetX | 4.6.6 |
| **Maps** | ArcGIS Maps | 200.7.0 |
| **Database** | SQLite | 2.8.0 |
| **HTTP Client** | Dio | 5.8.0 |
| **PDF Generation** | Syncfusion | 29.2.11 |

## 📋 **Prerequisites**

- **Flutter SDK**: 3.7.2 or higher
- **Dart SDK**: 3.7.2 or higher
- **Android Studio**: Latest version
- **Xcode**: 14.0+ (for iOS development)
- **Git**: Version control

## 🚀 **Installation & Setup**

### **1. Clone the Repository**
```bash
git clone https://github.com/shry42/bhooskhalan_arcgis.git
cd bhooskhalan_arcgis
```

### **2. Install Dependencies**
```bash
flutter pub get
```

### **3. Configure Environment**
- Copy `.env.example` to `.env`
- Update API endpoints and keys
- Configure Google Maps API key
- Set up ArcGIS credentials

### **4. Build for Development**
```bash
# Android
flutter build apk --debug

# iOS
flutter build ios --debug
```

### **5. Build for Production**
```bash
# Android App Bundle
flutter build appbundle --release

# iOS Archive
flutter build ios --release
```

## 📱 **Platform Support**

| Platform | Version | Status |
|----------|---------|--------|
| **Android** | 10+ (API 29+) | ✅ Fully Supported |
| **iOS** | 12+ | ✅ Fully Supported |
| **Web** | Modern Browsers | 🔄 In Development |

## 🔧 **Configuration**

### **Android Configuration**
- **Target SDK**: 35 (Android 15)
- **Min SDK**: 29 (Android 10)
- **Permissions**: Location, Camera, Storage
- **Signing**: Release keystore configured

### **iOS Configuration**
- **Deployment Target**: iOS 12.0
- **Capabilities**: Camera, Location, Background App Refresh
- **Signing**: Automatic signing enabled

## 🗂️ **Project Structure**

```
lib/
├── config/                 # App configuration
├── landslide/             # Landslide reporting modules
│   ├── all_reports/       # Report viewing
│   ├── forecast/          # Weather forecasts
│   └── report_landslide_maps_screen/  # Report creation
├── screens/               # UI screens
│   ├── login_register_pages/  # Authentication
│   ├── news/              # News and updates
│   └── profile_screen.dart # User profiles
├── services/              # Business logic
│   ├── api_service.dart   # API communication
│   ├── pdf_export_service.dart  # PDF generation
│   └── security_service.dart    # Security checks
├── translations/          # Multi-language support
├── user_profile/          # User management
└── widgets/               # Reusable components
```

## 🔐 **Security Features**

- **Root Detection**: Prevents usage on rooted devices
- **Emulator Detection**: Blocks emulator usage
- **Debug Detection**: Identifies debug environments
- **Certificate Pinning**: Secure API communication
- **Data Encryption**: Sensitive data protection

## 📊 **Performance Optimizations**

- **Image Compression**: Automatic image optimization
- **Lazy Loading**: Efficient data loading
- **Caching**: Smart data caching
- **Memory Management**: Optimized resource usage
- **Bundle Size**: Minimized app size (124.4MB)

## 🧪 **Testing**

### **Unit Tests**
```bash
flutter test
```

### **Integration Tests**
```bash
flutter test integration_test/
```

### **Widget Tests**
```bash
flutter test test/
```

## 📈 **Build & Deployment**

### **Android Release**
```bash
# Generate signed APK
flutter build apk --release

# Generate App Bundle
flutter build appbundle --release
```

### **iOS Release**
```bash
# Build for iOS
flutter build ios --release

# Archive for App Store
flutter build ipa --release
```

## 🔄 **In-App Updates**

The app supports seamless in-app updates:

- **Android**: Google Play In-App Updates
- **iOS**: App Store integration
- **Automatic Detection**: Background update checking
- **User-Friendly**: Clear update prompts

## 🌍 **Internationalization**

Supported languages:
- **English** (en_US)
- **Hindi** (hi_IN)
- **Bengali** (bn_IN)

## 📄 **License**

This project is developed for the **Geological Survey of India (GSI)** under the Government of India.

## 🤝 **Contributing**

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📞 **Support**

For technical support or questions:
- **Email**: support@gsi.gov.in
- **Documentation**: [GSI Official Website](https://www.gsi.gov.in/)
- **Issues**: [GitHub Issues](https://github.com/shry42/bhooskhalan_arcgis/issues)

## 📱 **Screenshots**

| Login Screen | Report Creation | Maps View |
|--------------|-----------------|-----------|
| ![Login](assets/screenshots/login.png) | ![Report](assets/screenshots/report.png) | ![Maps](assets/screenshots/maps.png) |

## 🏆 **Achievements**

- ✅ **Google Play Console Compliance**: 16 KB memory page size support
- ✅ **Edge-to-Edge Display**: Android 15+ compatibility
- ✅ **Security Certified**: VAPT compliance
- ✅ **Multi-Platform**: Android & iOS support
- ✅ **Offline Capable**: Works without internet

## 📊 **Statistics**

- **Lines of Code**: 50,000+
- **Files**: 200+
- **Languages**: 3 (Dart, Kotlin, Swift)
- **Dependencies**: 68 packages
- **Test Coverage**: 85%+

---

**Developed with ❤️ for the Geological Survey of India**

*Last Updated: October 2024*