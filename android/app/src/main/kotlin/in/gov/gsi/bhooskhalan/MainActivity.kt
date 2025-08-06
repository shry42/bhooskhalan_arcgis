package `in`.`gov`.gsi.bhooskhalan

import android.content.Context
import android.content.Intent
import android.provider.Settings
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity: FlutterActivity() {
    private val CHANNEL = "security_channel"
    private lateinit var inAppUpdateHelper: InAppUpdateHelper
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Initialize in-app update helper
        inAppUpdateHelper = InAppUpdateHelper(this)
        inAppUpdateHelper.onAttachedToEngine(flutterEngine)
        
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
                // ✅ Added comprehensive emulator detection method for VAPT compliance
                "isEmulatorDetected" -> {
                    result.success(isEmulatorDetected())
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
    
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        inAppUpdateHelper.onActivityResult(requestCode, resultCode, data)
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

    // ✅ Enhanced emulator detection method for VAPT compliance
    private fun isEmulatorDetected(): Boolean {
        return (checkBasicTelephony() ||
                checkFiles() ||
                checkQEmuDrivers() ||
                checkPipes() ||
                checkIP() ||
                checkBuild() ||
                checkEmulator()) // Also includes existing emulator check
    }

    private fun checkBasicTelephony(): Boolean {
        return Build.FINGERPRINT.startsWith("generic") ||
               Build.FINGERPRINT.lowercase().contains("unknown") ||
               Build.MODEL.contains("google_sdk") ||
               Build.MODEL.contains("Emulator") ||
               Build.MODEL.contains("Android SDK built for x86") ||
               Build.MANUFACTURER.contains("Genymotion") ||
               Build.BRAND.startsWith("generic") && Build.DEVICE.startsWith("generic") ||
               "google_sdk" == Build.PRODUCT
    }

    private fun checkFiles(): Boolean {
        val known_files = arrayOf(
            "/system/lib/libc_malloc_debug_qemu.so",
            "/sys/qemu_trace",
            "/system/bin/qemu-props",
            "/dev/socket/qemud",
            "/dev/qemu_pipe",
            "/dev/socket/baseband_genyd",
            "/dev/socket/genyd"
        )
        
        for (file_name in known_files) {
            val file = File(file_name)
            if (file.exists()) {
                return true
            }
        }
        return false
    }

    private fun checkQEmuDrivers(): Boolean {
        val drivers = arrayOf(
            "goldfish"
        )
        
        val file = File("/proc/tty/drivers")
        if (file.exists() && file.canRead()) {
            try {
                val data = file.readText()
                for (driver in drivers) {
                    if (data.contains(driver)) {
                        return true
                    }
                }
            } catch (e: Exception) {
                // Ignore exception
            }
        }
        return false
    }

    private fun checkPipes(): Boolean {
        val pipes = arrayOf(
            "/dev/socket/qemud",
            "/dev/qemu_pipe"
        )
        
        for (pipe in pipes) {
            val file = File(pipe)
            if (file.exists()) {
                return true
            }
        }
        return false
    }

    private fun checkIP(): Boolean {
        try {
            val networkInterfaces = java.net.NetworkInterface.getNetworkInterfaces()
            while (networkInterfaces.hasMoreElements()) {
                val networkInterface = networkInterfaces.nextElement()
                val addresses = networkInterface.inetAddresses
                while (addresses.hasMoreElements()) {
                    val address = addresses.nextElement()
                    val hostAddress = address.hostAddress
                    if (hostAddress == "10.0.2.15" || hostAddress == "10.0.3.2") {
                        return true
                    }
                }
            }
        } catch (e: Exception) {
            // Ignore exception
        }
        return false
    }

    private fun checkBuild(): Boolean {
        val buildTags = Build.TAGS
        return buildTags?.contains("test-keys") == true
    }
} 