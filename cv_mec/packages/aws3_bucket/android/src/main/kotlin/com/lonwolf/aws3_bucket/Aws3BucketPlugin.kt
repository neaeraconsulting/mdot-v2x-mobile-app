package com.lonwolf.aws3_bucket

import androidx.annotation.NonNull
import android.app.Activity
import android.content.Context
import com.google.gson.JsonObject
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.plugins.service.ServiceAware
import io.flutter.embedding.engine.plugins.service.ServicePluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

import org.jetbrains.annotations.NotNull
import org.json.JSONArray
import org.json.JSONObject
import java.io.File
import java.io.UnsupportedEncodingException
/** Aws3BucketPlugin */
class Aws3BucketPlugin: FlutterPlugin, MethodCallHandler, ActivityAware , ServiceAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var eventChannel : EventChannel
  private var awsRegionHelper: AwsRegionHelper? = null
  private var  awsMultiImageRegionHelper:AwsMultipleFileUploadHelper? = null

  private lateinit var context: Context
  private lateinit var activity: Activity

  private  lateinit var imageUploadListener:ImageUploadListener


  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "aws3_bucket")
    channel.setMethodCallHandler(this)
    eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "aws3_bucket_upload_steam")
    imageUploadListener = ImageUploadListener()
    eventChannel.setStreamHandler(imageUploadListener)
    //Factory.setup(this, flutterPluginBinding.binaryMessenger)
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    val filePath = call.argument<String>("filePath")
    val bucket = call.argument<String>("bucket")
    val secretKey = call.argument<String>("secretKey")
    val secretId = call.argument<String>("secretId")
    val fileName = call.argument<String>("imageName")
    val region = call.argument<String>("region")
    val subRegion = call.argument<String>("subRegion")

    System.out.println("\n❌ bucket--1")

    if (call.method.equals("uploadImage") ) {
      System.out.println("\n❌ bucket--2")
      if(filePath == null){
        return  result.error("file path cannot be empty","error",1)
      }else{
        System.out.println("\n❌ bucket--3")
        var imageUploadFolder = call.argument<String>("imageUploadFolder")

        val file = File(filePath)
        try {
          System.out.println("\n❌ bucket--4")
          System.out.println(bucket)
          System.out.println(secretKey)
          System.out.println(secretId)
          System.out.println(region)
          System.out.println(subRegion)
          awsRegionHelper = AwsRegionHelper(context, bucket!!, secretKey!!,secretId!!, region!!, subRegion!!)
          awsRegionHelper!!.uploadImage(file, fileName!!,imageUploadFolder, object : AwsRegionHelper.OnUploadCompleteListener {
            override fun onFailed() {
              System.out.println("\n❌ upload failed")
              try{
                result.success(false)
              }catch (e:Exception){

              }

            }

            override fun onUploadComplete(@NotNull imageUrl: String) {
              System.out.println("\n✅ upload complete: $imageUrl")
              result.success(true)
            }
          })
        } catch (e: UnsupportedEncodingException) {
          e.printStackTrace()
        }
      }

    }
    else if (call.method.equals("deleteImage")) {
      try {

        var imageUploadFolder = call.argument<String>("imageUploadFolder")


        awsRegionHelper = AwsRegionHelper(context, bucket!!,secretKey!!,secretId!!, region!!, subRegion!!)
        awsRegionHelper!!.deleteImage(fileName!!, imageUploadFolder,object : AwsRegionHelper.OnUploadCompleteListener{

          override fun onFailed() {
            System.out.println("\n❌ delete failed")
            try{
              result.success(false)
            }catch (e:Exception){

            }

          }

          override fun onUploadComplete(@NotNull imageUrl: String) {
            System.out.println("\n✅ delete complete: $imageUrl")

            try{
              result.success(true)
            }catch (e:Exception){

            }
          }
        })
      } catch (e: UnsupportedEncodingException) {
        e.printStackTrace()
      }

    }
    else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    imageUploadListener.onCancel(1)
    eventChannel.setStreamHandler(null)
  }
  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {

  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {

  }

  override fun onDetachedFromActivity() {

  }

  override fun onAttachedToService(binding: ServicePluginBinding) {
    context = binding.service.applicationContext
  }

  override fun onDetachedFromService() {

  }
}
