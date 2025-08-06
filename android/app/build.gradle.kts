plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}


dependencies {
    implementation("com.google.android.play:core:1.10.3")
}

android {
    namespace = "in.gov.gsi.bhooskhalan"
    compileSdk = 35
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
        targetSdk = 34   // Modern target for security
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        
        // ABI filters handled by splits configuration
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
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
            
            // Enable APK splitting for size reduction
            splits {
                abi {
                    isEnable = true
                    reset()
                    include("arm64-v8a", "armeabi-v7a", "x86_64")
                    isUniversalApk = false
                }
            }
            
            // Additional size optimizations
            ndk {
                debugSymbolLevel = "NONE"
            }
        }
    }
    
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
}

flutter {
    source = "../.."
}