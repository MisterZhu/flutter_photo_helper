package com.example.flutter_photo_helper

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "plugin_apple"
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "sendImageToNative" -> {
                    val imagePath = call.argument<String>("imagePath")
                    receiveImageFromFlutter(imagePath, result)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
    private fun receiveImageFromFlutter(imagePath: String?, result: MethodChannel.Result) {
        // 处理从 Flutter 传来的图片路径
        println("Received image path from Flutter: $imagePath")

        // 示例：在此处调用 ImageSegmentationTask
        if (!imagePath.isNullOrBlank()) {
            val imageSegmentationTask = ImageSegmentationTask(imagePath, result)
            imageSegmentationTask.execute()
        } else {
            result.error("INVALID_ARGUMENT", "Image path is null or empty.", null)
        }
    }

}