package com.example.bhooskhalann


import android.content.Context
import android.provider.Settings
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity: FlutterActivity() {
    private val CHANNEL = "security_channel"
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "isDeveloperModeEnabled" -> {
                    result.success(isDeveloperModeEnabled())
                }
                "isDebuggingEnabled" -> {
                    result.success(isDebuggingEnabled())
                }
                "checkRootFiles" -> {
                    result.success(checkRootFiles())
                }
                "checkRootApps" -> {
                    result.success(checkRootApps())
                }
                "checkSystemProperties" -> {
                    result.success(checkSystemProperties())
                }
                "checkEmulator" -> {
                    result.success(checkEmulator())
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
    
    private fun isDeveloperModeEnabled(): Boolean {
        return try {
            Settings.Secure.getInt(contentResolver, Settings.Global.DEVELOPMENT_SETTINGS_ENABLED, 0) != 0
        } catch (e: Exception) {
            false
        }
    }
    
    private fun isDebuggingEnabled(): Boolean {
        return try {
            Settings.Secure.getInt(contentResolver, Settings.Global.ADB_ENABLED, 0) != 0
        } catch (e: Exception) {
            false
        }
    }
    
    private fun checkRootFiles(): Boolean {
        val rootFiles = arrayOf(
            "/system/app/Superuser.apk",
            "/sbin/su",
            "/system/bin/su",
            "/system/xbin/su",
            "/data/local/xbin/su",
            "/data/local/bin/su",
            "/system/sd/xbin/su",
            "/system/bin/failsafe/su",
            "/data/local/su",
            "/su/bin/su",
            "/system/etc/init.d/99SuperSUDaemon",
            "/dev/com.koushikdutta.superuser.daemon/",
            "/system/xbin/daemonsu"
        )
        
        for (path in rootFiles) {
            try {
                if (File(path).exists()) return true
            } catch (e: Exception) {
                // Continue checking other files
            }
        }
        return false
    }
    
    private fun checkRootApps(): Boolean {
        val rootApps = arrayOf(
            "com.noshufou.android.su",
            "com.noshufou.android.su.elite",
            "eu.chainfire.supersu",
            "com.koushikdutta.superuser",
            "com.thirdparty.superuser",
            "com.yellowes.su",
            "com.koushikdutta.rommanager",
            "com.koushikdutta.rommanager.license",
            "com.dimonvideo.luckypatcher",
            "com.chelpus.lackypatch",
            "com.ramdroid.appquarantine",
            "com.ramdroid.appquarantinepro",
            "com.topjohnwu.magisk",
            "com.kingroot.kinguser",
            "com.kingo.root",
            "com.smedialink.oneclickroot",
            "com.zhiqupk.root.global",
            "com.alephzain.framaroot"
        )
        
        for (packageName in rootApps) {
            try {
                packageManager.getPackageInfo(packageName, 0)
                return true
            } catch (e: Exception) {
                // Package not found, continue
            }
        }
        return false
    }
    
    private fun checkSystemProperties(): Boolean {
        return try {
            val buildTags = Build.TAGS
            val debuggable = (applicationInfo.flags and android.content.pm.ApplicationInfo.FLAG_DEBUGGABLE) != 0
            
            // Check build tags
            val hasTestKeys = buildTags != null && buildTags.contains("test-keys")
            
            // Check if build is debuggable
            val isDebuggable = debuggable
            
            hasTestKeys || isDebuggable
        } catch (e: Exception) {
            false
        }
    }
    
    private fun checkEmulator(): Boolean {
        return try {
            // Check build properties
            val fingerprint = Build.FINGERPRINT
            val model = Build.MODEL
            val manufacturer = Build.MANUFACTURER
            val brand = Build.BRAND
            val device = Build.DEVICE
            val product = Build.PRODUCT
            
            // Common emulator signatures
            val emulatorSigns = arrayOf(
                "google_sdk", "Emulator", "Android SDK built for x86", "sdk",
                "sdk_x86", "vbox86p", "emulator", "simulator"
            )
            
            for (sign in emulatorSigns) {
                if (fingerprint.contains(sign, ignoreCase = true) ||
                    model.contains(sign, ignoreCase = true) ||
                    manufacturer.contains(sign, ignoreCase = true) ||
                    brand.contains(sign, ignoreCase = true) ||
                    device.contains(sign, ignoreCase = true) ||
                    product.contains(sign, ignoreCase = true)) {
                    return true
                }
            }
            
            // Check for specific emulator properties
            if (fingerprint.startsWith("generic") ||
                fingerprint.startsWith("unknown") ||
                model.contains("google_sdk") ||
                model.contains("Emulator") ||
                model.contains("Android SDK built for x86") ||
                manufacturer.contains("Genymotion") ||
                (brand.startsWith("generic") && device.startsWith("generic"))) {
                return true
            }
            
            false
        } catch (e: Exception) {
            false
        }
    }
}