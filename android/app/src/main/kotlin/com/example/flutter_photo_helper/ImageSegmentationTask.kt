package com.example.flutter_photo_helper

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Matrix
import android.graphics.drawable.BitmapDrawable
import android.os.AsyncTask
import com.huawei.hms.mlsdk.common.MLFrame

import io.flutter.plugin.common.MethodChannel
import com.huawei.hms.mlsdk.MLAnalyzerFactory
import com.huawei.hms.mlsdk.imgseg.MLImageSegmentationSetting

import android.util.Base64
import java.io.ByteArrayOutputStream
import android.media.ExifInterface

// ImageSegmentationTask.kt
class ImageSegmentationTask(
    private val imagePath: String,
    private val result: MethodChannel.Result
) : AsyncTask<Void?, Void?, Void?>() {

    override fun doInBackground(vararg params: Void?): Void? {
        // 加载本地图片为 Bitmap
        val bitmap = loadBitmapFromPath(imagePath)
        println("imagePath: $imagePath")

        // 进行图像分割处理
        val segmentationResult = processImageSegmentation(bitmap)

        return null
    }

    private fun loadBitmapFromPath(imagePath: String): Bitmap {
        // 从文件路径加载图片
        // 请根据你的实际需求实现该方法
        return BitmapFactory.decodeFile(imagePath)
    }

    private fun processImageSegmentation(bitmap: Bitmap): String {
        // 配置图像分割检测器
        val setting = MLImageSegmentationSetting.Factory()
            .setExact(true)
            .setAnalyzerType(MLImageSegmentationSetting.BODY_SEG)
            .create()
        val analyzer = MLAnalyzerFactory.getInstance().getImageSegmentationAnalyzer(setting)

        // 创建 MLFrame 对象
        val frame = MLFrame.Creator()
            .setBitmap(bitmap)
            .create()

        // 执行图像分割
        val task = analyzer.asyncAnalyseFrame(frame)
        task.addOnSuccessListener {
            val mlImageSegmentationResults = it
            val foreground = mlImageSegmentationResults.foreground
            val rotatedBitmap = rotateImageIfNeeded(imagePath, foreground)

            // 将 Bitmap 转换成 Base64 编码的字符串
//            val base64String = convertBitmapToBase64(foreground)
// 将 Bitmap 转换成 ByteArray
            val byteArrayOutputStream = ByteArrayOutputStream()
            rotatedBitmap.compress(Bitmap.CompressFormat.PNG, 100, byteArrayOutputStream)
            val byteArray = byteArrayOutputStream.toByteArray()

            // 将结果传递给 Flutter
            result.success(mapOf("result" to "success", "imgData" to byteArray))
        }.addOnFailureListener {
            // 处理分割失败
            result.error("SEGMENTATION_ERROR", "Image segmentation failed.", null)
        }


        return "Segmentation in progress..."
    }
    fun convertBitmapToBase64(bitmap: Bitmap): String {
        val byteArrayOutputStream = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, byteArrayOutputStream)
        val byteArray = byteArrayOutputStream.toByteArray()
        return Base64.encodeToString(byteArray, Base64.DEFAULT)
    }
    private fun rotateImageIfNeeded(imagePath: String, bitmap: Bitmap): Bitmap {
        val exif = ExifInterface(imagePath)
        val orientation = exif.getAttributeInt(ExifInterface.TAG_ORIENTATION, ExifInterface.ORIENTATION_UNDEFINED)

        val rotatedBitmap = when (orientation) {
            ExifInterface.ORIENTATION_ROTATE_90 -> rotateBitmap(bitmap, 90f)
            ExifInterface.ORIENTATION_ROTATE_180 -> rotateBitmap(bitmap, 180f)
            ExifInterface.ORIENTATION_ROTATE_270 -> rotateBitmap(bitmap, 270f)
            else -> bitmap
        }

        return rotatedBitmap
    }
    private fun rotateBitmap(bitmap: Bitmap, degrees: Float): Bitmap {
        val matrix = Matrix()
        matrix.postRotate(degrees)
        return Bitmap.createBitmap(bitmap, 0, 0, bitmap.width, bitmap.height, matrix, true)
    }
}

