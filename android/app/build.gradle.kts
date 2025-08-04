plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.bhooskhalann"
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.bhooskhalann"
        minSdk = 29      // ✅ VAPT compliance (Android 10)
        targetSdk = 34   // Modern target for security
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        debug {
            isDebuggable = true
            isMinifyEnabled = false
            isShrinkResources = false  // ✅ Disable resource shrinking for debug
        }
        release {
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false    // ✅ Keep simple for VAPT testing
            isShrinkResources = false  // ✅ Disable resource shrinking
        }
    }
}

flutter {
    source = "../.."
}