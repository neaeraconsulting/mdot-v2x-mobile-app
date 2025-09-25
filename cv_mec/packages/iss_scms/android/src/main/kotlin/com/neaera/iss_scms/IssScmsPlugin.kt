package com.neaera.iss_scms

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import com.iss_scms.dm.android.localdevicesecurityapi.LocalSigning
import com.iss_scms.dm.android.localdevicesecurityapi.TokenType
import com.iss_scms.dm.android.localdevicesecurityapi.ScmsEnvironment
import com.iss_scms.dm.android.localdevicesecurityapi.ValidateStatus
import com.iss_scms.dm.android.localdevicesecurityapi.SigningAPIState
import android.content.Context
import kotlinx.coroutines.*
import android.util.Log
// import com.iss_scms.dm.android.localdevicesecurityapi.api
// import com.iss_scms.dm.android.localdevicesecurityapi.db
// import com.iss_scms.dm.android.localdevicesecurityapi.encoderlibrary

/** IssScmsPlugin */
class IssScmsPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context : Context
  private lateinit var scope : CoroutineScope

  // private lateinit var signing : LocalSigning

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "iss_scms")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
    scope = CoroutineScope(Dispatchers.IO)
    // signing = LocalSigning.LocalSigning
  }

  @kotlin.ExperimentalStdlibApi
  override fun onMethodCall(call: MethodCall, result: Result) {
    val args = call.arguments<Map<String, Any>>()
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    }else if(call.method == "init"){
      LocalSigning.init(context, ScmsEnvironment.PREPRODUCTION)
      result.success(null)
    }
    else if(call.method == "validate"){
      val message = args?.get("message") as ByteArray

      val hex = message.joinToString(separator = "") { "%02X".format(it) }
      Log.i("SCMS","SCMS Validating Hex" + hex);
      val (valid, _) = LocalSigning.validate(message, true)
      Log.i("SCMS","SCMS Validation Validation " + valid)
      result.success(valid.ordinal)
    }else if(call.method == "sign"){
      val state = LocalSigning.getState()
      if( state== SigningAPIState.READY){
        val psid = args?.get("psid") as Int
        val tbsOer = args?.get("tbsOer") as ByteArray
        val jIndex = args?.get("jIndex") as? Int
        val digestSigner = args?.get("digestSigner") as? Boolean

        val outputArray = LocalSigning.sign(psid, tbsOer)
        val (valid, _) = LocalSigning.validate(outputArray, true)

        Log.i("SCMS","SCMS Self Validation" + valid)
        result.success(outputArray) 
      }else{
        result.error("Android Signing Error", "Signing is not possible yet. Signing API State is " + state.name, null)
      }
      
    }else if(call.method == "getDeviceCerts"){
      val token = args?.get("token") as String
      val tokenType = TokenType.values()[args?.get("tokenType") as Int]
      scope.launch {
        try {
            // val certs = LocalSigning.getDeviceCerts("jvKFigeCl81aRAwieGZIo4cKgqq88NH5gRBgbwq7Tecuql4qFRBLoQ==", TokenType.DM_DASHBOARD)
            LocalSigning.getDeviceCerts(token, tokenType)
            withContext(Dispatchers.Main) {
                result.success(null)
            }
        } catch (e: Exception) {
            withContext(Dispatchers.Main) {
                result.error("CERT_ERROR", e.message, null)
            }
        }
      }
    }
    else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
