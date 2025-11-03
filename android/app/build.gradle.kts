plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}


dependencies {
    // Updated Play libraries compatible with targetSdk 35 (Android 15)
    implementation("com.google.android.play:app-update:2.1.0")
    implementation("com.google.android.play:review:2.0.1")
    implementation("com.google.android.play:feature-delivery:2.1.0")
    implementation("com.google.android.gms:play-services-tasks:18.2.0")
    
    // Edge-to-edge support for Android 15+
    implementation("androidx.core:core-ktx:1.12.0")
    implementation("androidx.activity:activity-ktx:1.8.2")
}

android {
    namespace = "in.gov.gsi.bhooskhalan"
    compileSdk = 35  // ✅ Required by plugins for compatibility
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    signingConfigs {
        create("release") {
            storeFile = file("../../Keystore/gsi/gsi.keystore")
            storePassword = "gsimobile"
            keyAlias = "gsi"
            keyPassword = "gsimobile"
        }
    }

    defaultConfig {
        applicationId = "in.gov.gsi.bhooskhalan"
        minSdk = 29      // ✅ VAPT compliance (Android 10)
        targetSdk = 35   // ✅ Google Play Aug 31, 2025 compliance (Android 15)
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        
        // ABI filters are handled automatically by Flutter split builds or can be set here for universal builds
        // When using --split-per-abi flag, remove abiFilters to avoid conflicts
        // ndk {
        //     abiFilters += listOf("arm64-v8a", "armeabi-v7a", "x86_64")
        // }
    }

    buildTypes {
        debug {
            isDebuggable = true
            isMinifyEnabled = false
            isShrinkResources = false
        }
                release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            // Additional size optimizations
            isCrunchPngs = true
            isJniDebuggable = false
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
            
            // Additional size optimizations
            ndk {
                debugSymbolLevel = "NONE"
            }
            
            // Splits moved to correct location outside buildTypes
        }
    }
    
    // Enable APK splitting for size reduction (disabled for debug)
    // splits {
    //     abi {
    //         isEnable = true
    //         reset()
    //         include("arm64-v8a", "armeabi-v7a", "x86_64")
    //         isUniversalApk = false
    //     }
    // }
    
    // Enable bundle compression
    bundle {
        language {
            enableSplit = true
        }
        density {
            enableSplit = true
        }
        abi {
            enableSplit = true
        }
    }
    
    // 16 KB memory page size support configuration
    packagingOptions {
        jniLibs {
            useLegacyPackaging = false
        }
        // Ensure native libraries are properly aligned for 16 KB pages
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
        }
    }
}

flutter {
    source = "../.."
}