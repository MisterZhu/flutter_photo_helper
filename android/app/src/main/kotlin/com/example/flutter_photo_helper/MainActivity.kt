package com.example.flutter_photo_helper

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES

class MainActivity: FlutterActivity() {
    private val CHANNEL = "samples.flutter.dev/battery"
    private val CHANNEL2 = "plugin_apple"
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            // This method is invoked on the main thread.
                call, result ->
            if (call.method == "getBatteryLevel") {
                val batteryLevel = getBatteryLevel()

                if (batteryLevel != -1) {
                    result.success(batteryLevel)
                } else {
                    result.error("UNAVAILABLE", "Battery level not available.", null)
                }
            } else {
                result.notImplemented()
            }
        }
        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL2).setMethodCallHandler { call, result ->
            when (call.method) {
                "sendImageToNative" -> {
                    val imagePath = call.argument<String>("imagePath")
                    receiveImageFromFlutter(imagePath)
                    result.success(mapOf("result" to "success", "code" to 200))
                }
                "sendImageDataToNative" -> {
                    val imageData = call.argument<ByteArray>("imageData")
                    receiveImageDataFromFlutter(imageData)
                    result.success(mapOf("result" to "success", "code" to 200))
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
    private fun getBatteryLevel(): Int {
        val batteryLevel: Int
        if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
            val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
            batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        } else {
            val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
            batteryLevel = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
        }

        return batteryLevel
    }
    private fun receiveImageFromFlutter(imagePath: String?) {
        // 处理从 Flutter 传来的图片路径
        println("Received image path from Flutter: $imagePath")
    }

    private fun receiveImageDataFromFlutter(imageData: ByteArray?) {
        // 处理从 Flutter 传来的图片数据
        println("Received image data from Flutter: ${imageData?.contentToString()}")
    }
}