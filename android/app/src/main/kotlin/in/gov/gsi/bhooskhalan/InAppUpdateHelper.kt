package `in`.`gov`.gsi.bhooskhalan

import android.app.Activity
import android.content.Intent
import android.content.IntentSender
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import com.google.android.play.core.appupdate.AppUpdateInfo
import com.google.android.play.core.appupdate.AppUpdateManager
import com.google.android.play.core.appupdate.AppUpdateManagerFactory
import com.google.android.play.core.install.model.AppUpdateType
import com.google.android.play.core.install.model.UpdateAvailability

class InAppUpdateHelper(private val activity: Activity) : MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var appUpdateManager: AppUpdateManager
    private val REQUEST_CODE = 500

    fun onAttachedToEngine(flutterEngine: FlutterEngine) {
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "in_app_update")
        channel.setMethodCallHandler(this)
        appUpdateManager = AppUpdateManagerFactory.create(activity)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "checkForUpdate" -> {
                checkForUpdate(result)
            }
            "performImmediateUpdate" -> {
                performImmediateUpdate(result)
            }
            "startFlexibleUpdate" -> {
                startFlexibleUpdate(result)
            }
            "completeFlexibleUpdate" -> {
                completeFlexibleUpdate(result)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun checkForUpdate(result: Result) {
        appUpdateManager.appUpdateInfo.addOnSuccessListener { appUpdateInfo ->
            val updateAvailable = appUpdateInfo.updateAvailability() == UpdateAvailability.UPDATE_AVAILABLE
            val immediateAllowed = appUpdateInfo.isUpdateTypeAllowed(AppUpdateType.IMMEDIATE)
            val flexibleAllowed = appUpdateInfo.isUpdateTypeAllowed(AppUpdateType.FLEXIBLE)
            
            val updateInfo = mapOf(
                "updateAvailable" to updateAvailable,
                "immediateAllowed" to immediateAllowed,
                "flexibleAllowed" to flexibleAllowed,
                "availableVersionCode" to appUpdateInfo.availableVersionCode()
            )
            
            result.success(updateInfo)
        }.addOnFailureListener { exception ->
            result.error("UPDATE_CHECK_FAILED", exception.message, null)
        }
    }

    private fun performImmediateUpdate(result: Result) {
        appUpdateManager.appUpdateInfo.addOnSuccessListener { appUpdateInfo ->
            if (appUpdateInfo.updateAvailability() == UpdateAvailability.UPDATE_AVAILABLE &&
                appUpdateInfo.isUpdateTypeAllowed(AppUpdateType.IMMEDIATE)) {
                
                try {
                    appUpdateManager.startUpdateFlowForResult(
                        appUpdateInfo,
                        AppUpdateType.IMMEDIATE,
                        activity,
                        REQUEST_CODE
                    )
                    result.success(true)
                } catch (e: IntentSender.SendIntentException) {
                    result.error("IMMEDIATE_UPDATE_FAILED", e.message, null)
                }
            } else {
                result.error("IMMEDIATE_UPDATE_NOT_AVAILABLE", "Immediate update not available", null)
            }
        }.addOnFailureListener { exception ->
            result.error("IMMEDIATE_UPDATE_FAILED", exception.message, null)
        }
    }

    private fun startFlexibleUpdate(result: Result) {
        appUpdateManager.appUpdateInfo.addOnSuccessListener { appUpdateInfo ->
            if (appUpdateInfo.updateAvailability() == UpdateAvailability.UPDATE_AVAILABLE &&
                appUpdateInfo.isUpdateTypeAllowed(AppUpdateType.FLEXIBLE)) {
                
                try {
                    appUpdateManager.startUpdateFlowForResult(
                        appUpdateInfo,
                        AppUpdateType.FLEXIBLE,
                        activity,
                        REQUEST_CODE
                    )
                    result.success(true)
                } catch (e: IntentSender.SendIntentException) {
                    result.error("FLEXIBLE_UPDATE_FAILED", e.message, null)
                }
            } else {
                result.error("FLEXIBLE_UPDATE_NOT_AVAILABLE", "Flexible update not available", null)
            }
        }.addOnFailureListener { exception ->
            result.error("FLEXIBLE_UPDATE_FAILED", exception.message, null)
        }
    }

    private fun completeFlexibleUpdate(result: Result) {
        appUpdateManager.completeUpdate()
        result.success(true)
    }

    fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (requestCode == REQUEST_CODE) {
            if (resultCode == Activity.RESULT_OK) {
                // Update completed successfully
                channel.invokeMethod("onUpdateCompleted", null)
            } else if (resultCode == Activity.RESULT_CANCELED) {
                // Update was cancelled
                channel.invokeMethod("onUpdateCancelled", null)
            } else {
                // Update failed
                channel.invokeMethod("onUpdateFailed", null)
            }
        }
    }

    fun onDetachedFromEngine() {
        channel.setMethodCallHandler(null)
    }
} 